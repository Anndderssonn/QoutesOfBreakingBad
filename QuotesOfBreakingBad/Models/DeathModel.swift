//
//  DeathModel.swift
//  QuotesOfBreakingBad
//
//  Created by Andersson on 18/02/25.
//

import Foundation

struct DeathModel: Decodable {
    let character: String
    let image: URL
    let details: String
    let lastWords: String
}
