# MarktguruApp

A modern iOS application showcasing products with dark mode support and favorites functionality.

## Architecture & Design Decisions

### MVVM Architecture
The application follows the MVVM (Model-View-ViewModel) architectural pattern with some Clean Architecture principles:
- **Views**: SwiftUI views handling UI presentation (`ProductsView`, `SettingsView`)
- **ViewModels**: Managing business logic and state (`ProductsViewModel`, `SettingsViewModel`)
- **Models**: Data models representing the domain (`ProductModel`)

### Key Components
1. **Services Layer**
   - `ProductsService`: Handles product data fetching
   - Implements protocol-based design for better testability
   - Uses async/await for modern concurrency

2. **Managers**
   - `NetworkManager`: Generic network layer with protocol-based design
   - `ThemeManager`: Handles app-wide theme management
   - `ImageCache`: Efficient image caching implementation

3. **Data Persistence**
   - `UserDefaultsStore`: Handles local storage
   - Uses property wrappers for cleaner UserDefaults access
   - Stores dark mode preference and favorite products

### Design Patterns
- **Singleton**: Used sparingly (ThemeManager, NetworkManager) with dependency injection support
- **Protocol-Oriented**: Heavy use of protocols for better testability and modularity
- **Observer Pattern**: Using SwiftUI's @Published and ObservableObject
- **Repository Pattern**: Abstract data access layer

## Technical Decisions

1. **SwiftUI**
   - Modern declarative UI framework
   - Better state management
   - Native dark mode support

2. **Async/Await**
   - Modern concurrency approach
   - Better error handling
   - More maintainable asynchronous code

3. **Dependency Injection**
   - All major components support DI
   - Enables better unit testing
   - Reduces coupling

## Testing

- Comprehensive unit tests for:
  - ProductsService
  - ProductsViewModel
- Mock objects for dependencies
- Tests cover both success and error scenarios

## Assumptions & Limitations

1. **Data Persistence**
   - UserDefaults for simple data storage
   - Favorites are stored as simple IDs

2. **Networking**
   - Basic error handling
   - No retry mechanism
   - No offline support

3. **UI/UX**
   - Basic error states
   - Simple loading indicators
   - No advanced animations

4. **Image Loading**
   - Basic image caching
   - No image resizing/optimization
   - No placeholder images customization

## Development Time

Total time spent: 3-4 hours
- Initial setup and architecture: ~1 hour
- Core functionality: ~1.5 hours
- UI/UX implementation: ~0.5 hour
- Testing: ~1 hour

## AI Usage

AI (Claude) was utilized for:
- Generating unit test cases
- Identifying edge cases for testing
- Suggesting test coverage improvements
- Creating and structuring this README documentation

All core architecture decisions, business logic implementation, and UI design were done manually.

## Requirements

- iOS 18.1+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository
2. Open `MarktguruApp.xcodeproj` in Xcode
3. Build and run the project

## License

This project is proprietary and confidential. 
