//
//  UserProfileView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 04/12/2023.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userVM: UserViewModel
    @State var user: User
    @State private var placeUser: Place? = nil
    @State private var alertDisconnect = false
    
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: user.avatarURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
            
            Text(user.username)
                .font(.system(size: 36))
                .bold()
            
            List {
                HStack {
                    Text("Adresse e-mail")
                    Spacer()
                    Text(user.email)
                }
                
                if let placeUser = placeUser {
                    HStack {
                        Text("Endroit actuel")
                        Spacer()
                        MarkerView(place: placeUser)
                        Text(placeUser.name)
                    }
                }
            }
            .listStyle(.plain)
            .task {
                if let curUser = userVM.currentUser {
                    placeUser = await userVM.getPlaceUserPresent(id_user: curUser.id)
                }
            }
            
            Spacer()
            
            if user.id == userVM.currentUser?.id {
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
        .navigationBarTitle(Text("\(user.username) - Profile"), displayMode: .inline)
    }
}

#Preview {
    UserProfileView(user: User())
        .environmentObject(UserViewModel())
}
