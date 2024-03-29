//
//  StartView.swift
//  UdiSIM
//
//  Created by 유영웅 on 2022/11/18.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct StartView: View {
    var body: some View {
        NavigationView{
            ZStack{
                LinearGradient.udisimColor
                VStack(spacing:0){
                    ZStack{
                        Circle()
                            .stroke(Color.white,lineWidth: 10)
                            .frame(width: 250,height: 250)
                        Image("Udi")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250,height: 250)
                        
                    }
                    .shadow(radius: 20)
                    Image("where")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150,height: 150)
                }.navigationBarHidden(true)
            }.ignoresSafeArea()
        }
        
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
