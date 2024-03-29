//
//  AuthenticationViewModel.swift
//  UdiSIM
//
//  Created by 유영웅 on 2022/11/18.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift
import Combine

class AuthenticationViewModel:ObservableObject{
    
    @Published var userSession:FirebaseAuth.User?
    var successAuth = PassthroughSubject<(),Never>()
    @Published var userdata:UserData?
    @Published var recent:[Recent] = []
    @Published var isLogOut = false
    @Published var successRegister = false
    
    @Published var errorMessage = ""
    var errorLogin = PassthroughSubject<Bool,Never>()
    
    var isRemove = true
    private var tempUserSession:FirebaseAuth.User?
    private var userService = UserSerivce()
    var roginSuccenss = PassthroughSubject<(),Never>()
    
    init(){
        self.userSession = Auth.auth().currentUser
        fetchUser()
        fetchRecentChat()
    }
    func register(email:String,name:String,password:String){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in //회원가입
            if let error = error{
                print("회원가입에 실패했습니다. 에러명 : \(error)")
                return
            }
            guard let user = result?.user else{ return }    //유저정보가 비어있다면 반환
            self.tempUserSession = user //유저 회원가입 정보 로그인 여부에 전달
            
            
            let data = ["email":email,"name":name,"password":password,"uid":name + user.uid]    //회원가입 정보를 데이터에 저장
            
            Database.database().reference()
                .child("user")
                .childByAutoId()
                .setValue(data){ (error,ref) in
                    self.successAuth.send()          //회원정보 저장 후 프로필 사진 변경 화면으로 넘어가기 위함
                    print("DEBUG : 유저정보가 업로드 되었습니다. 프로필 사진 변경")
                }
//            Firestore.firestore().collection("user")    //"user" 데이터베이스에 저장
//                .document(name + user.uid)                     //문서명 유저.uid로 설정
//                .setData(data) { aaa in                   //데이터 저장 시 변경 사항
//                    self.successAuth.send()          //회원정보 저장 후 프로필 사진 변경 화면으로 넘어가기 위함
//                    print("DEBUG : 유저정보가 업로드 되었습니다. 프로필 사진 변경")
//                }
        }
        
    }
    func login(email:String,password:String){
        Auth.auth().signIn(withEmail: email, password: password){ result, error in
            if let error = error {
                print("로그인 실패 \(error.localizedDescription)")
                switch error.localizedDescription{
                case "The email address is badly formatted.":
                    self.errorLogin.send(true)
                    self.errorMessage = "이메일 형식이 올바르지 않습니다!"
                case "The password is invalid or the user does not have a password.":
                    self.errorLogin.send(true)
                    self.errorMessage = "비밀번호를 입력해주세요!"
                default:
                    return
                }
                
            }
//            guard let user = result?.user else{ return }    //유저정보가 비어있다면 반환
//            self.userSession = user
//            self.fetchUser()
//            self.recent.removeAll()
//            self.fetchRecentChat()
            print("로그인 성공")
        }
    }
    func imageUpload(_ image:UIImage){
        guard let uid = tempUserSession?.uid else{ return } //유저정보가 등록되어있지 않으면 반환
        
        ImageUploader.uploadImage(image: image){ profileImageUrl in
            Database.database().reference()
                .child("user")
                .childByAutoId()
                .setValue(["profileImageUrl":profileImageUrl]){
                    
                }
//            Firestore.firestore().collection("user")    //user에 정보 저장
//                .document(uid)  //document는 uid값으로 지정
//                .updateData(["profileImageUrl":profileImageUrl]){ _ in
//                    self.userSession = self.tempUserSession //userSession - 어플 전체에서 사용될 유저 정보, tempUserSession - 클래스내에서 메서드 실행 시에 사용될 유저 정보
//                    self.fetchUser()    //회원가입 후 모델에 정보를 업데이트
//                }
        }
    }
    func logOut(){
        userSession = nil
        try? Auth.auth().signOut()
        print("로그아웃됨")
        
    }
    
    func fetchUser(){       //유저정보 데이터 모델에 저장
        guard let uid = self.userSession?.uid else {return}
        userService.fetchUser(uid: uid){ snapshot in
            self.userdata = snapshot
        }
    }
    
    func fetchRecentChat(){
        guard let uid = Auth.auth().currentUser?.uid else{ return }
//        Firestore.firestore()
//            .collection("recent")
//            .document(uid)
//            .collection("message")
//            .order(by: LocationData.timestamp)
//            .addSnapshotListener { querySnapshot, error in
//                if let error = error{
//                    print("에러메세지 : \(error.localizedDescription)")
//                }
//                querySnapshot?.documentChanges.forEach({ [weak self] (change) in
//                    let docId = change.document.documentID
//                    print("이게 뭘끼? \(docId)")
//                    if let index = self?.recent.firstIndex(where: { $0.id == docId }){
//                        self?.recent.remove(at: index)
//                    }
//                    if self!.isRemove{
//                        try? self?.recent.insert(change.document.data(as: Recent.self),at: 0)
//                    }
//                    self?.isRemove = true
//                })
//            }
        
    }
    
}
