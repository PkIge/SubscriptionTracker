import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subscriptions: [Subscription]

    @State private var isPresentingAddSheet = false
    @State private var quickAddService: QuickAddService?
    @State private var subscriptionToEdit: EditableSubscription?

    private let viewModel = SubscriptionDashboardViewModel()

    var body: some View {
        NavigationStack {
            Group {
                let sortedSubscriptions = viewModel.sortedSubscriptions(from: subscriptions)

                if sortedSubscriptions.isEmpty {
                    ContentUnavailableView(
                        "No Subscriptions Yet",
                        systemImage: "tray",
                        description: Text("Add your first subscription or use Quick Add to prefill popular services.")
                    )
                } else {
                    List {
                        ForEach(sortedSubscriptions) { subscription in
                            NavigationLink {
                                SubscriptionDetailView(subscription: subscription)
                            } label: {
                                subscriptionRow(for: subscription)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button("Edit", systemImage: "pencil") {
                                    subscriptionToEdit = EditableSubscription(subscription: subscription)
                                }
                                .tint(.blue)
                            }
                        }
                        .onDelete(perform: deleteSubscriptions)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Subscriptions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Add Manually", systemImage: "square.and.pencil") {
                            isPresentingAddSheet = true
                        }

                        Divider()

                        ForEach(QuickAddService.popularServices) { service in
                            Button(service.name, systemImage: service.isUSSD ? "phone.connection" : "plus.circle") {
                                quickAddService = service
                            }
                        }
                    } label: {
                        Label("Add Subscription", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddSheet) {
                NavigationStack {
                    SubscriptionFormView()
                }
            }
            .sheet(item: $quickAddService) { service in
                NavigationStack {
                    SubscriptionFormView(quickAddService: service)
                }
            }
            .sheet(item: $subscriptionToEdit) { item in
                NavigationStack {
                    SubscriptionFormView(subscription: item.subscription)
                }
            }
        }
    }

    @ViewBuilder
    private func subscriptionRow(for subscription: Subscription) -> some View {
        HStack(spacing: 12) {
            Image(systemName: subscription.isUSSD ? "simcard.fill" : "creditcard.fill")
                .font(.title3)
                .foregroundStyle(subscription.isUSSD ? .orange : .accentColor)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.name)
                    .font(.headline)

                Text(viewModel.renewalSubtitle(for: subscription))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(viewModel.formattedPrice(for: subscription))
                .font(.headline)
                .monospacedDigit()
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(viewModel.accessibilitySummary(for: subscription))
    }

    private func deleteSubscriptions(at offsets: IndexSet) {
        let sortedSubscriptions = viewModel.sortedSubscriptions(from: subscriptions)
        for index in offsets {
            modelContext.delete(sortedSubscriptions[index])
        }

        try? modelContext.save()
    }
}

private struct EditableSubscription: Identifiable {
    let id: UUID
    let subscription: Subscription

    init(subscription: Subscription) {
        self.id = subscription.id
        self.subscription = subscription
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: Subscription.self, inMemory: true)
}
