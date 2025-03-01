//
//  EpisodeView.swift
//  QuotesOfBreakingBad
//
//  Created by Andersson on 28/02/25.
//

import SwiftUI

struct EpisodeView: View {
    let episode: EpisodeModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(episode.title)
                .font(.largeTitle)
            Text(episode.seasonEpisode)
                .font(.title2)
            AsyncImage(url: episode.image) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 10))
            } placeholder: {
                ProgressView()
            }
            Text(episode.synopsis)
                .font(.title3)
                .minimumScaleFactor(0.5)
                .padding(.bottom)
            Text("Written by: \(episode.writtenBy)")
            Text("Directed by: \(episode.directedBy)")
            Text("Aired: \(episode.airDate)")
        }
        .padding()
        .foregroundStyle(.white)
        .background(.black.opacity(0.6))
        .clipShape(.rect(cornerRadius: 10))
        .padding(.horizontal)
    }
}

#Preview {
    EpisodeView(episode: QuotesViewModel().episode)
}
