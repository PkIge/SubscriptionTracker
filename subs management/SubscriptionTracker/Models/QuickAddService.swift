import Foundation

struct QuickAddService: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let cancellationURL: String
    let isUSSD: Bool
    let suggestedBillingPeriod: BillingPeriod
    let suggestedCurrency: String
    let suggestedPrice: Double

    func makeSubscription(firstBillingDate: Date = .now) -> Subscription {
        Subscription(
            name: name,
            price: suggestedPrice,
            currency: suggestedCurrency,
            billingPeriod: suggestedBillingPeriod,
            firstBillingDate: firstBillingDate,
            cancellationURL: cancellationURL,
            isUSSD: isUSSD
        )
    }
}

extension QuickAddService {
    static let popularServices: [QuickAddService] = [
        QuickAddService(
            name: "YouTube",
            cancellationURL: "https://www.youtube.com/paid_memberships",
            isUSSD: false,
            suggestedBillingPeriod: .monthly,
            suggestedCurrency: "USD",
            suggestedPrice: 0
        ),
        QuickAddService(
            name: "X (Twitter)",
            cancellationURL: "https://twitter.com/settings/premium_tier",
            isUSSD: false,
            suggestedBillingPeriod: .monthly,
            suggestedCurrency: "USD",
            suggestedPrice: 0
        ),
        QuickAddService(
            name: "Snapchat+",
            cancellationURL: "https://accounts.snapchat.com/accounts/v2/snapchatplus",
            isUSSD: false,
            suggestedBillingPeriod: .monthly,
            suggestedCurrency: "USD",
            suggestedPrice: 0
        ),
        QuickAddService(
            name: "ElevenLabs",
            cancellationURL: "https://elevenlabs.io/app/subscription",
            isUSSD: false,
            suggestedBillingPeriod: .monthly,
            suggestedCurrency: "USD",
            suggestedPrice: 0
        ),
        QuickAddService(
            name: "Claude",
            cancellationURL: "https://claude.ai/settings/billing",
            isUSSD: false,
            suggestedBillingPeriod: .monthly,
            suggestedCurrency: "USD",
            suggestedPrice: 0
        ),
        QuickAddService(
            name: "ChatGPT",
            cancellationURL: "https://chat.openai.com/#settings/Billing",
            isUSSD: false,
            suggestedBillingPeriod: .monthly,
            suggestedCurrency: "USD",
            suggestedPrice: 0
        ),
        QuickAddService(
            name: "Spotify",
            cancellationURL: "https://www.spotify.com/account/subscriptions/",
            isUSSD: false,
            suggestedBillingPeriod: .monthly,
            suggestedCurrency: "USD",
            suggestedPrice: 0
        ),
        QuickAddService(
            name: "Google AI/Workspace",
            cancellationURL: "https://myaccount.google.com/subscriptions",
            isUSSD: false,
            suggestedBillingPeriod: .monthly,
            suggestedCurrency: "USD",
            suggestedPrice: 0
        ),
        QuickAddService(
            name: "Starlink",
            cancellationURL: "https://www.starlink.com/account/home",
            isUSSD: false,
            suggestedBillingPeriod: .monthly,
            suggestedCurrency: "USD",
            suggestedPrice: 0
        ),
        QuickAddService(
            name: "Proton VPN",
            cancellationURL: "https://account.proton.me/u/0/vpn/subscription",
            isUSSD: false,
            suggestedBillingPeriod: .monthly,
            suggestedCurrency: "USD",
            suggestedPrice: 0
        ),
        QuickAddService(
            name: "MTN",
            cancellationURL: "tel://*312#",
            isUSSD: true,
            suggestedBillingPeriod: .monthly,
            suggestedCurrency: "NGN",
            suggestedPrice: 0
        ),
        QuickAddService(
            name: "Glo",
            cancellationURL: "tel://*312#",
            isUSSD: true,
            suggestedBillingPeriod: .monthly,
            suggestedCurrency: "NGN",
            suggestedPrice: 0
        ),
        QuickAddService(
            name: "Airtel",
            cancellationURL: "tel://*312#",
            isUSSD: true,
            suggestedBillingPeriod: .monthly,
            suggestedCurrency: "NGN",
            suggestedPrice: 0
        )
    ]
}
