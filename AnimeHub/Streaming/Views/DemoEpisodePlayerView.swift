import SwiftUI
import AVKit
import SwiftData

struct DemoEpisodePlayerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var savedProgress: [EpisodeWatchProgress]

    let anime: Anime
    let episodes: [AnimeEpisode]
    @State private var selectedIndex: Int
    @State private var player: AVPlayer?

    init(anime: Anime, episodes: [AnimeEpisode], initialEpisode: Int = 1) {
        self.anime = anime
        self.episodes = episodes
        let index = episodes.firstIndex { $0.number == initialEpisode } ?? 0
        _selectedIndex = State(initialValue: index)
    }

    private var episode: AnimeEpisode { episodes[selectedIndex] }

    var body: some View {
        VStack(spacing: 16) {
            if let player {
                VideoPlayer(player: player)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .background(.black)
            } else {
                Rectangle()
                    .fill(.black)
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .overlay(ProgressView().tint(.white))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(anime.displayTitle)
                    .font(.headline)
                Text(episode.title)
                    .font(.title2.bold())
                Text("Demo footage — this is not an actual episode of this anime.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            HStack {
                Button {
                    move(by: -1)
                } label: {
                    Label("Previous", systemImage: "backward.end.fill")
                }
                .disabled(selectedIndex == 0)

                Spacer()

                Button {
                    saveProgress()
                    move(by: 1)
                } label: {
                    Label("Next", systemImage: "forward.end.fill")
                }
                .disabled(selectedIndex >= episodes.count - 1)
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)

            Spacer(minLength: 0)
        }
        .navigationTitle("Demo Player")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: preparePlayer)
        .onDisappear {
            saveProgress()
            player?.pause()
            player = nil
        }
        .onChange(of: selectedIndex) { _, _ in
            preparePlayer()
        }
    }

    private func preparePlayer() {
        guard episodes.indices.contains(selectedIndex) else { return }
        player?.pause()
        let item = episode
        let newPlayer = AVPlayer(url: item.videoURL)
        if let progress = savedProgress.first(where: { $0.id == item.id }),
           progress.position > 5,
           progress.duration <= 0 || progress.position < progress.duration - 10 {
            newPlayer.seek(to: CMTime(seconds: progress.position, preferredTimescale: 600))
        }
        player = newPlayer
        newPlayer.play()
    }

    private func move(by offset: Int) {
        let next = selectedIndex + offset
        guard episodes.indices.contains(next) else { return }
        selectedIndex = next
    }

    private func saveProgress() {
        guard let player else { return }
        let position = player.currentTime().seconds
        let duration = player.currentItem?.duration.seconds ?? 0
        guard position.isFinite, position >= 0 else { return }

        let progressID = episode.id
        if let existing = savedProgress.first(where: { $0.id == progressID }) {
            existing.position = position
            existing.duration = duration.isFinite ? duration : 0
            existing.updatedAt = .now
        } else {
            modelContext.insert(EpisodeWatchProgress(
                animeID: anime.id,
                episodeNumber: episode.number,
                position: position,
                duration: duration.isFinite ? duration : 0
            ))
        }
        try? modelContext.save()
    }
}
