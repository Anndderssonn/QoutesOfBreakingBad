//
//  ContentView.swift
//  QuotesOfBreakingBad
//
//  Created by Andersson on 17/02/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab(Constants.breakingBadName, systemImage: "flask") {
                QuoteView(show: Constants.breakingBadName)
                    
            }
            Tab(Constants.betterCallSaulName, systemImage: "candybarphone") {
                QuoteView(show: Constants.betterCallSaulName)
            }
            Tab(Constants.elCaminoName, systemImage: "road.lanes.curved.right") {
                QuoteView(show: Constants.elCaminoName)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
