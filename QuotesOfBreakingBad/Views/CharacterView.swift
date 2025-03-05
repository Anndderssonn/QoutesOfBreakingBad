//
//  CharacterView.swift
//  QuotesOfBreakingBad
//
//  Created by Andersson on 26/02/25.
//

import SwiftUI

struct CharacterView: View {
    let quotesVM = QuotesViewModel()
    let character: CharacterModel
    let show: String
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ZStack(alignment: .top) {
                    Image(show.removeCaseAndSpaces())
                        .resizable()
                        .scaledToFit()
                    ScrollView {
                        TabView {
                            ForEach(character.images, id: \.self) { image in
                                AsyncImage(url: image) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        .tabViewStyle(.page)
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
                            Text("Random Quote:")
                            switch quotesVM.status {
                            case .notStarted, .successEpisodes, .successRandomCharacter, .successSimpsonQuote:
                                EmptyView()
                            case .fetching:
                                ProgressView()
                            case .successQuotes:
                                Text("\"\(quotesVM.quote.quote)\"")
                                    .padding(.vertical)
                            case .failed(let error):
                                Text(error.localizedDescription)
                            }
                            Button {
                                Task {
                                    await quotesVM.getCharacterQoute(for: character.name)
                                }
                            } label: {
                                Text("Get Random Quote")                                
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
                                                .onAppear {
                                                    withAnimation {
                                                        proxy.scrollTo(1, anchor: .bottom)
                                                    }
                                                }
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
                        .id(1)
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CharacterView(character: QuotesViewModel().character, show: Constants.breakingBadName)
}
