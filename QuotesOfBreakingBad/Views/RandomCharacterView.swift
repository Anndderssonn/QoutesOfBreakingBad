//
//  RandomCharacterView.swift
//  QuotesOfBreakingBad
//
//  Created by Andersson on 3/03/25.
//

import SwiftUI

struct RandomCharacterView: View {
    let character: CharacterModel
    
    var body: some View {
        ZStack {
            AsyncImage(url: character.images.randomElement()) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        VStack {
                            Spacer()
                            Text(character.name)
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .background(.ultraThinMaterial)
                        }
                    )
            } placeholder: {
                ProgressView()
            }
        }
        .clipShape(.rect(cornerRadius: 10))
        .padding(.horizontal)
    }
}

#Preview {
    RandomCharacterView(character: QuotesViewModel().character)
}
