//
//  ButtonDisconnectView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 10/01/2024.
//

import SwiftUI

struct ButtonDisconnectView: View {
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var alertDisconnect = false

    var body: some View {
        Button {
            alertDisconnect.toggle()
        } label: {
            Text("Se déconnecter")
                .padding()
                .background(Color.accentColor)
                .cornerRadius(10)
                .foregroundColor(.white)
        }
        .alert(isPresented: $alertDisconnect) {
            Alert(
                title: Text("Êtes-vous sûr de vouloir vous déconnecter"),
                primaryButton: .default(Text("Non"), action: {
                    alertDisconnect = false
                }),
                secondaryButton: .cancel(Text("Oui"), action: {
                    userVM.disconnect()
                    if userVM.currentUser == nil {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
            )
        }
    }
}

#Preview {
    ButtonDisconnectView()
        .environmentObject(UserViewModel())
}
