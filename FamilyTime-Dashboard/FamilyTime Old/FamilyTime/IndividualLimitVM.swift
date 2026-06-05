//
//  IndividualLimitVM.swift
//  FamilyTime
//
//  Created by Sufyan on 18/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import Foundation

class IndividualLimitVM {
    
    var limitedApp = [InstalledApp]()
    var unlimitApp = [InstalledApp]()
    var recentApp = [InstalledApp]()
    var isLimitedSelected = false
    var selection = false
    
    var tblReloader: ()->() = {}
    
    func getApps() {
        let objects = DBManager.shared.fetchDataAndConvertToModels()
        let obj = objects.sorted(by: {$0.appsTime?.getDateFromStr() ?? Date() > $1.appsTime?.getDateFromStr() ?? Date.tomorrow})
        self.limitedApp = obj.filter({$0.appLimit == "1"})
        self.unlimitApp = obj.filter({$0.appLimit == "0"})
        if self.unlimitApp.count < 3 {
                self.recentApp = self.unlimitApp
                let obj = InstalledApp(appName: "recently_installed_apps".localized)
                self.recentApp.insert(obj, at: 0)
                self.unlimitApp.removeAll()
        } else {
                var recent = Array(self.unlimitApp[0..<3])
                self.unlimitApp.removeFirst(3)
                self.unlimitApp.insert(InstalledApp(appName: "all_apps".localized), at: 0)
                let obj = InstalledApp(appName: "recently_installed_apps".localized)
                recent.insert(obj, at: 0)
                self.recentApp = recent
            
        }
        UserDefaults.standard.set(false, forKey: "reloadDB")
        DispatchQueue.main.async {
            self.tblReloader()
        }
    }
}
    
    
    
