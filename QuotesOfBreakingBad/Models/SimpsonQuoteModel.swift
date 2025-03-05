//
//  SimpsonQuoteModel.swift
//  QuotesOfBreakingBad
//
//  Created by Andersson on 4/03/25.
//

import Foundation

struct SimpsonQuoteModel: Decodable {
    let quote: String
    let character: String
    let image: URL
    let characterDirection: String
}
