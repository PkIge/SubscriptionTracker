import Foundation
import Observation

@Observable
final class SubscriptionDetailViewModel {
    let subscription: Subscription

    init(subscription: Subscription) {
        self.subscription = subscription
    }

    var actionButtonTitle: String {
        subscription.isUSSD ? "Manage in Dialer" : "Manage / Cancel Subscription"
    }

    var actionSystemImage: String {
        subscription.isUSSD ? "phone.connection.fill" : "safari.fill"
    }

    var formattedPrice: String {
        let code = subscription.currency.uppercased()
        return subscription.price.formatted(
            .currency(code: code)
            .precision(.fractionLength(subscription.price == floor(subscription.price) ? 0 : 2))
        )
    }

    var managementDescription: String {
        subscription.isUSSD
        ? "This subscription uses a USSD code and will open your phone dialer."
        : "This link opens an in-app browser so you can manage or cancel the subscription."
    }

    var managementURL: URL? {
        if subscription.isUSSD {
            let encoded = subscription.cancellationURL.replacingOccurrences(of: "#", with: "%23")
            return URL(string: encoded)
        }

        return URL(string: subscription.cancellationURL)
    }
}
