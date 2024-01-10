//
//  MarkerMapView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 30/11/2023.
//

import SwiftUI
import MapKit

struct MarkerView: View {
    @State var place: Place
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(getColor())
                .scaledToFit()
                .frame(width: 40)
            
            Image(systemName: getMarkerImageName())
        }
        .foregroundColor(.white)
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

struct MarkerMapView: View {
    @State var place: Place
    @State private var isSheet = false
    
    var body: some View {
        MarkerView(place: place)
            .onTapGesture {
                isSheet.toggle()
            }
            .sheet(isPresented: $isSheet) {
                PlaceDetailView(place: place, appear: $isSheet)
            }
    }
}

#Preview {
    MarkerMapView(place: Place())
}
