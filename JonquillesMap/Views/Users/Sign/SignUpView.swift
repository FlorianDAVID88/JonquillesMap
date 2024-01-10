//
//  SignUpView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 13/12/2023.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var userVM: UserViewModel
    
    @State private var username = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var passwd = ""
    @State private var passwdConfirm = ""
    
    @Binding var isShowingSignIn: Bool
    @Binding var isShowingMenu: Bool
    @State private var clickButton = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Image("logo-soc")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                
                VStack(spacing: 5) {
                    TextField("Nom d'utilisateur", text: $username)
                        .padding(10)
                        .background(.gray.opacity(0.5))
                        .cornerRadius(10)
                    
                    TextField("Email", text: $email)
                        .padding(10)
                        .background(.gray.opacity(0.5))
                        .cornerRadius(10)
                    
                    TextField("Phone number", text: $phone)
                        .padding(10)
                        .background(.gray.opacity(0.5))
                        .cornerRadius(10)
                    
                    HStack(spacing: 5) {
                        SecureField("Mot de passe", text: $passwd)
                            .padding(10)
                            .background(.gray.opacity(0.5))
                            .cornerRadius(10)
                            .disableAutocorrection(true)
                        
                        SecureField("Confirmer le mot de passe", text: $passwdConfirm)
                            .padding(10)
                            .background(.gray.opacity(0.5))
                            .cornerRadius(10)
                            .disableAutocorrection(true)
                    }
                }
                .padding(.horizontal)
                
                Button {
                    let allSatisfy = !username.isEmpty && !phone.isEmpty && !email.isEmpty && !passwd.isEmpty && !passwdConfirm.isEmpty
                    
                    if allSatisfy && email.contains("@") {
                        Task.init {
                            let isConnect = await userVM.signUp(username: username, phone: phone, email: email, password: passwd)
                            isShowingMenu = !isConnect
                        }
                    }
                } label: {
                    Text("Créer son compte")
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 5) {
                    Text("Connectez vous")
                    Button {
                        withAnimation {
                            isShowingSignIn.toggle()
                        }
                    } label: {
                        Text("ici")
                            .underline()
                    }
                    Text("si vous avez déjà un compte")
                }
            }
        }
    }
}

#Preview {
    SignUpView(isShowingSignIn: .constant(false), isShowingMenu: .constant(true))
        .environmentObject(UserViewModel())
}
