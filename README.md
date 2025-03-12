# Fetch Recipes App

A SwiftUI-based recipe app that displays recipes from a provided API endpoint. The app features a clean, modern UI with efficient image loading and caching capabilities.

## Features

- Display recipes with name, photo, and cuisine type
- Pull-to-refresh functionality
- Efficient image loading and disk caching
- Error handling and empty states
- Modern SwiftUI interface
- No external dependencies

## Focus Areas

1. **Performance**: Implemented efficient image loading and caching system to minimize network usage and improve user experience.
2. **Error Handling**: Robust error handling for various scenarios (malformed data, empty responses, network errors).
3. **Clean Architecture**: Used MVVM pattern with clear separation of concerns.
4. **SwiftUI Best Practices**: Leveraged modern SwiftUI features and patterns.

## Time Spent

- Project Setup & Architecture: 1 hour
- Core Implementation: 2 hours
- UI/UX Design: 1 hour
- Testing: 1 hour
- Documentation: 30 minutes

Total: ~5.5 hours

## Trade-offs and Decisions

1. **Image Caching**: Implemented a custom disk caching solution instead of using URLCache to have more control over the caching behavior and demonstrate system design skills.

2. **Single Screen**: Focused on making the main list view highly polished rather than adding additional screens.

3. **Error Handling**: Chose to show user-friendly error messages while still maintaining detailed logging for debugging.

4. **Testing**: Focused on unit testing core business logic rather than UI testing to demonstrate testing approach while managing time constraints.

## Weakest Part

The current implementation could be improved in the following areas:

1. More comprehensive test coverage, including UI tests
2. Additional error recovery strategies
3. More sophisticated image caching with size variants
4. Offline support

## Additional Information

- Minimum iOS Target: iOS 16.0
- Swift Concurrency is used throughout the app
- No external dependencies were used
- All images are cached to disk to minimize network usage 