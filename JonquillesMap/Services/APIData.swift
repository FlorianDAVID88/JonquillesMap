//
//  APIData.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 30/11/2023.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidStatusCode(code: Int)
}

struct APIData {
    /**
     * Retourne l'URL principal de l'API (stockée dans une variable d'environnement nommée "URL_API")
     */
    private static func getApiURL() -> String {
        guard let url = ProcessInfo.processInfo.environment["URL_API"] else {
            return ""
        }
        return url
    }
    
    /**
     * Récupère les informations par rapport à une URL (utilisé seulement pour des requêtes GET avec paramètres et/ou possiblement des queries)
     * @route email : la route de l'API Node.js correspondante
     * @queryItems: les queries à passer à la route
     * @to: le type de l'objet à récupérer
     * @return: l'objet décodé
     */
    static func decodeAPIInfo<T: Decodable>(route: String, queryItems: [URLQueryItem], to: T.Type) async throws -> T {
        guard let url = URL(string: "\(APIData.getApiURL())/\(route)") else {
            throw APIError.invalidURL
        }
        
        let (data, resp) = try await URLSession.shared.data(from: url)
        let response = (resp as? HTTPURLResponse)!
        if response.statusCode != 200 && response.statusCode != 201 {
            throw APIError.invalidStatusCode(code: response.statusCode)
        }
        
        let decodingData = try JSONDecoder().decode(T.self, from: data)
        return decodingData
    }
    
    /**
     * Récupère les informations par rapport à une URL (utilisé seulement pour des requêtes "non-GET" (POST, PUT, DELETE) avec paramètres ou un body) renvoyant des données
     * @param route : la route utilisée
     * @param typeRequest : la méthode HTTP utilisée (POST, PUT, DELETE)
     * @param requestBody : le contenu du body sous forme de [String]
     * @param to: le type de l'objet à récupérer
     * @return rien l'objet décodé sauf si c'est défini comme un Void
     */
    static func requestAPIPost<T: Decodable>(route: String, typeRequest: String, requestBody: [String: Any], to: T.Type) async throws -> T {
        guard let url = URL(string: "\(APIData.getApiURL())/\(route)") else {
            throw APIError.invalidURL
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)
        var request = URLRequest(url: url)
        request.httpMethod = typeRequest
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, resp) = try await URLSession.shared.data(for: request)
        let response = (resp as? HTTPURLResponse)!
        if response.statusCode != 200 && response.statusCode != 201 {
            throw APIError.invalidStatusCode(code: response.statusCode)
        }

        let decodingData = try JSONDecoder().decode(T.self, from: data)
        return decodingData
    }
    
    /**
     * Même chose que pour la fonction précédente mais sans retour de données (Void)
     * @param route : la route utilisée
     * @param typeRequest : la méthode HTTP utilisée (POST, PATCH, DELETE)
     * @param requestBody : le contenu du body sous forme de [String]
     */
    static func requestAPIPost(route: String, typeRequest: String, requestBody: [String: Any]) async throws {
        guard let url = URL(string: "\(APIData.getApiURL())/\(route)") else {
            throw APIError.invalidURL
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)
        var request = URLRequest(url: url)
        request.httpMethod = typeRequest
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, resp) = try await URLSession.shared.data(for: request)
        let response = (resp as? HTTPURLResponse)!
        if response.statusCode != 200 && response.statusCode != 201 {
            throw APIError.invalidStatusCode(code: response.statusCode)
        }
    }
}
