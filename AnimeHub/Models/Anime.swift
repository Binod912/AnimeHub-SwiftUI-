import Foundation

struct Anime: Identifiable, Decodable, Hashable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let imageURL: URL?
    let synopsis: String?
    let score: Double?
    let episodes: Int?
    let year: Int?
    let status: String?
    let genres: [String]
    let rating: String?
    let trailerURL: URL?

    var displayTitle: String { titleEnglish ?? title }
    var scoreText: String { score.map { String(format: "%.1f", $0) } ?? "N/A" }

    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case title
        case titleEnglish = "title_english"
        case images
        case synopsis
        case score
        case episodes
        case year
        case status
        case genres
        case rating
        case trailer
    }

    enum ImageKeys: String, CodingKey { case jpg }
    enum JPGKeys: String, CodingKey { case imageURL = "image_url", largeImageURL = "large_image_url" }
    enum GenreKeys: String, CodingKey { case name }
    enum TrailerKeys: String, CodingKey { case url }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(Int.self, forKey: .id)
        title = try c.decodeIfPresent(String.self, forKey: .title) ?? "Unknown"
        titleEnglish = try c.decodeIfPresent(String.self, forKey: .titleEnglish)
        synopsis = try c.decodeIfPresent(String.self, forKey: .synopsis)
        score = try c.decodeIfPresent(Double.self, forKey: .score)
        episodes = try c.decodeIfPresent(Int.self, forKey: .episodes)
        year = try c.decodeIfPresent(Int.self, forKey: .year)
        status = try c.decodeIfPresent(String.self, forKey: .status)
        rating = try c.decodeIfPresent(String.self, forKey: .rating)

        if let imageContainer = try? c.nestedContainer(keyedBy: ImageKeys.self, forKey: .images),
           let jpg = try? imageContainer.nestedContainer(keyedBy: JPGKeys.self, forKey: .jpg) {
            let large = try jpg.decodeIfPresent(String.self, forKey: .largeImageURL)
            let regular = try jpg.decodeIfPresent(String.self, forKey: .imageURL)
            imageURL = URL(string: large ?? regular ?? "")
        } else {
            imageURL = nil
        }

        genres = (try? c.decode([GenreDTO].self, forKey: .genres).map(\.name)) ?? []
        if let trailerContainer = try? c.nestedContainer(keyedBy: TrailerKeys.self, forKey: .trailer) {
            trailerURL = try trailerContainer.decodeIfPresent(URL.self, forKey: .url)
        } else {
            trailerURL = nil
        }
    }

    private struct GenreDTO: Decodable {
        let name: String
    }
}
