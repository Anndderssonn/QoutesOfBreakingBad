//
//  CharacterView.swift
//  QuotesOfBreakingBad
//
//  Created by Andersson on 26/02/25.
//

import SwiftUI

struct CharacterView: View {
    let character: CharacterModel
    let show: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image(show.lowercased().replacingOccurrences(of: " ", with: ""))
                    .resizable()
                    .scaledToFit()
                ScrollView {
                    AsyncImage(url: character.images[0]) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: geometry.size.width/1.2, height: geometry.size.height/1.7)
                    .clipShape(.rect(cornerRadius: 12))
                    .padding(.top, 70)
                    VStack(alignment: .leading) {
                        Text(character.name)
                            .font(.largeTitle)
                        Text("Portrayed by: \(character.portrayedBy)")
                            .font(.subheadline)
                        Divider()
                        Text("\(character.name) Character Info")
                            .font(.title2)
                        Text("Born: \(character.birthday)")
                        Divider()
                        Text("Occupation:")
                        ForEach(character.occupations, id: \.self) { occupation in
                            Text("• \(occupation)")
                                .font(.subheadline)
                        }
                        Divider()
                        Text("Nicknames:")
                        if !character.aliases.isEmpty {
                            ForEach(character.aliases, id: \.self) { nickname in
                                Text("• \(nickname)")
                                    .font(.subheadline)
                            }
                        } else {
                            Text("None")
                                .font(.subheadline)
                        }
                        Divider()
                        DisclosureGroup("Status (spoiler alert!):") {
                            VStack(alignment: .leading) {
                                Text(character.status)
                                    .font(.title2)
                                if let death = character.death {
                                    AsyncImage(url: death.image) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(.rect(cornerRadius: 10))
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    Text("How: \(death.details)")
                                        .padding(.bottom, 7)
                                    Text("Last words: \"\(death.lastWords)\"")
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .tint(.red)
                    }
                    .frame(width: geometry.size.width/1.25, alignment: .leading)
                    .padding(.bottom, 50)
                }
                .scrollIndicators(.hidden)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CharacterView(character: QuotesViewModel().character, show: "Breaking Bad")
}
