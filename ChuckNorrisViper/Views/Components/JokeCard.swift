//
//  JokeCard.swift
//  ChuckNorrisViper
//
//  Reusable joke card component with favorite and share
//

import SwiftUI
import SwiftData

struct JokeCard: View {
    let joke: Joke
    let modelContext: ModelContext

    @State private var isFavorited = false
    @State private var showShareSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Joke text
            Text(joke.value)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)

            // Categories (if any)
            if let categories = joke.categories, !categories.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { category in
                            Text(category.uppercased())
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                    }
                }
            }

            // Action buttons
            HStack(spacing: 20) {
                Button(action: toggleFavorite) {
                    Label(isFavorited ? "Favorited" : "Favorite", systemImage: isFavorited ? "heart.fill" : "heart")
                        .font(.subheadline)
                        .foregroundColor(isFavorited ? .red : .gray)
                }

                Button(action: { showShareSheet = true }) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                Text("ID: \(joke.id.prefix(8))")
                    .font(.caption2)
                    .foregroundColor(.gray.opacity(0.6))
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .onAppear {
            checkIfFavorited()
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [joke.value])
        }
    }

    private func checkIfFavorited() {
        let descriptor = FetchDescriptor<FavoriteJoke>(
            predicate: #Predicate { $0.id == joke.id }
        )
        do {
            let results = try modelContext.fetch(descriptor)
            isFavorited = !results.isEmpty
        } catch {
            isFavorited = false
        }
    }

    private func toggleFavorite() {
        if isFavorited {
            removeFavorite()
        } else {
            addFavorite()
        }
    }

    private func addFavorite() {
        let favorite = FavoriteJoke(from: joke)
        modelContext.insert(favorite)

        do {
            try modelContext.save()
            isFavorited = true
        } catch {
            print("Failed to save favorite: \(error)")
        }
    }

    private func removeFavorite() {
        let descriptor = FetchDescriptor<FavoriteJoke>(
            predicate: #Predicate { $0.id == joke.id }
        )

        do {
            let results = try modelContext.fetch(descriptor)
            for favorite in results {
                modelContext.delete(favorite)
            }
            try modelContext.save()
            isFavorited = false
        } catch {
            print("Failed to remove favorite: \(error)")
        }
    }
}

// MARK: - ShareSheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
