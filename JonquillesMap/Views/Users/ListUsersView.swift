//
//  ListUsersView.swift
//  MingleMap
//
//  Created by Florian DAVID on 04/12/2023.
//

import SwiftUI

struct ItemUserView: View {
    @State var user: User
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                Text(user.username)
                    .bold()
                
                Text(user.email)
            }
            .foregroundColor(.primary)
        }
    }
}

struct ListUsersView: View {
    @State var users: [User]
    
    var body: some View {
        List {
            ForEach(users, id: \.self.id) { user in
                NavigationLink(destination: UserProfileView(user: user)) {
                    ItemUserView(user: user)
                }
            }
        }
        .listStyle(.grouped)
    }
}

#Preview {
    ListUsersView(users: [
        User(), User()
    ])
}
