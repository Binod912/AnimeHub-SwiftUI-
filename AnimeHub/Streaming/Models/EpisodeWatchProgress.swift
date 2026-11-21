import Foundation
import SwiftData

@Model
final class EpisodeWatchProgress {
    @Attribute(.unique) var id: String
    var animeID: Int
    var episodeNumber: Int
    var position: Double
    var duration: Double
    var updatedAt: Date

    init(animeID: Int, episodeNumber: Int, position: Double, duration: Double) {
        self.id = "\(animeID)-\(episodeNumber)"
        self.animeID = animeID
        self.episodeNumber = episodeNumber
        self.position = position
        self.duration = duration
        self.updatedAt = .now
    }
}
