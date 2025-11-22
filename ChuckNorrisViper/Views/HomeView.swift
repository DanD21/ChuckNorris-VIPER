//
//  HomeView.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - MVVM Architecture
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                // Chuck Norris Icon/Header
                Text("🥋")
                    .font(.system(size: 80))

                Text("Chuck Norris Jokes")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                // Joke Display
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                } else if let joke = viewModel.currentJoke {
                    ScrollView {
                        JokeCard(joke: joke, modelContext: modelContext)
                            .padding(.horizontal)
                    }
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Text("Tap 'Random Joke' to get started!")
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()

                // Action Button
                Button(action: {
                    viewModel.loadRandomJoke()
                    saveToHistory()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Random Joke")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            if viewModel.currentJoke == nil {
                viewModel.loadRandomJoke()
            }
        }
    }

    private func saveToHistory() {
        guard let joke = viewModel.currentJoke else { return }

        let history = JokeHistory(from: joke)
        modelContext.insert(history)

        do {
            try modelContext.save()
        } catch {
            print("Failed to save to history: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .modelContainer(for: [FavoriteJoke.self, JokeHistory.self])
    }
}
