//
//  TermsVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 14/06/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit
import WebKit

class TermsVC: UIViewController {
    
    var webView: WKWebView!
    @objc var isPrivacyPolicy = false
    
    //    var html = """
    //<!DOCTYPE html>\r\n<html lang=\"en\">\r\n<head>\r\n  <title>Bootstrap Example</title>\r\n  <meta charset=\"utf-8\">\r\n  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\r\n  <link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css\">\r\n  <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js\"></script>\r\n  <script src=\"https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js\"></script>\r\n  <script src=\"https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js\"></script>\r\n</head>\r\n<body>\r\n\r\n<div class=\"jumbotron text-center\">\r\n  <h1>My First Bootstrap Page</h1>\r\n  <p>Resize this responsive page to see the effect!</p> \r\n</div>\r\n  \r\n<div class=\"container\">\r\n  <div class=\"row\">\r\n    <div class=\"col-sm-4\">\r\n      <h3>Column 1</h3>\r\n      <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit...</p>\r\n      <p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris...</p>\r\n    </div>\r\n    <div class=\"col-sm-4\">\r\n      <h3>Column 2</h3>\r\n      <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit...</p>\r\n      <p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris...</p>\r\n    </div>\r\n    <div class=\"col-sm-4\">\r\n      <h3>Column 3</h3>        \r\n      <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit...</p>\r\n      <p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris...</p>\r\n    </div>\r\n  </div>\r\n</div>\r\n\r\n</body>\r\n</html>\r\n
    //
    //"""
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getContentApiCall()
        navigationItem.title = isPrivacyPolicy ? "Privacy Policy".myModification() : "Terms of Use".myModification()
        navigationController?.setNavigationBarHidden(false, animated: true)
        //        navigationController?.navigationBar.barTintColor = UIColor.white
        //        navigationController?.navigationBar.tintColor = UIColor.init(red: 22, green: 151, blue: 191, a: 1)
        //        22/255.0 green:151/255.0 blue:191/255.0 alpha:1]
        //        [cont.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        //        [cont.navigationController.navigationBar setTintColor:kBarTextColor()];
    }
    
    func loadHtml(htmlStr:String){
        webView.loadHTMLString(htmlStr, baseURL: nil)
    }
    
    func getContentApiCall(){
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        let url = isPrivacyPolicy ? SwiftAPIConstants.kPrivacy_mesh2 : SwiftAPIConstants.kTerms_mesh2
        print("url = \(url)")
        ApiManager.shared().commonGetApi(withVC: self, andUrl: url, withResponse: { (response, error) in
            DispatchQueue.main.async{
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                print("response = \(response)")
                let model = try? AgreementModel.init(dictionary: response as? [AnyHashable : Any])
                print("status = \(String(describing: model?.status)) html content = \(model?.data.page_text)")
                self.loadHtml(htmlStr: model?.data.page_text ?? "")
            }
        }) { (msg, code) in
            DispatchQueue.main.async{
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                print("internet filter api failed with msg = \(msg) and code = \(code)")
                CommonModel.showAlert("Error!", msg: msg)
            }
        }
    }
}
extension TermsVC : WKUIDelegate{
    
}
