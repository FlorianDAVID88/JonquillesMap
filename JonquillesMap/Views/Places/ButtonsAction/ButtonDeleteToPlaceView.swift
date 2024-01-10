//
//  ButtonDeleteToPlaceView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 18/12/2023.
//

import SwiftUI

struct ButtonDeleteToPlaceView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State var place: Place
    @State private var isClicked = false
    @State private var change = false
    
    var body: some View {
        ZStack {
            if let curUser = userVM.currentUser {
                Button {
                    isClicked.toggle()
                } label: {
                    HStack {
                        Image(systemName: "trash")
                            .imageScale(.large)
                            .scaledToFit()
                        
                        Text("Je ne suis plus à cet endroit")
                    }
                    .padding()
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .alert(isPresented: $isClicked) {
                    Alert(title: Text("Êtes-vous parti de \(place.name) ?"),
                          primaryButton: .cancel(Text("Oui"), action: { change.toggle() }),
                          secondaryButton: .default(Text("Non"))
                    )
                }
                .onChange(of: change) {
                    Task.init {
                        if change {
                            await userVM.deleteUserPlace(id_user: curUser.id)
                            await userVM.getUsersInPlace(id: place.id)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ButtonDeleteToPlaceView(place: Place())
        .environmentObject(UserViewModel())
}

