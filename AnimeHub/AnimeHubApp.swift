import SwiftUI
import SwiftData

@main
struct AnimeHubApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(nil)
        }
        .modelContainer(for: [AnimeBookmark.self, EpisodeWatchProgress.self])
    }
}
