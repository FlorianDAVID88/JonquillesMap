//
//  MarkerMapView.swift
//  MingleMap
//
//  Created by Florian DAVID on 30/11/2023.
//

import SwiftUI
import MapKit

struct MarkerMapView: View {
    @State var place: Place
    @State private var isSheet = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(getColor())
                .scaledToFit()
                .frame(width: 40)
            
            Image(systemName: getMarkerImageName())
        }
        .onTapGesture {
            isSheet.toggle()
        }
        .foregroundColor(.white)
        .sheet(isPresented: $isSheet) {
            PlaceDetailView(place: place, appear: $isSheet)
        }
    }
    
    func getColor() -> Color {
        switch place.type {
            case .restaurant: return .blue
            case .bar: return .brown
            case .hotel: return .orange
            case .activity: return .green
        }
    }
    
    func getMarkerImageName() -> String {
        switch place.type {
            case .restaurant: return "fork.knife"
            case .bar: return "wineglass"
            case .hotel: return "house"
            case .activity: return "list.clipboard"
        }
    }
}

#Preview {
    MarkerMapView(place: Place())
}
