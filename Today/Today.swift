//
//  Today.swift
//  Today
//
//  Created by Danylo Ternovoi on 07.01.2024.
//

import WidgetKit
import SwiftUI
import MapKit

struct Provider: TimelineProvider {
    
    @StateObject var store = PurchasesManager()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), serverConnection: true, wreck: Wreck.test, mapImage: nil, premium: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), serverConnection: true, wreck: Wreck.test, mapImage: nil, premium: false)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            // Create shapshots
            var entries: [SimpleEntry] = []
            if let wreck = await getRandomWreck() {
                let mapSnapshot = await generateMapSnapshot(latitude: wreck.hasCoordinates.latitude,
                                                            longitude: wreck.hasCoordinates.longitude)
                mapSnapshot == nil ? print("empty") : print("not empty")
                let pro = store.hasPRO
                let entry = SimpleEntry(date: Date(), serverConnection: true, wreck: wreck, mapImage: mapSnapshot, premium: pro)
                entries.append(entry)
            } else {
                let entry = SimpleEntry(date: Date(), serverConnection: false, wreck: Wreck.test, mapImage: nil, premium: false)
                entries.append(entry)
            }
            
            // Calculate time to next widget update
            let calendar = Calendar.current
            let today: Date = calendar.startOfDay(for: Date())
            guard let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: today) else {
                print("Error while fetching date")
                return
            }
            // Create timeline
            let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
            completion(timeline)
        }
    }
    
    private func getRandomWreck() async -> Wreck? {
        do {
            guard let url = URL(string: ServerURL.homePageWrecks.path) else {
                throw HTTPError.badURL
            }
            let serverData = try await HTTPServer.shared.sendRequest(url: url, HTTPMethod: .GET)
            let serverHomePageModel = try JSONCoder.shared.decodeItemFromData(data: serverData) as HomePageModel
            let wrecks = serverHomePageModel.random5Wrecks
            return wrecks.randomElement()
        } catch let error {
            print("Wreckpointer.Today Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func generateMapSnapshot(latitude: Double, longitude: Double) async -> UIImage? {
        let options = MKMapSnapshotter.Options()
            options.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude,
                                                                               longitude: longitude),
                                                span: MKCoordinateSpan(latitudeDelta: 90,
                                                                       longitudeDelta: 90))
        let mapSnapshotter = MKMapSnapshotter(options: options)
        do {
            let snapshot = try await mapSnapshotter.start()
            return snapshot.image
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    let serverConnection: Bool
    let wreck: Wreck
    let mapImage: UIImage?
    let premium: Bool
}

struct TodayEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        if entry.premium {
            switch family {
            case .systemSmall:
                SmallWidgetView(wreck: entry.wreck)
            case .systemMedium:
                MediumWidgetView(wreck: entry.wreck)
            case .systemLarge:
                LargeWidgetView(wreck: entry.wreck, map: entry.mapImage)
            default:
                Text("Wreckpointer")
            }
        } else {
            switch family {
            case .systemSmall:
                SupportWidgetView(description: "")
            case .systemMedium:
                SupportWidgetView(description: "Support")
            case .systemLarge:
                SupportWidgetView(description: "Support")
            default:
                Text("Wreckpointer")
            }
        }
    }
}

struct Today: Widget {
    let kind: String = "Today"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TodayEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TodayEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    Today()
} timeline: {
    SimpleEntry(date: .now, serverConnection: true, wreck: Wreck.test, mapImage: nil, premium: false)
}
