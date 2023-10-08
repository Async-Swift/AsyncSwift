//
//  AsyncSwiftWidget.swift
//  AsyncSwiftWidget
//
//  Created by 김인섭 on 2023/10/01.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), imageData: getRemoteImage())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), imageData: getRemoteImage())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        
        let entry = SimpleEntry(date: Date(), imageData: getRemoteImage())
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate!))
        completion(timeline)
    }
    
    func getRemoteImage() -> Data? {
        try? Data(contentsOf: URL(string: GitHubStorageURL.widgetLargeImage)!)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    let imageData: Data?
}

struct AsyncSwiftWidget: Widget {
    let kind: String = "AsyncSwiftWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AsyncSwiftWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("AsyncSwift")
        .description("행사 정보를 확인하세요.")
        .supportedFamilies(
            [.systemLarge]
        )
    }
}

struct AsyncSwiftWidget_Previews: PreviewProvider {
    static var previews: some View {
        AsyncSwiftWidgetEntryView(
            entry: SimpleEntry(
                date: Date(),
                imageData: try? Data(contentsOf: URL(string: GitHubStorageURL.widgetLargeImage)!)
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
