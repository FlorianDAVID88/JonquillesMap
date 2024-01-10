//
//  User.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 04/12/2023.
//

import Foundation

struct User: Codable {
    var id: Int
    var username: String
    var avatarURL: URL?
    var phone: String
    var email: String
    
    init() {
        self.id = 7
        self.username = "Florian DAVID"
        self.phone = ""
        self.email = "flodavid88@gmail.com"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username = "pseudo"
        case avatarURL = "avatarimg"
        case phone
        case email = "mail"
    }
}
