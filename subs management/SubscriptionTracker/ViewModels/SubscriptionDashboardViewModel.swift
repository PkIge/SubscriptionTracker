import Foundation
import Observation

@Observable
final class SubscriptionDashboardViewModel {
    func sortedSubscriptions(from subscriptions: [Subscription]) -> [Subscription] {
        subscriptions.sorted {
            if $0.nextBillingDate == $1.nextBillingDate {
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
            return $0.nextBillingDate < $1.nextBillingDate
        }
    }

    func formattedPrice(for subscription: Subscription) -> String {
        let code = subscription.currency.uppercased()
        return subscription.price.formatted(
            .currency(code: code)
            .precision(.fractionLength(subscription.price == floor(subscription.price) ? 0 : 2))
        )
    }

    func renewalSubtitle(for subscription: Subscription) -> String {
        let nextDate = subscription.nextBillingDate.formatted(date: .abbreviated, time: .omitted)
        return "\(subscription.renewalDescription) - \(nextDate)"
    }

    func accessibilitySummary(for subscription: Subscription) -> String {
        "\(subscription.name), \(formattedPrice(for: subscription)), \(renewalSubtitle(for: subscription))"
    }
}
