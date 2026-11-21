import SwiftUI
import Observation

@Observable
final class DependencyContainer {
    let repository: AnimeRepository
    let streamingRepository: StreamingRepository

    init(
        repository: AnimeRepository = DefaultAnimeRepository(api: JikanAPIClient()),
        streamingRepository: StreamingRepository = DemoStreamingRepository()
    ) {
        self.repository = repository
        self.streamingRepository = streamingRepository
    }
}

struct MainTabView: View {
    @State private var dependencies = DependencyContainer()

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }

            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }

            LibraryView()
                .tabItem { Label("Library", systemImage: "bookmark") }

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }
        }
        .environment(dependencies)
    }
}
