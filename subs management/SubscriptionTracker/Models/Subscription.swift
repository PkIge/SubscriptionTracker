import Foundation
import SwiftData

@Model
final class Subscription {
    @Attribute(.unique) var id: UUID
    var name: String
    var price: Double
    var currency: String
    var billingPeriod: BillingPeriod
    var firstBillingDate: Date
    var cancellationURL: String
    var isUSSD: Bool

    init(
        id: UUID = UUID(),
        name: String,
        price: Double,
        currency: String,
        billingPeriod: BillingPeriod,
        firstBillingDate: Date,
        cancellationURL: String,
        isUSSD: Bool = false
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.currency = currency
        self.billingPeriod = billingPeriod
        self.firstBillingDate = firstBillingDate
        self.cancellationURL = cancellationURL
        self.isUSSD = isUSSD
    }
}

extension Subscription {
    var nextBillingDate: Date {
        let calendar = Calendar.current
        let now = Date()
        var candidate = firstBillingDate

        while candidate < now {
            guard let nextCandidate = calendar.date(
                byAdding: billingPeriod.calendarComponent,
                value: billingPeriod.calendarValue,
                to: candidate
            ) else {
                break
            }

            candidate = nextCandidate
        }

        return candidate
    }

    var daysUntilRenewal: Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfRenewalDay = calendar.startOfDay(for: nextBillingDate)
        return calendar.dateComponents([.day], from: startOfToday, to: startOfRenewalDay).day ?? 0
    }

    var renewalDescription: String {
        switch daysUntilRenewal {
        case ..<0:
            return "Renewal overdue"
        case 0:
            return "Renews today"
        case 1:
            return "Renews tomorrow"
        default:
            return "\(daysUntilRenewal) days until renewal"
        }
    }
}
