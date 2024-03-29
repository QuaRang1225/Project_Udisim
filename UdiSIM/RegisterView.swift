//
//  RegisterView.swift
//  UdiSIM
//
//  Created by 유영웅 on 2022/11/18.
//

import SwiftUI

struct RegisterView: View {
    
    @State var passwordStatus = false
    @State var email:String = ""
    @State var name:String = ""
    @State var password:String = ""
    @State var passwordConfirm:String = ""
    @Binding var registerMode:Bool
    @Environment(\.presentationMode) var presentMode
    @EnvironmentObject var vm:AuthenticationViewModel
    
    var body: some View {
            ZStack{
                LinearGradient.udisimColor.ignoresSafeArea()
                VStack(spacing: 20){
                    
                    AuthHeaderView(title: "회원가입")
                    
                    Spacer()
                    Group{
                        CustomInputView(imageName: "person", placeholderText: "이메일", text: $email)
                        CustomInputView(imageName: "person.fill", placeholderText: "이름", text: $name)
                        CustomInputView(imageName: "lock", placeholderText: "비밀번호",securefield: true, text: $password)
                        CustomInputView(imageName: "lock.fill", placeholderText: "비밀번호 확인",securefield: true, text: $passwordConfirm)
                    }
                    register
                    Spacer()
                    loginTransferButton
                    
                }
                
                
            }.navigationDestination(isPresented:  $vm.successRegister) {
                ProfileSelectView(name: $name, email: $email, password: $password, registerSuccess: $registerMode)
            }
            .ignoresSafeArea()
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(registerMode: .constant(true)).environmentObject(AuthenticationViewModel())
    }
}
extension RegisterView{
    var register:some View{
        Button {
            if password == "" || passwordConfirm == "" || email == "" || name == ""{
                vm.errorMessage = "입력하지 않은 정보가 있습니다!"
                self.passwordStatus = true
            }
            else if password != passwordConfirm{
                vm.errorMessage = "비밀번호가 일치하지않습니다!"
                self.passwordStatus = true
            }else{
                vm.successRegister = true
            }
        } label: {
            LinearGradient.udisimColor
                .mask {
                    Text("회원가입")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(width: 350,height: 50)
                .background(Color.white)
                .clipShape(Capsule())
                .padding()
            
        }.alert(isPresented: $passwordStatus) {
            Alert(title: Text(vm.errorMessage),dismissButton: .default(Text("확인")))
        }
    }
    var loginTransferButton:some View{
        Button {
            presentMode.wrappedValue.dismiss()
        } label: {
            HStack{
                Text("계정이 이미 있으신가요?")
                    .font(.footnote)
                Text("로그인")
                    .font(.footnote)
                    .fontWeight(.semibold)
            }
            
        }
        .padding(.bottom,30)
        .foregroundColor(.white)
    }

   
}
