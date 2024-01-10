//
//  PlaceViewModel.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 30/11/2023.
//

import Foundation

enum PlaceState {
    case notAvailable
    case loading
    case success(data: Decodable)
    case error(error: Error)
}

@MainActor
class PlaceViewModel: ObservableObject {
    @Published var state: PlaceState = .notAvailable
    private let service = PlaceService()
    
    func getAllPlaces() async {
        state = .loading
        do {
            let places = try await service.fetchAllPlaces()
            state = .success(data: places)
        } catch {
            state = .error(error: error)
            print(error)
        }
    }
}
