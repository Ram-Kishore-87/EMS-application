import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> EmsWidgetEntry {
        EmsWidgetEntry(date: Date(), payload: .empty)
    }

    func getSnapshot(in context: Context, completion: @escaping (EmsWidgetEntry) -> ()) {
        let entry = EmsWidgetEntry(date: Date(), payload: loadPayload())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = EmsWidgetEntry(date: Date(), payload: loadPayload())
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func loadPayload() -> EmsWidgetPayload {
        let userDefaults = UserDefaults(suiteName: "group.com.example.emsApp")
        guard let jsonString = userDefaults?.string(forKey: "ems_weekly_widget_data"),
              let data = jsonString.data(using: .utf8) else {
            return .empty
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(EmsWidgetPayload.self, from: data)
        } catch {
            return .empty
        }
    }
}

struct EmsWidgetEntry: TimelineEntry {
    let date: Date
    let payload: EmsWidgetPayload
}

struct EmsWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            Color(red: 0.12, green: 0.16, blue: 0.23).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 8) {
                // Header: Title & Weekly Completion Badge
                HStack {
                    Text("EMS Duties")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Text("Week: \(entry.payload.weeklyProgressPct)%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(6)
                }

                // Weekly Progress Gauge
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.green)
                            .frame(width: max(0, min(geo.size.width * CGFloat(entry.payload.weeklyProgressPct) / 100.0, geo.size.width)), height: 6)
                    }
                }
                .frame(height: 6)

                Divider().background(Color.gray.opacity(0.4))

                // Prioritized Duties: Today & Tomorrow
                if let todayDuty = entry.payload.todayDuties.first {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TODAY • \(todayDuty.time)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.blue)
                        Text(todayDuty.title)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Text("\(todayDuty.employeeName) (\(todayDuty.shiftLabel))")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                } else {
                    Text("No duties scheduled for today")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }

                if family != .systemSmall {
                    if let tomorrowDuty = entry.payload.tomorrowDuties.first {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("TOMORROW • \(tomorrowDuty.time)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.orange)
                            Text(tomorrowDuty.title)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                                .lineLimit(1)
                            Text("\(tomorrowDuty.employeeName) (\(tomorrowDuty.shiftLabel))")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                    }

                    Spacer()

                    Text("Upcoming: \(entry.payload.upcomingDuties.count) duties next 7 days")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
            }
            .padding(12)
        }
    }
}

@main
struct EmsWidgetExtension: Widget {
    let kind: String = "EmsWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EmsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("EMS Duties & Weekly Progress")
        .description("View your weekly shift completion rate and upcoming 7-day duties.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
