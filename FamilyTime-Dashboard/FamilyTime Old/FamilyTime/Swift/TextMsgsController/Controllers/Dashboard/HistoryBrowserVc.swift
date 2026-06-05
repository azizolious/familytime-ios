//
//  HistoryBrowserVc.swift
//  FamilyTime
//
//  Created by Rizwan-Apps on 08/12/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit
import WebKit

class HistoryBrowserVc: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!

    var strUrl:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: strUrl ?? "") else {
            return
        }
        webView.contentMode = .scaleToFill
        webView.load(URLRequest(url:url))
        
    }

    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: false,completion: nil)
    }
}
