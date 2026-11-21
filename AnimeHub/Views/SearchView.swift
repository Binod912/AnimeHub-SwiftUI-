import SwiftUI

struct SearchView: View {
    @Environment(DependencyContainer.self) private var dependencies
    @State private var viewModel: SearchViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let vm = viewModel {
                    searchContent(vm)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Search")
            .searchable(text: Binding(
                get: { viewModel?.query ?? "" },
                set: {
                    viewModel?.query = $0
                    viewModel?.search()
                }
            ), prompt: "Search anime")
            .task {
                if viewModel == nil {
                    viewModel = SearchViewModel(repository: dependencies.repository)
                }
            }
        }
    }

    @ViewBuilder
    private func searchContent(_ vm: SearchViewModel) -> some View {
        if vm.isLoading && vm.results.isEmpty {
            ProgressView("Searching…")
        } else if vm.query.isEmpty {
            ContentUnavailableView("Find your next anime", systemImage: "magnifyingglass",
                                   description: Text("Search by anime title."))
        } else if vm.results.isEmpty && vm.errorMessage == nil {
            ContentUnavailableView.search(text: vm.query)
        } else {
            List {
                ForEach(vm.results) { anime in
                    NavigationLink(value: anime) {
                        AnimeRowView(anime: anime)
                    }
                    .task { await vm.loadMoreIfNeeded(current: anime) }
                }
                if vm.isLoading { ProgressView().frame(maxWidth: .infinity) }
                if let message = vm.errorMessage {
                    Text(message).foregroundStyle(.red)
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: Anime.self) { anime in
                AnimeDetailView(anime: anime)
            }
        }
    }
}
