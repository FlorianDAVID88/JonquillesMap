//
//  ButtonDeleteAccount.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 10/01/2024.
//

import SwiftUI

struct ButtonDeleteAccount: View {
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var alertDelete = false
    @State private var goDelete = false

    var body: some View {
        Button {
            alertDelete.toggle()
        } label: {
            Text("Supprimer le compte")
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .foregroundColor(.white)
        }
        .alert(isPresented: $alertDelete) {
            Alert(
                title: Text("Êtes-vous sûr de vouloir vous supprimer votre comptet utilisateur ?"),
                primaryButton: .default(Text("Non"), action: {
                    alertDelete = false
                }),
                secondaryButton: .cancel(Text("Oui"), action: {
                    goDelete = true
                    if userVM.currentUser == nil {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
            )
        }
        .onChange(of: goDelete) {
            if goDelete {
                Task.init {
                    if let user = userVM.currentUser {
                        await userVM.deleteAccount(id_user: user.id)
                    }
                }
            }
        }
    }
}

#Preview {
    ButtonDeleteAccount()
        .environmentObject(UserViewModel())
}
