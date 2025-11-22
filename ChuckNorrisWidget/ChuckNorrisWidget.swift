//
//  ChuckNorrisWidget.swift
//  ChuckNorrisWidget
//
//  Widget showing random Chuck Norris jokes
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), joke: "Chuck Norris doesn't wait for widgets to load. Widgets load before he asks.")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), joke: "Chuck Norris counted to infinity. Twice.")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            var entries: [SimpleEntry] = []
            let currentDate = Date()

            // Fetch a joke from the API
            do {
                let service = JokesService()
                let joke = try await service.getRandomJoke()

                let entry = SimpleEntry(
                    date: currentDate,
                    joke: joke.value
                )
                entries.append(entry)

                // Update every hour
                let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
                let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                // Fallback joke on error
                let entry = SimpleEntry(
                    date: currentDate,
                    joke: "Chuck Norris doesn't need network connections. The internet connects to him."
                )
                entries.append(entry)

                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
                let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
                completion(timeline)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let joke: String
}

struct ChuckNorrisWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color.black)

            VStack(spacing: 12) {
                // Icon
                Text("🥋")
                    .font(.system(size: 40))

                // Joke
                Text(entry.joke)
                    .font(.caption)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .lineLimit(6)

                // Last updated
                Text(entry.date, style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

struct ChuckNorrisWidget: Widget {
    let kind: String = "ChuckNorrisWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ChuckNorrisWidgetEntryView(entry: entry)
                .containerBackground(.black, for: .widget)
        }
        .configurationDisplayName("Chuck Norris Jokes")
        .description("Get random Chuck Norris jokes on your home screen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    ChuckNorrisWidget()
} timeline: {
    SimpleEntry(date: .now, joke: "Chuck Norris can divide by zero.")
    SimpleEntry(date: .now, joke: "Chuck Norris doesn't use SwiftUI. SwiftUI uses Chuck Norris.")
}
