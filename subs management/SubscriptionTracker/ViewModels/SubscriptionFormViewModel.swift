import Foundation
import Observation

@Observable
final class SubscriptionFormViewModel {
    var name: String
    var price: String
    var currency: String
    var billingPeriod: BillingPeriod
    var firstBillingDate: Date
    var cancellationURL: String
    var isUSSD: Bool

    let isEditing: Bool
    private let subscription: Subscription?

    init(subscription: Subscription? = nil, quickAddService: QuickAddService? = nil) {
        self.subscription = subscription
        self.isEditing = subscription != nil
        self.name = subscription?.name ?? ""
        if let value = subscription?.price {
            self.price = value == floor(value) ? String(Int(value)) : String(format: "%.2f", value)
        } else {
            self.price = ""
        }
        self.currency = subscription?.currency ?? "USD"
        self.billingPeriod = subscription?.billingPeriod ?? .monthly
        self.firstBillingDate = subscription?.firstBillingDate ?? .now
        self.cancellationURL = subscription?.cancellationURL ?? ""
        self.isUSSD = subscription?.isUSSD ?? false

        if subscription == nil, let quickAddService {
            applyQuickAdd(quickAddService)
        }
    }

    var navigationTitle: String {
        isEditing ? "Edit Subscription" : "Add Subscription"
    }

    var saveButtonTitle: String {
        isEditing ? "Save Changes" : "Add Subscription"
    }

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        Double(price) != nil &&
        !currency.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !cancellationURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func applyQuickAdd(_ service: QuickAddService) {
        name = service.name
        cancellationURL = service.cancellationURL
        isUSSD = service.isUSSD
        billingPeriod = service.suggestedBillingPeriod
        currency = service.suggestedCurrency
        price = service.suggestedPrice == 0 ? "" : String(service.suggestedPrice)
    }

    func save() -> Subscription? {
        guard
            canSave,
            let parsedPrice = Double(price)
        else {
            return nil
        }

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCurrency = currency.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let trimmedURL = cancellationURL.trimmingCharacters(in: .whitespacesAndNewlines)

        if let subscription {
            subscription.name = trimmedName
            subscription.price = parsedPrice
            subscription.currency = trimmedCurrency
            subscription.billingPeriod = billingPeriod
            subscription.firstBillingDate = firstBillingDate
            subscription.cancellationURL = trimmedURL
            subscription.isUSSD = isUSSD
            return subscription
        }

        return Subscription(
            name: trimmedName,
            price: parsedPrice,
            currency: trimmedCurrency,
            billingPeriod: billingPeriod,
            firstBillingDate: firstBillingDate,
            cancellationURL: trimmedURL,
            isUSSD: isUSSD
        )
    }
}
