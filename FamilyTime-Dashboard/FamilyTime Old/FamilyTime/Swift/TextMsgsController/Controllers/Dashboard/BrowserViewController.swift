//
//  BrowserViewController.swift
//  FamilyTime - Dashboard
//
//  Created by Rao Mudassar on 23/09/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import WebKit
import FirebaseAnalytics

class BrowserViewController:UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    //MARK: - VARIBALES
    var strUrl:String?
    var isComingFromUpgrade: Bool?
    var isComingFromTrial : Bool?
    var iscomingFromHistory: Bool?
    
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        guard let url = URL(string: strUrl ?? "") else {
            return
        }
        webView.contentMode = .scaleToFill
        webView.load(URLRequest(url:url))
        if let isComingFromUpgrade = isComingFromUpgrade, isComingFromUpgrade == true {
            UserDefaults.standard.set(true, forKey: UserDefaultsConstants.IS_COMING_FROM_BROWSER_UPGRADE)
            UserDefaults.standard.synchronize()
        }
        
        if let isComingFromTrial = isComingFromTrial, isComingFromTrial {
            UserDefaults.standard.set(true, forKey: UserDefaultsConstants.IS_COMING_FROM_BROWSER_TRIAL)
            UserDefaults.standard.synchronize()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        Analytics.logEvent("app_store_subscription_renew", parameters: [
            "upgrade_status": "in_app_upgrade_compeleted_external",
            "screen_name": "in_app_upgrade_screen"
        ])
    }
    
    //MARK: BUTTON ACTIONS
    @IBAction func Done(_ sender: Any) {
        if iscomingFromHistory == true{
            dismiss(animated: false, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)

        }
    }
}

//MARK: - DELEGATE METHODE
extension BrowserViewController: WKNavigationDelegate ,UIScrollViewDelegate{
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
        print("Start Request")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
        print("Failed Request")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
        print("Finished Request")
    }
}
