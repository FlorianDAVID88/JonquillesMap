//
//  UserService.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 04/12/2023.
//

import Foundation

struct UserService {
    /**
     * Récupère tous les utilisateurs de l'application
     */
    func fetchAllUsers() async throws -> [User] {
        return try await APIData.decodeAPIInfo(route: "person", queryItems: [], to: [User].self)
    }
    
    /**
     * Récupère un utilisateur en fonction de son id
     * @param id_user l'id de l'utilisateur
     */
    func fetchUserById(id_user: Int) async throws -> User {
        return try await APIData.decodeAPIInfo(route: "person/\(id_user)", queryItems: [], to: User.self)
    }
    
    /**
     * Récupère les utilisateurs présents à un certain endroit
     * @param id_place l'id de l'endroit
     */
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
    
    /**
     * Connexion d'un utilisateur existant
     * @return cet utilisateur
     */
    func logIn(email: String, password: String) async throws -> User {
        let requestBody = ["mail": email,
                           "mdp": password]
                
        let decodingData = try await APIData.requestAPIPost(route: "log_in", typeRequest: "POST", requestBody: requestBody as [String: Any], to: User.self)
        return decodingData
    }
    
    /**
     * Inscription d'un nouvel utilisateur
     * @return cet utilisateur
     */
    func signUp(username: String, phone: String, email: String, password: String) async throws -> User {
        let requestBody = ["pseudo": username,
                           "avatarimg": nil,
                           "phone": phone,
                           "mail": email,
                           "mdp": password]
                
        let decodingData = try await APIData.requestAPIPost(route: "person", typeRequest: "POST", requestBody: requestBody as [String : Any], to: User.self)
        return decodingData
    }
    
    /**
     * L'utilisateur s'ajoute à un endroit donné (sachant qu'il est référencé nulle part)
     * @param id_user l'id de l'utilisateur
     * @param id_place l'id de l'utilisateur
     */
    func addPlaceUser(id_user: Int, id_place: Int) async throws {
        let requestBody = ["time": getFormattedDate(date: .now),
                           "persons_id": id_user,
                           "event_id": id_place] as [String : Any]

        try await APIData.requestAPIPost(route: "est_present", typeRequest: "POST", requestBody: requestBody)
    }
    
    /**
     * L'utilisateur change d'endroit (sachant qu'il est déjà référencé quelque part)
     * @param id_user l'id de l'utilisateur
     * @param id_place l'id de l'utilisateur
     */
    func changeUserPlace(id_user: Int, id_place: Int) async throws {
        let requestBody = ["time": getFormattedDate(date: .now),
                           "event_id": id_place] as [String : Any]

        try await APIData.requestAPIPost(route: "est_present/\(id_user)", typeRequest: "PATCH", requestBody: requestBody)
    }
    
    /**
     * L'utilisateur se retire d'un endroit sans aller dans un autre
     * @param id_user l'id de l'utilisateur
     */
    func deleteUserPlace(id_user: Int) async throws {
        try await APIData.requestAPIPost(route: "est_present/\(id_user)", typeRequest: "DELETE", requestBody: [:])
    }
    
    /**
     * Suppression d'un compte utilisateur
     * @param id_user l'id de l'utilisateur
     */
    func deleteAccount(id_user: Int) async throws {
        try await APIData.requestAPIPost(route: "person/\(id_user)", typeRequest: "DELETE", requestBody: [:])
    }
    
    /**
     * Formate une date donnée au format "yyyy-MM-dd HH:mm:ss.SSSSSS" utilisé dans la base de données
     * @return la date formatée sous forme de String
     */
    private func getFormattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
}
