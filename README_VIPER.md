# Chuck Norris Jokes - VIPER + SwiftUI

This branch contains a modernized version of the Chuck Norris Jokes app using:

## Architecture
- **VIPER (View-Interactor-Presenter-Entity-Router)** - Adapted for SwiftUI
- **Swift 6** - Latest language features with strict concurrency
- **SwiftUI** - Modern declarative UI framework

## Key Features
- ✅ Full VIPER architecture with SwiftUI integration
- ✅ Async/await for networking
- ✅ Actor-based Interactors and Service layer
- ✅ @MainActor Presenters as ObservableObjects
- ✅ Protocol-oriented design for testability
- ✅ Sendable protocols for concurrency safety
- ✅ Builder pattern for module assembly
- ✅ Router pattern for navigation coordination

## VIPER with SwiftUI Adaptation

Traditional VIPER has been adapted for SwiftUI:

### View
- SwiftUI View structs
- Observes Presenter via @StateObject
- Pure UI, no business logic

### Interactor
- Actor-based for thread safety
- Handles business logic
- Communicates with Service layer
- Returns Entities to Presenter

### Presenter
- @MainActor ObservableObject
- Presentation logic
- @Published properties for View binding
- Coordinates between View, Interactor, and Router

### Entity
- Codable, Identifiable, Sendable models
- Pure data structures

### Router
- @MainActor for UI navigation
- NavigationState pattern for SwiftUI navigation
- Handles routing logic

## Structure
```
ChuckNorrisViper/
├── Models/
│   ├── Joke.swift          # Entity
│   └── Category.swift      # Entity
├── Core/
│   └── JokesService.swift  # Shared service (Actor)
├── Modules/
│   ├── Home/
│   │   ├── HomeView.swift       # View (SwiftUI)
│   │   ├── HomePresenter.swift  # Presenter (ObservableObject)
│   │   ├── HomeInteractor.swift # Interactor (Actor)
│   │   └── HomeRouter.swift     # Router + NavigationState
│   └── Categories/
│       ├── CategoriesView.swift
│       ├── CategoriesPresenter.swift
│       ├── CategoriesInteractor.swift
│       └── CategoriesRouter.swift
└── ChuckNorrisViperApp.swift
```

## Benefits of VIPER with SwiftUI

### Pros:
- **Testability** - Each layer can be unit tested independently
- **Separation of Concerns** - Clear responsibilities per layer
- **Scalability** - Easy to add new modules
- **Protocol-Oriented** - Easy to mock for testing
- **Type Safety** - Swift 6 concurrency guarantees

### Cons:
- **More Boilerplate** - More files and protocols than MVVM
- **Learning Curve** - More complex than MVVM
- **Overhead** - Might be overkill for simple apps

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

## Comparison with MVVM Branch

**VIPER** (this branch):
- More layers, more structure
- Better for large, complex apps
- Better testability with clear protocols
- More boilerplate code

**MVVM** (other branch):
- Simpler, fewer files
- Better for small-medium apps
- More natural fit for SwiftUI
- Less boilerplate

## Differences from Original
- **UIKit → SwiftUI** - Modern declarative UI
- **RxSwift → Async/Await** - Native concurrency
- **VIPER UIKit → VIPER SwiftUI** - Adapted patterns for SwiftUI
- **CocoaPods → No external dependencies** - Uses native frameworks
- **Actor-based Service** - Swift 6 concurrency safety
