import SwiftUI
import SwiftData

@main
struct SubscriptionTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView()
        }
        .modelContainer(for: Subscription.self)
    }
}
