//
//  FIRAppCheck.swift
//  FamilyTime
//
//  Created by Sufyan on 08/08/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAppCheck
@available(iOS 14.0, *)
class YourSimpleAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    @available(iOS 14.0, *)
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    return AppAttestProvider(app: app)
  }
}
class YourAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    if #available(iOS 14.0, *) {
      return AppAttestProvider(app: app)
    } else {
      return DeviceCheckProvider(app: app)
    }
  }
}
