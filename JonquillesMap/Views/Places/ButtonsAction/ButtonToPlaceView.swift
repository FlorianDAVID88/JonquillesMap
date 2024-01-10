//
//  ButtonToPlaceView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 18/12/2023.
//

import SwiftUI

struct ButtonToPlaceView: View {
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
                        Image(systemName: "arrowshape.turn.up.forward.fill")
                            .imageScale(.large)
                            .scaledToFit()
                        
                        Text("Je suis à cet endroit")
                    }
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .alert(isPresented: $isClicked) {
                    Alert(title: Text("Vous étiez déjà à un autre endroit ! Changer ?"),
                          primaryButton: .cancel(Text("Oui"), action: { change.toggle() }),
                          secondaryButton: .default(Text("Non"))
                    )
                }
                .onChange(of: change) {
                    Task.init {
                        if change {
                            await userVM.changePlaceUser(id_place: place.id, id_user: curUser.id)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ButtonToPlaceView(place: Place())
        .environmentObject(UserViewModel())
}
