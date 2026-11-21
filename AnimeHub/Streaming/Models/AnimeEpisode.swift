import Foundation

struct AnimeEpisode: Identifiable, Hashable {
    let animeID: Int
    let number: Int
    let title: String
    let videoURL: URL
    let description: String

    var id: String { "\(animeID)-\(number)" }
}
