import Foundation
import Observation

@MainActor
@Observable
final class SearchViewModel {
    private let repository: AnimeRepository
    var query = ""
    private(set) var results: [Anime] = []
    private(set) var isLoading = false
    var errorMessage: String?
    private var page = 1
    private var hasNextPage = false
    private var searchTask: Task<Void, Never>?

    init(repository: AnimeRepository) { self.repository = repository }

    func search() {
        searchTask?.cancel()
        let term = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else {
            results = []
            errorMessage = nil
            return
        }
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(350))
            guard !Task.isCancelled else { return }
            await performSearch(term: term, page: 1, replacing: true)
        }
    }

    func loadMoreIfNeeded(current item: Anime) async {
        guard item.id == results.last?.id, hasNextPage, !isLoading else { return }
        await performSearch(term: query, page: page + 1, replacing: false)
    }

    private func performSearch(term: String, page requestedPage: Int, replacing: Bool) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await repository.search(query: term, page: requestedPage)
            guard !Task.isCancelled else { return }
            if replacing { results = response.data } else {
                let ids = Set(results.map(\.id))
                results.append(contentsOf: response.data.filter { !ids.contains($0.id) })
            }
            page = requestedPage
            hasNextPage = response.pagination?.hasNextPage ?? false
            errorMessage = nil
        } catch {
            if !Task.isCancelled { errorMessage = error.localizedDescription }
        }
    }
}
