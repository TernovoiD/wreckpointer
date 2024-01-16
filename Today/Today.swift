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
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), wreck: generateExampleWreck(), mapImage: UIImage(named: "RMSLusitania"))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), wreck: generateExampleWreck(), mapImage: UIImage(named: "RMSLusitaniaMap"))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            var entries: [SimpleEntry] = []
            let wrecks = await getWrecks()
            let today = Date()
            
            // Make entries
            for index in 0 ..< wrecks.count {
                let entryDate = Calendar.current.date(byAdding: .minute, value: index * 20, to: today) ?? Date()
                let wreck = wrecks[index]
                let mapSnapshot = await generateMapSnapshot(latitude: wreck.hasCoordinates.latitude,
                                                            longitude: wreck.hasCoordinates.longitude)
                let entry = SimpleEntry(date: entryDate, wreck: wreck, mapImage: mapSnapshot)
                entries.append(entry)
            }
            
            // Create timeline
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    private func getWrecks() async -> [Wreck] {
        do {
            guard let url = URL(string: ServerURL.homePageWrecks.path) else {
                throw HTTPError.badURL
            }
            let serverData = try await HTTPServer.shared.sendRequest(url: url, HTTPMethod: .GET)
            let serverHomePageModel = try JSONCoder.shared.decodeItemFromData(data: serverData) as HomePageModel
            let wrecks = serverHomePageModel.random5Wrecks
            return wrecks
        } catch let error {
            print("Wreckpointer.Today Error: \(error.localizedDescription)")
            return [ ]
        }
    }
    
    private func generateExampleWreck() -> Wreck {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 1915
        dateComponents.month = 5
        dateComponents.day = 7
        
        let dateOfLoss = calendar.date(from: dateComponents) ?? Date()
        
        let image = UIImage(named: "RMSLusitania")
        let imageData = image?.pngData()
        
        return Wreck(id: UUID(uuidString: "12345"),
                     createdAt: Date(),
                     updatedAt: Date(),
                     name: "RMS Lusitania",
                     latitude: 51.25,
                     longitude: -8.33,
                     type: .passengerShip,
                     cause: .explosion,
                     approved: true,
                     dive: false,
                     dateOfLoss: dateOfLoss,
                     lossOfLive: 1191,
                     displacement: 44060,
                     depth: 305,
                     image: imageData,
                     history: "The RMS Lusitania, a British ocean liner, met a tragic fate during World War I on May 7, 1915. Sailing from New York to Liverpool, it was struck by a German torpedo off the coast of Ireland, causing its swift sinking within 18 minutes. This devastating event claimed the lives of 1,198 passengers and crew, including 128 Americans. The sinking significantly influenced public opinion worldwide and played a role in the eventual entry of the United States into World War I. The loss of the Lusitania remains a poignant reminder of the human toll and the complexities of wartime maritime history.")
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
    let wreck: Wreck
    let mapImage: UIImage?
}

struct TodayEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(wreck: entry.wreck)
        case .systemMedium:
            MediumWidgetView(wreck: entry.wreck, map: entry.mapImage)
        case .systemLarge:
            LargeWidgetView(wreck: entry.wreck, map: entry.mapImage)
        default:
            Text("Wreckpointer")
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
        .configurationDisplayName("Wreckpointer.widget")
        .description("Unveil History's Depths. Navigate the Shipwrecks.")
    }
}
