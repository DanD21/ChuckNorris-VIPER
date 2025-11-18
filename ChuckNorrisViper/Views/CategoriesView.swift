//
//  CategoriesView.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - MVVM Architecture
//

import SwiftUI

struct CategoriesView: View {
    @StateObject private var viewModel = CategoriesViewModel()
    @State private var selectedCategory: String?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                } else if let error = viewModel.errorMessage, viewModel.categories.isEmpty {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.categories, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                    viewModel.loadJoke(for: category)
                                }) {
                                    HStack {
                                        Text(category.capitalized)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
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
            viewModel.loadCategories()
        }
        .sheet(item: .constant(selectedCategory.map { CategorySelection(category: $0) })) { selection in
            CategoryJokeView(
                category: selection.category,
                joke: viewModel.categoryJoke,
                isLoading: viewModel.isLoadingJoke
            )
        }
    }
}

// Helper struct for sheet presentation
struct CategorySelection: Identifiable {
    let id = UUID()
    let category: String
}

struct CategoryJokeView: View {
    let category: String
    let joke: Joke?
    let isLoading: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 20) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    } else if let joke = joke {
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

#Preview {
    NavigationStack {
        CategoriesView()
    }
}
