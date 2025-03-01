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
        case successQuotes
        case successEpisodes
        case failed(error: Error)
    }
    
    private(set) var status: FetchStatus = .notStarted
    private let fetcher = FetchService()
    var quote: QuoteModel
    var character: CharacterModel
    var episode: EpisodeModel
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        quote = try! decoder.decode(QuoteModel.self, from: quoteData)
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(CharacterModel.self, from: characterData)
        let episodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
        episode = try! decoder.decode(EpisodeModel.self, from: episodeData)
    }
    
    func getQuoteData(for show: String) async {
        status = .fetching
        do {
            quote = try await fetcher.fetchQuotes(from: show)
            character = try await fetcher.fetchCharacter(quote.character)
            character.death = try await fetcher.fetchDeath(for: character.name)
            status = .successQuotes
        } catch {
            status = .failed(error: error)
        }
    }
    
    func getEpisode(for show: String) async {
        status = .fetching
        do {
            if let unwrappedEpisode = try await fetcher.fetchEpisode(from: show) {
                episode = unwrappedEpisode
            }
            status = .successEpisodes
        } catch {
            status = .failed(error: error)
        }
    }
}
