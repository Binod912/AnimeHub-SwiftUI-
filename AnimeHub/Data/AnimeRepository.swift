import Foundation

protocol AnimeRepository {
    func topAnime(page: Int) async throws -> APIResponse<[Anime]>
    func search(query: String, page: Int) async throws -> APIResponse<[Anime]>
    func details(id: Int) async throws -> Anime
}

final class DefaultAnimeRepository: AnimeRepository {
    private let api: AnimeAPI

    init(api: AnimeAPI) { self.api = api }

    func topAnime(page: Int) async throws -> APIResponse<[Anime]> {
        try await api.fetchTopAnime(page: page)
    }

    func search(query: String, page: Int) async throws -> APIResponse<[Anime]> {
        try await api.searchAnime(query: query, page: page)
    }

    func details(id: Int) async throws -> Anime {
        try await api.fetchAnime(id: id).data
    }
}
