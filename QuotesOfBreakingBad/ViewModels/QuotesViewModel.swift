//
//  QuotesViewModel.swift
//  QuotesOfBreakingBad
//
//  Created by Andersson on 19/02/25.
//

import Foundation

@Observable
@MainActor
class QuotesViewModel {
    enum FetchStatus {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    
    private(set) var status: FetchStatus = .notStarted
    private let fetcher = FetchService()
    var quote: QuoteModel
    var character: CharacterModel
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        quote = try! decoder.decode(QuoteModel.self, from: quoteData)
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(CharacterModel.self, from: characterData)
    }
    
    func fetchData(for show: String) async {
        status = .fetching
        do {
            quote = try await fetcher.fetchQuotes(from: show)
            character = try await fetcher.fetchCharacter(quote.character)
            character.death = try await fetcher.fetchDeath(for: character.name)
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
}
