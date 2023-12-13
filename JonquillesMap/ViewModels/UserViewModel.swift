//
//  UserViewModel.swift
//  MingleMap
//
//  Created by Florian DAVID on 04/12/2023.
//

import Foundation

enum UserState {
    case notAvailable
    case loading
    case success(data: Codable)
    case error(error: Error)
}

@MainActor
class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var state: UserState = .notAvailable
    private let service = UserService()
    
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
            let users = try await service.fetchUsersInPlace(id_place: id)
            state = .success(data: users)
        } catch {
            state = .error(error: error)
            print(error)
        }
    }
}
