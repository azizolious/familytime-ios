//
//  Utilities.swift
//  FamilyTime
//
//  Created by iOS Dev on 20/11/2018.
//  Copyright © 2018 YumyApps. All rights reserved.
//

import Foundation
import Firebase
//import UIKit

class Utilities {
    
    
    static let shared = Utilities()
    
    func logFirebaseEvent(event name : String, params:[String:String] = ["":""], shouldLogScreen screenView : Bool = false){
        FIRAnalytics.logEvent(withName: name, parameters: params)
        
        
    }
}
