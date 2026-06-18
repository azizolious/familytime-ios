//
//  String+Validation.swift
//  FamilyTime
//
//  Phase 2 — Swift-native input validation, replacing the legacy
//  `CommonModel.isValidEmail(_:)` Objective-C helper used by
//  `LoginViewController`.
//

import Foundation

extension String {

    /// `true` when the receiver is a syntactically valid email address.
    ///
    /// Uses an `NSPredicate` with a standard RFC-ish pattern — matching the
    /// behaviour of the legacy `CommonModel.isValidEmail(_:)` check so login
    /// validation stays consistent across the migration.
    var isValidEmail: Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
}
