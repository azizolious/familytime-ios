//
//  CoreManager.swift
//  FamilyTime
//
//  Created by Sufyan on 18/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import Foundation
import Alamofire

typealias EmptyResponseModel = Empty
class CoreManager {
    static func getControlApps() {
        let base =  HLConstants.BASE_URL_CORE_2
        let url = base + "reports/apps"
        let headers:HTTPHeaders = getHeader()
        print("\(url) -> params: \(headers)")
        AF.request(url, method: .get,
                   parameters:nil, encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    
                    do {
                        let responseDecoded = try JSONDecoder().decode(ControlAppListModel.self, from: response.data!)
                        print("response:", responseDecoded.installedApps?.count as Any)
                        
                        DBManager.shared.deleteData(entityName: "ControlListApps")
                        if responseDecoded.installedApps != nil {
                            DBManager.shared.saveModelsToCoreData(myModelArray: responseDecoded.installedApps!)
                        }
                    } catch let error as NSError{
                        print(error)
                    }
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
    static func putLimitToApp(params:[String: Any], childID: Int, callBack:@escaping ()->()) {
        let base =  HLConstants.BASE_URL_CORE_2
        let url = base + "controls/\(childID)/app-limit"
        let headers:HTTPHeaders = getHeader()
        print("\(url) -> params: \(headers)")
        AF.request(url, method: .post,
                   parameters:params, encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    print(json)
                    callBack()
                    //                    do {
                    //                        let responseDecoded = try JSONDecoder().decode(ControlAppListModel.self, from: response.data!)
                    //                        print("response:", responseDecoded)
                    //                    } catch let error as NSError{
                    //                        print(error)
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
    static func postSocialMediaMonitor(params:[String: Any], callBack:@escaping (_ err: String?)->()) {
        let base =  HLConstants.BASE_URL_CORE_2
        let url = base + "controls/social-monitoring"
        let headers:HTTPHeaders = getHeader()
        print("\(url) -> params: \(headers)")
        AF.request(url, method: .put,
                   parameters:params, encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    print(json)
                    callBack(nil)
                    //                    do {
                    //                        let responseDecoded = try JSONDecoder().decode(ControlAppListModel.self, from: response.data!)
                    //                        print("response:", responseDecoded)
                    //                    } catch let error as NSError{
                    //                        print(error)
                    //                    }
                case 404, 429, 400:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(message)
                        //completion(nil, 404, message)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(message)
                        // completion(nil, 404, message)
                    }
                }
            case .failure(let error):
                print(error)
                callBack(error.localizedDescription)
                //completion(nil, 500, error.localizedDescription)
            }
        }
    }
    
    static func syncSstSettings(params:[String: Any], callBack:@escaping (String ,Bool)->()) {
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let base =  HLConstants.BASE_URL_CORE_2 + "devices/\(Int(child_Id ?? "") ?? -1)/sync-settings"
        let headers:HTTPHeaders = getHeader()
        AF.request(base, method: .post,
                   parameters:params, encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    print(json)
                    callBack("", true)
                case 404, 429, 400:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(message, false)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(message, false)
                    }
                }
            case .failure(let error):
                print(error)
                callBack(error.localizedDescription, false)
            }
        }
    }
    
    static func syncSettings(params:[String: Any], callBack:@escaping (Int, String?)->()) {
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let base =  HLConstants.BASE_URL_CORE_2 + "devices/\(Int(child_Id ?? "") ?? -1)/sync-settings"
        let headers:HTTPHeaders = getHeader()
        AF.request(base, method: .post,
                   parameters:params, encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    print(json)
                    callBack(200, nil)
                case 404, 429, 400:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(404, message)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(404, message)
                    }
                }
            case .failure(let error):
                print(error)
                callBack(404, error.localizedDescription)
            }
        }
    }
    static func changePin(params:[String: Any], callBack:@escaping ()->()) {
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let base =  HLConstants.BASE_URL_CORE_2
        let url = String(format: "\(base)devices/\(Int(child_Id ?? "") ?? -1)/sync-settings")
        let headers:HTTPHeaders = getHeader()
        print("\(url) -> params: \(headers)")
        AF.request(url, method: .post,
                   parameters:params, encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    print(json)
                    callBack()
                case 404, 429, 400:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack()
                    }
                default:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack()
                    }
                }
            case .failure(let error):
                print(error)
                callBack()
            }
        }
    }
    
    static func getTextMsgs(params: [String: Any] = [:], isFirstTime: Bool,loaderView: UIView, completion: @escaping (Bool) -> Void) {
        loaderVisibility(view: loaderView,show: true)
        let base = HLConstants.BASE_URL_CORE_2
        let url = base + "reports/sms"
        let headers: HTTPHeaders = getHeader()
        print("\(url) -> params: \(headers)")
        
        AF.request(url, method: .get, parameters: params, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200, 201, 202, 204, 206:
                    do {
                        let responseDecoded = try JSONDecoder().decode(TextMessagesCodable.self, from: response.data!)
                        print("response:", responseDecoded.sms?.count as Any)
                        if let msgs = responseDecoded.sms {
                            if isFirstTime {
                                DBManager.shared.deleteData(entityName: CoredataKeys.Entities.TEXT_MSGS_DATA)
                            }
                            DBManager.shared.saveTextMsgsToCoreData(myModelArray: msgs)
                            completion(!msgs.isEmpty)
                        } else {
                            completion(false)
                        }
                    } catch let error as NSError {
                        print(error)
                        completion(false)
                        loaderVisibility(view: loaderView,show: false)
                    }
                case 404, 429, 400:
                    if let dict = json as? [String: Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        // handle the error
                    }
                    completion(false)
                    loaderVisibility(view: loaderView,show: false)
                default:
                    if let dict = json as? [String: Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        // handle the error
                    }
                    completion(false)
                    loaderVisibility(view: loaderView,show: false)
                }
            case .failure(let error):
                print(error)
                completion(false)
                loaderVisibility(view: loaderView,show: false)
            }
        }
    }
    
    //    static func getTextMsgs(params:[String:Any] = [:], isFirstTime: Bool) {
    //        let base =  HLConstants.BASE_URL_CORE_2
    //        let url = base + "reports/sms"
    //        let headers:HTTPHeaders = getHeader()
    //        print("\(url) -> params: \(headers)")
    //        AF.request(url, method: .get,
    //                   parameters:params,
    //                   headers: headers).responseJSON { response in
    //            switch response.result {
    //            case .success(let json):
    //                switch response.response?.statusCode {
    //                case 200,201,202,204,206:
    //
    //                    do {
    //                        let responseDecoded = try JSONDecoder().decode(TextMessagesCodable.self, from: response.data!)
    //                        print("response:", responseDecoded.sms?.count as Any)
    //                        if let msgs = responseDecoded.sms {
    //                            if isFirstTime {
    //                                DBManager.shared.deleteData(entityName: CoredataKeys.Entities.TEXT_MSGS_DATA)
    //                                DBManager.shared.saveTextMsgsToCoreData(myModelArray: msgs)
    //                            } else {
    //                                DBManager.shared.saveTextMsgsToCoreData(myModelArray: msgs)
    //                            }
    //                        }
    //                    } catch let error as NSError{
    //                        print(error)
    //                    }
    //                case 404, 429, 400:
    //                    if let dict = json as? [String:Any] {
    //                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
    //                        //completion(nil, 404, message)
    //                    }
    //                default:
    //                    if let dict = json as? [String:Any] {
    //                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
    //                        // completion(nil, 404, message)
    //                    }
    //                }
    //            case .failure(let error):
    //                print(error)
    //                //completion(nil, 500, error.localizedDescription)
    //            }
    //        }
    //    }
    static func getFamilyFeed(params: [String: Any] = [:], isFirstTime: Bool) {
        let base = HLConstants.BASE_URL_CORE_2
        let url = base + "family-feed"
        let headers: HTTPHeaders = getHeader()
        print("\(url) -> params: \(headers)")
        
        AF.request(url, method: .get, parameters: params, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200, 201, 202, 204, 206:
                    do {
                        let responseDecoded = try JSONDecoder().decode(FamilyFeedModel.self, from: response.data!)
                        if let feed = responseDecoded.data {
                            if isFirstTime {
                                DBManager.shared.deleteData(entityName: "FamilyFeed")
                            }
                            DBManager.shared.saveFamilyFeed(myModelArray: feed)
                            let familyFeed = DBManager.shared.getLatestFamilyFeed()
                            print("Family feed data fetched and saved successfully.")
                        }
                    } catch let error as NSError {
                        print("Error decoding response: \(error)")
                    }
                case 404, 429, 400:
                    if let dict = json as? [String: Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        print("Error: \(message)")
                    }
                default:
                    if let dict = json as? [String: Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        print("Error: \(message)")
                    }
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    static func getCoParents(){
        let url = HLConstants.BASE_URL_CORE_2 + "co-parents"
        let token = UserDefaults.standard.value(forKey: kHeaderToken) as? String ?? ""
        let tokenWithBear = "Bearer \(token)"
        var lang = UserDefaults.standard.string(forKey: "userlanguage") ?? NSLocale.current.languageCode ?? "en"
        
        let headers = getHeader()
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            DispatchQueue.main.async {
                
                switch response.result {
                case .success(let json):
                    switch response.response?.statusCode {
                    case 200, 201, 202, 204, 206:
                        if let jsonResponse = json as? [String: Any], let coparents = jsonResponse["data"] as? [[String: Any]] {
                            DBManager.shared.deleteData(entityName: "CoParents")
                            DBManager.shared.saveCoParents(coParentsArray: coparents)
                        } else {
                            CommonModel.showAlert("", msg: "Response")
                        }
                    case 404, 429, 400:
                        if let dict = json as? [String: Any], let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                            CommonModel.showAlert("Error!", msg: message.myModification())
                        }
                    default:
                        if let dict = json as? [String: Any], let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
                            CommonModel.showAlert("Error!", msg: message.myModification())
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    CommonModel.showAlert("Error!", msg: kErrorGeneral.myModification())
                }
            }
        }
    }
    
    static func getFamilyLocation(completion:@escaping((_ response: [ChildLocation]?, _ status: Int?, _ message: String?) -> ())) {
        let base =  HLConstants.BASE_URL_CORE_2
        let url = base + "family-locator"
        let headers:HTTPHeaders = getHeader()
        print("\(url) -> params: \(headers)")
        AF.request(url, method: .get,
                   parameters:nil,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    do {
                        if let dict = json as? [String:Any] {
                            print("alldict:",dict)
                        }
                        let responseDecoded = try JSONDecoder().decode(FamilyLocatorCodable.self, from: response.data!)
                        let locations = responseDecoded.locations
                        print("response:", locations?.count as Any)
                        completion(responseDecoded.locations, response.response?.statusCode ?? 404, nil)
                    } catch let error as NSError{
                        completion(nil,response.response?.statusCode ?? 404, "Model Failed")
                        print(error)
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
    static func postFamilyLocatorStatus(status:Bool, callBack: @escaping((_ response: [String:Any]?, _ status: Int?, _ message: String?) -> ())) {
        let base =  HLConstants.BASE_URL_CORE_2
        let url = base + "family-locator"
        let headers:HTTPHeaders = getHeader()
        print("\(url) -> params: \(headers)")
        let param = ["status":status]
        AF.request(url, method: .post,
                   parameters:param, encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    print(json)
                    callBack(nil, response.response?.statusCode ?? 204, "")
                case 404, 429, 400:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(nil, 404, message)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(nil, 404, message)
                    }
                }
            case .failure(let error):
                print(error)
                callBack(nil, 500, error.localizedDescription)
            }
        }
    }
    
    static func getWebBlocker() {
        let base =  HLConstants.BASE_URL_CORE_2
        let url = base + "web-blocker"
        let headers:HTTPHeaders = getHeader()
        print("\(url) -> params: \(headers)")
        AF.request(url, method: .get,
                   parameters:nil, encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    
                    do {
                        let responseDecoded = try JSONDecoder().decode(WebBlockerModel.self, from: response.data!)
                        DBManager.shared.deleteData(entityName: "WebBlocker")
                        if let web = responseDecoded.webBlockers {
                            DBManager.shared.saveWebBlocker(myModelArray: web)
                        }
                    } catch let error as NSError{
                        print(error)
                    }
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
    static func postWebBlocker(param:[String:Any], callBack: @escaping((_ response: [String:Any]?, _ status: Int?, _ message: String?) -> ())) {
        let base =  HLConstants.BASE_URL_CORE_2
        let url = base + "web-blocker"
        let headers:HTTPHeaders = getHeader()
        print("\(url) -> params: \(headers)")
        AF.request(url, method: .post,
                   parameters:param, encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    print(json)
                    callBack(nil, response.response?.statusCode ?? 204, "")
                case 404, 429, 400:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(nil, 404, message)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(nil, 404, message)
                    }
                }
            case .failure(let error):
                print(error)
                callBack(nil, 500, error.localizedDescription)
            }
        }
    }
    static func patchWebBlocker(param:[String:Any], callBack: @escaping((_ response: [String:Any]?, _ status: Int?, _ message: String?) -> ())) {
        let base =  HLConstants.BASE_URL_CORE_2
        let url = base + "controls/web-blocker"
        let headers:HTTPHeaders = getHeader()
        print("\(url) -> params: \(headers)")
        AF.request(url, method: .patch,
                   parameters:param, encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    print(json)
                    callBack(nil, response.response?.statusCode ?? 204, "")
                case 404, 429, 400:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(nil, 404, message)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(nil, 404, message)
                    }
                }
            case .failure(let error):
                print(error)
                callBack(nil, 500, error.localizedDescription)
            }
        }
    }
    static func deleteWebBlocker(param:[String:Any], callBack: @escaping((_ response: [String:Any]?, _ status: Int?, _ message: String?) -> ())) {
        let base =  HLConstants.BASE_URL_CORE_2
        let url = base + "web-blocker"
        let headers:HTTPHeaders = getHeader()
        print("\(url) -> params: \(headers)")
        AF.request(url, method: .delete,
                   parameters:param, encoding: JSONEncoding.default,
                   headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                switch response.response?.statusCode {
                case 200,201,202,204,206:
                    print(json)
                    callBack(nil, response.response?.statusCode ?? 204, "")
                case 404, 429, 400:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(nil, 404, message)
                    }
                default:
                    if let dict = json as? [String:Any] {
                        let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String ?? ""
                        callBack(nil, 404, message)
                    }
                }
            case .failure(let error):
                print(error)
                callBack(nil, 500, error.localizedDescription)
            }
        }
    }
    static func networkRequest<T:Decodable>(url:String, method:HTTPMethod,
                                            params:[String: Any]? = nil,
                                            callback: @escaping(T?,Int? ,String?)->()) {
        AF.request(url, method: method,
                   parameters:params, encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                   headers: getHeader()).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let json):
                if (200...206).contains(response.response?.statusCode ?? 0) {
                    callback(json, response.response?.statusCode ?? 204, nil)
                } else {
                    let data = response.data
                    do {
                        let errorBac = try JSONDecoder().decode(APIResponseError.self, from: data!)
                        callback(nil, response.response?.statusCode ?? 204, errorBac.message)
                    } catch {
                        callback(nil, response.response?.statusCode ?? 204, error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error)
                callback(nil, 500, error.localizedDescription)
            }
        }
    }
}

func getHeader() -> HTTPHeaders {
    let deviceOS = UIDevice.current.systemName
    let language = NSLocale.preferredLanguages.first
    let appBuildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")  as! String
    let appVersionNumber =  Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let systemVersion = UIDevice.current.systemVersion
    let currentLocale = Locale.current.regionCode ?? "pk"
    var deviceType = "0"
    
#if targetEnvironment(simulator)
    deviceType = "0"
    
#else
    deviceType = "1"
    
#endif
    let headers:HTTPHeaders = [NetworkCallConstants.Header.AUTHORIZATION: NetworkCallConstants.Header.BEARER + (UserDefaultsManager.bearerTokenCore2 ?? ""),
                               NetworkCallConstants.Header.ACCEPT: NetworkCallConstants.Header.APPLICATION_JSON,
                               "language":language!,
                               "app-build":appBuildNumber,
                               "app-version": appVersionNumber,
                               "os-version": systemVersion,
                               "country": currentLocale,
                               "device-type" : deviceType,
                               "user-agent": "FamilyTime/\(appVersionNumber) (iOS; Build:\(appBuildNumber); SDK:\(systemVersion);)",
                               "content-type": "application/json",
                               "os": deviceOS]
    return headers
}
struct APIResponseError: Codable {
    var message: String? = ""
    var responseCode: Int? = -1
}
