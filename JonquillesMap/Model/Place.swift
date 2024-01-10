//
//  Place.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 30/11/2023.
//

import Foundation

enum TypePlace: String, CaseIterable, Decodable {
    case restaurant = "Restaurant"
    case bar = "Bar"
    case hotel = "Hotel"
    case activity = "Activité"
    
    init(id: Int) {
        switch id {
            case 2 : self = .bar
            case 3 : self = .restaurant
            case 4 : self = .hotel
            default: self = .activity
        }
    }
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
    
    init() {
        self.id = 1
        self.name = "O’Malo"
        self.type = .restaurant
        self.latitude = 48.079277
        self.longitude = 6.889018
        self.description = "Restauration rapide"
        self.address = "5 Faubourg de Bruyères, 88400 Gérardmer"
        self.phone = "0329565878"
        self.website = URL(string: "https://omalo.fr/gerardmer2/")
        self.image = URL(string: "http://www.jamagne.com/assets/img/jamagne__.svg")
        self.rating = 4.5
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case type_id = "event_types_id"
        case name
        case latitude
        case longitude
        case description
        case address
        case phone
        case website
        case image
        case rating
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeId = try container.decode(Int.self, forKey: .type_id)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.type = TypePlace(id: typeId)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.description = try container.decode(String.self, forKey: .description)
        self.address = try container.decode(String.self, forKey: .address)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.website = try container.decode(URL?.self, forKey: .website)
        self.image = try container.decode(URL?.self, forKey: .image)
        self.rating = try container.decode(Double?.self, forKey: .rating)
    }
}
