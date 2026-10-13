import Foundation

struct EmsDutyItem: Codable, Identifiable {
    let id: String
    let title: String
    let time: String
    let date: String
    let employeeName: String
    let department: String
    let shiftLabel: String
    let isCompleted: Bool
}

struct EmsWidgetPayload: Codable {
    let lastUpdated: String?
    let weeklyProgressPct: Int
    let weeklyCompleted: Int
    let weeklyTotal: Int
    let dailyProgressPct: Int
    let dailyCompleted: Int
    let dailyTotal: Int
    let todayDuties: [EmsDutyItem]
    let tomorrowDuties: [EmsDutyItem]
    let upcomingDuties: [EmsDutyItem]

    static var empty: EmsWidgetPayload {
        return EmsWidgetPayload(
            lastUpdated: nil,
            weeklyProgressPct: 0,
            weeklyCompleted: 0,
            weeklyTotal: 0,
            dailyProgressPct: 0,
            dailyCompleted: 0,
            dailyTotal: 0,
            todayDuties: [],
            tomorrowDuties: [],
            upcomingDuties: []
        )
    }
}
