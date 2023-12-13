//
//  UserService.swift
//  MingleMap
//
//  Created by Florian DAVID on 04/12/2023.
//

import Foundation

enum UserError: Error {
    case invalidStatusCode
}

struct UserService {
    func fetchAllUsers() async throws -> [User] {
        let url = URL(string: "\(APIData.getApiURL())/users")!
        
        let (data, resp) = try await URLSession.shared.data(from: url)
        
        guard let response = resp as? HTTPURLResponse, response.statusCode == 200 else {
            throw UserError.invalidStatusCode
        }
        
        let decodingData = try JSONDecoder().decode([User].self, from: data)
        return decodingData
    }
    
    func fetchUsersInPlace(id_place: Int) async throws -> [User] {
        let url = URL(string: "\(APIData.getApiURL())/users/place/\(id_place)")!
        
        let (data, resp) = try await URLSession.shared.data(from: url)
        
        guard let response = resp as? HTTPURLResponse, response.statusCode == 200 else {
            throw UserError.invalidStatusCode
        }
        
        let decodingData = try JSONDecoder().decode([User].self, from: data)
        return decodingData
    }
}
