//
//  FetchService.swift
//  QuotesOfBreakingBad
//
//  Created by Andersson on 18/02/25.
//

import Foundation

struct FetchService {
    enum FetchError: Error {
        case badresponse
    }
    
    let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")
    
    func fetchQuotes(from show: String) async throws -> QuoteModel {
        let quoteURL = baseURL?.appending(path: "quotes/random")
        let fetchURL = quoteURL?.appending(queryItems: [URLQueryItem(name: "production", value: show)])
        return QuoteModel(quote: "quote test", character: "character test")
    }
}
