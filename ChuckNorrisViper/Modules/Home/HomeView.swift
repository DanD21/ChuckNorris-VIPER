//
//  HomeView.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import SwiftUI

struct HomeView: View {
    @StateObject private var presenter: HomePresenter
    @StateObject private var navigationState = NavigationState()

    init(presenter: HomePresenter = HomePresenter()) {
        _presenter = StateObject(wrappedValue: presenter)
    }

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
                    if presenter.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    } else if let joke = presenter.currentJoke {
                        ScrollView {
                            Text(joke.value)
                                .font(.title3)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    } else if let error = presenter.errorMessage {
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
                            presenter.didTapRandomJoke()
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
                            presenter.didTapCategories()
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
            .navigationDestination(isPresented: $navigationState.showCategories) {
                CategoriesView()
            }
        }
        .onAppear {
            // Wire up router navigation
            if let router = (presenter as? HomePresenter)?.router as? HomeRouter {
                router.navigationState = navigationState
            }
            presenter.viewDidLoad()
        }
    }
}

// MARK: - Builder
enum HomeBuilder {
    static func build() -> HomeView {
        let router = HomeRouter()
        let interactor = HomeInteractor()
        let presenter = HomePresenter(interactor: interactor, router: router)
        return HomeView(presenter: presenter)
    }
}

#Preview {
    HomeBuilder.build()
}
