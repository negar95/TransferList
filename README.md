# TransferList

iOS application for managing transfer lists with favorites functionality.

## Architecture

- MVVM Pattern with Combine reactive programming
- Modular SPM Structure (AppDomain, AppUI, AppFoundation)
- Dependency Injection using property wrappers
- Reactive UserDefaults with Combine publishers

## Technical Stack

- iOS 14+ deployment target
- UIKit with programmatic UI
- Combine for reactive data flow
- Swift Package Manager for modular architecture
- XCTest for unit testing

## Features

- Transfer list with pagination
- Favorites management with persistent storage
- Pull-to-refresh and load more functionality
- Detail view for individual transfers
- Reactive UI updates

## Key Components

- Injected Property Wrapper: Dependency Injection
- UserDefault Property Wrapper: Reactive storage with Combine publishers
- CollectionView: Custom collection view with type-erased diffable data source and compositional layout
- TransferViewModel: Detail screen business logic with reactive state management
- TransferListViewModel: List screen with pagination and API integration

## Technical Implementation

- Type-Erased Diffable Data Source: Supports multiple cell types in single collection view
- Compositional Layout: Different section layouts (horizontal scrolling favorites, vertical main list)
- Reactive State Management: Combine publishers drive UI updates automatically
- Property Wrapper Architecture: Custom @UserDefault and @Injected for clean dependency management

## Testing

- Unit tests for ViewModel and property wrappers
- Mock infrastructure for clean testing
- Combine testing with async expectations
