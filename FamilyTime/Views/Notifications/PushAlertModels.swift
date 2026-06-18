import Foundation

// TODO confirm push payload keys with backend

/// The category of an incoming APNs alert, normalized from the various
/// string keys the backend may use (`pushtype`, top-level `type`, `alertType`).
enum PushAlertType: String {
    case panic
    case pickup
    case geofenceCheckin
    case geofenceCheckout
    case overSpeed
    case normalSpeed
    case approveApp
    case screenTimeRule
    case contactWatchlist
    case appBlocking
    case phoneLocked
    case phoneUnlocked
    case generic

    /// Maps a raw backend string (from any of the supported payload keys) to a
    /// `PushAlertType`. Unknown values fall back to `.generic`.
    static func from(rawValue raw: String) -> PushAlertType {
        switch raw.lowercased() {
        case "panic":
            return .panic
        case "pickup":
            return .pickup
        case "checkin", "geofencecheckin":
            return .geofenceCheckin
        case "checkout", "geofencecheckout":
            return .geofenceCheckout
        case "overspeed":
            return .overSpeed
        case "normalspeed":
            return .normalSpeed
        case "approve_app", "approveapp":
            return .approveApp
        case "ruleactivated", "ruledeactivated", "screentimerule":
            return .screenTimeRule
        case "contact_watchlist", "contactwatchlist":
            return .contactWatchlist
        case "app_blocking", "appblocking":
            return .appBlocking
        case "phonelocked":
            return .phoneLocked
        case "phoneunlocked":
            return .phoneUnlocked
        default:
            return .generic
        }
    }
}

/// A typed representation of an APNs alert parsed from the raw `userInfo` dict.
struct PushAlert: Identifiable, Equatable {
    let id = UUID()
    let type: PushAlertType
    let title: String
    let message: String
    let childName: String?
    let placeName: String?

    /// Parses an APNs `userInfo` payload into a typed `PushAlert`.
    ///
    /// Recognized type sources, in priority order:
    ///   1. `aps.pushtype` (panic / pickup / checkin / checkout / ruleActivated …)
    ///   2. top-level `type` (approve_app / subscription_* …)
    ///   3. top-level `alertType` (overSpeed / normalSpeed)
    ///
    /// Returns `nil` if none of those keys carry a recognizable string, so the
    /// caller can ignore unrelated/system payloads.
    init?(userInfo: [AnyHashable: Any]) {
        let aps = userInfo["aps"] as? [String: Any]

        // Resolve the raw type string from the supported keys, in priority order.
        let rawType: String?
        if let pushType = aps?["pushtype"] as? String, !pushType.isEmpty {
            rawType = pushType
        } else if let topType = userInfo["type"] as? String, !topType.isEmpty {
            rawType = topType
        } else if let alertType = userInfo["alertType"] as? String, !alertType.isEmpty {
            rawType = alertType
        } else {
            rawType = nil
        }

        guard let rawType = rawType else {
            return nil
        }

        self.type = PushAlertType.from(rawValue: rawType)

        // Title: prefer the aps title, then top-level title.
        let resolvedTitle = (aps?["title"] as? String)
            ?? (userInfo["title"] as? String)
            ?? ""
        self.title = resolvedTitle

        // Message: prefer aps `alert`, then `push_content` / `body` from either level.
        let apsAlert: String?
        if let alertString = aps?["alert"] as? String {
            apsAlert = alertString
        } else if let alertDict = aps?["alert"] as? [String: Any] {
            // APNs may deliver `alert` as a dict with a `body` (and `title`).
            apsAlert = alertDict["body"] as? String
        } else {
            apsAlert = nil
        }

        let resolvedMessage = apsAlert
            ?? (aps?["push_content"] as? String)
            ?? (userInfo["push_content"] as? String)
            ?? (aps?["body"] as? String)
            ?? (userInfo["body"] as? String)
            ?? ""
        self.message = resolvedMessage

        // childName from `sendername`; placeName from `placename` (either level).
        self.childName = (aps?["sendername"] as? String)
            ?? (userInfo["sendername"] as? String)
        self.placeName = (aps?["placename"] as? String)
            ?? (userInfo["placename"] as? String)
    }
}
