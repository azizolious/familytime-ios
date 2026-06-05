//
//  DataBaseUtility.swift
//  FamilyTime
//
//  Created by Sana Ullah on 01/01/2019. //---NEW YEAR 2019---//
//  Copyright © 2019 YumyApps. All rights reserved.
//

import Foundation

//class DB_Utility{
//    
//    static let shared = DB_Utility()
//        
//    //MARK: - DASHBOARD METHODS SAVE MODELS TO DB
//    
//    init() {
//        // Inside your application(application:didFinishLaunchingWithOptions:)
//        
//        let configuration = Realm.Configuration(
//            schemaVersion: 1,
//            migrationBlock: { migration, oldSchemaVersion in
//                if oldSchemaVersion < 1 {
//                    // if you added a new property or removed a property you don't
//                    // have to do anything because Realm automatically detects that
//                }
//        })
//        Realm.Configuration.defaultConfiguration = configuration
//        
//        // opening the Realm file now makes sure that the migration is performed
//        realm = try! Realm()
//        
//        
//    }
//    
//    func populateDBFromDashboardModel(dashboard:Dashboard, shouldClearDb:Bool = false, shouldUpdate:Bool = false){
////        let realm = try! Realm()
//        
//        if shouldClearDb{
//            clearPreviousChildrenFromDb()
//        }
//        
//        //---UPDATE---//
//        if shouldUpdate
//        {
//            //---IF DB CHILD_ID NOT FOUND IN SERVER CHILDREN LIST THEN DELETE THAT CHILD FROM DB---//
//            //updateDbIfSomeDeletedFromServer(dashboard: dashboard)
//            //---CREATE NEW CHILD IN DB IF SERVER CHILD_ID NOT FOUND IN DB---//
//           // updateDbIfSomeAddedFromServer(dashboard: dashboard)
//            
//            //---UPDATE INFO AND DAILY LIMIT GET FROM SERVER---//
//            for childModel in dashboard.children{
//                let child = childModel as! DashboardChild
//                
//                let dbChild = realm.objects(Children_DB.self).filter("child_id == \(child.child_id)").first
//                
//                if dbChild != nil{
//                    try! realm.write {
//                        dbChild?.info             = updateChildInfo(child: child)
//                        dbChild?.daily_limit      = populateChildDailyLimit(limitModel: child.dailyLimit ?? DashboardChildDailyLimit())
////                        dbChild?.package_features=savePackageFeaturesOfChild(childId: child.child_id, arr: child.package_features as! [DashboardChildPackageFeature])
//                    }
//                    savePackageFeaturesOfChild(childId: child.child_id, arr: child.package_features as! [DashboardChildPackageFeature], shouldUpdate: true)
//                }
//            }
//        }
//        else
//        {
//            for childModel in dashboard.children{
//                let child = childModel as! DashboardChild
//                
//                print(child)
//                print(child.package_name ?? "NA" )
//                print(child.name ?? "NA" )
//                
//                createNewDbChildFromServer(child: child)
//            }
//        }
//        
//        print("db children count after = \(realm.objects(Children_DB.self).count)")
//    }
//    
//    func createNewDbChildFromServer(child:DashboardChild){
//        let newChild = Children_DB()
//        
//        newChild.child_id         = child.child_id
//        newChild.info             = populateChildInfo(child: child)
//        newChild.device_info      = populateChildDeviceInfo(deviceInfo: child.deviceInfo ?? DashboardChildDeviceInfo())
//        newChild.daily_limit      = populateChildDailyLimit(limitModel: child.dailyLimit ?? DashboardChildDailyLimit())
//       // newChild.preferences      = populateChildDailyLimit(limitModel: child.dailyLimit ?? DashboardChildDailyLimit())
//        
//        savePreferencesOfChild(childId: child.child_id, arr: child.preferences as! [DashboardChildPreference])
//        saveNotificationsOfChild(childId: child.child_id, arr: child.notifications as! [DashboardChildNotification])
//        savePackageFeaturesOfChild(childId: child.child_id, arr: child.package_features as! [DashboardChildPackageFeature])
//        
//        try! realm.write {
//            self.realm.add(newChild, update: true)
//        }
//    }
//    
//    func populateChildDailyLimit(limitModel:DashboardChildDailyLimit) -> Daily_limit_DB{
//        let limit = Daily_limit_DB()
//        
//        limit.child_id        = limitModel.child_id
//        limit.duration        = Double(limitModel.duration)
//        limit.remaining       = Double(limitModel.remaining)
//        limit.remaining_limit = Double(limitModel.remaining_limit)
//        limit.auto_add        = limitModel.auto_add
//        limit.is_active       = limitModel.is_active
//        
//        print("db limit = \(limit)")
//        return limit
//    }
//    
//
//    func savePreferencesOfChild(childId:Int, arr:[DashboardChildPreference], shouldUpdate:Bool = false){
//        
//        //---DELETE PREV LIST---//
//        if shouldUpdate{
//            var prefList    = realm.objects(Preferences_DB.self).filter("child_id == \(childId)")
//            print("count after deleting prev pref list = \(prefList.count)")
//            try! realm.write {
//                self.realm.delete(prefList)
//            }
//            
//            prefList    = realm.objects(Preferences_DB.self).filter("child_id == \(childId)")
//            print("count after deleting prev pref list = \(prefList.count)")
//        }
//        
//        for prefModel in arr{
//            let pref    = Preferences_DB()
//            
//            pref.child_id   = childId
//            pref.name       = prefModel.name   ?? ""
//            pref.status     = prefModel.status
//            pref.value      = prefModel.value  ?? ""
//            
//            try! realm.write {
//                self.realm.add(pref)
//            }
//        }
//    }
//    
//
//    func saveNotificationsOfChild(childId:Int, arr:[DashboardChildNotification], shouldUpdate:Bool=false){
//        //---DELETE PREV LIST---//
//        if shouldUpdate{
//            var notifList   = realm.objects(Notifications_DB.self).filter("child_id == \(childId)")
//            print("count after deleting prev pref list = \(notifList.count)")
//            
//            try! realm.write {
//                self.realm.delete(notifList)
//            }
//            
//            notifList    = realm.objects(Notifications_DB.self).filter("child_id == \(childId)")
//            print("count after deleting prev pref list = \(notifList.count)")
//        }
//        
//        for model in arr{
//            let notif = Notifications_DB()
//            
//            notif.child_id  = childId
//            notif.name      = model.name   ?? ""
//            notif.status    = model.status
//            notif.value     = model.value  ?? ""
//            
//            print("notif name = \(notif.name) status = \(notif.status)")
//            
//            try! realm.write {
//                self.realm.add(notif)
//            }
//        }
//    }
//    
//
//    func savePackageFeaturesOfChild(childId:Int, arr:[DashboardChildPackageFeature], shouldUpdate:Bool = false){
//        
//        if shouldUpdate{
//            var prefList    = realm.objects(Package_features_DB.self).filter("child_id == \(childId)")
//            print("count after deleting prev pref list = \(prefList.count)")
//            try! realm.write {
//                self.realm.delete(prefList)
//            }
//            
//            prefList    = realm.objects(Package_features_DB.self).filter("child_id == \(childId)")
//            print("count after deleting prev pref list = \(prefList.count)")
//        }
//        for model in arr
//        {
//            let package            = Package_features_DB()
//            
//            package.child_id       = childId
//            package.feature_name   = model.feature_name   ?? ""
//            package.package_id     = model.package_id
//            package.is_count_based = model.is_count_based
//            package.count_limit    = model.count_limit
//            package.is_time_based  = model.is_time_based
//            package.time_limit     = model.time_limit
//            package.active         = model.is_active
//
//            try! realm.write {
//                self.realm.add(package)
//            }
//        }
//        
//        let pkgList     = realm.objects(Package_features_DB.self).filter("child_id == \(childId)")
//        print("pref list count = \(pkgList.count)")
//    }
//    
//    //MARK: - CLEAR DB---//
//    
//    func updateDbIfSomeDeletedFromServer(dashboard:Dashboard){
//        let dbChildrenList = realm.objects(Children_DB.self)
//        
//        for dbChild in dbChildrenList{
//            var dbChildFound = false
//            
//            for childModel in dashboard.children{
//                let serverChild = childModel as! DashboardChild
//                
//                if serverChild.child_id == dbChild.child_id{
//                    dbChildFound = true
//                    break
//                }
//            }//---END INNER LOOP---//
//            
//            //---IF DB CHILD_ID NOT FOUND IN SERVER CHILDREN LIST THEN DELETE THAT CHILD FROM DB---//
//            if dbChildFound == false{
//                deleteChildFromDb(childId: dbChild.child_id)
//            }
//        }//---END OUTER LOOP---//
//    }
//    
//    
//    func updateDbIfSomeAddedFromServer(dashboard:Dashboard){
//        //---CREATE NEW CHILD IN DB IF SERVER CHILD_ID NOT FOUND IN DB---//
//        
//        let dbChildrenList = realm.objects(Children_DB.self)
//        
//        for childModel in dashboard.children{
//            let serverChild = childModel as! DashboardChild
//            
//            var serverChildFound = false
//            
//            for dbChild in dbChildrenList{
//                if dbChild.child_id == serverChild.child_id{
//                    serverChildFound = true
//                    break
//                }
//            }//---END INNER LOOP---//
//            
//            if serverChildFound == false{
//                //---CREATE NEW CHILD---//
//                createNewDbChildFromServer(child: serverChild)
//            }
//            
//        }//---END OUTER LOOP---//
//    }
//    
//    func clearPreviousChildrenFromDb(){
////        let realm = try! Realm()
//        let allChildren = realm.objects(Children_DB.self)
//        let prefList    = realm.objects(Preferences_DB.self)
//        let notifList   = realm.objects(Notifications_DB.self)
//        let pkgList     = realm.objects(Package_features_DB.self)
//        
//        print("child count before     = \(allChildren.count)")
//        print("preflist count before  = \(prefList.count)")
//        print("notifLIst count before = \(notifList.count)")
//        print("pkgLIst count before   = \(pkgList.count)")
//        
//        try! realm.write {
//            self.realm.delete(allChildren)
//            self.realm.delete(prefList)
//            self.realm.delete(notifList)
//            self.realm.delete(pkgList)
//        }
//    }
//    
//    
//    func deleteChildFromDb(childId:Int){
////        let realm = try! Realm()
//        print("child id to delete = \(childId)")
//        
//        let child       = realm.objects(Children_DB.self).filter("child_id == \(childId)")
//        let prefList    = realm.objects(Preferences_DB.self).filter("child_id == \(childId)")
//        let notifList   = realm.objects(Notifications_DB.self).filter("child_id == \(childId)")
//        let pkgList     = realm.objects(Package_features_DB.self).filter("child_id == \(childId)")
//        
//        
//        try! realm.write {
//            self.realm.delete(child)
//            self.realm.delete(prefList)
//            self.realm.delete(notifList)
//            self.realm.delete(pkgList)
//        }
//        
//        print("specific child deleted from db with child_id = \(childId)")
//    }
//}

