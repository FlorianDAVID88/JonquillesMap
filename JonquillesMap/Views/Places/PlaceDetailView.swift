//
//  PlaceDetailView.swift
//  MingleMap
//
//  Created by Florian DAVID on 04/12/2023.
//

import SwiftUI

struct PlaceDetailView: View {
    @StateObject var viewModel = UserViewModel()
    @State var place: Place
    @Binding var appear: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 15) {
                    Text(place.name)
                        .font(.title)
                        .bold()
                    
                    if let url = place.image {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(40)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 80)
                    }
                }
                
                VStack {
                    HStack {
                        Text("Personnes présentes : ")
                        Spacer()
                    }
                    
                    switch viewModel.state {
                    case .loading:
                        ProgressView()
                    case .success(let data):
                        let users = (data as? [User])!
                        ListUsersView(users: users)
                    default:
                        EmptyView()
                    }
                }
            }
            .padding(.horizontal, 5)
            .navigationBarItems(
                leading: Button {
                    appear = false 
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .scaledToFit()
                }
            )
            .navigationBarTitle(Text(place.name), displayMode: .inline)
            .task {
                await viewModel.getUsersInPlace(id: place.id)
            }
        }
    }
}

#Preview {
    PlaceDetailView(place: Place(), appear: .constant(true))
}
