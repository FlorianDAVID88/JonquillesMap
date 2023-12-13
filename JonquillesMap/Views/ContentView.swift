//
//  ContentView.swift
//  MingleMap
//
//  Created by Florian DAVID on 30/11/2023.
//

import SwiftUI
import MapKit
//https://www.fete-des-jonquilles-gerardmer-officiel.fr
struct ContentView: View {
    @State private var tabTitle = "Home"
    
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $tabTitle) {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag("Home")
                    
                    MapView()
                        .tabItem {
                            Image(systemName: "map.fill")
                            Text("Map")
                        }
                        .tag("Map")
                }
            }
            .navigationBarTitle(Text(tabTitle), displayMode: .inline)
            .navigationBarItems(trailing:
                NavigationLink(destination: UserProfileView(user: User())) {
                    Image(systemName: "person.circle.fill")
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
