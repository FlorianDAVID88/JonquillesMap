//
//  Place.swift
//  MingleMap
//
//  Created by Florian DAVID on 30/11/2023.
//

import Foundation

enum TypePlace: String, CaseIterable, Decodable {
    case restaurant = "Restaurant"
    case bar = "Bar"
    case hotel = "Hotel"
    case activity = "Activité"
}

struct Place: Decodable {
    let id: Int
    let name: String
    let type: TypePlace
    let latitude: Double
    let longitude: Double
    let description: String
    let address: String
    let phone: String
    let website: URL?
    let image: URL?
    let rating: Double?
    let users: [User]
    
    init() {
        self.id = 1
        self.name = ""
        self.type = .bar
        self.latitude = 48.069516
        self.longitude = 6.866446
        self.description = ""
        self.address = "Gérardmer"
        self.phone = ""
        self.website = nil
        self.image = nil
        self.rating = 5
        self.users = []
    }
    
    enum CodingKeys: CodingKey {
        case id_place
        case name_place
        case libelle_type
        case latitude
        case longitude
        case description
        case address
        case phone_number
        case website
        case image
        case rating
        case users
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .libelle_type)
        
        self.id = try container.decode(Int.self, forKey: .id_place)
        self.name = try container.decode(String.self, forKey: .name_place)
        self.type = TypePlace(rawValue: type)!
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.description = try container.decode(String.self, forKey: .description)
        self.address = try container.decode(String.self, forKey: .address)
        self.phone = try container.decode(String.self, forKey: .phone_number)
        self.website = try container.decode(URL?.self, forKey: .website)
        self.image = try container.decode(URL?.self, forKey: .image)
        self.rating = try container.decode(Double?.self, forKey: .rating)
        self.users = try container.decode([User].self, forKey: .users)
    }
}
