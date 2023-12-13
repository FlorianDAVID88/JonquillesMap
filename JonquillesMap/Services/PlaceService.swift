//
//  PlaceService.swift
//  MingleMap
//
//  Created by Florian DAVID on 30/11/2023.
//

import Foundation

enum PlaceError: Error {
    case invalidStatusCode
}

struct PlaceService {
    func fetchAllPlaces() async throws -> [Place] {
        let url = URL(string: "\(APIData.getApiURL())/places")!

        let (data, resp) = try await URLSession.shared.data(from: url)

        guard let response = resp as? HTTPURLResponse, response.statusCode == 200 else {
            throw PlaceError.invalidStatusCode
        }
        
        let decodingData = try JSONDecoder().decode([Place].self, from: data)
        return decodingData
    }
    
    func fetchPlaceWithUsers(id: Int) async throws -> Place {
        let url = URL(string: "\(APIData.getApiURL())/places/\(id)")!

        let (data, resp) = try await URLSession.shared.data(from: url)

        guard let response = resp as? HTTPURLResponse, response.statusCode == 200 else {
            throw PlaceError.invalidStatusCode
        }
        
        let decodingData = try JSONDecoder().decode(Place.self, from: data)
        return decodingData
    }
}
