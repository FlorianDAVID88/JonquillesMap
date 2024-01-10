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
    
    /**
     * Retourne tous les endroits qui seront utilisés dans la Map
     */
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
    
    /**
     * Récupère l'endroit où se situe un certain utilisateur via l'API
     * @param id_user l'id de l'utilisateur
     * @return Place? l'endroit où se situe l'utilisateur (s'il y en a un)
     */
    func getPlaceUserPresent(id_user: Int) async -> Place? {
        do {
            return try await service.placeUserPresent(id_user: id_user)
        } catch {
            return nil
        }
    }
}
