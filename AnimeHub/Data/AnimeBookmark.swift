import Foundation
import SwiftData

@Model
final class AnimeBookmark {
    @Attribute(.unique) var animeID: Int
    var title: String
    var imageURL: String?
    var synopsis: String?
    var score: Double?
    var kind: String
    var createdAt: Date

    init(anime: Anime, kind: String) {
        self.animeID = anime.id
        self.title = anime.displayTitle
        self.imageURL = anime.imageURL?.absoluteString
        self.synopsis = anime.synopsis
        self.score = anime.score
        self.kind = kind
        self.createdAt = .now
    }
}
