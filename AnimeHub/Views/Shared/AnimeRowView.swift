import SwiftUI

struct AnimeRowView: View {
    let anime: Anime

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: anime.imageURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                RoundedRectangle(cornerRadius: 8).fill(.secondary.opacity(0.15))
            }
            .frame(width: 76, height: 104)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 6) {
                Text(anime.displayTitle).font(.headline).lineLimit(2)
                if let year = anime.year { Text(String(year)).font(.caption).foregroundStyle(.secondary) }
                if let episodes = anime.episodes { Text("\(episodes) episodes").font(.caption).foregroundStyle(.secondary) }
                Label(anime.scoreText, systemImage: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
