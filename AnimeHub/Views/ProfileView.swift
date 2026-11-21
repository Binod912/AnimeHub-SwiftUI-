import SwiftUI

struct ProfileView: View {
    @AppStorage("animehub.notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("animehub.showScores") private var showScores = true

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 14) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 54))
                            .foregroundStyle(.tint)
                        VStack(alignment: .leading) {
                            Text("AnimeHub User").font(.headline)
                            Text("Your personal anime space").font(.caption).foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section("Preferences") {
                    Toggle("Show anime scores", isOn: $showScores)
                    Toggle("Enable reminders", isOn: $notificationsEnabled)
                }

                Section("About") {
                    LabeledContent("Data provider", value: "Jikan API")
                    LabeledContent("Version", value: "1.0.0")
                    Link("Jikan API documentation", destination: URL(string: "https://docs.api.jikan.moe/")!)
                }

                Section {
                    Text("AnimeHub is an independent fan app. Anime metadata is provided by Jikan and MyAnimeList.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Profile")
        }
    }
}
