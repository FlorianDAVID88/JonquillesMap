//
//  UserProfileView.swift
//  MingleMap
//
//  Created by Florian DAVID on 04/12/2023.
//

import SwiftUI

struct UserProfileView: View {
    @State var user: User
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .navigationBarTitle(Text("\(user.username) - Profile"), displayMode: .inline)
    }
}

#Preview {
    UserProfileView(user: User())
}
