import SwiftUI

struct HomeView: View {
    @Environment(DependencyContainer.self) private var dependencies
    @State private var viewModel: HomeViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    content(viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Discover")
            .task {
                if viewModel == nil {
                    viewModel = HomeViewModel(repository: dependencies.repository)
                }
                await viewModel?.load()
            }
        }
    }

    @ViewBuilder
    private func content(_ vm: HomeViewModel) -> some View {
        if vm.isLoading && vm.anime.isEmpty {
            ProgressView("Loading anime…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let message = vm.errorMessage, vm.anime.isEmpty {
            ContentUnavailableView {
                Label("Unable to load anime", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") { Task { await vm.refresh() } }
            }
        } else {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 22) {
                    if let featured = vm.anime.first {
                        NavigationLink(value: featured) {
                            FeaturedAnimeView(anime: featured)
                        }
                        .buttonStyle(.plain)
                    }

                    sectionTitle("Top Anime")
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                        ForEach(vm.anime) { anime in
                            NavigationLink(value: anime) {
                                AnimePosterView(anime: anime, width: 150)
                            }
                            .buttonStyle(.plain)
                            .task { await vm.loadMoreIfNeeded(current: anime) }
                        }
                    }

                    if vm.isLoadingMore { ProgressView().frame(maxWidth: .infinity) }
                    if let message = vm.errorMessage {
                        Text(message).font(.caption).foregroundStyle(.red)
                    }
                }
                .padding()
            }
            .refreshable { await vm.refresh() }
            .navigationDestination(for: Anime.self) { anime in
                AnimeDetailView(anime: anime)
            }
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title).font(.title2.bold())
    }
}

private struct FeaturedAnimeView: View {
    let anime: Anime

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: anime.imageURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Rectangle().fill(.secondary.opacity(0.2))
            }
            .frame(height: 230)
            .clipped()

            LinearGradient(colors: [.clear, .black.opacity(0.85)], startPoint: .center, endPoint: .bottom)

            VStack(alignment: .leading, spacing: 6) {
                Text("FEATURED").font(.caption.bold()).tracking(1.5)
                Text(anime.displayTitle).font(.title2.bold()).lineLimit(2)
                Label("Score \(anime.scoreText)", systemImage: "star.fill").font(.caption)
            }
            .foregroundStyle(.white)
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
