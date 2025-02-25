//
//  FetchService.swift
//  QuotesOfBreakingBad
//
//  Created by Andersson on 18/02/25.
//

import Foundation

struct FetchService {
    private enum FetchError: Error {
        case badresponse
    }
    
    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    
    func fetchQuotes(from show: String) async throws -> QuoteModel {
        let quoteURL = baseURL.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badresponse
        }
        let quote = try JSONDecoder().decode(QuoteModel.self, from: data)
        return quote
    }
    
    func fetchCharacter(_ name: String) async throws -> CharacterModel {
        let characterURL = baseURL.appending(path: "characters")
        let fetchURL = characterURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badresponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let characters = try decoder.decode([CharacterModel].self, from: data)
        return characters[0]
    }
    
    func fetchDeath(for character: String) async throws -> DeathModel? {
        let fetchURL = baseURL.appending(path: "deaths")
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badresponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let deaths = try decoder.decode([DeathModel].self, from: data)
        return deaths.first(where: { $0.character == character })
    }
}
