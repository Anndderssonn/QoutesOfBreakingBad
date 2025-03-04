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
    @State var showCharacterInfo: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(show.removeCaseAndSpaces())
                    .resizable()
                    .frame(width: geometry.size.width * 2.7, height: geometry.size.height * 1.2)
                VStack {
                    VStack {
                        Spacer(minLength: 60)
                        switch quotesVM.status {
                        case .notStarted:
                            EmptyView()
                        case .fetching:
                            ProgressView()
                        case .successQuotes:
                            Text("\"\(quotesVM.quote.quote)\"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 10))
                                .padding(.horizontal)
                            ZStack(alignment: .bottom) {
                                AsyncImage(url: quotesVM.character.images.randomElement()) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geometry.size.width/1.1, height: geometry.size.height/1.8)
                                Text(quotesVM.quote.character)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                            }
                            .frame(width: geometry.size.width/1.1, height: geometry.size.height/1.8)
                            .clipShape(.rect(cornerRadius: 10))
                            .onTapGesture {
                                showCharacterInfo.toggle()
                            }
                        case .successEpisodes:
                            EpisodeView(episode: quotesVM.episode)
                        case .successRandomCharacter:
                            RandomCharacterView(character: quotesVM.character)
                        case .failed(let error):
                            Text(error.localizedDescription)
                        }
                        Spacer(minLength: 20)
                    }
                    HStack {
                        Button {
                            Task {
                                await quotesVM.getQuoteData(for: show)
                            }
                        } label: {
                            Text("Get Random Quote")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color("\(show.removeSpaces())Button"))
                            .clipShape(.rect(cornerRadius: 5))
                            .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 3)
                        }
                        Spacer()
                        Button {
                            Task {
                                await quotesVM.getEpisode(for: show)
                            }
                        } label: {
                            Text("Get Random Episode")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color("\(show.removeSpaces())Button"))
                            .clipShape(.rect(cornerRadius: 5))
                            .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 3)
                        }
                        Spacer()
                        Button {
                            Task {
                                await quotesVM.getCharacterRandom(for: show)
                            }
                        } label: {
                            Text("Get Random Character")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color("\(show.removeSpaces())Button"))
                            .clipShape(.rect(cornerRadius: 5))
                            .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 3)
                        }
                    }
                    .padding(.horizontal, 30)
                    Spacer(minLength: 110)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .toolbarBackgroundVisibility(.visible, for: .tabBar)
        .sheet(isPresented: $showCharacterInfo) {
            CharacterView(character: quotesVM.character, show: show)
        }
        .onAppear {
            Task {
                await quotesVM.getQuoteData(for: show)
            }
        }
    }
}

#Preview {
    QuoteView(show: Constants.breakingBadName)
        .preferredColorScheme(.dark)
}
