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
        case successRandomCharacter
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
    
    func getCharacterRandom(for show: String) async {
        status = .fetching
        var attempts = 0
        let maxAttempts = 10
        do {
            while attempts < maxAttempts {
                if let unwrappedCharacter = try await fetcher.fetchRandomCharacter() {
                    if unwrappedCharacter.productions.contains(show) {
                        character = unwrappedCharacter
                        status = .successRandomCharacter
                        return
                    } else {
                        attempts += 1
                    }
                }
            }
            let error = NSError(domain: "RandomCharacterError",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "No valid character found after \(maxAttempts) attempts."]
            )
            status = .failed(error: error)
        } catch {
            status = .failed(error: error)
        }
    }
    
}
