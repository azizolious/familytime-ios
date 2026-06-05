//
//  NetworkManager.swift
//  FamilyTime
//
//  Created by Sana-Ullah-IOS on 11/03/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//
//  MARK:- by Hammad Lodhi



import Foundation

class NetworkManager {

    static let manager = NetworkManager()
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func postAPI(with Url: URL, params: [String:Any], fileParams: [String:Any]? = nil, success: @escaping((_ response: [String:Any]?) -> ()), failure: @escaping((_ error: String?, _ status: Int) -> ())) {
        
        var requestUrl = URLRequest(url: Url)
        
        requestUrl.addValue("application/json", forHTTPHeaderField:"Content-Type")
        //requestUrl.addValue("application/json", forHTTPHeaderField:"Accept")
        requestUrl.addValue("en", forHTTPHeaderField:"language")
        
        requestUrl.httpMethod = "POST"
        
        var paramsData : Data?
        do {
            paramsData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            requestUrl.httpBody = paramsData
        }
        catch (let error) {
            print("Error Params: \(error.localizedDescription)")
        }
        
        
        session.dataTask(with: requestUrl) { (data, response, error) in
            
            guard let data = data else {
                print("Data is null  ->  \(Url.lastPathComponent)")
                failure("Data is null", 0)
                return
            }
            
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                success(json)
            }
            catch(let error) {
                print(error.localizedDescription)
                failure(error.localizedDescription, 0)
            }
            
            
        }
        
    }
    
    
}
