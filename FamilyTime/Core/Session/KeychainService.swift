//
//  KeychainService.swift
//  FamilyTime
//
//  A thin, dependency-free wrapper around the system Keychain (Security
//  framework) used to persist sensitive session material — namely the auth
//  and core tokens consumed by `SessionManager`.
//
//  Design notes:
//  - Implemented as a stateless `enum` with static members: there is nothing
//    to instantiate, and the namespace prevents accidental construction.
//  - Items are scoped to a single service identifier and addressed by an
//    arbitrary string key (the account).
//  - Stored items use `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`, so
//    values are readable after the first unlock following a boot and never
//    leave the device via backups.
//  - No UIKit, no third-party dependencies, no force-unwraps.
//

import Foundation
import Security

/// Namespaced, stateless access to the system Keychain for generic-password
/// items scoped to FamilyTime.
enum KeychainService {

    /// Service identifier that scopes every Keychain item managed here.
    private static let service = "io.familytime.dashboard"

    /// Accessibility class applied to stored items. Values become available
    /// after the first device unlock following a restart and are excluded from
    /// device backups.
    private static let accessible = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

    /// Stores (inserting or replacing) a UTF-8 string value for the given key.
    ///
    /// Existing items are updated in place; otherwise a new item is added.
    ///
    /// - Parameters:
    ///   - key: Account key that addresses the item within the service.
    ///   - value: String value to persist. Must be UTF-8 encodable.
    /// - Returns: `true` when the value was written, `false` otherwise.
    @discardableResult
    static func save(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: accessible
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecSuccess { return true }

        if status == errSecItemNotFound {
            var add = query
            add[kSecValueData as String] = data
            add[kSecAttrAccessible as String] = accessible
            return SecItemAdd(add as CFDictionary, nil) == errSecSuccess
        }

        return false
    }

    /// Loads the UTF-8 string value previously stored for the given key.
    ///
    /// - Parameter key: Account key that addresses the item within the service.
    /// - Returns: The decoded string, or `nil` if no item exists or the stored
    ///   data is not valid UTF-8.
    static func load(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data,
              let value = String(data: data, encoding: .utf8) else { return nil }

        return value
    }

    /// Removes the item stored for the given key, if present.
    ///
    /// - Parameter key: Account key that addresses the item within the service.
    /// - Returns: `true` when the item was deleted or did not exist, `false`
    ///   when deletion failed for another reason.
    @discardableResult
    static func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
