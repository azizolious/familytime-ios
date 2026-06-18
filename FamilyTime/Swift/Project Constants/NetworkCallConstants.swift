//
//  NetworkCallConstants.swift
//  FamilyTime
//
//  Created by Usama-Apps on 28/10/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation

class NetworkCallConstants {
    //MARK: - Header
    class Header: NetworkCallConstants {
        static let ACCEPT                   = "Accept"
        static let APPLICATION_JSON         = "application/json"
        static let CONTENT_TYPE             = "Content-Type"
        static let APP_BUILD                = "app-build"
        static let APP_VERSION              = "app-version"
        static let AUTHORIZATION            = "Authorization"
        static let BEARER                   = "Bearer "
        static let LANG                     = "language"
        static let OS                       = "os"
        static let OS_VERSIO                = "os-version"
        static let LANGUAGE                 = "language"
    }
    //MARK: - Parameters
    class Parameters: NetworkCallConstants {
        static let EMAIL                    = "email"
        static let PASSWORD                 = "password"
        static let AGENT                    = "agent"
        static let PUSH_TOKEN               = "push_token"
        static let DEVICE_TIME_ZONE         = "device_timezone"
        static let APP_VERSION              = "app_version"
        static let APP_BUILD                = "app_build"
        static let DEVICE_LANGUAGE          = "device_language"
        static let WIFI_NAME                = "wifi_name"
        static let DEVICE_MODEL             = "device_model"
        static let DEVICE_NAME              = "device_name"
        static let DEVICE_OS                = "device_os"
        static let UNIQUE_DEVICE_ID         = "unique_device_id"
        static let LATITUDE                 = "latitude"
        static let LONGITUDE                = "longitude"
        static let SIGNAL_STRENGHT          = "signal_strength"
        static let BATTERY_REMAINING        = "battery_remaining"
        static let ACCURACY                 = "accuracy"
        static let ADDRESS                  = "address"
        static let DEVICE_IMEI              = "device_imei"
        static let PROVIDER_NAME            = "provider_name"
        static let TOKEN                    = "token"
        static let IOS                      = "ios"
        static let GOOGLE                   = "google"
        static let APPLE                    = "apple"
        static let COUNTRY_CODE             = "country_code"
        static let DEVICE                   = "device"
        static let IPHONE                   = "iphone"
        static let HASH                     = "hash"
        static let SIGNUP_CHANNEL           = "signup_channel"
        static let DEVICE_MANUFACTURER      = "device_manufacturer"
        static let DEVICE_UNIQUE_IDENTITY   = "device_unique_identity"
        static let FILTER_NAME              = "filter_name"
        static let FILTER_VALUE             = "filter_value"
    }
}
