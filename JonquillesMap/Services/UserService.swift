//
//  UserService.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 04/12/2023.
//

import Foundation

struct UserService {
    func fetchAllUsers() async throws -> [User] {
        return try await APIData.decodeAPIInfo(route: "person", queryItems: [], to: [User].self)
    }
    
    func fetchUserById(id_user: Int) async throws -> User {
        return try await APIData.decodeAPIInfo(route: "person/\(id_user)", queryItems: [], to: User.self)
    }
    
    func fetchUsersInPlace(id_place: Int) async throws -> [User] {
        struct UserIds: Codable {
            var id_user: Int
            var id_place: Int
            
            enum CodingKeys: String, CodingKey {
                case id_user = "persons_id"
                case id_place = "event_id"
            }
        }
        
        let list = try await APIData.decodeAPIInfo(route: "event/\(id_place)/present", queryItems: [], to: [UserIds].self)
        var users: [User] = []
        
        for item in list {
            let user = try await fetchUserById(id_user: item.id_user)
            users.append(user)
        }
        
        return users
    }
    
    func logIn(email: String, password: String) async throws -> User {
        let requestBody = ["mail": email,
                           "mdp": password]
                
        let decodingData = try await APIData.requestAPIPost(route: "log_in", typeRequest: "POST", requestBody: requestBody as [String: Any], to: User.self)
        return decodingData
    }
    
    func signUp(username: String, phone: String, email: String, password: String) async throws -> User {
        let requestBody = ["pseudo": username,
                           "avatarimg": nil,
                           "phone": phone,
                           "mail": email,
                           "mdp": password]
                
        let decodingData = try await APIData.requestAPIPost(route: "person", typeRequest: "POST", requestBody: requestBody as [String : Any], to: User.self)
        return decodingData
    }
    
    func addPlaceUser(id_user: Int, id_place: Int) async throws {
        let requestBody = ["time": getFormattedDate(date: .now),
                           "persons_id": id_user,
                           "event_id": id_place] as [String : Any]

        try await APIData.requestAPIPost(route: "est_present", typeRequest: "POST", requestBody: requestBody)
    }
    
    func changeUserPlace(id_user: Int, id_place: Int) async throws {
        let requestBody = ["time": getFormattedDate(date: .now),
                           "event_id": id_place] as [String : Any]

        try await APIData.requestAPIPost(route: "est_present/\(id_user)", typeRequest: "PATCH", requestBody: requestBody)
    }
    
    func deleteUserPlace(id_user: Int) async throws {
        try await APIData.requestAPIPost(route: "est_present/\(id_user)", typeRequest: "DELETE", requestBody: [:])
    }
    
    func placeUserPresent(id_user: Int) async throws -> Place {
        return try await APIData.decodeAPIInfo(route: "person/\(id_user)/event", queryItems: [], to: Place.self)
    }
    
    private func getFormattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
}
