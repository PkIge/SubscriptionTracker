import Foundation

enum BillingPeriod: String, CaseIterable, Codable, Identifiable {
    case weekly
    case monthly
    case quarterly
    case yearly

    var id: String { rawValue }

    var title: String {
        switch self {
        case .weekly:
            "Weekly"
        case .monthly:
            "Monthly"
        case .quarterly:
            "Quarterly"
        case .yearly:
            "Yearly"
        }
    }

    var calendarComponent: Calendar.Component {
        switch self {
        case .weekly:
            .weekOfYear
        case .monthly, .quarterly, .yearly:
            .month
        }
    }

    var calendarValue: Int {
        switch self {
        case .weekly:
            1
        case .monthly:
            1
        case .quarterly:
            3
        case .yearly:
            12
        }
    }
}
