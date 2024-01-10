//
//  MapView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 30/11/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var viewModel = PlaceViewModel()
    @State private var region = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 48.074487, longitude: 6.872251),
            span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        )
    )
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .success(let data):
                Map(position: .constant(region)) {
                    let places = (data as? [Place])!
                    ForEach(places, id: \.self.id) { place in
                        Annotation(place.name, coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)) {
                            MarkerMapView(place: place)
                        }
                    }
                }
                .mapControlVisibility(.hidden)
            default:
                EmptyView()
            }
        }
        .task {
            await viewModel.getAllPlaces()
        }
    }
}

#Preview {
    MapView()
}
