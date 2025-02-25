//
//  QuoteView.swift
//  QuotesOfBreakingBad
//
//  Created by Andersson on 24/02/25.
//

import SwiftUI

struct QuoteView: View {
    let quotesVM = QuotesViewModel()
    let show: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(show.lowercased().replacingOccurrences(of: " ", with: ""))
                    .resizable()
                    .frame(width: geometry.size.width * 2.7, height: geometry.size.height * 1.2)
                VStack {
                    Text("\"\(quotesVM.quote.quote)\"")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .padding()
                        .background(.black.opacity(0.5))
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.horizontal)
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: quotesVM.character.images[0]) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: geometry.size.width/1.1, height: geometry.size.height/1.8)
                        Text(quotesVM.quote.character)
                            .foregroundStyle(.white)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                    }
                    .frame(width: geometry.size.width/1.1, height: geometry.size.height/1.8)
                    .clipShape(.rect(cornerRadius: 10))
                }
                .frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    QuoteView(show: "Breaking Bad")
        .preferredColorScheme(.dark)
}
