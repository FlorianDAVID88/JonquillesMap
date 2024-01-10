//
//  PlaceDetailView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 04/12/2023.
//

import SwiftUI

struct PlaceDetailView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @State var place: Place
    @Binding var appear: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 15) {
                    if let url = place.image {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(40)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 80, height: 80)
                    }
                    
                    Text(place.address)
                }
                   
                if let rating = place.rating {
                    StarRatingView(rating: rating)
                }
                
                HStack {
                    MarkerMapView(place: place)
                        .frame(height: 30)
                    Text(place.description)
                }
                
                if !place.phone.isEmpty {
                    HStack {
                        Image(systemName: "phone.fill")
                            .imageScale(.large)
                            .scaledToFit()
                            .foregroundColor(.accentColor)
                        Text(place.phone)
                    }
                }
                
                VStack {
                    switch viewModel.state {
                        case .loading:
                            ProgressView()
                        case .success(let data):
                            if let users = (data as? [User]) {
                                HStack {
                                    Text("Personnes présentes (\(users.count)) : ")
                                    Spacer()
                                }
                                .padding(5)
                                
                                ListUsersView(users: users)
                                ButtonsActionPlaceView(place: place, users: users)
                            }
                        default:
                            Text("Execution error")
                                .bold()
                                .foregroundColor(.red)
                    }
                }
            }
            .navigationBarItems(
                leading:
                    Button {
                        appear = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .scaledToFit()
                    },
                trailing:
                    Section {
                        if let url = place.website {
                            Button {
                                UIApplication.shared.open(url)
                            } label: {
                                Image(systemName: "globe")
                                    .imageScale(.large)
                                    .scaledToFit()
                            }
                        }
                    }
            )
            .navigationBarTitle(Text(place.name), displayMode: .inline)
            .task {
                await viewModel.getUsersInPlace(id: 4)
            }
        }
    }
}

#Preview {
    PlaceDetailView(place: Place(), appear: .constant(true))
        .environmentObject(UserViewModel())
}
