import Foundation

/// Bridges incoming APNs pushes to SwiftUI by publishing the most recent
/// `PushAlert` for views to present.
///
/// This is the modern replacement for the legacy UserDefaults-flag pattern in
/// new code: the AppDelegate posts `.pushReceived` with the raw APNs `userInfo`,
/// and this center parses it into a typed `PushAlert` on the main actor. It is an
/// additive bridge and reuses the existing `PushAlert` / `PushAlertType` models.
@MainActor
@Observable
final class PushAlertCenter {
    static let shared = PushAlertCenter()

    /// The alert currently awaiting presentation, or `nil` when none is pending.
    var currentAlert: PushAlert?

    private var observer: NSObjectProtocol?

    private init() {
        observer = NotificationCenter.default.addObserver(
            forName: .pushReceived,
            object: nil,
            queue: .main
        ) { [weak self] note in
            guard let userInfo = note.userInfo else { return }
            // Hop to the main actor; the observer closure is not actor-isolated.
            Task { @MainActor in
                self?.handle(userInfo)
            }
        }
    }

    // No `deinit` cleanup: `shared` is a process-lifetime singleton, so the
    // observer stays valid for the app's whole lifetime. (A `deinit` would be
    // nonisolated and could not access the `@MainActor` `observer` property.)

    /// Parses a raw APNs payload and publishes it when it is a recognizable alert.
    /// Unrecognized payloads (where `PushAlert(userInfo:)` returns `nil`) are ignored.
    func handle(_ userInfo: [AnyHashable: Any]) {
        if let alert = PushAlert(userInfo: userInfo) {
            currentAlert = alert
        }
    }

    /// Clears the current alert once it has been presented/handled.
    func dismiss() {
        currentAlert = nil
    }
}
