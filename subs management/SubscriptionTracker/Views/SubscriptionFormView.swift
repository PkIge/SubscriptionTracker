import SwiftUI
import SwiftData

struct SubscriptionFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel: SubscriptionFormViewModel

    init(subscription: Subscription? = nil, quickAddService: QuickAddService? = nil) {
        _viewModel = State(initialValue: SubscriptionFormViewModel(subscription: subscription, quickAddService: quickAddService))
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        Form {
            Section("Quick Add") {
                Menu {
                    ForEach(QuickAddService.popularServices) { service in
                        Button(service.name, systemImage: service.isUSSD ? "phone.connection" : "sparkles") {
                            viewModel.applyQuickAdd(service)
                        }
                    }
                } label: {
                    Label("Prefill Popular Service", systemImage: "wand.and.stars")
                }
            }

            Section("Subscription Info") {
                TextField("Name", text: $viewModel.name)
                    .textInputAutocapitalization(.words)

                TextField("Price", text: $viewModel.price)
                    .keyboardType(.decimalPad)

                TextField("Currency Code", text: $viewModel.currency)
                    .textInputAutocapitalization(.characters)

                Picker("Billing Period", selection: $viewModel.billingPeriod) {
                    ForEach(BillingPeriod.allCases) { period in
                        Text(period.title).tag(period)
                    }
                }

                DatePicker(
                    "First Billing Date",
                    selection: $viewModel.firstBillingDate,
                    displayedComponents: [.date]
                )
            }

            Section("Management") {
                TextField("Cancellation URL or USSD", text: $viewModel.cancellationURL)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                Toggle("Requires USSD / Dialer", isOn: $viewModel.isUSSD)

                if viewModel.isUSSD {
                    Label("USSD subscriptions will launch the phone dialer instead of the in-app browser.", systemImage: "phone.connection")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button(viewModel.saveButtonTitle) {
                    saveSubscription()
                }
                .disabled(!viewModel.canSave)
            }
        }
    }

    private func saveSubscription() {
        guard let savedSubscription = viewModel.save() else {
            return
        }

        if !viewModel.isEditing {
            modelContext.insert(savedSubscription)
        }

        try? modelContext.save()
        dismiss()
    }
}
