//
//  ButtonAddToPlaceView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 20/12/2023.
//

import SwiftUI

struct ButtonAddToPlaceView: View {
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
                        Image(systemName: "plus")
                            .imageScale(.large)
                            .scaledToFit()
                        
                        Text("Je suis à cet endroit")
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .alert(isPresented: $isClicked) {
                    Alert(title: Text("S'ajouter à \(place.name) ?"),
                          primaryButton: .cancel(Text("Oui"), action: { change.toggle() }),
                          secondaryButton: .default(Text("Non"))
                    )
                }
                .onChange(of: change) {
                    Task.init {
                        if change {
                            await userVM.addUserPlace(id_user: curUser.id, id_place: place.id)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ButtonAddToPlaceView(place: Place())
        .environmentObject(UserViewModel())
}
