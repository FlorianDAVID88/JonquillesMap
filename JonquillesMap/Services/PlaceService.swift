//
//  PlaceService.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 30/11/2023.
//

import Foundation

struct PlaceService {
    func fetchAllPlaces() async throws -> [Place] {
        return try await APIData.decodeAPIInfo(route: "event", queryItems: [], to: [Place].self)
    }
}
