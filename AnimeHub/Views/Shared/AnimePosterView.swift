import SwiftUI

struct AnimePosterView: View {
    let anime: Anime
    var width: CGFloat = 132

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            AsyncImage(url: anime.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    placeholder
                case .empty:
                    placeholder.overlay(ProgressView())
                @unknown default:
                    placeholder
                }
            }
            .frame(width: width, height: width * 1.42)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(anime.displayTitle)
                .font(.subheadline.weight(.semibold))
                .lineLimit(2)
                .foregroundStyle(.primary)

            Label(anime.scoreText, systemImage: "star.fill")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: width, alignment: .leading)
    }

    private var placeholder: some View {
        Rectangle()
            .fill(Color.secondary.opacity(0.15))
            .overlay(Image(systemName: "play.rectangle").font(.largeTitle).foregroundStyle(.secondary))
    }
}
