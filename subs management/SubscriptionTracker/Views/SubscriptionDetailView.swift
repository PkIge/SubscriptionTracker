import SwiftUI
import UIKit

struct SubscriptionDetailView: View {
    @Bindable var subscription: Subscription
    @State private var safariDestination: SafariDestination?
    @State private var isPresentingEditor = false

    private var viewModel: SubscriptionDetailViewModel {
        SubscriptionDetailViewModel(subscription: subscription)
    }

    var body: some View {
        List {
            Section("Overview") {
                labeledValue("Name", value: viewModel.subscription.name, systemImage: "textformat")
                labeledValue("Price", value: viewModel.formattedPrice, systemImage: "creditcard")
                labeledValue("Billing", value: viewModel.subscription.billingPeriod.title, systemImage: "calendar")
                labeledValue(
                    "Next Renewal",
                    value: viewModel.subscription.nextBillingDate.formatted(date: .complete, time: .omitted),
                    systemImage: "clock.arrow.circlepath"
                )
                labeledValue("Renewal Status", value: viewModel.subscription.renewalDescription, systemImage: "calendar.badge.clock")
            }

            Section("Management") {
                labeledValue("Link / Code", value: viewModel.subscription.cancellationURL, systemImage: "link")

                Text(viewModel.managementDescription)
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Button {
                    handleManagementAction()
                } label: {
                    Label(viewModel.actionButtonTitle, systemImage: viewModel.actionSystemImage)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
            }
        }
        .navigationTitle(viewModel.subscription.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit", systemImage: "pencil") {
                    isPresentingEditor = true
                }
            }
        }
        .sheet(item: $safariDestination) { destination in
            SafariView(url: destination.url)
        }
        .sheet(isPresented: $isPresentingEditor) {
            NavigationStack {
                SubscriptionFormView(subscription: subscription)
            }
        }
    }

    @ViewBuilder
    private func labeledValue(_ title: String, value: String, systemImage: String) -> some View {
        LabeledContent {
            Text(value)
                .multilineTextAlignment(.trailing)
        } label: {
            Label(title, systemImage: systemImage)
        }
    }

    private func handleManagementAction() {
        guard let url = viewModel.managementURL else { return }

        if subscription.isUSSD {
            UIApplication.shared.open(url)
        } else {
            safariDestination = SafariDestination(url: url)
        }
    }
}

private struct SafariDestination: Identifiable {
    let id = UUID()
    let url: URL
}
