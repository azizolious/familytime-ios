import SwiftUI

struct ScreenTimeView: View {
    @State private var viewModel = ScreenTimeViewModel()
    @State private var editingRule: ScreenTimeRule?
    @State private var showingEditor = false

    var body: some View {
        NavigationStack {
            List {
                if let limit = viewModel.dailyLimit {
                    Section("Daily Limit") {
                        HStack {
                            Text("Allowed")
                            Spacer()
                            Text("\(limit.duration) min")
                        }
                        HStack {
                            Text("Remaining")
                            Spacer()
                            Text("\(limit.remaining) min")
                        }
                        Toggle("Active", isOn: .constant(limit.isActive))
                            .disabled(true) // read-only display this increment
                    }
                }

                Section("Schedules") {
                    if viewModel.rules.isEmpty && !viewModel.isLoading {
                        Text("No schedules yet")
                            .foregroundColor(.secondary)
                    }
                    ForEach(viewModel.rules) { rule in
                        Button {
                            editingRule = rule
                            showingEditor = true
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(rule.ruleName)
                                    Text("\(rule.timeStart) – \(rule.timeEnd)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if rule.isActive {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                    }
                    .onDelete { idx in
                        if let i = idx.first {
                            let r = viewModel.rules[i]
                            Task { await viewModel.deleteRule(r) }
                        }
                    }
                }
            }
            .navigationTitle("Screen Time")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        editingRule = ScreenTimeRule(
                            id: nil,
                            ruleName: "",
                            timeStart: "21:00",
                            timeEnd: "07:00",
                            isMon: true,
                            isTue: true,
                            isWed: true,
                            isThu: true,
                            isFri: true,
                            isSat: true,
                            isSun: true,
                            isActive: true
                        )
                        showingEditor = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .refreshable { await viewModel.load() }
            .task { await viewModel.load() }
            .sheet(isPresented: $showingEditor) {
                if let rule = editingRule {
                    RuleEditorView(rule: rule) { saved in
                        Task { await viewModel.saveRule(saved) }
                        showingEditor = false
                    }
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}
