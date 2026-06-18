import SwiftUI

struct RuleEditorView: View {
    @State private var rule: ScreenTimeRule
    let onSave: (ScreenTimeRule) -> Void
    @Environment(\.dismiss) private var dismiss

    init(rule: ScreenTimeRule, onSave: @escaping (ScreenTimeRule) -> Void) {
        _rule = State(initialValue: rule)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Rule name", text: $rule.ruleName)
                }
                Section("Time") {
                    TextField("Start (HH:mm)", text: $rule.timeStart)
                    TextField("End (HH:mm)", text: $rule.timeEnd)
                }
                Section("Days") {
                    Toggle("Mon", isOn: $rule.isMon)
                    Toggle("Tue", isOn: $rule.isTue)
                    Toggle("Wed", isOn: $rule.isWed)
                    Toggle("Thu", isOn: $rule.isThu)
                    Toggle("Fri", isOn: $rule.isFri)
                    Toggle("Sat", isOn: $rule.isSat)
                    Toggle("Sun", isOn: $rule.isSun)
                }
                Section {
                    Toggle("Active", isOn: $rule.isActive)
                }
            }
            .navigationTitle(rule.id == nil ? "New Schedule" : "Edit Schedule")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { onSave(rule) }
                        .disabled(rule.ruleName.isEmpty)
                }
            }
        }
    }
}
