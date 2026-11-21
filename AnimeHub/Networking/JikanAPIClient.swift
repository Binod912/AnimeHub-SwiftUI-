

import Foundation

protocol AnimeAPI {
    func fetchTopAnime(page: Int) async throws -> APIResponse<[Anime]>
    func searchAnime(query: String, page: Int) async throws -> APIResponse<[Anime]>
    func fetchAnime(id: Int) async throws -> APIResponse<Anime>
}

final class JikanAPIClient: AnimeAPI {

    private let session: URLSession
    private let decoder = JSONDecoder()

    private let baseURL = "https://api.tenrai.org/v1"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchTopAnime(
        page: Int
    ) async throws -> APIResponse<[Anime]> {

        try await request(
            path: "/top/anime",
            query: [
                URLQueryItem(name: "page", value: "\(page)")
            ]
        )
    }

    func searchAnime(
        query: String,
        page: Int
    ) async throws -> APIResponse<[Anime]> {

        try await request(
            path: "/anime",
            query: [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "sfw", value: "true")
            ]
        )
    }

    func fetchAnime(
        id: Int
    ) async throws -> APIResponse<Anime> {

        try await request(
            path: "/anime/\(id)/full",
            query: []
        )
    }

    private func request<T: Decodable>(
        path: String,
        query: [URLQueryItem]
    ) async throws -> APIResponse<T> {

        guard var components = URLComponents(
            string: baseURL + path
        ) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = query

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.timeoutInterval = 30
        urlRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        do {
            let (data, response) = try await session.data(
                for: urlRequest
            )

            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard (200...299).contains(http.statusCode) else {
                throw NetworkError.httpStatus(http.statusCode)
            }

            do {
                return try decoder.decode(
                    APIResponse<T>.self,
                    from: data
                )
            } catch {
                throw NetworkError.decoding(error)
            }

        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.underlying(error)
        }
    }
}
