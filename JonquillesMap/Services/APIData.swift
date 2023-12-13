//
//  APIData.swift
//  MingleMap
//
//  Created by Florian DAVID on 30/11/2023.
//

import Foundation

struct APIData {
    //localhost:3000 est stocké dans une variable d'environnement nommée URL_API
    static func getApiURL() -> String {
        guard let url = ProcessInfo.processInfo.environment["URL_API"] else {
            return ""
        }
        return url
    }
}
