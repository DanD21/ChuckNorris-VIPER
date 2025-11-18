# Chuck Norris Jokes - MVVM + SwiftUI

This branch contains a modernized version of the Chuck Norris Jokes app using:

## Architecture
- **MVVM (Model-View-ViewModel)** - Clean separation with SwiftUI
- **Swift 6** - Latest language features with strict concurrency
- **SwiftUI** - Modern declarative UI framework

## Key Features
- ✅ Async/await for networking
- ✅ Actor-based service layer for thread safety
- ✅ @MainActor ViewModels for UI updates
- ✅ Sendable protocols for concurrency safety
- ✅ Native URLSession (no external dependencies needed)
- ✅ Combine for reactive programming

## Structure
```
ChuckNorrisViper/
├── Models/
│   ├── Joke.swift          # Codable, Identifiable, Sendable
│   └── Category.swift      # Type alias for categories
├── Services/
│   └── JokesService.swift  # Actor-based API service
├── ViewModels/
│   ├── HomeViewModel.swift
│   └── CategoriesViewModel.swift
├── Views/
│   ├── HomeView.swift
│   └── CategoriesView.swift
└── ChuckNorrisViperApp.swift
```

## API
Base URL: `https://api.chucknorris.io`

Endpoints:
- `/jokes/random` - Get random joke
- `/jokes/categories` - Get all categories
- `/jokes/random?category={category}` - Get joke by category

## Building
1. Open project in Xcode 15+
2. Ensure Swift 6 language mode is enabled
3. Build and run on iOS 17+

## Differences from Original
- **UIKit → SwiftUI** - Modern declarative UI
- **RxSwift → Async/Await + Combine** - Native concurrency
- **VIPER → MVVM** - Simpler architecture better suited for SwiftUI
- **CocoaPods → No external dependencies** - Uses native frameworks
