import Foundation
import Observation

@MainActor
@Observable
final class DetailViewModel {
    private let repository: AnimeRepository
    let animeID: Int
    private(set) var anime: Anime?
    private(set) var isLoading = false
    var errorMessage: String?

    init(animeID: Int, repository: AnimeRepository) {
        self.animeID = animeID
        self.repository = repository
    }

    func load() async {
        guard anime == nil, !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            anime = try await repository.details(id: animeID)
            errorMessage = nil
        } catch { errorMessage = error.localizedDescription }
    }
}
