import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    private let repository: AnimeRepository
    private(set) var anime: [Anime] = []
    private(set) var isLoading = false
    private(set) var isLoadingMore = false
    var errorMessage: String?
    private var page = 1
    private var hasNextPage = true

    init(repository: AnimeRepository) { self.repository = repository }

    func load() async {
        guard anime.isEmpty, !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await repository.topAnime(page: 1)
            anime = response.data
            page = 1
            hasNextPage = response.pagination?.hasNextPage ?? false
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refresh() async {
        page = 1
        hasNextPage = true
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await repository.topAnime(page: 1)
            anime = response.data
            hasNextPage = response.pagination?.hasNextPage ?? false
            errorMessage = nil
        } catch { errorMessage = error.localizedDescription }
    }

    func loadMoreIfNeeded(current item: Anime) async {
        guard item.id == anime.last?.id, hasNextPage, !isLoadingMore else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        do {
            let nextPage = page + 1
            let response = try await repository.topAnime(page: nextPage)
            let existing = Set(anime.map(\.id))
            anime.append(contentsOf: response.data.filter { !existing.contains($0.id) })
            page = nextPage
            hasNextPage = response.pagination?.hasNextPage ?? false
        } catch { errorMessage = error.localizedDescription }
    }
}
