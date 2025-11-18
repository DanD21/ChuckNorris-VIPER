//
//  CategoriesView.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import SwiftUI

struct CategoriesView: View {
    @StateObject private var presenter: CategoriesPresenter
    @StateObject private var navigationState = CategoriesNavigationState()

    init(presenter: CategoriesPresenter = CategoriesPresenter()) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                if presenter.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                } else if let error = presenter.errorMessage, presenter.categories.isEmpty {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(presenter.categories, id: \.self) { category in
                                Button(action: {
                                    presenter.didSelectCategory(category)
                                }) {
                                    HStack {
                                        Text(category.capitalized)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        Spacer()
                                        if presenter.isLoadingJoke && presenter.selectedCategory == category {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        } else {
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            // Wire up router navigation
            if let router = (presenter as? CategoriesPresenter)?.router as? CategoriesRouter {
                router.navigationState = navigationState
            }
            presenter.viewDidLoad()
        }
        .sheet(item: $navigationState.selectedJoke) { jokeDetail in
            CategoryJokeDetailView(
                category: jokeDetail.category,
                joke: jokeDetail.joke
            )
        }
    }
}

struct CategoryJokeDetailView: View {
    let category: String
    let joke: Joke
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        Text("Category: \(category.capitalized)")
                            .font(.headline)
                            .foregroundColor(.gray)

                        Text(joke.value)
                            .font(.title3)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
            }
            .navigationTitle("Joke")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

// MARK: - Builder
enum CategoriesBuilder {
    static func build() -> CategoriesView {
        let router = CategoriesRouter()
        let interactor = CategoriesInteractor()
        let presenter = CategoriesPresenter(interactor: interactor, router: router)
        return CategoriesView(presenter: presenter)
    }
}

#Preview {
    NavigationStack {
        CategoriesBuilder.build()
    }
}
