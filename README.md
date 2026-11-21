# AnimeHub

A native SwiftUI anime discovery app built with Clean Architecture-inspired separation, MVVM, Repository pattern, URLSession async/await, and SwiftData.

## Requirements
- Xcode 15+
- iOS 17+
- Swift 5.9+

## Setup
1. Open `AnimeHub.xcodeproj` in Xcode.
2. Select an iOS 17+ simulator or device.
3. Build and run.

No API key or third-party package is required. Data comes from the public Jikan API (https://api.jikan.moe/v4).

## Features
- Top anime feed from Jikan
- Pull to refresh and pagination
- Search with debounce and pagination
- Anime detail view
- Favorites and watchlist persisted with SwiftData
- Profile preferences
- Loading, empty, and error states
- Dark mode follows system appearance

## Notes
- Jikan is a community API for MyAnimeList data. It has rate limits; avoid rapid repeated requests.
- The reminders toggle is currently a saved preference only; local notification scheduling is not implemented.
- Streaming playback, episode browsing, comments, and account synchronization are not included.
- This is a starter app, not a production-audited release.
