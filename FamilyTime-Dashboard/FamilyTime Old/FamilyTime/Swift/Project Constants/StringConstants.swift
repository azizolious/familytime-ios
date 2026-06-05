//
//  StringConstants.swift
//  FamilyTime
//
//  Created by Usama-Apps on 09/09/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation

class StringConstants {
    
    //MARK: - Error And Messages 
    class Errors: StringConstants {
        static let FETCHING_DATA_FAILED                     = "Fetch Failed because of: "
        static let SAVING_DATA_FAILED                       = "Saving Core Data Failed because of: "
        static let SOMETHING_WENT_WRONG                     = "Something went wrong!"
        static let DO_NOTHING                               = "Do nothing for this..."
        static let CORE2_TOKEN_NOT_FOUND                    = "New Core2 Token is not found due to"
        static let APP_CONFIG_NOT_FOUND                     = "App Configurations are not found due to error  "
        static let RESPONSE_NIL_WITH_MESSAGE                = "Response nil with message ->"
        static let QR_CODE_STRING_NOT_FOUND                 = "QR Code String is not found because of error "
    }
    
    //MARK: - Controller Strings
    class Constants: StringConstants {
        static let DISCLAIMER_DISCRIPTION                   = "Disclaimer: As required by Apple policy, we do not share any personally identifiable data collected by our service with any third parties for any reason."
        static let DISCLAIMER                               = "Disclaimer:"
        static let SHOPPING_FUNNEL                          = "shopping_funnel"
        static let ACTIVATION_FUNNEL                        = "activation_funnel"
        static let UPGRADE_SUB_INTERNAL                     = "upgrade_sub_int"
        static let UPDRADE_SUB_EXTERNAL                     = "upgrade_sub_ext"
        static let FAST_SPRING_TRIAL_EXT                    = "trial_sub_ext"
        static let APPLE_TRIAL_INT                          = "trial_sub_int"
        static let NIL_VALUE                                = "nil"
        static let INTERNAL                                 = "internal"
        static let EXTERNAL                                 = "external"
        static let TOKEN_ALREADY_EXIST                      = "Token already exists..."
        static let RESEST_PASSWORD_LABEL                    = "Having trouble signing in? Reset Password."
        static let RESET_PASSWORD                           = "Reset Password"
        static let TERMS_AND_CONDITION_DETAILS              = "By continuing, You are agree to our Terms and Conditions and PrivacyPolicy."
        static let TERMS_AND_CONDITIONS                     = "Terms and Conditions"
        static let PRIVACY_POLICY                           = "PrivacyPolicy"
        static let INSTRUCTIONS_CELL_SETP_1                 = "Step1:\nOpen get.familytime.io in browser, on kid's device."
        static let QR_CELL_STEP_1_DETAILS                   = "Open get.familytime.io in the browser on child's device, and install FamilyTime Jr."
        static let QR_CELL_STEP_2_DETAILS                   = "Open FamilyTime Jr. App and scan the QR code shown here."
        static let QR_CELL_STEP_3_DETAILS                   = "Follow the in-app instructions on child’s device to complete the setup."
        static let YES_I_HAVE_DONE_IT                       = "Yes, I have done it"
        static let VIEW_DETAILED_GUIDE                      = "view_Detailed_Guide_title".localized
        static let FAMILY_TIME_TRIAL                        = "FamilyTime Trial"
        static let FATHER                                   = "Father"
        static let MOTHER                                   = "Mother"
        static let MALE                                     = "male"
        static let EMPTY_STRING                             = ""
        static let EMAILS_ARE_MARKED_AS_SPAM                = "FamilyTime’s emails are marked as spam."
        static let UNMARK_SPAM                              = "Unmark Spam"
        static let FIX_NOW                                  = "fix_now".localized
        static let EMAILS_ARE_NOT_DELIVERED                 = "Emails are not delivered to your mailbox."
        static let NOT_DELIVERED                            = "Emails Not Delivered"
        static let EMAIL_ADDRESS_NOT_VERIFIED               = "your_email_address_is_not_verified_yet".localized
        static let CHANGE_EMAIL                             = "change_now".localized
        static let VERIFIY_EMAIL                            = "verify_now".localized
        static let EMAIL_MISSING                            = "email_missing".localized
        static let YOU_HAVE_NOT_ADDED_EMAIL                 = "You haven't added your email address."
        static let VERIFY_YOUR_EMAIL                        = "verify_your_email".localized
        static let VERIFICATION_EMAIL_IS_SENT               = "email_verification_sent".localized
        static let CHANGES_ARE_SENT                         = "Changes have been saved successfully"
        static let DRAWER                                   = "Drawer"
        static let DASHBOARD                                = "dashboard"
        static let FAST_SPRING                              = "fs"
        static let PADDLE                                   = "paddle"
        static let SUBSCRIPTION                             = "SUBSCRIPTION"
        static let SUBSCRIPTION_CANCELLED                   = "You have cancelled your subscription, please update your package so you can enjoy all the premium features."
        static let IOS                                      = "ios"
        static let PAUSED                                   = "PAUSED"
        static let UNLOCKED                                 = "UNLOCKED"
    }
    
    //MARK: - Data Keys
    class ResponseKeys: StringConstants {
        static let CHILDREN                                 = "children"
        static let LANGUAGE                                 = "language"
        static let PACKAGE                                  = "package"
        static let ID                                       = "id"
        static let NAME                                     = "name"
        static let EMAIL                                    = "email"
        static let PHONE                                    = "phone"
        static let GENDER                                   = "gender"
        static let TYPE                                     = "type"
        static let TOKEN                                    = "token"
        static let PASSPORT_TOKEN                           = "passport_token"
        static let MESSAGE                                  = "message"
        static let ACTIVATION_FUNNEL                        = "activation_funnel"
        static let QR_CODE                                  = "qr_code"
        static let DATA                                     = "data"
        static let STATUS                                   = "status"
        static let VALUE                                    = "value"
        static let LIST                                     = "list"
        static let HASH                                     = "hash"
        static let USER                                     = "user"
        static let APP_CONGIG                               = "app_config"
        static let IS_NEW                                   = "is_new"
        static let CHILD_COUNT                              = "child_count"
        static let DURAITON                                 = "duration"
        static let RADAIN                                   = "radian"
        static let REMAINING                                = "remaining"
        static let AUTO_ADD                                 = "auto_add"
        static let IS_ACTIVE                                = "is_active"
        static let APPS                                     = "apps"
        static let INSTALLED_APP_ID                         = "installedapp_id"
        static let APP_NAME                                 = "app_name"
        static let APP_PACKAGE_NAME                         = "app_package_name"
        static let APP_CATEGORY                             = "app_category"
        static let IN_DAILY_LIMITS                          = "in_daily_limit"
        static let FEED_DATA                                = "feed_data"
        static let ENCODED_URL                              = "encoded_url"
        static let FREQUENCY                                = "frequency"
        static let ACTION_TEXT                              = "action_text"
        static let BILLING_STATUS                           = "billing_status"
        static let CARD_COLOR                               = "card_color"
        static let CUSTOMER_CRITERIA                        = "customer_criteria"
        static let END_DATE                                 = "end_date"
        static let SORT_ORDER                               = "sort_order"
        static let FEED_SNIPPET                             = "feed_snippet"
        static let FEED_SNIPPET_COLOR                       = "feed_snippet_color"
        static let IMAGE_URL                                = "image_url"
        static let LANG                                     = "lang"
        static let LIMIT                                    = "limit"
        static let NOTIFICATION_TYPE                        = "notification_type"
        static let PLATFORM_ID                              = "platform_id"
        static let READ_MORE_COLOR                          = "read_more_color"
        static let START_DATE                               = "start_date"
        static let TIME_COLOR                               = "time_color"
        static let TITLE                                    = "title"
        static let TITLE_COLOR                              = "title_color"
        static let GOOGLE_IN_APP_SUB_ID                     = "google_in_app_sub_id"
        static let APPLE_IN_APP_SUB_ID                      = "apple_in_app_sub_id"
        static let FS_SUB_URL                               = "fs_sub_url"
        static let PADDLE_SUB_URL                           = "paddle_sub_url"
        static let DASHBOARD_SUB_URL                        = "dashboard_sub_url"
        static let WEB_CTA                                  = "web_cta"
    }
    
    //MARK: - Translations
    class Translation: StoryboardConstants {
        static let LOGIN_TO_YOUR_EXISTING_ACCOUNT           = "LOGIN_TO_YOUR_EXISTING_ACCOUNT".localized
        static let BY_CONTINUING_YOU_ARE_AGREE              = "BY_CONTINUING_YOU_ARE_AGREE".localized
        static let PRIVACY_POLICY                           = "PRIVACY_POLICY".localized
        static let AND                                      = "AND".localized
        static let TERMS_AND_CONDITIONS                     = "TERMS_AND_CONDITIONS".localized
        static let RESET_PASSWORD                           = "RESET_PASSWORD".localized
        static let HAVING_TROUBLE_IN_SIGN_IN                = "HAVING_TROUBLE_IN_SIGN_IN".localized
    }
    
    //MARK: - Subscriptions
    class Subscriptions : StringConstants {
        static let PREMIUM_CAPITAL                          = "PREMIUM"
        static let PREMIUM_SMALL                            = "premium"
        static let FREE_CAPITAL                             = "FREE"
        static let FREE_SMALL                               = "free"
        static let TRIAL_CAPITAL                            = "TRIAL"
        static let TRIAL_SMALL                              = "trial"
    }
}
