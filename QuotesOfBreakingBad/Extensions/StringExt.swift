//
//  StringExt.swift
//  QuotesOfBreakingBad
//
//  Created by Andersson on 27/02/25.
//

import Foundation

extension String {
    func removeSpaces() -> String {
        self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeCaseAndSpaces() -> String {
        self.removeSpaces().lowercased()
    }
}
