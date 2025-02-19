//
//  CharacterModel.swift
//  QuotesOfBreakingBad
//
//  Created by Andersson on 18/02/25.
//

import Foundation

struct CharacterModel: Decodable {
    let name: String
    let birthday: String
    let occupations: [String]
    let images: [URL]
    let aliases: [String]
    let status: String
    let portrayedBy: String
    var death: DeathModel?
}
