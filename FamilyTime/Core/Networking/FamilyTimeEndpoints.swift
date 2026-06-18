import Foundation

/// All FamilyTime API endpoints. Base host: https://core.familytime.io (no /dashboard or /api prefix).
/// Paths confirmed against the backend spec (June 2026).
enum FamilyTimeEndpoint: EndpointProtocol {
    // MARK: - Authentication
    case login(email: String, password: String, pushToken: String, deviceId: String)
    case forgotPassword(email: String)
    case verifyEmail
    case logout

    // MARK: - Dashboard
    case home
    case notificationFeed

    // MARK: - Account & Profile
    case accountInfo
    case updateProfile(params: [String: String])

    // MARK: - Child & Devices
    case deleteChild(childId: String)
    case generateQRCode
    case devices

    // MARK: - Co-Parenting
    case coParentList
    case coParentInvite(email: String, name: String)
    case removeCoParent(coParentId: String)

    // MARK: - Security
    /// Path not yet confirmed by the backend team — de-prefixed placeholder.
    case changePassword(currentPassword: String, newPassword: String)

    // MARK: - Subscription / IAP
    case validateReceipt(receiptData: String)
    case notifications(childId: String)

    // MARK: - Screen Time
    case dailyLimit
    case updateDailyLimit(body: DailyLimitUpdate)
    case screenTimeRules(childId: String)
    case createScreenTimeRule(childId: String, body: ScreenTimeRuleBody)
    case updateScreenTimeRule(ruleId: String, body: ScreenTimeRuleBody)
    case deleteScreenTimeRule(ruleId: String)

    // MARK: - Location & Maps
    case familyMap
    case locationHistory(childId: String, startDate: String)
    case places(childId: String)
    case createPlace(body: PlaceBody)
    case updatePlace(body: UpdatePlaceBody)
    case deletePlace(childId: String, placeId: String)
    case placeHistory(childId: String)

    // MARK: - Reports & History
    case webHistory(childId: String, startDate: String)
    case youtubeHistory(childId: String, startDate: String)
    case tikTokHistory(childId: String, startDate: String)
    case socialMonitoring(childId: String, startDate: String)
    case callHistory(childId: String, startDate: String)
    case contacts(childId: String)
    case smsHistory(childId: String, startDate: String)
    case appUsage(childId: String, startDate: String)

    // MARK: - App Blocking & Content Filters
    case installedApps(childId: String)
    case setAppBlocked(body: AppBlockBody)
    case contentFilters(childId: String)
    case updateContentFilters(body: ContentFilterBody)

    // MARK: - Hosts

    private enum Host {
        static let core = "https://core.familytime.io"
    }

    // MARK: - EndpointProtocol

    var baseURL: String { Host.core }

    var path: String {
        switch self {
        case .login:                       return "/login"
        case .forgotPassword:              return "/forget-password"
        case .verifyEmail:                 return "/user/verify-email"
        case .logout:                      return "/logout"
        case .home:                        return "/v1/home"
        case .notificationFeed:            return "/family-feed"
        case .accountInfo, .updateProfile: return "/profile"
        case .deleteChild(let childId):    return "/children/\(childId)"
        case .generateQRCode:              return "/generate-qr-code"
        case .devices:                     return "/devices"
        case .coParentList:                return "/co-parents"
        case .coParentInvite:              return "/invite-co-parent"
        case .removeCoParent:              return "/cancel-co-parent-invitation"
        case .changePassword:              return "/change-password" // TODO confirm with backend
        case .validateReceipt:             return "/ipn"
        case .notifications:               return "/v1/push-notifications"
        case .dailyLimit, .updateDailyLimit: return "/controls/daily-limit"
        case .screenTimeRules(let childId):  return "/controls/sst/\(childId)"
        case .createScreenTimeRule(let childId, _): return "/controls/sst/store/\(childId)"
        case .updateScreenTimeRule(let ruleId, _):  return "/controls/sst/update/\(ruleId)"
        case .deleteScreenTimeRule(let ruleId):     return "/controls/sst/delete/\(ruleId)"
        case .familyMap:                   return "/family-locator"
        case .locationHistory:             return "/reports/locations"
        case .places, .createPlace, .updatePlace, .deletePlace: return "/controls/places"
        case .placeHistory(let childId):   return "/devices/\(childId)/visits"
        case .webHistory:                  return "/reports/web-history"
        case .youtubeHistory:              return "/reports/youtube-history"
        case .tikTokHistory:               return "/reports/tiktok-history"
        case .socialMonitoring:            return "/reports/social-monitoring"
        case .callHistory:                 return "/reports/calls"
        case .contacts:                    return "/reports/contacts"
        case .smsHistory:                  return "/reports/sms"
        case .appUsage:                    return "/reports/app-usage"
        case .installedApps(let childId):  return "/devices/\(childId)/apps"
        case .setAppBlocked:               return "/controls/app-blocker"
        case .contentFilters, .updateContentFilters: return "/controls/content-filters"
        }
    }

    var method: HTTPVerb {
        switch self {
        case .login, .forgotPassword, .logout, .validateReceipt,
             .coParentInvite, .removeCoParent, .changePassword, .generateQRCode,
             .createScreenTimeRule, .createPlace, .setAppBlocked:
            return .post
        case .updateProfile, .updateDailyLimit, .updateScreenTimeRule,
             .updatePlace, .updateContentFilters:
            return .put
        case .deleteChild, .deleteScreenTimeRule, .deletePlace:
            return .delete
        case .verifyEmail, .home, .notificationFeed, .accountInfo, .devices,
             .coParentList, .notifications, .dailyLimit, .screenTimeRules,
             .familyMap, .locationHistory, .places, .placeHistory,
             .webHistory, .youtubeHistory, .tikTokHistory, .socialMonitoring,
             .callHistory, .contacts, .smsHistory, .appUsage,
             .installedApps, .contentFilters:
            return .get
        }
    }

    var headers: [String: String]? { nil }

    var queryParameters: [String: String]? {
        switch self {
        case .notifications(let childId), .places(let childId), .contentFilters(let childId), .contacts(let childId):
            return ["child_id": childId]
        case .locationHistory(let childId, let startDate),
             .webHistory(let childId, let startDate),
             .youtubeHistory(let childId, let startDate),
             .tikTokHistory(let childId, let startDate),
             .socialMonitoring(let childId, let startDate),
             .callHistory(let childId, let startDate),
             .smsHistory(let childId, let startDate),
             .appUsage(let childId, let startDate):
            return ["device_id": childId, "start_date": startDate]
        default:
            return nil
        }
    }

    var body: (any Encodable)? {
        switch self {
        case .login(let email, let password, let pushToken, let deviceId):
            return LoginBody(email: email, password: password, pushToken: pushToken, uniqueDeviceId: deviceId, agent: "ios")
        case .forgotPassword(let email):
            return ForgotPasswordBody(email: email)
        case .validateReceipt(let receiptData):
            return ValidateReceiptBody(signedPayload: receiptData)
        case .updateProfile(let params):
            return params
        case .coParentInvite(let email, let name):
            return CoParentInviteBody(name: name, email: email, type: "co_parent")
        case .changePassword(let currentPassword, let newPassword):
            return ChangePasswordBody(currentPassword: currentPassword, newPassword: newPassword)
        case .removeCoParent(let coParentId):
            return CancelCoParentBody(userId: coParentId)
        case .updateDailyLimit(let body):
            return body
        case .createScreenTimeRule(_, let body), .updateScreenTimeRule(_, let body):
            return body
        case .createPlace(let body):
            return body
        case .updatePlace(let body):
            return body
        case .deletePlace(let childId, let placeId):
            return DeletePlaceBody(data: [DeletePlaceItem(childId: childId, id: placeId)])
        case .setAppBlocked(let body):
            return body
        case .updateContentFilters(let body):
            return body
        default:
            return nil
        }
    }
}

// MARK: - Request bodies

private struct LoginBody: Encodable {
    let email: String
    let password: String
    let pushToken: String
    let uniqueDeviceId: String
    let agent: String

    enum CodingKeys: String, CodingKey {
        case email, password, agent
        case pushToken = "push_token"
        case uniqueDeviceId = "unique_device_id"
    }
}

private struct ForgotPasswordBody: Encodable {
    let email: String
}

private struct ValidateReceiptBody: Encodable {
    let signedPayload: String
}

struct ChangePasswordBody: Encodable {
    let currentPassword: String
    let newPassword: String

    enum CodingKeys: String, CodingKey {
        case currentPassword = "current_password"
        case newPassword = "new_password"
    }
}

struct CoParentInviteBody: Encodable {
    let name: String
    let email: String
    let type: String
}

struct CancelCoParentBody: Encodable {
    let userId: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}

// MARK: - Screen Time bodies

struct DailyLimitUpdate: Encodable {
    let childId: String
    let duration: Int
    let apps: [String]

    enum CodingKeys: String, CodingKey {
        case childId = "child_id"
        case duration
        case apps
    }
}

struct ScreenTimeRuleBody: Encodable {
    let name: String
    let startTime: String   // "Y-m-d H:i:s"
    let endTime: String     // "Y-m-d H:i:s"
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
    let sunday: Bool
    let active: Bool

    enum CodingKeys: String, CodingKey {
        case name, monday, tuesday, wednesday, thursday, friday, saturday, sunday, active
        case startTime = "start_time"
        case endTime = "end_time"
    }
}

// MARK: - Location bodies

/// Create-place payload (geofence). Numeric fields are strings per backend.
struct PlaceBody: Encodable {
    let childId: String
    let name: String
    let longitude: String
    let latitude: String
    let address: String
    let radius: String
    let status: String
    let function: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case childId = "child_id"
        case name, longitude, latitude, address, radius, status, function, icon
    }
}

/// Update-place payload — same as `PlaceBody` plus the place `id`.
struct UpdatePlaceBody: Encodable {
    let id: String
    let childId: String
    let name: String
    let longitude: String
    let latitude: String
    let address: String
    let radius: String
    let status: String
    let function: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id
        case childId = "child_id"
        case name, longitude, latitude, address, radius, status, function, icon
    }
}

struct DeletePlaceItem: Encodable {
    let childId: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case childId = "child_id"
        case id
    }
}

struct DeletePlaceBody: Encodable {
    let data: [DeletePlaceItem]
}

// MARK: - App Blocking & Content Filter bodies

struct AppBlockItem: Encodable {
    let appId: Int?
    let appPackageName: String?
    let blocked: Bool
    let childId: String

    enum CodingKeys: String, CodingKey {
        case appId = "app_id"
        case appPackageName = "app_package_name"
        case blocked
        case childId = "child_id"
    }
}

struct AppBlockBody: Encodable {
    let apps: [AppBlockItem]
}

struct ContentFilterBody: Encodable {
    let childId: String
    let mdmPayload: String

    enum CodingKeys: String, CodingKey {
        case childId = "child_id"
        case mdmPayload = "mdm_payload"
    }
}
