import Foundation

/// All FamilyTime API endpoints used by the dashboard app.
enum FamilyTimeEndpoint: EndpointProtocol {
    case login(email: String, password: String)
    case forgotPassword(email: String)
    case verifyEmail(params: [String: String])
    case tokenRefresh
    case dashboard(childId: String)
    case dashboardCore2(childId: String)
    case summaryData(childId: String)
    case validateReceipt(receiptData: String)
    case subscriptionProducts
    case subscriptionCancelled(childId: String)
    case notifications(childId: String)
    /// Premium "at launch" notification feed (all children; no params).
    /// Distinct from `notifications(childId:)`, which is per-child settings.
    case notificationFeed // TODO confirm
    case accountInfo
    case updateProfile(params: [String: String])
    case deleteChild(childId: String)
    case logout
    case generateQRCode(childId: String)

    // MARK: - Settings & Account
    // TODO confirm path/payload with backend (paths derived from a code audit, not backend docs).
    case changePassword(currentPassword: String, newPassword: String)
    case coParentInvite(email: String, name: String)
    case coParentList
    case removeCoParent(coParentId: String)

    // MARK: - Screen Time
    // TODO confirm path/payload with backend (paths derived from a code audit, not backend docs).
    case dailyLimit(childId: String)
    case updateDailyLimit(childId: String, body: DailyLimitUpdate)
    case screenTimeRules(childId: String)
    case createScreenTimeRule(childId: String, body: ScreenTimeRuleBody)
    case updateScreenTimeRule(childId: String, ruleId: String, body: ScreenTimeRuleBody)
    case deleteScreenTimeRule(childId: String, ruleId: String)

    // MARK: - Location & Maps
    // TODO confirm path/payload with backend (paths derived from a code audit, not backend docs).
    case familyMap
    case locationDates(childId: String)
    case locationHistory(childId: String, date: String)
    case places(childId: String)
    case createPlace(childId: String, body: PlaceBody)
    case updatePlace(childId: String, placeId: String, body: PlaceBody)
    case deletePlace(childId: String, placeId: String)
    case placeHistory(childId: String)

    // MARK: - Reports & History
    // TODO confirm path/payload with backend (paths derived from a code audit, not backend docs).
    case webHistory(childId: String, date: String, page: Int)
    case webSearch(childId: String, date: String, page: Int)
    case youtubeHistory(childId: String, date: String, page: Int)
    case tikTokHistory(childId: String, date: String, page: Int)
    case socialMonitoring(childId: String, date: String, appPackage: String, page: Int)

    // MARK: - Onboarding & Pairing
    // TODO confirm path/payload with backend (paths derived from a code audit, not backend docs).
    /// Legacy core2 QR generation (/generate-qr-code); distinct from `generateQRCode(childId:)`.
    case pairingQRCode(childId: String)
    case pairingStatus(childId: String)
    case addChild(body: ChildCreateBody)

    // MARK: - App Blocking & Content Filters
    // TODO confirm path/payload with backend (paths derived from a code audit, not backend docs).
    case installedApps(childId: String)
    case setAppBlocked(childId: String, appId: String, body: AppBlockBody)
    case contentFilters(childId: String)
    case updateContentFilters(body: ContentFilterBody)

    // MARK: - Hosts

    private enum Host {
        /// Single base host for ALL endpoints. mesh/mesh2 are dead.
        static let core = "https://core.familytime.io"
    }

    // MARK: - EndpointProtocol

    var baseURL: String {
        // All endpoints resolve to the single core host.
        return Host.core
    }

    var path: String {
        switch self {
        case .login:
            // path derived for mesh2 (KPLoginUrl + /dashboard/signin)
            return "/dashboard/signin" // TODO: confirm core path with backend team
        case .forgotPassword:
            // path derived for mesh2 (kForgot_password_mesh2 + /dashboard/forgotpassword)
            return "/dashboard/forgotpassword" // TODO: confirm core path with backend team
        case .verifyEmail:
            // path derived for mesh2 (kVerifyEmail_mesh2 + /dashboard/verifyemail)
            return "/dashboard/verifyemail" // TODO: confirm core path with backend team
        case .tokenRefresh:
            // path derived for mesh2 (KRefreshDashboard_mesh2 + /dashboard/home/refresh/)
            return "/dashboard/token/refresh" // TODO: confirm core path with backend team
        case .dashboard(let childId):
            // path derived for mesh2 (KDashboard_home_mesh2 + /dashboard/home/)
            return "/dashboard/home/\(childId)" // TODO: confirm core path with backend team
        case .dashboardCore2(let childId):
            return "/api/v1/dashboard/\(childId)" // TODO: confirm core path with backend team
        case .summaryData(let childId):
            return "/dashboard/summary/\(childId)" // TODO: confirm core path with backend team
        case .validateReceipt:
            // path derived for mesh2 (kValidateReceipt_mesh2 + /dashboard/ios/inapp/validatepurchase)
            return "/dashboard/ios/inapp/validatepurchase" // TODO: confirm core path with backend team
        case .subscriptionProducts:
            // path derived for mesh2 (kIAP_Products_Mesh2 + /dashboard/ios/in-app/products/)
            return "/dashboard/ios/in-app/products/" // TODO: confirm core path with backend team
        case .subscriptionCancelled(let childId):
            return "/dashboard/ios/inapp/cancelled/\(childId)" // TODO: confirm core path with backend team
        case .notifications(let childId):
            return "/dashboard/settings/ios/notifications/\(childId)" // TODO: confirm core path with backend team
        case .notificationFeed:
            return "/dashboard/notifications/feeds/atlaunch" // TODO: confirm core path with backend team
        case .accountInfo:
            return "/dashboard/parentdevice" // TODO: confirm core path with backend team
        case .updateProfile:
            // path derived for mesh2 (kUpdateParentInfo_mesh2 + /dashboard/parentdevice)
            return "/dashboard/parentdevice" // TODO: confirm core path with backend team
        case .deleteChild(let childId):
            // path derived for mesh2 (/child/delete/{child_id})
            return "/child/delete/\(childId)" // TODO: confirm core path with backend team
        case .logout:
            // path derived for mesh2 (kLogoutUrl_mesh2 + /dashboard/logout)
            return "/dashboard/logout" // TODO: confirm core path with backend team
        case .generateQRCode(let childId):
            return "/dashboard/qrcode/\(childId)" // TODO: confirm core path with backend team
        // MARK: - Settings & Account
        case .changePassword:
            return "/dashboard/changepassword" // TODO: confirm core path with backend team
        case .coParentInvite:
            return "/dashboard/coparent/invite" // TODO: confirm core path with backend team
        case .coParentList:
            return "/dashboard/coparents" // TODO: confirm core path with backend team
        case .removeCoParent:
            return "/dashboard/coparent" // TODO: confirm core path with backend team
        // MARK: - Screen Time
        // TODO confirm path/payload with backend
        case .dailyLimit(let childId),
             .updateDailyLimit(let childId, _):
            return "/dashboard/settings/android/lst/dailylimit/\(childId)" // TODO: confirm core path with backend team
        case .screenTimeRules(let childId):
            return "/dashboard/settings/ios/lst/applock/\(childId)" // TODO: confirm core path with backend team
        case .createScreenTimeRule(let childId, _):
            return "/dashboard/settings/ios/lst/applock/rule/\(childId)" // TODO: confirm core path with backend team
        case .updateScreenTimeRule(let childId, let ruleId, _),
             .deleteScreenTimeRule(let childId, let ruleId):
            return "/dashboard/settings/ios/lst/applock/rule/\(childId)/\(ruleId)" // TODO: confirm core path with backend team
        // MARK: - Location & Maps
        // TODO confirm path/payload with backend
        case .familyMap:
            // all children; no child param
            return "/dashboard/notifications/familytimemap/1" // TODO: confirm core path with backend team
        case .locationDates(let childId):
            return "/dashboard/reports/ios/locations/checkindates/\(childId)" // TODO: confirm core path with backend team
        case .locationHistory(_, let date):
            // childId is passed as a query parameter (see queryParameters).
            return "/dashboard/reports/ios/locations/\(date)" // TODO: confirm core path with backend team
        case .places,
             .createPlace:
            // childId is passed as a query parameter for GET.
            return "/dashboard/settings/places/" // TODO: confirm core path with backend team
        case .updatePlace(_, let placeId, _),
             .deletePlace(_, let placeId):
            return "/dashboard/settings/places/\(placeId)" // TODO: confirm core path with backend team
        case .placeHistory(let childId):
            return "/dashboard/reports/ios/placevisit/\(childId)" // TODO: confirm core path with backend team
        // MARK: - Reports & History
        // childId/date/page are passed as query parameters (see queryParameters).
        case .webHistory:
            return "/reports/web-history" // TODO: confirm core path with backend team
        case .webSearch:
            return "/reports/web-search" // TODO: confirm core path with backend team
        case .youtubeHistory:
            return "/reports/youtube-history" // TODO: confirm core path with backend team
        case .tikTokHistory:
            return "/reports/tiktok-history" // TODO: confirm core path with backend team
        case .socialMonitoring:
            return "/reports/social-monitoring" // TODO: confirm core path with backend team
        // MARK: - Onboarding & Pairing
        case .pairingQRCode:
            // Legacy core2 QR generation; childId is sent in the body, not the path.
            return "/generate-qr-code" // TODO: confirm core path with backend team
        case .pairingStatus(let childId):
            return "/child/\(childId)/status" // TODO: confirm core path with backend team
        case .addChild:
            return "/child/add" // TODO: confirm core path with backend team
        // MARK: - App Blocking & Content Filters
        case .installedApps(let childId):
            return "/dashboard/installed-apps/\(childId)" // TODO: confirm core path with backend team
        case .setAppBlocked(let childId, let appId, _):
            return "/dashboard/installed-apps/\(childId)/\(appId)" // TODO: confirm core path with backend team
        case .contentFilters(let childId):
            return "/dashboard/settings/ios/contentfilters/apps/\(childId)" // TODO: confirm core path with backend team
        case .updateContentFilters:
            return "/controls/content-filters" // TODO: confirm core path with backend team
        }
    }

    var method: HTTPVerb {
        switch self {
        case .login,
             .forgotPassword,
             .verifyEmail,
             .tokenRefresh,
             .validateReceipt,
             .logout,
             .changePassword,
             .coParentInvite,
             .removeCoParent,
             .pairingQRCode,
             .addChild:
            return .post
        case .updateProfile,
             .updateDailyLimit,
             .updatePlace,
             .setAppBlocked,
             .updateContentFilters:
            return .put
        case .deleteChild,
             .deleteScreenTimeRule,
             .deletePlace:
            return .delete
        case .createScreenTimeRule,
             .createPlace:
            return .post
        case .updateScreenTimeRule:
            return .patch
        case .dashboard,
             .dashboardCore2,
             .summaryData,
             .subscriptionProducts,
             .subscriptionCancelled,
             .notifications,
             .notificationFeed,
             .accountInfo,
             .generateQRCode,
             .coParentList,
             .dailyLimit,
             .screenTimeRules,
             .familyMap,
             .locationDates,
             .locationHistory,
             .places,
             .placeHistory,
             .webHistory,
             .webSearch,
             .youtubeHistory,
             .tikTokHistory,
             .socialMonitoring,
             .pairingStatus,
             .installedApps,
             .contentFilters:
            return .get
        }
    }

    var headers: [String: String]? {
        // Auth header is injected by `urlRequest(authToken:)`; no per-endpoint headers needed.
        return nil
    }

    var queryParameters: [String: String]? {
        switch self {
        case .verifyEmail(let params):
            return params
        // TODO confirm childId is a query parameter (audit-derived).
        case .locationHistory(let childId, _),
             .places(let childId):
            return ["child_id": childId]
        // TODO confirm reports pass childId/date/page as query parameters (audit-derived).
        case .webHistory(let childId, let date, let page),
             .webSearch(let childId, let date, let page),
             .youtubeHistory(let childId, let date, let page),
             .tikTokHistory(let childId, let date, let page):
            return ["child_id": childId, "date": date, "page": String(page)]
        case .socialMonitoring(let childId, let date, let appPackage, let page):
            return ["child_id": childId, "date": date, "app_package": appPackage, "page": String(page)]
        default:
            return nil
        }
    }

    var body: (any Encodable)? {
        switch self {
        case .login(let email, let password):
            return LoginBody(email: email, password: password)
        case .forgotPassword(let email):
            return ForgotPasswordBody(email: email)
        case .validateReceipt(let receiptData):
            return ValidateReceiptBody(receiptData: receiptData)
        case .updateProfile(let params):
            return params
        case .updateDailyLimit(_, let body):
            return body
        case .createScreenTimeRule(_, let body),
             .updateScreenTimeRule(_, _, let body):
            return body
        case .createPlace(_, let body),
             .updatePlace(_, _, let body):
            return body
        case .changePassword(let currentPassword, let newPassword):
            return ChangePasswordBody(currentPassword: currentPassword, newPassword: newPassword)
        case .coParentInvite(let email, let name):
            return CoParentInviteBody(email: email, name: name)
        case .removeCoParent(let coParentId):
            // Legacy uses POST + _method=DELETE hack.
            // TODO confirm whether backend now accepts a real DELETE.
            return CoParentRemoveBody(coParentUserId: coParentId, method: "DELETE")
        case .pairingQRCode(let childId):
            return QRRequestBody(childId: childId)
        case .addChild(let body):
            return body
        case .setAppBlocked(_, _, let body):
            return body
        case .updateContentFilters(let body):
            return body
        case .verifyEmail,
             .tokenRefresh,
             .logout,
             .dashboard,
             .dashboardCore2,
             .summaryData,
             .subscriptionProducts,
             .subscriptionCancelled,
             .notifications,
             .notificationFeed,
             .accountInfo,
             .deleteChild,
             .generateQRCode,
             .coParentList,
             .dailyLimit,
             .screenTimeRules,
             .deleteScreenTimeRule,
             .familyMap,
             .locationDates,
             .locationHistory,
             .places,
             .placeHistory,
             .deletePlace,
             .webHistory,
             .webSearch,
             .youtubeHistory,
             .tikTokHistory,
             .socialMonitoring,
             .pairingStatus,
             .installedApps,
             .contentFilters:
            return nil
        }
    }
}

// MARK: - Request bodies

private struct LoginBody: Encodable {
    let email: String
    let password: String
}

private struct ForgotPasswordBody: Encodable {
    let email: String
}

private struct ValidateReceiptBody: Encodable {
    let receiptData: String
}

// MARK: - Settings & Account request bodies
// TODO confirm payload with backend (derived from a code audit, not backend docs).
// Non-private because they are associated values of the public `FamilyTimeEndpoint` enum.

struct ChangePasswordBody: Encodable {
    let currentPassword: String
    let newPassword: String

    enum CodingKeys: String, CodingKey {
        case currentPassword = "current_password"
        case newPassword = "new_password"
    }
}

struct CoParentInviteBody: Encodable {
    let email: String
    let name: String
}

struct CoParentRemoveBody: Encodable {
    let coParentUserId: String
    /// Legacy POST + `_method=DELETE` override hack.
    let method: String

    enum CodingKeys: String, CodingKey {
        case coParentUserId = "co_parent_user_id"
        case method = "_method"
    }
}

// MARK: - Screen Time request bodies
// TODO confirm payload with backend (derived from a code audit, not backend docs).

struct DailyLimitUpdate: Encodable {
    let duration: Int
    let autoAdd: Bool
    let isActive: Bool
    let remaining: Int
    let remainingLimit: Int

    enum CodingKeys: String, CodingKey {
        case duration
        case autoAdd = "auto_add"
        case isActive = "is_active"
        case remaining
        case remainingLimit = "remaining_limit"
    }
}

struct ScreenTimeRuleBody: Encodable {
    let ruleName: String
    let timeStart: String
    let timeEnd: String
    let isMon: Bool
    let isTue: Bool
    let isWed: Bool
    let isThu: Bool
    let isFri: Bool
    let isSat: Bool
    let isSun: Bool
    let isActive: Bool

    enum CodingKeys: String, CodingKey {
        case ruleName = "rule_name"
        case timeStart = "time_start"
        case timeEnd = "time_end"
        case isMon = "is_mon"
        case isTue = "is_tue"
        case isWed = "is_wed"
        case isThu = "is_thu"
        case isFri = "is_fri"
        case isSat = "is_sat"
        case isSun = "is_sun"
        case isActive = "is_active"
    }
}

// MARK: - Location request bodies
// TODO confirm payload with backend (derived from a code audit, not backend docs).

/// Request body for creating/updating a saved place (geofence).
/// The legacy API expects all numeric fields as strings. Non-private because it
/// is an associated value of the public `FamilyTimeEndpoint` enum.
struct PlaceBody: Encodable {
    let location: String
    let latitude: String
    let longitude: String
    let radius: String
    let checkinAlert: String

    enum CodingKeys: String, CodingKey {
        case location
        case latitude
        case longitude
        case radius
        case checkinAlert = "checkin_alert"
    }
}

// MARK: - Onboarding & Pairing request bodies
// TODO confirm payload with backend (derived from a code audit, not backend docs).
// Non-private because they are associated values of the public `FamilyTimeEndpoint` enum.

/// Request body for the legacy core2 QR generation endpoint.
struct QRRequestBody: Encodable {
    let childId: String

    enum CodingKeys: String, CodingKey {
        case childId = "child_id"
    }
}

/// Request body for creating a child profile.
struct ChildCreateBody: Encodable {
    let name: String
    /// "ios" | "android"
    let platform: String
    let relationship: String?
    let gender: String?
    let age: String?
}

// MARK: - App Blocking & Content Filters request bodies
// TODO confirm payload with backend (derived from a code audit, not backend docs).

/// Request body for blocking/unblocking an installed app.
struct AppBlockBody: Encodable {
    /// 1 = blocked, 0 = unblocked.
    let isBlacklisted: Int

    enum CodingKeys: String, CodingKey {
        case isBlacklisted = "is_blacklisted"
    }
}

/// Request body for updating iOS content filters (MDM payload).
struct ContentFilterBody: Encodable {
    let id: Int
    let childId: String
    let mdmPayload: String

    enum CodingKeys: String, CodingKey {
        case id
        case childId = "child_id"
        case mdmPayload = "mdm_payload"
    }
}
