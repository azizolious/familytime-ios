//
//  HLApiManager.swift
//  FamilyTime
//
//  Created by Sana-Ullah-IOS on 11/03/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//  Modified by Usama-Apps in 2022.

import Foundation
import MBProgressHUD
import Alamofire
import SwiftUI
import UIKit

class HLApiManager {
        
    //  MARK: - Variables
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    //  MARK: - Authentication APIs
    static func loginUser(email: String, password: String, view: UIView?, completion: @escaping((_ response: UserProfile?, _ childs: Int, _ status: Int, _ message: String) -> ())) {
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let timeZone    = NSTimeZone.local as NSTimeZone
        let tzName      = timeZone.name
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build       = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let deviceToken  = UserDefaults.standard.string(forKey: kDeviceToken)
        print("token = \(deviceToken ?? "")")
        let params = [NetworkCallConstants.Parameters.EMAIL                         : email,
                      NetworkCallConstants.Parameters.PASSWORD                      : password,
                      NetworkCallConstants.Parameters.DEVICE                        : "iphone",
                      NetworkCallConstants.Parameters.HASH                          : UserDefaultsManager.LaunchAppHash ?? "",
                      NetworkCallConstants.Parameters.COUNTRY_CODE                  : (Locale.current.regionCode ?? ""),
                      NetworkCallConstants.Parameters.PUSH_TOKEN                    : UserDefaultsManager.deviceToken ?? "",
                      NetworkCallConstants.Parameters.SIGNUP_CHANNEL                : "email",
                      NetworkCallConstants.Parameters.ACCURACY                      : "",
                      NetworkCallConstants.Parameters.ADDRESS                       : "",
                      NetworkCallConstants.Parameters.APP_BUILD                     : build,
                      NetworkCallConstants.Parameters.APP_VERSION                   : appVersion ?? "",
                      NetworkCallConstants.Parameters.BATTERY_REMAINING             : "",
                      NetworkCallConstants.Parameters.DEVICE_IMEI                   : "",
                      NetworkCallConstants.Parameters.DEVICE_LANGUAGE               : language,
                      NetworkCallConstants.Parameters.DEVICE_MANUFACTURER           : "Apple",
                      NetworkCallConstants.Parameters.DEVICE_MODEL                  : UIDevice.modelName, //UIDevice.current.model,
                      NetworkCallConstants.Parameters.DEVICE_NAME                   : UIDevice.current.name,
                      NetworkCallConstants.Parameters.DEVICE_OS                     : UIDevice.current.systemVersion,
                      NetworkCallConstants.Parameters.DEVICE_TIME_ZONE              : tzName,
                      NetworkCallConstants.Parameters.LATITUDE                      : "0.0",
                      NetworkCallConstants.Parameters.LONGITUDE                     : "0.0",
                      NetworkCallConstants.Parameters.SIGNAL_STRENGHT               : "",
                      NetworkCallConstants.Parameters.WIFI_NAME                     : SwiftCommonUtility.shared.getWiFiSsid() ?? "",
                      NetworkCallConstants.Parameters.UNIQUE_DEVICE_ID              : "" ] as [String:Any]
        
        let url = HLConstants.URLs.AUTH.SignUp_SignIn
        print("\(url) -> params: \(params)")
        loaderVisibility(view: view, message: "Authenticating...")
        AuthenticationService.shared()?.nativePost_api(withParamsLaunch: params, andUrl: url, success: { (response) in
            loaderVisibility(view: view, show: false)
            guard let json = response as? [String:Any] else {
                completion(nil, 0, 0, "Data is nill -> \(url)")
                return
            }
            print(json)
            let message = json[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
            guard let success = json[StringConstants.ResponseKeys.DATA] as? [String:Any] else {
                guard (json[StringConstants.ResponseKeys.STATUS] as? Bool) != nil else {
                    completion(nil, 0, 0, message)
                    return
                }
                completion(nil, 0, 200, message)
                return
            }
            if let token = success[StringConstants.ResponseKeys.TOKEN] as? String {
                UserDefaultsManager.LoginApiToken = token
            }
            guard let userJson = success[StringConstants.ResponseKeys.USER] as? [String:Any] else {
                completion(nil, 0, 0, message)
                return
            }
            guard let app_config = success[StringConstants.ResponseKeys.APP_CONGIG] as? [String:Any] else {
                completion(nil, 0, 0, message)
                return
            }
            //MARK: RIZWAN
            if let activationFunnel = app_config[StringConstants.ResponseKeys.ACTIVATION_FUNNEL] as? Int {
//                UserDefaultsManager.AddChildWithQRScan = (activationFunnel == 1)
                UserDefaultsManager.AddChildWithQRScan = (activationFunnel == 1)
            } else {
                UserDefaultsManager.AddChildWithQRScan = false
            }
            let user = UserProfile(userJson)
            if let isNew = json[StringConstants.ResponseKeys.IS_NEW] as? String, isNew == "1" {
                completion(user, 0, 200, message)
            }
            else if let childs = success[StringConstants.ResponseKeys.CHILD_COUNT] as? Int {
                completion(user, childs, 200, message)
            }
        }, failure: { (error, statusCode) in
            loaderVisibility(view: view, show: false)
            let message = error ?? "\(statusCode)"
            print(message)
            completion(nil, 0, 0,message)
        })
    }
    
    //MARK: -  Verify User Method
    static func verifyUser(email:String, view: UIView?, completion: @escaping((_ response: UserProfile?, _ childs: Int, _ status: Int, _ message: String) -> ())) {
        //        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        //        let timeZone    = NSTimeZone.local as NSTimeZone
        //        let tzName      = timeZone.name
        //        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        //        let build       = Bundle.main.infoDictionary!["CFBundleVersion"]!
        
        let deviceToken  = UserDefaults.standard.string(forKey: kDeviceToken)
        print("token = \(deviceToken ?? "")")
        let params = [NetworkCallConstants.Parameters.HASH      : UserDefaultsManager.LaunchAppHash ?? "",
                      NetworkCallConstants.Parameters.EMAIL     : email] as [String:Any]
        let url = HLConstants.URLs.AUTH.verifyUserURL
        print("\(url) -> params: \(params)")
        loaderVisibility(view: view, message: "Authenticating...")
        AuthenticationService.shared()?.nativePost_api(withParamsLaunch: params, andUrl: url, success: { (response) in
            loaderVisibility(view: view, show: false)
            guard let json = response as? [String:Any] else {
                completion(nil, 0, 0, "Data is nill -> \(url)")
                return
            }
            print(json)
            let message = json[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
            guard let success = json[StringConstants.ResponseKeys.DATA] as? [String:Any] else {
                guard (json[StringConstants.ResponseKeys.STATUS] as? Int) != nil else {
                    completion(nil, 0, 0, message)
                    return
                }
                completion(nil, 0, json[StringConstants.ResponseKeys.STATUS] as? Int ?? 200, message)
                return
            }
            if let token = success[StringConstants.ResponseKeys.TOKEN] as? String {
                UserDefaultsManager.LoginApiToken = token
            }
            guard let userJson = success[StringConstants.ResponseKeys.USER] as? [String:Any] else {
                completion(nil, 0, 200, message)
                return
            }



            
            guard let app_config = success[StringConstants.ResponseKeys.APP_CONGIG] as? [String:Any] else {
                completion(nil, 0, 0, message)
                return
            }
            //MARK: RIZWAN
            if let activationFunnel = app_config[StringConstants.ResponseKeys.ACTIVATION_FUNNEL] as? Int {
                UserDefaultsManager.AddChildWithQRScan = (activationFunnel == 1)
            } else {
                UserDefaultsManager.AddChildWithQRScan = false
            }
            
            let user = UserProfile(userJson)
            if let isNew = json[StringConstants.ResponseKeys.IS_NEW] as? String, isNew == "1" {
                completion(user, 0, 200, message)
            }
            else if let childs = success[StringConstants.ResponseKeys.CHILD_COUNT] as? Int {
                completion(user, childs, 200, message)
            }
        }, failure: { (error, statusCode) in
            loaderVisibility(view: view, show: false)
            let message = error ?? "\(statusCode)"
            print(message)
            completion(nil, 0, 0,message)
        })
    }
    
    
    static func loginWithVerifiedEmail(name: String, email: String, password: String, signInType: String, view: UIView?, completion: @escaping((_ response: UserProfile?, _ childs: Int, _ status: Int, _ message: String) -> ())) {
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let timeZone    = NSTimeZone.local as NSTimeZone
        let tzName      = timeZone.name
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build       = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let deviceToken  = UserDefaults.standard.string(forKey: kDeviceToken)
        print("token = \(deviceToken ?? "")")
        let params = ["name" : name,
                      "email" : email,
                      "password" : password,
                      "device":"iphone",
                      "hash" : UserDefaultsManager.LaunchAppHash ?? "",
                      //"hash" : "6bea4a2fca7ab22c5ee8d8c234a40434",
                      "country_code" : (Locale.current.regionCode ?? ""),
                      "signup_channel" : signInType,
                      "accuracy"            : "",
                      "address"             :"",
                      "app_build"           : build,
                      "app_version"         : appVersion ?? "",
                      "battery_remaining"   : "",
                      "device_imei"         : "",
                      "device_language"     : language,
                      "device_manufacturer" : "Apple",
                      "device_model"        : UIDevice.modelName, //UIDevice.current.model,
                      "device_name"         : UIDevice.current.name,
                      "device_os"           : UIDevice.current.systemVersion,
                      "device_timezone"     : tzName,
                      "latitude"            : "0.0",
                      "longitude"           : "0.0",
                      "signal_strength"     : "",
                      "wifi_name"           : SwiftCommonUtility.shared.getWiFiSsid() ?? "",
                      "device_unique_identity" : "",
                      "push_token": deviceToken ?? "",
        ] as [String:Any]
        
        print(params)
        let url = HLConstants.URLs.AUTH.auth
        print("\(url) -> params: \(params)")
        loaderVisibility(view: view, message: "Authenticating...")
        AuthenticationService.shared()?.nativePost_api(withParamsLaunch: params, andUrl: url, success: { (response) in
            loaderVisibility(view: view, show: false)
            guard let json = response as? [String:Any] else {
                completion(nil, 0, 0, "Data is nill -> \(url)")
                return
            }
            print(json)
            let message = json[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
            guard let success = json[StringConstants.ResponseKeys.DATA] as? [String:Any] else {
                completion(nil, 0, 0, message)
                return
            }
            if let token = success[StringConstants.ResponseKeys.TOKEN] as? String {
                UserDefaultsManager.LoginApiToken = token
            }
            guard let userJson = success[StringConstants.ResponseKeys.USER] as? [String:Any] else {
                completion(nil, 0, 0, message)
                return
            }
            guard let app_config = success[StringConstants.ResponseKeys.APP_CONGIG] as? [String:Any] else {
                completion(nil, 0, 0, message)
                return
            }
            if let activationFunnel = app_config[StringConstants.ResponseKeys.APP_CONGIG] as? Int {
                UserDefaultsManager.AddChildWithQRScan = (activationFunnel == 1)
            } else {
                UserDefaultsManager.AddChildWithQRScan = false
            }
            let user = UserProfile(userJson)
            if let isNew = json[StringConstants.ResponseKeys.IS_NEW] as? String, isNew == "1" {
                completion(user, 0, 200, message)
            }
            else if let childs = success[StringConstants.ResponseKeys.CHILD_COUNT] as? Int {
                completion(user, childs, 200, message)
            }
        }, failure: { (error, statusCode) in
            loaderVisibility(view: view, show: false)
            let message = error ?? "\(statusCode)"
            print(message)
            completion(nil, 0, 0,message)
        })
    }
    
    static func forgotPassword(email: String, view: UIView?, completion: @escaping((_ response: Bool, _ message: String, _ status: Int) -> ())) {
        let params = [NetworkCallConstants.Parameters.EMAIL : email] as [String:Any]
        let url = HLConstants.URLs.AUTH.Forgot_Password
        print("\(url) -> params: \(params)")
        loaderVisibility(view: view)
        AuthenticationService.shared()?.nativePost_api(withParams: params, andUrl: url, success: { (response) in
            loaderVisibility(view: view, show: false)
            
            guard let json = response as? [String:Any] else {
                print("Response nil -> \(url)")
                return
            }
            let message = (json[StringConstants.ResponseKeys.MESSAGE] as? String) ?? ""
            let status = (json[StringConstants.ResponseKeys.STATUS] as? Int) ?? 0
            completion(true, message, status)
        }, failure: { (error, statusCode) in
            print(error ?? "\(statusCode)")
            completion(false, (error ?? "\(statusCode)"), 0)
        })
    }
    
    //  MARK: - Configuration APIs
    
    static func getFunnelConfigurationParams() {
        let params = [NetworkCallConstants.Parameters.DEVICE    : NetworkCallConstants.Parameters.IPHONE] as [String:Any]
        let url = HLConstants.URLs.FUNNEL.activation
        print(url)
        AuthenticationService.shared()?.nativePost_api(withParams: params, andUrl: url, success: { (response) in
            guard let json = response as? [String:Any] else {
                print("Response nil -> \(url)")
                return
            }
            guard let configuration = json[StringConstants.ResponseKeys.APP_CONGIG] as? [String:Any] else {
                return
            }
            if let activationFunnel = configuration[StringConstants.ResponseKeys.ACTIVATION_FUNNEL] as? Int {
                UserDefaultsManager.AddChildWithQRScan = (activationFunnel == 0)
            } else {
                UserDefaultsManager.AddChildWithQRScan = false
            }
        }, failure: { (error, statusCode) in
            print(error ?? "\(statusCode)")
        })
    }
    
    //  MARK: - Child Dashboard
    
//    static func getExplicitContentiTunesData(childID: String, view: UIView?, completion: @escaping((_ response: String?, _ message: String) -> ())) {
//        var url = HLConstants.URLs.Child.Settings.ContentFilters.ExplicitContents
//        url = url.replacingOccurrences(of: "{child_id}", with: childID)
//        print(url)
//        loaderVisibility(view: view)
//        ApiManager.shared().mesh2_getApi(withApi: url, sendHeader: true) { (response, statusCode, message) in
//            loaderVisibility(view: view, show: false)
//            guard let json = response as? [String:Any] else {
//                print(StringConstants.Errors.RESPONSE_NIL_WITH_MESSAGE + message)
//                return
//            }
//            print(json)
//            if let status = json[StringConstants.ResponseKeys.STATUS] as? Int, status == 200 {
//                if let data = json[StringConstants.ResponseKeys.STATUS] as? [String:Any], let value = data[StringConstants.ResponseKeys.VALUE] as? String {
//                    print(data,value)
//                    completion(value, message)
//                }
//            } else {
//                completion(nil, message)
//            }
//        }
//    }
    
//    static func getBookStoreEroticaData(childID: String, view: UIView?, completion: @escaping((_ response: String?, _ message: String) -> ())) {
//        var url = HLConstants.URLs.Child.Settings.ContentFilters.BookStoreErotica
//        url = url.replacingOccurrences(of: "{child_id}", with: childID)
//        print(url)
//        loaderVisibility(view: view)
//        ApiManager.shared().mesh2_getApi(withApi: url, sendHeader: true) { (response, statusCode, message) in
//            loaderVisibility(view: view, show: false)
//            guard let json = response as? [String:Any] else {
//                print(StringConstants.Errors.RESPONSE_NIL_WITH_MESSAGE + message)
//                return
//            }
//            print(json)
//            if let status = json[StringConstants.ResponseKeys.STATUS] as? Int, status == 200 {
//                if let data = json[StringConstants.ResponseKeys.DATA] as? [String:Any], let value = data[StringConstants.ResponseKeys.VALUE] as? String {
//                    completion(value, message)
//                }
//            } else {
//                completion(nil, message)
//            }
//        }
//    }
    
//    static func getContentFilterApps(childID: String, view: UIView?, completion: @escaping((_ response: [String]?, _ selected: String?, _ message: String) -> ())) {
//        var url = HLConstants.URLs.Child.Settings.ContentFilters.Apps
//        url = url.replacingOccurrences(of: "{child_id}", with: childID)
//        print(url)
//        loaderVisibility(view: view)
//        ApiManager.shared().mesh2_getApi(withApi: url, sendHeader: true) { (response, statusCode, message) in
//            loaderVisibility(view: view, show: false)
//            guard let json = response as? [String:Any] else {
//                print(StringConstants.Errors.RESPONSE_NIL_WITH_MESSAGE + message)
//                return
//            }
//            print(json)
//            if let status = json[StringConstants.ResponseKeys.STATUS] as? Int, status == 200 {
//                if let data = json[StringConstants.ResponseKeys.DATA] as? [String:Any] {
//                    let list = data[StringConstants.ResponseKeys.LIST] as? [String]
//                    let value = data[StringConstants.ResponseKeys.VALUE] as? String
//                    completion(list, value, message)
//                }
//            } else {
//                completion(nil, nil, message)
//            }
//        }
//    }
        
//    static func getContentFilterTvShows(childID: String, view: UIView?, completion: @escaping((_ response: [String]?, _ selected: String?, _ message: String) -> ())) {
//        var url = HLConstants.URLs.Child.Settings.ContentFilters.TVShows
//        url = url.replacingOccurrences(of: "{child_id}", with: childID)
//        print(url)
//        loaderVisibility(view: view)
//        ApiManager.shared().mesh2_getApi(withApi: url, sendHeader: true) { (response, statusCode, message) in
//            loaderVisibility(view: view, show: false)
//            guard let json = response as? [String:Any] else {
//                print(StringConstants.Errors.RESPONSE_NIL_WITH_MESSAGE + message)
//                return
//            }
//            print(json)
//            if let status = json[StringConstants.ResponseKeys.STATUS] as? Int, status == 200 {
//                if let data = json[StringConstants.ResponseKeys.DATA] as? [String:Any] {
//                    let list = data[StringConstants.ResponseKeys.LIST] as? [String]
//                    let value = data[StringConstants.ResponseKeys.VALUE] as? String
//                    completion(list, value, message)
//                }
//            } else {
//                completion(nil, nil, message)
//            }
//        }
//    }
    
    
//    static func getContentFilterMovies(childID: String, view: UIView?, completion: @escaping((_ response: [String]?, _ selected: String?, _ message: String) -> ())) {
//        var url = HLConstants.URLs.Child.Settings.ContentFilters.Movies
//        url = url.replacingOccurrences(of: "{child_id}", with: childID)
//        print(url)
//        loaderVisibility(view: view)
//        ApiManager.shared().mesh2_getApi(withApi: url, sendHeader: true) { (response, statusCode, message) in
//            loaderVisibility(view: view, show: false)
//            guard let json = response as? [String:Any] else {
//                print(StringConstants.Errors.RESPONSE_NIL_WITH_MESSAGE + message)
//                return
//            }
//            print(json)
//            if let status = json[StringConstants.ResponseKeys.STATUS] as? Int, status == 200 {
//                if let data = json[StringConstants.ResponseKeys.DATA] as? [String:Any] {
//                    let list = data[StringConstants.ResponseKeys.LIST] as? [String]
//                    let value = data[StringConstants.ResponseKeys.VALUE] as? String
//                    completion(list, value, message)
//                }
//            } else {
//                completion(nil, nil, message)
//            }
//        }
//    }
    
    
//    static func updateChildContentFilter(childID: String, key: String, value: String, view: UIView?, completion: @escaping((_ success: Bool, _ message: String) -> ())) {
//        let url = HLConstants.URLs.Child.Settings.ContentFilters.Root + childID
//        print(url)
//        let params = [ NetworkCallConstants.Parameters.FILTER_NAME              : key,
//                       NetworkCallConstants.Parameters.FILTER_VALUE             : value]
//        print(params)
//        loaderVisibility(view: view)
//        ApiManager.shared().putApi(url, params: params) { (message, status) in
//            loaderVisibility(view: view, show: false)
//            guard status == 200 || status != 0 else {
//                print(StringConstants.Errors.RESPONSE_NIL_WITH_MESSAGE + message)
//                completion(false, message)
//                return
//            }
//            completion(true, message)
//        }
//    }
    
    static func loadNotificationsApi(completion: @escaping((_ response: [String:Any]?, _ status: Int, _ message: String) -> ())) {
        let url = HLConstants.URLs.AUTH.notification_feeds
        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION            : NetworkCallConstants.Header.BEARER + (UserDefaultsManager.LoginApiToken ?? ""),
                                   NetworkCallConstants.Header.CONTENT_TYPE             : NetworkCallConstants.Header.APPLICATION_JSON,
                                   NetworkCallConstants.Header.CONTENT_TYPE             : NetworkCallConstants.Header.APPLICATION_JSON,
                                   NetworkCallConstants.Header.LANG                     : UserDefaults.standard.value(forKey: UserDefaultsConstants.USER_LANGUAGE) as? String ?? "en"]
        //print("\(url) -> params: \(headers)")
        AF.request(url, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        completion(dict,200, message)
                    }
                case 404, 429, 400:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        completion(nil, 404, message)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        completion(nil, 404, message)
                    }
                }
            case .failure(let error):
                print(error)
                completion(nil, 500, error.localizedDescription)
            }
        }
    }
    
//    static func hitDashboardApi2(view: UIView?, completion: @escaping((_ response: [String:Any]?, _ status: Bool, _ message: String) -> ())) {
//        let url = HLConstants.URLs.Child.Settings.ContentFilters.dashboardApi2
////        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION            : NetworkCallConstants.Header.BEARER + UserDefaultsManager.LoginApiToken!,
////                                   NetworkCallConstants.Header.CONTENT_TYPE             : NetworkCallConstants.Header.APPLICATION_JSON,
////                                   NetworkCallConstants.Header.LANG                     : UserDefaults.standard.value(forKey: UserDefaultsConstants.USER_LANGUAGE) as? String ?? "en"]
//        let headers = getHeader()
//        print("\(url) -> params: \(headers)")
//        AF.request(url, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//            print(response.result)
//            switch response.result
//            {
//            case .success(let json):
//                guard let dict = json as? [String:Any] else {
//                    return
//                }
//                print(json)
//                print(dict)
//                if let status = dict[StringConstants.ResponseKeys.STATUS] as? Bool{
//                    
//                    if(status == true){
//                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
//                        completion(dict,true, message)
//                    } else {
//                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
//                        completion(nil, false, message)
//                    }
//                }
//            case .failure(let error):
//                print(error)
//                completion(nil, false, error.localizedDescription)
//            }
//        }
//    }
    
    static func mesh_putApi(withParamString paramsStr: [String : Any]?, withApi url: String?, withResponse completion: @escaping (_ json: [AnyHashable : Any]?, _ errorCode: Int, _ message: String?) -> Void) {
        print("post api URL = \(url ?? "") and params = \(paramsStr ?? [:])")
        UserDefaults.standard.setValue(kNO, forKey: kSendHeaders)
        UserDefaults.standard.synchronize()
        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION            : NetworkCallConstants.Header.BEARER + UserDefaultsManager.LoginApiToken!,
                                   NetworkCallConstants.Header.CONTENT_TYPE             : NetworkCallConstants.Header.APPLICATION_JSON,
                                   NetworkCallConstants.Header.LANG                     : UserDefaults.standard.value(forKey: UserDefaultsConstants.USER_LANGUAGE) as? String ?? "en"]
        
        AF.request(url ?? "", method: .put, parameters:paramsStr, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result
            {
            case .success(let json):
                guard let dict = json as? [String:Any] else {
                    return
                }
                print(dict)
                if let status = dict[StringConstants.ResponseKeys.STATUS] as? Int{
                    if(status == 200){
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        completion(dict,1, message)
                    } else {
                        
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        completion(nil, 0, message)
                    }
                }
            case .failure(let error):
                print(error)
                completion(nil, 0, error.localizedDescription)
            }
        }
    }
    
    static func getSummaryData(view: UIView?, urlString: String, completion: @escaping((_ response: [String:Any]?, _ status: Int, _ message: String) -> ())) {
        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION              : NetworkCallConstants.Header.BEARER + UserDefaultsManager.LoginApiToken!,
                                   NetworkCallConstants.Header.CONTENT_TYPE               : NetworkCallConstants.Header.APPLICATION_JSON,
                                   NetworkCallConstants.Header.LANG                       : UserDefaults.standard.value(forKey: UserDefaultsConstants.USER_LANGUAGE) as? String ?? "en"]
        
        print("\(urlString) -> params: \(headers)")
        AF.request(urlString, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result
            {
            case .success(let json):
                guard let dict = json as? [String:Any] else {
                    return
                }
                print(dict)
                
                if let status = dict[StringConstants.ResponseKeys.STATUS] as? Int{
                    if (status == 200){
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        completion(dict,200, message)
                    } else {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        completion(nil, 0, message)
                    }
                }
            case .failure(let error):
                print(error)
                completion(nil, 0, error.localizedDescription)
            }
        }
    }
    
    static func loginNetworkCallCore2(email:String,password:String,siginInType:String,accessToken:String, providerName:String, completion: @escaping((_ response: [String:Any]?, _ error: String?) -> ())) {
        let build       = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceOS    = UIDevice.current.systemVersion
        var deviceType = "0"
        let currentLocale = Locale.current.regionCode ?? "pk"
#if targetEnvironment(simulator)
        deviceType = "0"
        
#else
        deviceType = "1"
        
#endif
        let header : HTTPHeaders = [NetworkCallConstants.Header.ACCEPT:NetworkCallConstants.Header.APPLICATION_JSON,
                                    NetworkCallConstants.Header.CONTENT_TYPE    : NetworkCallConstants.Header.APPLICATION_JSON,
                                    NetworkCallConstants.Header.LANGUAGE        : language,
                                    NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
                                    NetworkCallConstants.Header.OS              : "iOS",
                                    NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
                                    "device-type"      : deviceType,
                                    "user-agent": "FamilyTime/\(appVersion ?? "") (iOS; Build:\(build); SDK:\(deviceOS);)",
                                    "country": currentLocale,
                                    NetworkCallConstants.Header.APP_BUILD       : build as! String]
        let url = HLConstants.URLs.AUTH.signInCore2
        let uniqueDeciveID = UIDevice.current.identifierForVendor?.uuidString
        let timeZone    = NSTimeZone.local as NSTimeZone
        let timeZoneName      = timeZone.name
        
        let deviceToken = UserDefaults.standard.object(forKey: kDeviceToken)
        
        var params  = [String:Any]()
        if siginInType == NetworkCallConstants.Parameters.EMAIL {
            params =  [NetworkCallConstants.Parameters.EMAIL                        : email,
                       NetworkCallConstants.Parameters.PASSWORD                     : password,
                       NetworkCallConstants.Parameters.AGENT                        : NetworkCallConstants.Parameters.IOS,
                       NetworkCallConstants.Parameters.PUSH_TOKEN                   : deviceToken ?? "00",
                       NetworkCallConstants.Parameters.DEVICE_TIME_ZONE             : timeZoneName,
                       NetworkCallConstants.Parameters.APP_VERSION                  : appVersion ?? "",
                       NetworkCallConstants.Parameters.APP_BUILD                    : build,
                       NetworkCallConstants.Parameters.DEVICE_LANGUAGE              : language,
                       NetworkCallConstants.Parameters.WIFI_NAME                    : SwiftCommonUtility.shared.getWiFiSsid() ?? "",
                       NetworkCallConstants.Parameters.DEVICE_MODEL                 : UIDevice.modelName,
                       NetworkCallConstants.Parameters.DEVICE_NAME                  : UIDevice.current.name,
                       NetworkCallConstants.Parameters.DEVICE_OS                    : UIDevice.current.systemVersion,
                       NetworkCallConstants.Parameters.UNIQUE_DEVICE_ID             : uniqueDeciveID ?? "",
                       NetworkCallConstants.Parameters.LATITUDE                     : "0.0",
                       NetworkCallConstants.Parameters.LONGITUDE                    : "0.0",
                       NetworkCallConstants.Parameters.SIGNAL_STRENGHT              : "",
                       NetworkCallConstants.Parameters.BATTERY_REMAINING            : "",
                       NetworkCallConstants.Parameters.ACCURACY                     : "",
                       NetworkCallConstants.Parameters.ADDRESS                      : "",
                       NetworkCallConstants.Parameters.DEVICE_IMEI                  : "" ]  as [String:Any]
            
        } else if siginInType == NetworkCallConstants.Parameters.GOOGLE {
            params =  [NetworkCallConstants.Parameters.TOKEN                        : accessToken,
                       NetworkCallConstants.Parameters.PROVIDER_NAME                : providerName,
                       NetworkCallConstants.Parameters.AGENT                        : NetworkCallConstants.Parameters.IOS,
                       NetworkCallConstants.Parameters.PUSH_TOKEN                   : deviceToken ?? "00",
                       NetworkCallConstants.Parameters.DEVICE_TIME_ZONE             : timeZoneName,
                       NetworkCallConstants.Parameters.APP_VERSION                  : appVersion ?? "",
                       NetworkCallConstants.Parameters.APP_BUILD                    : build,
                       NetworkCallConstants.Parameters.DEVICE_LANGUAGE              : language,
                       NetworkCallConstants.Parameters.WIFI_NAME                    : SwiftCommonUtility.shared.getWiFiSsid() ?? "",
                       NetworkCallConstants.Parameters.DEVICE_MODEL                 : UIDevice.modelName,
                       NetworkCallConstants.Parameters.DEVICE_NAME                  : UIDevice.current.name,
                       NetworkCallConstants.Parameters.DEVICE_OS                    : UIDevice.current.systemVersion,
                       NetworkCallConstants.Parameters.UNIQUE_DEVICE_ID             : uniqueDeciveID ?? "",
                       NetworkCallConstants.Parameters.LATITUDE                     : "0.0",
                       NetworkCallConstants.Parameters.LONGITUDE                    : "0.0",
                       NetworkCallConstants.Parameters.SIGNAL_STRENGHT              : "",
                       NetworkCallConstants.Parameters.BATTERY_REMAINING            : "",
                       NetworkCallConstants.Parameters.ACCURACY                     : "",
                       NetworkCallConstants.Parameters.ADDRESS                      : "",
                       NetworkCallConstants.Parameters.DEVICE_IMEI                  : "" ]  as [String:Any]
            
        } else if siginInType == NetworkCallConstants.Parameters.APPLE {
            params =  [NetworkCallConstants.Parameters.TOKEN                        : accessToken,
                       NetworkCallConstants.Parameters.PROVIDER_NAME                : providerName,
                       NetworkCallConstants.Parameters.AGENT                        : NetworkCallConstants.Parameters.IOS,
                       NetworkCallConstants.Parameters.PUSH_TOKEN                   : deviceToken ?? "00",
                       NetworkCallConstants.Parameters.DEVICE_TIME_ZONE             : timeZoneName,
                       NetworkCallConstants.Parameters.APP_VERSION                  : appVersion ?? "",
                       NetworkCallConstants.Parameters.APP_BUILD                    : build,
                       NetworkCallConstants.Parameters.DEVICE_LANGUAGE              : language,
                       NetworkCallConstants.Parameters.WIFI_NAME                    : SwiftCommonUtility.shared.getWiFiSsid() ?? "",
                       NetworkCallConstants.Parameters.DEVICE_MODEL                 : UIDevice.modelName,
                       NetworkCallConstants.Parameters.DEVICE_NAME                  : UIDevice.current.name,
                       NetworkCallConstants.Parameters.DEVICE_OS                    : UIDevice.current.systemVersion,
                       NetworkCallConstants.Parameters.UNIQUE_DEVICE_ID             : uniqueDeciveID ?? "",
                       NetworkCallConstants.Parameters.LATITUDE                     : "0.0",
                       NetworkCallConstants.Parameters.LONGITUDE                    : "0.0",
                       NetworkCallConstants.Parameters.SIGNAL_STRENGHT              : "",
                       NetworkCallConstants.Parameters.BATTERY_REMAINING            : "",
                       NetworkCallConstants.Parameters.ACCURACY                     : "",
                       NetworkCallConstants.Parameters.ADDRESS                      : "",
                       NetworkCallConstants.Parameters.DEVICE_IMEI                  : "" ]  as [String:Any]
        }
        
        print("\(url) -> params: \(params)")
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        if let dict = json as? [String:Any] {
                            completion(dict,nil)
                        }
                    case 429:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    static func tokenGeneraterNetworkCallCore2(completion: @escaping((_ response: String?, _ error: String?) -> ())) {
        let timeZone    = NSTimeZone.local as NSTimeZone
        let timeZoneName      = timeZone.name
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build       = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let deviceOS    = UIDevice.current.systemVersion
        let uniqueDeciveID = UIDevice.current.identifierForVendor?.uuidString
        let pushToken  = UserDefaults.standard.string(forKey: kDeviceToken)
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION   : NetworkCallConstants.Header.BEARER + UserDefaultsManager.LoginApiToken!,
//                                   NetworkCallConstants.Header.CONTENT_TYPE    : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.ACCEPT          : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE        : language,
//                                   NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD       : build as! String]
        let headers = getHeader()
        let url = HLConstants.URLs.AUTH.generateCore2Token
        let params = [NetworkCallConstants.Parameters.DEVICE_TIME_ZONE    : timeZoneName,
                      NetworkCallConstants.Parameters.APP_VERSION         : appVersion ?? "" ,
                      NetworkCallConstants.Parameters.APP_BUILD           : build ,
                      NetworkCallConstants.Parameters.UNIQUE_DEVICE_ID    : uniqueDeciveID ?? "" ,
                      NetworkCallConstants.Parameters.AGENT               : "ios",
                      NetworkCallConstants.Parameters.WIFI_NAME           : SwiftCommonUtility.shared.getWiFiSsid() ?? "",
                      NetworkCallConstants.Parameters.PUSH_TOKEN          : pushToken ?? "",
                      NetworkCallConstants.Parameters.DEVICE_MODEL        : UIDevice.modelName, //UIDevice.current.model,
                      NetworkCallConstants.Parameters.DEVICE_NAME         : UIDevice.current.name,
                      NetworkCallConstants.Parameters.DEVICE_OS           : UIDevice.current.systemVersion,
                      NetworkCallConstants.Parameters.DEVICE_LANGUAGE     : language,
                      NetworkCallConstants.Parameters.LATITUDE            : "0.0",
                      NetworkCallConstants.Parameters.LONGITUDE           : "0.0",
                      NetworkCallConstants.Parameters.SIGNAL_STRENGHT     : "",
                      NetworkCallConstants.Parameters.BATTERY_REMAINING   : "",
                      NetworkCallConstants.Parameters.ACCURACY            : "",
                      NetworkCallConstants.Parameters.ADDRESS             : "",
                      NetworkCallConstants.Parameters.DEVICE_IMEI         : "" ] as [String:Any]
        
        print("\(url) -> params: \(params)")
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        if let dict = json as? [String : Any] {
                            if let token = dict[StringConstants.ResponseKeys.TOKEN] as? String {
                                completion(token,nil)
                            }
                        }
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    static func oldTokenGeneraterNetworkCallCore(email:String,password:String, completion: @escaping((_ response: String?, _ error: String?) -> ())) {
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build       = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let deviceOS    = UIDevice.current.systemVersion
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.CONTENT_TYPE    : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE        : language,
//                                   NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD       : build as! String,
//                                   NetworkCallConstants.Header.ACCEPT          : NetworkCallConstants.Header.APPLICATION_JSON]
        let headers = getHeader()
        let url = HLConstants.URLs.AUTH.generateCoreOldToken
        let params = [NetworkCallConstants.Parameters.EMAIL         : email,
                      NetworkCallConstants.Parameters.PASSWORD      : password] as [String:Any]
        print("\(url) -> params: \(params)")
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        if let dict = json as? [String : Any] {
                            if let data = dict[StringConstants.ResponseKeys.DATA] as? [String : Any] {
                                if let token = data[StringConstants.ResponseKeys.TOKEN] as? String {
                                    completion(token,nil)
                                }
                            }
                        }
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    static func profileNetworkCallCore2(bearerToken:String, completion: @escaping((_ response: [String:Any]?, _ error: String?) -> ())) {
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceOS    = UIDevice.current.systemVersion
        let url = SwiftAPIConstants.kProfileURL
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION   : NetworkCallConstants.Header.BEARER + (bearerToken),
//                                   NetworkCallConstants.Header.CONTENT_TYPE    : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.ACCEPT          : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE        : language,
//                                   NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD       : build as! String]
        let headers = getHeader()
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        if let dict = json as? [String : Any] {
                            print(dict)
                            completion(dict,nil)
                        }
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    static func appConfigurationsNetworkCallCore2(completion: @escaping((_ response: Configurations?, _ error: String?) -> ())) {
        let url = HLConstants.URLs.AUTH.appCongigurations
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceOS    = UIDevice.current.systemVersion
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let currentLocale = Locale.current.regionCode ?? "pk"
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION: NetworkCallConstants.Header.BEARER + (UserDefaultsManager.bearerTokenCore2 ?? ""),
//            NetworkCallConstants.Header.APPLICATION_JSON: NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.ACCEPT          : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE        : language,
//                                   NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   "country": currentLocale,
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD       : build as! String]
        let headers = getHeader()
        
        print(url)
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        if let data = response.data {
                            print(data)
                            do {
                                let responseDecoded = try JSONDecoder().decode(Configurations.self, from: data)
                                completion(responseDecoded,nil)
                            } catch let error as NSError{
                                print(error)
                            }
                        }
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    //MARK: ACCOUNT API - RIZWAM
    static func accountApiFunc(token: String,completion: @escaping((_ response: AccountModel?, _ error: String?) -> ())) {
        let url = HLConstants.URLs.AUTH.accountCore
//        let language  = SwiftCommonUtility.shared.getCurrentLanguageCode()
//        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
//        let deviceOS  = UIDevice.current.systemVersion
//        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
//        let currentLocale = Locale.current.regionCode ?? "pk"
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION    : NetworkCallConstants.Header.BEARER + (token),
//                                   NetworkCallConstants.Header.CONTENT_TYPE     : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.ACCEPT           : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE         : language,
//                                   NetworkCallConstants.Header.APP_VERSION      : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   "country": currentLocale,
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD        : build as! String]
        let headers = getHeader()
        print(url, headers)
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        if let data = response.data {
                            print(data)
                            do {
                                let responseDecoded = try JSONDecoder().decode(AccountModel.self, from: data)
                                completion(responseDecoded,nil)
                            } catch let error as NSError{
                                print(error)
                            }
                        }
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    static func generateQRCodeNetworkCallCore2(completion: @escaping((_ response: String?, _ error: String?) -> ())) {
        
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceOS    = UIDevice.current.systemVersion
        let url = HLConstants.URLs.AUTH.generateQRCode
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION   : NetworkCallConstants.Header.BEARER + (UserDefaultsManager.bearerTokenCore2 ?? ""),
//                                   NetworkCallConstants.Header.CONTENT_TYPE    : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.ACCEPT          : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE        : language,
//                                   NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD       : build as! String]
//        
        let headers = getHeader()
        print(url)
        AF.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        if let dict = json as? [String : Any] {
                            print(dict)
                            if let qrCode = dict[StringConstants.ResponseKeys.QR_CODE] as? String {
                                completion(qrCode,nil)
                            }
                        }
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    static func LogoutNetworkCallCore2(completion: @escaping((_ isLogout: Bool?, _ error: String?) -> ())) {
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceOS    = UIDevice.current.systemVersion
        let url = HLConstants.URLs.AUTH.logoutCore2
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION   : NetworkCallConstants.Header.BEARER + (UserDefaultsManager.bearerTokenCore2 ?? ""),
//                                   NetworkCallConstants.Header.CONTENT_TYPE    : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.ACCEPT          : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE        : language,
//                                   NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD       : build as! String]
        let headers = getHeader()
        print(url)
        AF.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        completion(true, nil)
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    static func deleteChildNetworkCallCore2(withURL:String,completion: @escaping((_ isDeleted: Bool?, _ error: String?) -> ())) {
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceOS    = UIDevice.current.systemVersion
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION   : NetworkCallConstants.Header.BEARER + (UserDefaultsManager.bearerTokenCore2 ?? ""),
//                                   NetworkCallConstants.Header.CONTENT_TYPE    : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.ACCEPT          : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE        : language,
//                                   NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD       : build as! String]
        let headers = getHeader()
        AF.request(withURL, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        completion(true, nil)
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    static func forgetPasswordNetworkCallCore2(email:String, completion: @escaping((_ isEmailSent: Bool?, _ error: String?) -> ())) {
//        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
//        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
//        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
//        let deviceOS    = UIDevice.current.systemVersion
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.CONTENT_TYPE    : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.ACCEPT          : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE        : language,
//                                   NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD       : build as! String]
        let headers = getHeader()
        let url = HLConstants.URLs.AUTH.forgetPasswordCore2
        let params = [StringConstants.ResponseKeys.EMAIL : email] as [String:Any]
        
        print("\(url) -> params: \(params)")
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        completion(true, nil)
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    static func HomeNetworkCallCore2(completion: @escaping((_ response: HomeResponse?, _ error: String?) -> ())) {
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceOS    = UIDevice.current.systemVersion
        let currentLocale = Locale.current.regionCode ?? "pk"
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.CONTENT_TYPE    : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.ACCEPT          : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.AUTHORIZATION   : NetworkCallConstants.Header.BEARER + (UserDefaultsManager.bearerTokenCore2 ?? ""),
//                                   NetworkCallConstants.Header.LANGUAGE        : language,
//                                   NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   "country": currentLocale,
//                                   NetworkCallConstants.Header.APP_BUILD       : build as! String]
        let headers = getHeader()
        let url = HLConstants.URLs.Child.Dashboard.homeApiCore2
         var prefValueArr = [String]()
        print("\(url)")
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        if let dict = json as? [String:Any] {
                            if let data = dict["data"] as? [String : Any] {
                               if let children = data["children"] as? [[String :Any]] {
                                   for childAr in children{
                                       let prefArr = childAr["preferences"] as? [[String :Any]]
                                       if let arr = prefArr{
                                           for item in arr{
                                               let value = item["value"]
                                               let new_value = "\(String(describing: value ?? ""))"
                                               print(new_value)
                                               prefValueArr.append(new_value)
                                               UserDefaults.standard.set(prefValueArr, forKey: "VALUE_ARR")
                                               UserDefaults.standard.synchronize()
                                           }
                                       }
                                   }
                                }
                            }
                        }
                        if let data = response.data {
                            print(data)
                            do {
                                
                                
                                let responseDecoded = try JSONDecoder().decode(HomeResponse.self, from: data)
                                completion(responseDecoded,nil)
                            } catch let error as NSError{
                                print(error)
                            }
                        }
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    
    //MARK: WEB HISTORY API - RIZWAM
    static func webHistoryAPI(params: [String:Any] = [:],url: String,completion: @escaping((_ response: AppHistoryBase?, _ error: String?) -> ())) {
        let language  = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceOS  = UIDevice.current.systemVersion
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION    : NetworkCallConstants.Header.BEARER + (UserDefaultsManager.bearerTokenCore2 ?? ""),
//                                   NetworkCallConstants.Header.CONTENT_TYPE     : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.ACCEPT           : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE         : language,
//                                   NetworkCallConstants.Header.APP_VERSION      : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD        : build as! String]
        let headers = getHeader()
        print(url, headers)
        AF.request(url, method: .get, parameters: params, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        if let data = response.data {
                            print(data)
                            do {
                                let responseDecoded = try JSONDecoder().decode(AppHistoryBase.self, from: data)
                                completion(responseDecoded,nil)
                            } catch let error as NSError{
                                print(error)
                            }
                        }
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    
    static func youtubeHistoyApi(params:[String:Any] = [:],url: String,completion: @escaping((_ response: YoutubeBaseModel?, _ error: String?) -> ())) {
        let language  = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceOS  = UIDevice.current.systemVersion
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION    : NetworkCallConstants.Header.BEARER + (UserDefaultsManager.bearerTokenCore2 ?? ""),
//                                   NetworkCallConstants.Header.CONTENT_TYPE     : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.ACCEPT           : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE         : language,
//                                   NetworkCallConstants.Header.APP_VERSION      : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD        : build as! String]
        let headers = getHeader()
        print(url, headers)
        AF.request(url, method: .get, parameters: params,headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        if let data = response.data {
                            print(data)
                            do {
                                let responseDecoded = try JSONDecoder().decode(YoutubeBaseModel.self, from: data)
                                completion(responseDecoded,nil)
                            } catch let error as NSError{
                                print(error)
                            }
                        }
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    //MARK: NOTIFICTION NEW FUNCTION
    static func loadNotificationsApiNew(view: UIView?,completion: @escaping((_ response: [FeedDatum]?, _ error: String?) -> ())){
        let url = HLConstants.URLs.AUTH.notification_feeds
        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION            : NetworkCallConstants.Header.BEARER + UserDefaultsManager.LoginApiToken!,
                                   NetworkCallConstants.Header.CONTENT_TYPE             : NetworkCallConstants.Header.APPLICATION_JSON,
                                   NetworkCallConstants.Header.CONTENT_TYPE             : NetworkCallConstants.Header.APPLICATION_JSON,
                                   NetworkCallConstants.Header.LANG                     : UserDefaults.standard.value(forKey: UserDefaultsConstants.USER_LANGUAGE) as? String ?? "en"]
        print("\(url) -> params: \(headers)")
        AF.request(url, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    if let data = response.data {
                        print(data)
                        do {
                            let responseDecoded = try JSONDecoder().decode(NotificationFeedModel.self, from: data)
                            completion(responseDecoded.feedData,nil)
                        } catch let error as NSError{
                            print(error)
                        }
                    }
                case 429,422:
                    if let dict = json as? [String:Any] {
                        if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                            completion(nil,message)
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    } else {
                        completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                            completion(nil,message)
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    } else {
                        completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    static func networkCallDailyLimits(childID: String, completion: @escaping((_ response: [String:Any]?, _ error: String?) -> ())){
        let url = KDailyLimit_mesh2 + childID
        let token = UserDefaults.standard.string(forKey: "LoginAuthToken") ?? ""
        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION            : NetworkCallConstants.Header.BEARER + token,
                                   NetworkCallConstants.Header.CONTENT_TYPE             : NetworkCallConstants.Header.APPLICATION_JSON,
                                   NetworkCallConstants.Header.CONTENT_TYPE             : NetworkCallConstants.Header.APPLICATION_JSON,
                                   NetworkCallConstants.Header.LANG                     : UserDefaults.standard.value(forKey:UserDefaultsConstants.USER_LANGUAGE) as? String ?? "en"]
        //let headers = getHeader()
        AF.request(url, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    if let data = json as? [String:Any] {
                        completion(data,nil)
                    }
                case 429,422:
                    if let dict = json as? [String:Any] {
                        if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                            completion(nil,message)
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    } else {
                        completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                            completion(nil,message)
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    } else {
                        completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            }
        })
    }
    
    static func networkCallEmailVerification(completion: @escaping((_ response: Bool?, _ error: String?) -> ())){
        let url = HLConstants.URLs.Child.Dashboard.emailVerification
        let token = UserDefaultsManager.bearerTokenCore2 ?? ""
        let currentLocale = Locale.current.regionCode ?? "pk"
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION    : NetworkCallConstants.Header.BEARER + token,
//                                   NetworkCallConstants.Header.CONTENT_TYPE     : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.CONTENT_TYPE     : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   "country": currentLocale,
//                                   NetworkCallConstants.Header.LANG             : UserDefaults.standard.value(forKey: UserDefaultsConstants.USER_LANGUAGE) as? String ?? "en"]
        let headers = getHeader()
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    completion(true, nil)
                case 429,422:
                    if let dict = json as? [String:Any] {
                        if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                            completion(nil,message)
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    } else {
                        completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                            completion(nil,message)
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    } else {
                        completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    static func networkCallEmailBounce(completion: @escaping((_ response: Bool?, _ error: String?) -> ())){
        let url = HLConstants.URLs.Child.Dashboard.emailBounce
        let token = UserDefaultsManager.bearerTokenCore2 ?? ""
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION    : NetworkCallConstants.Header.BEARER + token,
//                                   NetworkCallConstants.Header.CONTENT_TYPE     : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.CONTENT_TYPE     : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANG             : UserDefaults.standard.value(forKey: UserDefaultsConstants.USER_LANGUAGE) as? String ?? "en"]
        let headers = getHeader()
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    completion(true, nil)
                case 429,422:
                    if let dict = json as? [String:Any] {
                        if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                            completion(nil,message)
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    } else {
                        completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                            completion(nil,message)
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    } else {
                        completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    static func networkCallEmailComplaint(completion: @escaping((_ response: Bool?, _ error: String?) -> ())){
        let url = HLConstants.URLs.Child.Dashboard.emailComplaint
        let token = UserDefaultsManager.bearerTokenCore2 ?? ""
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION    : NetworkCallConstants.Header.BEARER + token,
//                                   NetworkCallConstants.Header.CONTENT_TYPE     : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.CONTENT_TYPE     : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANG             : UserDefaults.standard.value(forKey: UserDefaultsConstants.USER_LANGUAGE) as? String ?? "en"]
        let headers = getHeader()
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    completion(true, nil)
                case 429,422:
                    if let dict = json as? [String:Any] {
                        if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                            completion(nil,message)
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    } else {
                        completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                            completion(nil,message)
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    } else {
                        completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    static func networkAprovedApp(urlEnd:String,para:[String:Any], completion: @escaping((_ response: Int?, _ error: String?) -> ())) {
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build       = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let deviceOS    = UIDevice.current.systemVersion
        print(UserDefaultsManager.bearerTokenCore2)
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION   : NetworkCallConstants.Header.BEARER + UserDefaultsManager.bearerTokenCore2!,
//                                   NetworkCallConstants.Header.CONTENT_TYPE    : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE        : language,
//                                   NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD       : build as! String,
//                                   NetworkCallConstants.Header.ACCEPT          : NetworkCallConstants.Header.APPLICATION_JSON]
        let headers = getHeader()
        let url = HLConstants.URLs.AproveApp.update_ApproveApp + urlEnd
        print(url)
        print("PARAMS:- \(para)")
        let params = ["preferences": [para]]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        completion(response.response?.statusCode,nil)
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    static func networkAppStatus(urlEnd:String,approve: Bool,appName: String , appPkg: String, completion: @escaping((_ response: Int?, _ error: String?) -> ())) {
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build       = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let deviceOS    = UIDevice.current.systemVersion
        print(UserDefaultsManager.bearerTokenCore2)
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION   : NetworkCallConstants.Header.BEARER + UserDefaultsManager.bearerTokenCore2!,
//                                   NetworkCallConstants.Header.CONTENT_TYPE    : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE        : language,
//                                   NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD       : build as! String,
//                                   NetworkCallConstants.Header.ACCEPT          : NetworkCallConstants.Header.APPLICATION_JSON]
        let headers = getHeader()
        let url = HLConstants.URLs.AproveApp.update_ApproveApp + urlEnd
        print(url)
        
        let params = ["approve": approve,
                      "app_package": appPkg,
                      "app_name": appName
        ] as [String : Any]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        completion(response.response?.statusCode,nil)
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    
    static func networkCallUpdateProfile(params:[String :Any], completion: @escaping((_ response: Int?, _ error: String?) -> ())) {
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build       = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let deviceOS    = UIDevice.current.systemVersion
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION   : NetworkCallConstants.Header.BEARER + (UserDefaultsManager.bearerTokenCore2 ?? ""),
//                                   NetworkCallConstants.Header.CONTENT_TYPE    : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE        : language,
//                                   NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD       : build as! String,
//                                   NetworkCallConstants.Header.ACCEPT          : NetworkCallConstants.Header.APPLICATION_JSON]
        let headers = getHeader()
        let url = HLConstants.URLs.Child.Dashboard.updateProfile
        print(url)
        AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        completion(response.response?.statusCode,nil)
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    static func networkCallSubscriptionCancelled(params:[String :Any], completion: @escaping((_ response: Bool?, _ error: String?) -> ())) {
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build       = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let deviceOS    = UIDevice.current.systemVersion
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION   : NetworkCallConstants.Header.BEARER + (UserDefaultsManager.bearerTokenCore2 ?? ""),
//                                   NetworkCallConstants.Header.CONTENT_TYPE    : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE        : language,
//                                   NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD       : build as! String,
//                                   NetworkCallConstants.Header.ACCEPT          : NetworkCallConstants.Header.APPLICATION_JSON]
        let headers = getHeader()
        let url = HLConstants.URLs.Child.Dashboard.subscriptionCancelled
        print(url)
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        completion(true,nil)
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    static func getContentFiltersApi() {
        let url = HLConstants.BASE_URL_CORE_2 + "controls/content-filters"
        let headers: HTTPHeaders = getHeader()
        print("\(url) -> params: \(headers)")
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200, 201, 202, 204, 206:
                    do {
                        let decoder = JSONDecoder()
                        let contentFilterResponse = try decoder.decode(ContentFilterResponse.self, from: response.data!)
                        DBManager.shared.saveContentFiltersModel(myModelArray: contentFilterResponse.contentFilters)
                        // Now you can access contentFilterResponse.contentFilters to access the array of content filters
                        for contentFilter in contentFilterResponse.contentFilters {
                            print("Child ID: \(contentFilter.childId)")
                            
                            switch contentFilter.mdmPayload.movies {
                            case .bool(let value):
                                print("Movies (Bool): \(value)")
                            case .string(let value):
                                print("Movies (String): \(value)")
                            }
                            
                            switch contentFilter.mdmPayload.tvShows {
                            case .bool(let value):
                                print("TV Shows (Bool): \(value)")
                            case .string(let value):
                                print("TV Shows (String): \(value)")
                            }
                            
                            switch contentFilter.mdmPayload.apps {
                            case .bool(let value):
                                print("Apps (Bool): \(value)")
                            case .string(let value):
                                print("Apps (String): \(value)")
                            }
                            
                            print("Bookstore Erotica: \(contentFilter.mdmPayload.bookstoreErotica.value)")
                            print("Explicit Content: \(contentFilter.mdmPayload.explicitContent.value)")
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                case 404, 429, 400:
                    if let dict = json as? [String: Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                    }
                default:
                    if let dict = json as? [String: Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func prePaidSubscriptionApiCall(code: String, callBack: @escaping (String?) -> Void) {
        let url = HLConstants.BASE_URL_CORE_2 + "ipn"
        let headers: HTTPHeaders = getHeader()
        let token = UserDefaultsManager.bearerTokenCore2 ?? ""

        let payload = [
            "code": code,
        ] as [String : Any]
        
        AF.request(url, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    if let httpResponse = response.response {
                        switch httpResponse.statusCode {
                        case 200, 201, 202, 204, 206:
                            callBack(nil)
                        case 404, 429, 400:
                            if let dict = json as? [String: Any], let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                callBack(message)
                            } else {
                                callBack("Unknown error occurred.")
                            }
                        default:
                            if let dict = json as? [String: Any], let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                callBack(message)
                            } else {
                                callBack("Unknown error occurred.")
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                    callBack(error.localizedDescription)
                }
            }
        
        
    }
    
   static func putContentFilters(id: Int, childId: Int, mdmPayload: String, callBack: @escaping (String?) -> Void) {
        let url = HLConstants.BASE_URL_CORE_2 + "controls/content-filters"
        let headers: HTTPHeaders = getHeader()

        let payload = [
            "id": id,
            "child_id": String(childId),
            "mdm_payload": mdmPayload
        ] as [String : Any]

        AF.request(url, method: .put, parameters: payload, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    if let httpResponse = response.response {
                        switch httpResponse.statusCode {
                        case 200, 201, 202, 204, 206:
                            callBack(nil)
                        case 404, 429, 400:
                            if let dict = json as? [String: Any], let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                callBack(message)
                            } else {
                                callBack("Unknown error occurred.")
                            }
                        default:
                            if let dict = json as? [String: Any], let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                callBack(message)
                            } else {
                                callBack("Unknown error occurred.")
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                    callBack(error.localizedDescription)
                }
            }
    }
    static func getControlApi() {
        let url = HLConstants.BASE_URL_CORE_2 + "controls"
        let headers:HTTPHeaders = getHeader()
//        [NetworkCallConstants.Header.AUTHORIZATION            : NetworkCallConstants.Header.BEARER + UserDefaultsManager.bearerTokenCore2!,
//                                   NetworkCallConstants.Header.ACCEPT             : NetworkCallConstants.Header.APPLICATION_JSON]
        print("\(url) -> params: \(headers)")
        AF.request(url, method: .get,
                   parameters:nil, encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    DBManager.shared.saveDataToDB(entityName: .control, ModelData: response.data!) {
                        print("saved")
                    }
                    do {
                        let responseDecoded = try JSONDecoder().decode(ControlCodableModel.self, from: response.data!)
                        print("response:", responseDecoded.controls?.count as Any)
                        
                        if responseDecoded.controls != nil {
                            DBManager.shared.saveControlsModel(myModelArray: responseDecoded.controls!)
                        }
                    } catch let error as NSError{
                        print(error)
                    }
//                    if let dict = json as? [String:Any] {
//                        
//                        //let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
//                        //completion(dict,200, message)
//                    }
                case 404, 429, 400:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        //completion(nil, 404, message)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                       // completion(nil, 404, message)
                    }
                }
            case .failure(let error):
                print(error)
                //completion(nil, 500, error.localizedDescription)
            }
        }
    }
    static func putControlApi(childId:Int, featureId: Int, state: Int,identifier: String,value:String = "" ,isValue:Bool = false,callBack:@escaping (_ err: String?)->()) {
        let url = HLConstants.BASE_URL_CORE_2 + "controls"
        let headers:HTTPHeaders = getHeader()

        print("\(url) -> params: \(headers)")
        var params = ["child_id":childId,
                      "feature_id":featureId,
                      "state":state,
                      "identifier":identifier] as [String : Any]
        if isValue {
            let value = ["value": value]
            params.merge(value) { (_, new) in new }
            print("params",params)
        }
        AF.request(url, method: .put, parameters:params,
                   encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                   callBack(nil)
                case 404, 429, 400:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        //completion(nil, 404, message)
                        callBack(message)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                       // completion(nil, 404, message)
                        callBack(message)
                    }
                }
            case .failure(let error):
                print(error)
                callBack(error.localizedDescription)
                //completion(nil, 500, error.localizedDescription)
            }
        }
    }
    
    static func getHomeApi(completion: @escaping (HomePlansModel?, Error?) -> Void) {
        let url = HLConstants.BASE_URL_CORE_2 + "v1/home"
        let headers: HTTPHeaders = getHeader()
        
        print("\(url) -> params: \(headers)")
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: HomePlansModel.self) { response in
                switch response.result {
                case .success(let responseDecoded):
                    switch response.response?.statusCode {
                    case 200, 201, 202, 204, 206:
                        print("response:", responseDecoded.plans?.count as Any)
                        
                        // Call completion handler with successful response
                        completion(responseDecoded, nil)
                    case 404, 429, 400:
                        // Handle error status codes
                        print("Error: Received status code \(String(describing: response.response?.statusCode))")
                        completion(nil, NSError(domain: "HTTPError", code: response.response?.statusCode ?? 400, userInfo: nil))
                    default:
                        // Handle unexpected status codes
                        print("Error: Received status code \(String(describing: response.response?.statusCode))")
                        completion(nil, NSError(domain: "HTTPError", code: response.response?.statusCode ?? 400, userInfo: nil))
                    }
                case .failure(let error):
                    // Handle network request failure
                    print(error)
                    completion(nil, error)
                }
        }
    }
    
//    static func getHomePlansApi() {
//          let url = HLConstants.BASE_URL_CORE_2 + "v1/home"
//          let headers: HTTPHeaders = getHeader()
//          
//          print("\(url) -> params: \(headers)")
//          
//          AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: HomePlansModel.self) { response in
//              switch response.result {
//              case .success(let responseDecoded):
//                  switch response.response?.statusCode {
//                  case 200, 201, 202, 204, 206:
//                      print("response:", responseDecoded.plans?.count as Any)
//                      
//                      if let plans = responseDecoded.plans {
//                          print(plans)
//                          DBManager.shared.savePlans(plans: plans)
//                      }
//                      
//                      if let children = responseDecoded.children {
//                          print(children)
//                          DBManager.shared.saveChildren(children: children)
//                      }
//                  case 404, 429, 400:
//                      print("Error: Received status code \(String(describing: response.response?.statusCode))")
//                  default:
//                      print("Error: Received status code \(String(describing: response.response?.statusCode))")
//                  }
//              case .failure(let error):
//                  print(error)
//              }
//          }
//      }
    
    static func putControlAppBlocker(childId:Int, featureId: Int,
                                     state: Int,identifier: String,
                                     blockSt: Int ,appSt: Int ,callBack:@escaping (_ res: String?, _ err: String?)->()) {
        let url = HLConstants.BASE_URL_CORE_2 + "controls"
        let headers:HTTPHeaders = getHeader()
        var params = [String: Any]()
        print("\(url) -> params: \(headers)")
        do {
            let dict = [
                [
                    "identifier": "block_new_apps",
                    "status": blockSt
                ],
                [
                    "identifier": "approve_new_app",
                    "status": appSt
                ]
            ]
            let jsonData = try JSONSerialization.data(withJSONObject: dict)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let param: [String: Any] = [
                    "child_id": childId,
                    "feature_id": featureId,
                    "identifier": identifier,
                    "state": state,
                    "value": jsonString
//                    ,
//                    "subtype": "app_blocker"
                ]
                params = param
            }
        } catch {
            print("Error: \(error)")
        }
        AF.request(url, method: .put, parameters:params,
                   encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                   callBack("success", nil)
                case 404, 429, 400:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        //completion(nil, 404, message)
                        callBack(nil, message)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(nil, message)
                    }
                }
            case .failure(let error):
                print(error)
                callBack(nil, error.localizedDescription)
                //completion(nil, 500, error.localizedDescription)
            }
        }
    }
    static func putControlDailyLimit(childId:Int, featureId: Int,
                                     state: Int,identifier: String,
                                     blockSt: Int ,callBack:@escaping (_ res: String?, _ err: String?)->()) {
        let url = HLConstants.BASE_URL_CORE_2 + "controls"
        let headers:HTTPHeaders = getHeader()
        var params = [String: Any]()
        print("\(url) -> params: \(headers)")
        do {
            let dict = [
                    "identifier": "auto_limit_new_apps",
                    "status": blockSt
            ] as [String : Any]
            let jsonData = try JSONSerialization.data(withJSONObject: dict)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let param: [String: Any] = [
                    "child_id": childId,
                    "feature_id": featureId,
                    "identifier": identifier,
                    "state": state,
                    "value": jsonString
                ]
                params = param
            }
        } catch {
            print("Error: \(error)")
        }
        AF.request(url, method: .put, parameters:params,
                   encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                   callBack("success", nil)
                case 404, 429, 400:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        //completion(nil, 404, message)
                        callBack(nil, message)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(nil, message)
                    }
                }
            case .failure(let error):
                print(error)
                callBack(nil, error.localizedDescription)
                //completion(nil, 500, error.localizedDescription)
            }
        }
    }
    
    static func chargeDeviceRequest(childId:String, callBack:@escaping ()->()) {
        let url = "\(HLConstants.BASE_URL_CORE_2)devices/\(childId)/charge-device"
        let headers:HTTPHeaders = getHeader()
        var params:[String: Any] = ["charge": "charge"]
        print("\(url) -> params: \(headers)")
        
        AF.request(url, method: .post, parameters:params,
                   encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                   callBack()
                case 404, 429, 400:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        //completion(nil, 404, message)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                       // completion(nil, 404, message)
                    }
                }
            case .failure(let error):
                print(error)
                //completion(nil, 500, error.localizedDescription)
            }
        }
    }
    static func reloadSocialMonitor(childId:String,para:String, completion: @escaping((_ response: Int?, _ error: String?) -> ())) {
        let language    = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build       = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let deviceOS    = UIDevice.current.systemVersion
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION   : NetworkCallConstants.Header.BEARER + UserDefaultsManager.bearerTokenCore2!,
//                                   NetworkCallConstants.Header.CONTENT_TYPE    : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE        : language,
//                                   NetworkCallConstants.Header.APP_VERSION     : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD       : build as! String,
//                                   NetworkCallConstants.Header.ACCEPT          : NetworkCallConstants.Header.APPLICATION_JSON]
        let headers = getHeader()
        let url = HLConstants.BASE_URL_CORE_2 + "devices/\(childId)/sync-data"
        print(url)
        print("PARAMS:- \(para)")
        let params = ["feature": para]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        completion(response.response?.statusCode,nil)
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
    
    static func socialAppsHistoryCall(params: [String:Any] = [:],url: String,completion: @escaping((_ response: SocialAppsHistoryModel?, _ error: String?) -> ())) {
        let language  = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceOS  = UIDevice.current.systemVersion
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
//        let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION    : NetworkCallConstants.Header.BEARER + (UserDefaultsManager.bearerTokenCore2 ?? ""),
//                                   NetworkCallConstants.Header.CONTENT_TYPE     : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.ACCEPT           : NetworkCallConstants.Header.APPLICATION_JSON,
//                                   NetworkCallConstants.Header.LANGUAGE         : language,
//                                   NetworkCallConstants.Header.APP_VERSION      : appVersion ?? "",
//                                   NetworkCallConstants.Header.OS              : "iOS",
//                                   NetworkCallConstants.Header.OS_VERSIO       : deviceOS,
//                                   NetworkCallConstants.Header.APP_BUILD        : build as! String]
        let headers = getHeader()
        print(url, headers)
        AF.request(url, method: .get, parameters: params, headers: headers).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200,201,202,204,206:
                        if let data = response.data {
                            print(data)
                            do {
                                let responseDecoded = try JSONDecoder().decode(SocialAppsHistoryModel.self, from: data)
                                completion(responseDecoded,nil)
                            } catch let error as NSError{
                                print(error)
                            }
                        }
                    case 429,422:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    default:
                        if let dict = json as? [String:Any] {
                            if let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                                completion(nil,message)
                            } else {
                                completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                            }
                        } else {
                            completion(nil,StringConstants.Errors.SOMETHING_WENT_WRONG)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
            })
    }
}


//MARK: - Public Functions
public func loaderVisibility(view: UIView?, show: Bool = true, message: String = "") {
    DispatchQueue.main.async {
        if show {
            SwiftFTUtils.showHUDAdded(to: view, withText: message.localized, animated: true)
        } else {
            MBProgressHUD.hideAllHUDs(for: view, animated: true)
        }
    }
}


