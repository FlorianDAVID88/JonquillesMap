//
//  ButtonsActionPlaceView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 09/01/2024.
//

import SwiftUI

struct ButtonsActionPlaceView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State var place: Place
    @State var users: [User]
    @State private var placeUser: Place? = nil
    
    var body: some View {
        VStack {
            if let currentUser = userVM.currentUser {
                HStack {
                    if users.filter({ $0.id == currentUser.id }).count > 0 {
                        ButtonDeleteToPlaceView(place: place)
                    } else if let _ = placeUser {
                        ButtonToPlaceView(place: place)
                    } else {
                        ButtonAddToPlaceView(place: place)
                    }
                }
                .task {
                    placeUser = await userVM.getPlaceUserPresent(id_user: currentUser.id)
                }
            }
        }
    }
}

#Preview {
    ButtonsActionPlaceView(place: Place(), users: [])
        .environmentObject(UserViewModel())
}
