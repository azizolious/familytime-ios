import Foundation

/// Single source of truth for the currently selected child context used by the
/// screen-time layer. Backed by `UserDefaultsConstants.SELECTED_CHILD_ID`.
@MainActor
@Observable
final class SelectedChildStore {

    static let shared = SelectedChildStore()

    /// The full selected child model, when available.
    private(set) var selectedChild: ChildData?

    /// String form of the selected child id, suitable for API path parameters.
    private(set) var selectedChildID: String?

    private init() {
        // Seed from UserDefaults. The stored value may be an Int or a String
        // depending on the writer, so normalize whatever is present to String?.
        if let id = UserDefaults.standard.object(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) {
            selectedChildID = "\(id)"
        }
    }

    /// Selects a child and persists its id to UserDefaults.
    func select(_ child: ChildData) {
        selectedChild = child
        if let childID = child.childInfo?.childID {
            selectedChildID = String(childID)
            UserDefaults.standard.set(childID, forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        }
    }

    /// Sets only the string id (e.g. when the full model is not yet loaded).
    func selectID(_ id: String?) {
        selectedChildID = id
    }
}
