//
//  HomeView.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - MVVM Architecture
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showCategories = false

    var body: some View {
        NavigationStack {
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
                            Text(joke.value)
                                .font(.title3)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
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

                    // Action Buttons
                    VStack(spacing: 15) {
                        Button(action: {
                            viewModel.loadRandomJoke()
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

                        Button(action: {
                            showCategories = true
                        }) {
                            HStack {
                                Image(systemName: "list.bullet")
                                Text("Browse Categories")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                }
            }
            .navigationDestination(isPresented: $showCategories) {
                CategoriesView()
            }
        }
        .onAppear {
            viewModel.loadRandomJoke()
        }
    }
}

#Preview {
    HomeView()
}
