import Foundation

protocol StreamingRepository {
    func episodes(for anime: Anime) -> [AnimeEpisode]
}

/// Supplies public sample footage for UI and playback testing.
/// These clips are not episodes of the selected anime.
struct DemoStreamingRepository: StreamingRepository {
    private let sampleURLs: [URL] = [
        URL(string: "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
        URL(string: "https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!,
        URL(string: "https://storage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4")!,
        URL(string: "https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4")!
    ]

    func episodes(for anime: Anime) -> [AnimeEpisode] {
        let count = min(max(anime.episodes ?? 12, 1), 24)
        return (1...count).map { number in
            AnimeEpisode(
                animeID: anime.id,
                number: number,
                title: "Demo Episode \(number)",
                videoURL: sampleURLs[(number - 1) % sampleURLs.count],
                description: "Public sample video for testing AnimeHub playback."
            )
        }
    }
}
