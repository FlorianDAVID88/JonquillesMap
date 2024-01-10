//
//  ContentView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 30/11/2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State private var tabTitle = "Home"
    @State private var sheetConnect = false
    
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $tabTitle) {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Accueil")
                        }
                        .tag("Accueil")
                    
                    MapView()
                        .tabItem {
                            Image(systemName: "map.fill")
                            Text("Map")
                        }
                        .tag("Map")
                }
            }
            .navigationBarTitle(Text(tabTitle), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Group {
                        if tabTitle == "Map" { InfoMapButton() }
                    },
                trailing:
                    Group {
                        if let user = userVM.currentUser {
                            NavigationLink(destination: UserProfileView(user: user)) {
                                Image(systemName: "person.circle.fill")
                            }
                        } else {
                            Button {
                                sheetConnect.toggle()
                            } label: {
                                Image(systemName: "person.circle.fill")
                            }
                        }
                    }
            )
            .sheet(isPresented: $sheetConnect) {
                SliderSignView(isShowingMenu: $sheetConnect)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserViewModel())
}
