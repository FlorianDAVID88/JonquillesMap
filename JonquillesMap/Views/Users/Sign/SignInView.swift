//
//  SignInView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 13/12/2023.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State private var email = ""
    @State private var passwd = ""
    
    @State private var signClick = false
    @Binding var isShowingSignIn: Bool
    @Binding var isShowingMenu: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Image("logo-soc")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                
                VStack(spacing: 5) {
                    TextField("Email", text: $email)
                        .padding(10)
                        .background(.gray.opacity(0.5))
                        .cornerRadius(10)
                    
                    SecureField("Mot de passe", text: $passwd)
                        .padding(10)
                        .background(.gray.opacity(0.5))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button {
                    if !email.isEmpty && !passwd.isEmpty {
                        Task.init {
                            let isConnect = await userVM.logIn(email: email, passwd: passwd)
                            isShowingMenu = !isConnect
                        }
                    }
                } label: {
                    Text("Se connecter")
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 5) {
                    Text("Vous n'avez pas encore de compte, cliquez")
                    Button {
                        withAnimation {
                            isShowingSignIn.toggle()
                        }
                    } label: {
                        Text("ici")
                            .underline()
                    }
                }
            }
        }
    }
}

#Preview {
    SignInView(isShowingSignIn: .constant(true), isShowingMenu: .constant(true))
        .environmentObject(UserViewModel())
}
