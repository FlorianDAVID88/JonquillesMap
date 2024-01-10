//
//  UserViewModel.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 04/12/2023.
//

import Foundation

enum UserState {
    case notAvailable
    case loading
    case success(data: Decodable)
    case error(error: Error)
}

@MainActor
class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var state: UserState = .notAvailable
    private let service = UserService()
    
    init() {
        currentUser = getCurrentUser()
    }
    
    /**
     * Récupère l'utilisateur courant
     * @return User? currentUser
     */
    private func getCurrentUser() -> User? {
        if let storedData = UserDefaults.standard.data(forKey: "currentUser"),
           let decodedPerson = try? JSONDecoder().decode(User.self, from: storedData) {
            return decodedPerson
        }
        return nil
    }
    
    /**
     * Définit l'utilisateur courant (sauf si déconnexion : nil)
     */
    func setCurrentUser(user: User?) {
        if let encodedData = try? JSONEncoder().encode(user) {
            DispatchQueue.main.async {
                UserDefaults.standard.set(encodedData, forKey: "currentUser")
                self.currentUser = user
            }
        }
    }
    
    /**
     * Déconnexion de l'application -> Utilisateur courant à nil
     */
    func disconnect() {
        self.setCurrentUser(user: nil)
    }
    
    /**
     * Récupère tous les utilisateurs via l'API
     */
    func getAllUsers() async {
        state = .loading
        do {
            let users = try await service.fetchAllUsers()
            state = .success(data: users)
        } catch {
            state = .error(error: error)
            print(error)
        }
    }
    
    /**
     * Récupère tous les utilisateurs se situant à une certain endroit via l'API
     * @param id l'id du lieu
     */
    func getUsersInPlace(id: Int) async {
        state = .loading
        do {
            let allUsers = try await service.fetchUsersInPlace(id_place: id)
            state = .success(data: allUsers)
        } catch {
            state = .error(error: error)
            print(error)
        }
    }
    
    /**
     * Connexion d'un utilisateur existant via l'API
     * @return Bool true si connexion réussie, false sinon
     */
    func logIn(email: String, passwd: String) async -> Bool {
        do {
            let user = try await service.logIn(email: email, password: passwd)
            self.setCurrentUser(user: user)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    /**
     * Inscription d'un nouvel utilisateur via l'API
     * @return Bool true si inscription réussie, false sinon
     */
    func signUp(username: String, phone: String, email: String, password: String) async -> Bool {
        do {
            let user = try await service.signUp(username: username, phone: phone, email: email, password: password)
            self.setCurrentUser(user: user)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    /**
     * Ajoute l'utilisateur à un certain endroit via l'API
     * @param id_user l'id de l'utilisateur
     * @param id_place l'id de l'endroit
     */
    func addUserPlace(id_user: Int, id_place: Int) async {
        do {
            try await service.addPlaceUser(id_user: id_user, id_place: id_place)
        } catch {
            print("Erreur addUserPlace : \(error)")
        }
        await getUsersInPlace(id: id_place)
    }
    
    
    /**
     * Change l'endroit où se situe l'utilisateur via l'API
     * @param id_place l'id de l'endroit
     * @param id_user l'id de l'utilisateur
     */
    func changePlaceUser(id_place: Int, id_user: Int) async {
        do {
            try await service.changeUserPlace(id_user: id_user, id_place: id_place)
        } catch {
            print("Erreur changeUserPlace : \(error)")
        }
        await getUsersInPlace(id: id_place)
    }
    
    /**
     * L'utilisateur se retire de l'endroit où il se trouve via l'API
     * @param id_user l'id de l'utilisateur
     */
    func deleteUserPlace(id_user: Int) async {
        do {
            try await service.deleteUserPlace(id_user: id_user)
        } catch {
            print("Erreur deleteUserPlace : \(error)")
        }
    }
    
    /**
     * Récupère l'endroit où se situe un certain utilisateur via l'API
     * @param id_user l'id de l'utilisateur
     * @return Place? l'endroit où se situe l'utilisateur (s'il y en a un)
     */
    private func getPlaceUserPresent(id_user: Int) async -> Place? {
        do {
            return try await APIData.decodeAPIInfo(route: "person/\(id_user)/event", queryItems: [], to: Place.self)
        } catch {
            return nil
        }
    }
    
    /**
     * Supprime le compte d'un utilisateur via l'API
     * @param id_user l'id de l'utilisateur
     */
    func deleteAccount(id_user: Int) async {
        if await getPlaceUserPresent(id_user: id_user) != nil {
            await deleteUserPlace(id_user: id_user)
        }
        
        do {
            try await service.deleteAccount(id_user: id_user)
            disconnect()
        } catch {
            print("Erreur deleteAccount : \(error)")
        }
    }
}
