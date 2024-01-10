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
    
    func disconnect() {
        self.setCurrentUser(user: nil)
    }
    
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
    
    func addUserPlace(id_user: Int, id_place: Int) async {
        do {
            try await service.addPlaceUser(id_user: id_user, id_place: id_place)
        } catch {
            print("Erreur addUserPlace : \(error)")
        }
        await getUsersInPlace(id: id_place)
    }
    
    func changePlaceUser(id_place: Int, id_user: Int) async {
        do {
            try await service.changeUserPlace(id_user: id_user, id_place: id_place)
        } catch {
            print("Erreur changeUserPlace : \(error)")
        }
        await getUsersInPlace(id: id_place)
    }
    
    func deleteUserPlace(id_user: Int, id_place: Int) async {
        do {
            try await service.deleteUserPlace(id_user: id_user)
        } catch {
            print("Erreur deleteUserPlace : \(error)")
        }
        await getUsersInPlace(id: id_place)
    }
    
    func getPlaceUserPresent(id_user: Int) async -> Place? {
        do {
            return try await service.placeUserPresent(id_user: id_user)
        } catch {
            return nil
        }
    }
}
