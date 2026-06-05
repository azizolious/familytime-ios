//
//  SetLimitVm.swift
//  FamilyTime
//
//  Created by Sufyan on 19/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import Foundation

class SetLimitVM {
    
    var selectedApps = [InstalledApp]()
    var customSelection = false
    let minutessArray = (0...60).map { String(format: "%02d", $0) }
    let hourArray = (0...23).map { String(format: "%02d", $0) }
    let daysArray = ["sunday".localized, "monday".localized,"tuesday".localized,"wednesday".localized,
                     "thursday".localized,"friday".localized,"saturday".localized]
    var selectedhours = ""
    var selectedMinutes = ""
    var customHour = ""
    var customMin = ""
    var isValid = false
    var boolArr = [false, false, false, false, false, false, false]
    
    
    func setLimit(array: [InstalledApp], callback:@escaping ()->()) {
        
        let params = getParamsForLimit(array: array)
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        CoreManager.putLimitToApp(params: params, childID: childID, callBack: {
            for obj in array {
                var object = obj
                object.isSelected = false
                object.appLimit = "1"
                DBManager.shared.fetchModelAndUpdate(obj: object)
            }
            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: "reloadDB")
                callback()
            }
            
        })
    }
    
    func getParamsForLimit(array: [InstalledApp]) -> [String: Any] {
        var json = [[String: Any]]()
        for obj in array{
            let params: [String:Any] = [
                "installed_app_id": obj.installedappID ?? 0,
                "monday":obj.monday ?? 0,
                "tuesday":obj.tuesday ?? 0,
                "wednesday":obj.wednesday ?? 0,
                "thursday":obj.thursday ?? 0,
                "friday":obj.friday ?? 0,
                "saturday":obj.saturday ?? 0,
                "sunday":obj.sunday ?? 0,
                "app_limit": 1]
            json.append(params)
        }
        let param = ["apps": json]
        return param
    }
    func getTimeInSec(hour: String, minute: String)->Int {
        let h = Int(hour) ?? 00
        let min = Int(minute) ?? 00
        let hourTosec = h * 3600
        let minuteToSec = min * 60
        let totalSec = hourTosec + minuteToSec
        return totalSec
    }
    func setCustomLimit(index: Int, hour: String, minute: String) {
        let time = getTimeInSec(hour: hour, minute: minute)
        for i in 0..<selectedApps.count {
            switch index {
            case 0:
                selectedApps[i].sunday = time
                break
            case 1:
                selectedApps[i].monday = time
                break
            case 2:
                selectedApps[i].tuesday = time
                break
            case 3:
                selectedApps[i].wednesday = time
                break
            case 4:
                selectedApps[i].thursday = time
                break
            case 5:
                selectedApps[i].friday = time
                break
            case 6:
                selectedApps[i].saturday = time
                selectedApps[i].saturday = time
                break
            default:
                break
            }
        }
    }
    
    func applyTapped(callback:@escaping ()->()) {
            if !customSelection {
                if !selectedhours.isEmpty || !selectedMinutes.isEmpty {
                    print("seklected", selectedMinutes)
                    let time = getTimeInSec(hour: selectedhours, minute: selectedMinutes)
                    for i in 0..<selectedApps.count {
                        selectedApps[i].sunday = time
                        selectedApps[i].monday = time
                        selectedApps[i].tuesday = time
                        selectedApps[i].wednesday = time
                        selectedApps[i].thursday = time
                        selectedApps[i].friday = time
                        selectedApps[i].saturday = time
                    }
                }
                setLimit(array: selectedApps, callback: callback)
            } else {
                print(selectedApps)
                setLimit(array: selectedApps, callback: callback)
            }
    }
    func getTimeForSpecificDay(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let str = "\(hours)h \(minutes)min"
        return str
    }
}
