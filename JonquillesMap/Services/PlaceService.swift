//
//  PlaceService.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 30/11/2023.
//

import Foundation

struct PlaceService {
    /**
     * Retourne tous les endroits utilisés pour la Map
     */
    func fetchAllPlaces() async throws -> [Place] {
        return try await APIData.decodeAPIInfo(route: "event", queryItems: [], to: [Place].self)
    }
    
    /**
     * Récupère l'endroit ou se trouve un utilisateur
     * @return cet endroit
     */
    func placeUserPresent(id_user: Int) async throws -> Place {
        return try await APIData.decodeAPIInfo(route: "person/\(id_user)/event", queryItems: [], to: Place.self)
    }
}
