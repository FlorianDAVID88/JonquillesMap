//
//  UserProfileView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 04/12/2023.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var userVM: UserViewModel
    @StateObject var placeVM = PlaceViewModel()
    @State var user: User
    @State private var placeUser: Place? = nil
    
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
                
                HStack {
                    Text("N° de téléphone")
                    Spacer()
                    Text(user.phone)
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
                placeUser = await placeVM.getPlaceUserPresent(id_user: user.id)
            }
            
            Spacer()
            
            if user.id == userVM.currentUser?.id {
                HStack {
                    ButtonDisconnectView()
                    ButtonDeleteAccount()
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
