//
//  ApproveAppNotification.swift
//  FamilyTime
//
//  Created by Usama-Apps on 19/01/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import Foundation

class ApproveAppNotification {
    var title : String?
    var body : String?
    var appName : String?
    var packageName : String?
    var childName : String?
    
    init(title:String?, body:String?, appName:String?, packageName:String?, childName:String?) {
        self.title = title
        self.body = body
        self.appName = appName
        self.packageName = packageName
        self.childName = childName
    }
}
