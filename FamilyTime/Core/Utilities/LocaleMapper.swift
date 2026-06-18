import Foundation

/// Maps iOS locale identifiers to the backend's locale codes.
///
/// iOS uses the modern ISO code `he` for Hebrew, but the backend DB still uses
/// the legacy code `iw`. Send `backendCode(for:)` when transmitting a language
/// preference to the API; use the iOS code everywhere else.
struct LocaleMapper {
    static func backendCode(for iOSLocale: String) -> String {
        switch iOSLocale {
        case "he": return "iw"  // Hebrew: iOS uses "he", backend DB uses "iw"
        default: return iOSLocale
        }
    }
}
