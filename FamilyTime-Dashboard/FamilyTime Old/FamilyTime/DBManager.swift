



//
//  DBManager.swift
//  FamilyTime
//
//  Created by Sufyan on 18/09/2023.
//
import Foundation
import CoreData

class DBManager {
    
    static let shared = DBManager()
    var appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
    //var context = appDel.persistentContainer.viewContext
    //MARK: Pass ModelData to save in DB
    func saveDataToDB(entityName: EntityName,ModelData: Data, completion:()->()) {
        deleteDataFromDB(entityName: entityName) {
            let entity = NSEntityDescription.entity(forEntityName: entityName.rawValue, in: self.appDel.persistentContainer.viewContext)
            let data = NSManagedObject(entity: entity!, insertInto: self.appDel.persistentContainer.viewContext)
            data.setValue(ModelData, forKey: entityName.attribute)
            self.appDel.saveContext()
            completion()
        }
    }
    //MARK: Delete ModelData in DB
    private func deleteDataFromDB(entityName: EntityName, compla:()->()){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try appDel.persistentContainer.viewContext.execute(deleteRequest)
            try appDel.persistentContainer.viewContext.save()
            compla()
        } catch let error as NSError {
            // TODO: handle the error
            print("connot be deleted", error.localizedDescription)
        }
    }
    //MARK: Get Any Model (Generic) from DB
    func getModelDataFromDB<T:Codable>(entityName: EntityName, callBack: ((T?, DBError?)->())?) {
        let decoder = JSONDecoder()
        let supplication = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        do {
            let results = try appDel.persistentContainer.viewContext.fetch(supplication) as? [NSManagedObject]
            print(results?.count as Any)
            if results?.count == 0 {
                callBack?(nil, .noData)
                return
            }
            let dataId = results![0].value(forKey: entityName.attribute) as? Data
            
            do {
                let decodedModel = try decoder.decode(T.self, from: dataId!)
                callBack?(decodedModel, nil)
            } catch {
                // Handle decoding errors
                print("Decoding Error: \(error)")
            }
        }
        catch{
            print("Fetch Failed: \(error)")
        }
    }
    func deleteData(entityName: String){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try appDel.persistentContainer.viewContext.execute(deleteRequest)
            try appDel.persistentContainer.viewContext.save()
        } catch let error as NSError {
            // TODO: handle the error
            print("connot be deleted", error.localizedDescription)
        }
    }
    func saveModelsToCoreData(myModelArray: [InstalledApp]) {
        deleteData(entityName: "ControlListApps")
        let context = self.appDel.persistentContainer.viewContext
        
        for model in myModelArray {
            let entity = NSEntityDescription.entity(forEntityName: "ControlListApps", in: context)
            let coreDataObject = NSManagedObject(entity: entity!, insertInto: context)
            
            // Map MyModel properties to Core Data object attributes
            coreDataObject.setValue(model.appName, forKey: "appName")
            coreDataObject.setValue(model.appLimit, forKey: "appLimit")
            coreDataObject.setValue(model.childID, forKey: "childID")
            coreDataObject.setValue(model.uninstalled, forKey: "uninstalled")
            coreDataObject.setValue(model.friday, forKey: "friday")
            coreDataObject.setValue(model.saturday, forKey: "saturday")
            coreDataObject.setValue(model.sunday, forKey: "sunday")
            coreDataObject.setValue(model.monday, forKey: "monday")
            coreDataObject.setValue(model.tuesday, forKey: "tuesday")
            coreDataObject.setValue(model.wednesday, forKey: "wednesday")
            coreDataObject.setValue(model.thursday, forKey: "thursday")
            coreDataObject.setValue(model.installedappID, forKey: "installedappID")
            coreDataObject.setValue(model.appsTime, forKey: "appsTime")
            coreDataObject.setValue(model.isMonitor, forKey: "isMonitor")
            coreDataObject.setValue(model.appPackageName, forKey: "appPackageName")
            coreDataObject.setValue(model.isBlacklisted, forKey: "isBlacklisted")
            coreDataObject.setValue(model.inDailyLimit, forKey: "inDailyLimit")
            
            coreDataObject.setValue(model.size, forKey: "size")
            coreDataObject.setValue(model.appCategory, forKey: "appCategory")
            coreDataObject.setValue(model.dateCreated, forKey: "dateCreated")
            coreDataObject.setValue(model.dateModified, forKey: "dateModified")
            coreDataObject.setValue(model.deleted, forKey: "deletedm")
            
            // Save the context
            do {
                try context.save()
            } catch {
                print("Error saving data to Core Data: \(error)")
            }
        }
    }
    func setSocialHistoryToCoreData(myModelArray: [SocialApp]) {
        
        let context = self.appDel.persistentContainer.viewContext
        
        for model in myModelArray {
            let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.SOCIAL_HISTORY_DATA, in: context)
            let coreDataObject = NSManagedObject(entity: entity!, insertInto: context)
            print("appname:",model.appName as Any)
            print("childID:",model.childID as Any)
            // Map MyModel properties to Core Data object attributes
            coreDataObject.setValue(model.appName ?? "", forKey: "app_name")
            coreDataObject.setValue(model.childID ?? 0, forKey: "child_id")
            coreDataObject.setValue(model.appPackage ?? "", forKey: "app_package")
            coreDataObject.setValue(model.date, forKey: "date")
            coreDataObject.setValue(model.contentType, forKey: "content_type")
            coreDataObject.setValue(model.contactName, forKey: "contact_name")
            coreDataObject.setValue(model.body, forKey: "body")
            coreDataObject.setValue(model.url, forKey: "url")
            coreDataObject.setValue(model.fromMe, forKey: "from_me")
            coreDataObject.setValue(model.isRead, forKey: "isRead")
            // Save the context
            do {
                try context.save()
            } catch {
                print("Error saving data to Core Data: \(error)")
            }
        }
    }
    
    func saveSocialHistoryToCoreData(myModelArray: [SocialApp]) {
        let context = self.appDel.persistentContainer.viewContext
        
        // Prepare an array of dictionaries for batch insertion
        var objectsToInsert: [[String: Any]] = []
        if #available(iOS 13.0, *) {
            for model in myModelArray {
                let object: [String: Any] = [
                    "app_name": model.appName ?? "",
                    "child_id": model.childID ?? 0,
                    "app_package": model.appPackage ?? "",
                    "date": model.date ?? Date(),
                    "content_type": model.contentType ?? "",
                    "contact_name": model.contactName ?? "",
                    "body": model.body ?? "",
                    "url": model.url ?? "",
                    "from_me": model.fromMe ?? "",
                    "isRead": model.isRead ?? 0
                ]
                objectsToInsert.append(object)
            }
            let batchInsert = NSBatchInsertRequest(entity: NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.SOCIAL_HISTORY_DATA, in: context)!, objects: objectsToInsert)
            do {
                try context.execute(batchInsert)
                print("Batch insertion successful.")
            } catch {
                print("Error during batch insertion: \(error)")
            }
        } else {
            setSocialHistoryToCoreData(myModelArray: myModelArray)
        }
    }
    
    func fetchSocialAppsHistory(appIdentifier: String, date: String) -> [SocialApp] {
        let outputDateString = convertDateString(date, fromFormat: "dd MMMM yyyy", toFormat: "yyyy-MM-dd")
        var myModels: [SocialApp] = []
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.SOCIAL_HISTORY_DATA)
        let predicate = NSPredicate(format: "child_id = %d", id)
        let appID = NSPredicate(format: "app_package = %@", appIdentifier)
        let time = NSPredicate(format: "date BEGINSWITH[cd] %@", outputDateString ?? "")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appID,time])
        fetchRequest.predicate = compoundPredicate
        
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [NSManagedObject]() {
                // Create a new instance of your MyModel object
                var object = SocialApp()
                // Map Core Data object attributes to MyModel properties
                object.appName = coreDataObject.value(forKey: "app_name") as? String
                object.childID   = coreDataObject.value(forKey: "child_id") as? Int
                object.appPackage  = coreDataObject.value(forKey: "app_package") as? String
                object.date =  coreDataObject.value(forKey: "date") as? String
                object.contentType = coreDataObject.value(forKey: "content_type") as? String
                object.contactName = coreDataObject.value(forKey: "contact_name") as? String
                object.body = coreDataObject.value(forKey: "body") as? String
                object.url = coreDataObject.value(forKey: "url") as? String
                object.fromMe =  coreDataObject.value(forKey: "from_me") as? String
                object.isRead =  coreDataObject.value(forKey: "isRead") as? Int
                
                print(object)
                myModels.append(object)
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        
        return myModels
    }
    func fetchSocialAppsMsg(appIdentifier: String, thread: String) -> [SocialApp] {
        var myModels: [SocialApp] = []
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.SOCIAL_HISTORY_DATA)
        let predicate = NSPredicate(format: "child_id = %d", id)
        let appID = NSPredicate(format: "app_package = %@", appIdentifier)
        let time = NSPredicate(format: "contact_name = %@", thread)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appID,time])
        fetchRequest.predicate = compoundPredicate
        
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [NSManagedObject]() {
                // Create a new instance of your MyModel object
                var object = SocialApp()
                // Map Core Data object attributes to MyModel properties
                object.appName = coreDataObject.value(forKey: "app_name") as? String
                object.childID   = coreDataObject.value(forKey: "child_id") as? Int
                object.appPackage  = coreDataObject.value(forKey: "app_package") as? String
                object.date =  coreDataObject.value(forKey: "date") as? String
                object.contentType = coreDataObject.value(forKey: "content_type") as? String
                object.contactName = coreDataObject.value(forKey: "contact_name") as? String
                object.body = coreDataObject.value(forKey: "body") as? String
                object.url = coreDataObject.value(forKey: "url") as? String
                object.fromMe =  coreDataObject.value(forKey: "from_me") as? String
                object.isRead =  coreDataObject.value(forKey: "isRead") as? Int
                
                print(object)
                myModels.append(object)
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        
        return myModels
    }
    func fetchAllSocialHistory(appIdentifier: String) -> [SocialApp] {
        var myModels: [SocialApp] = []
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.SOCIAL_HISTORY_DATA)
        let predicate = NSPredicate(format: "child_id = %d", id)
        let appID = NSPredicate(format: "app_package = %@", appIdentifier)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appID])
        fetchRequest.predicate = compoundPredicate
        
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [NSManagedObject]() {
                // Create a new instance of your MyModel object
                var object = SocialApp()
                // Map Core Data object attributes to MyModel properties
                object.appName = coreDataObject.value(forKey: "app_name") as? String
                object.childID   = coreDataObject.value(forKey: "child_id") as? Int
                object.appPackage  = coreDataObject.value(forKey: "app_package") as? String
                object.date =  coreDataObject.value(forKey: "date") as? String
                object.contentType = coreDataObject.value(forKey: "content_type") as? String
                object.contactName = coreDataObject.value(forKey: "contact_name") as? String
                object.body = coreDataObject.value(forKey: "body") as? String
                object.url = coreDataObject.value(forKey: "url") as? String
                object.fromMe =  coreDataObject.value(forKey: "from_me") as? String
                object.isRead =  coreDataObject.value(forKey: "isRead") as? Int
                
                print(object)
                myModels.append(object)
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        
        return myModels
    }
    func fetchAllSocialHistory() -> [SocialApp] {
        var myModels: [SocialApp] = []
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.SOCIAL_HISTORY_DATA)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [NSManagedObject]() {
                // Create a new instance of your MyModel object
                var object = SocialApp()
                // Map Core Data object attributes to MyModel properties
                object.appName = coreDataObject.value(forKey: "app_name") as? String
                object.childID   = coreDataObject.value(forKey: "child_id") as? Int
                object.appPackage  = coreDataObject.value(forKey: "app_package") as? String
                object.date =  coreDataObject.value(forKey: "date") as? String
                object.contentType = coreDataObject.value(forKey: "content_type") as? String
                object.contactName = coreDataObject.value(forKey: "contact_name") as? String
                object.body = coreDataObject.value(forKey: "body") as? String
                object.url = coreDataObject.value(forKey: "url") as? String
                object.fromMe =  coreDataObject.value(forKey: "from_me") as? String
                object.isRead =  coreDataObject.value(forKey: "isRead") as? Int
                
                print(object)
                myModels.append(object)
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        
        return myModels
    }
    
    func fetchAndUpdateSocialHistory(socialApps: SocialApp) {
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.SOCIAL_HISTORY_DATA)
        let predicate = NSPredicate(format: "child_id = %d", id)
        let appdate = NSPredicate(format: "date = %@", socialApps.date ?? "")
        let conName = NSPredicate(format: "contact_name = %@", socialApps.contactName ?? "")
        let appName = NSPredicate(format: "app_name = %@", socialApps.appName ?? "")
        let appBody = NSPredicate(format: "body = %@", socialApps.body ?? "")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appdate, conName, appName, appBody])
        fetchRequest.predicate = compoundPredicate
        
        do {
            let matchingObjects = try self.appDel.persistentContainer.viewContext.fetch(fetchRequest)  as? [NSManagedObject]
            if matchingObjects?.count != 0{
                for obj in matchingObjects ?? [NSManagedObject]() {
                    let values = obj
                    values.setValue(1, forKey: "isRead")
                    saveContext()
                }
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        
        //return myModels
    }
    func fetchDataAndConvertToModels() -> [InstalledApp] {
        var myModels: [InstalledApp] = []
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ControlListApps")
        //let idPredicate = NSPredicate(format: "childID == %@", [id])
        fetchRequest.predicate = NSPredicate(format: "childID = %@", argumentArray: [id])
        
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [NSManagedObject]() {
                // Create a new instance of your MyModel object
                var object = InstalledApp()
                // Map Core Data object attributes to MyModel properties
                object.installedappID = coreDataObject.value(forKey: "installedappID") as? Int
                object.appName = coreDataObject.value(forKey: "appName") as? String
                object.childID = coreDataObject.value(forKey: "childID") as? Int
                object.uninstalled = coreDataObject.value(forKey: "uninstalled") as? Int
                object.saturday = coreDataObject.value(forKey: "saturday") as? Int
                object.sunday = coreDataObject.value(forKey: "sunday") as? Int
                object.monday = coreDataObject.value(forKey: "monday") as? Int
                object.tuesday = coreDataObject.value(forKey: "tuesday") as? Int
                object.wednesday = coreDataObject.value(forKey: "wednesday") as? Int
                object.thursday = coreDataObject.value(forKey: "thursday") as? Int
                object.friday = coreDataObject.value(forKey: "friday") as? Int
                object.appLimit = coreDataObject.value(forKey: "appLimit") as? String
                object.appsTime = coreDataObject.value(forKey: "appsTime") as? String
                object.isMonitor = coreDataObject.value(forKey: "isMonitor") as? Int
                object.appPackageName = coreDataObject.value(forKey: "appPackageName") as? String
                object.isBlacklisted = coreDataObject.value(forKey: "isBlacklisted") as? Int
                object.inDailyLimit = coreDataObject.value(forKey: "inDailyLimit") as? Int
                
                object.size = coreDataObject.value(forKey: "size") as? Int
                object.appCategory = coreDataObject.value(forKey: "appCategory") as? String
                object.dateCreated = coreDataObject.value(forKey: "dateCreated") as? String
                object.dateModified = coreDataObject.value(forKey: "dateModified") as? String
                object.deleted = coreDataObject.value(forKey: "deletedm") as? Int
                
                print(object)
                myModels.append(object)
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        
        return myModels
    }
    func fetchFilteredAppsCount(fromDate: Date, toDate: Date) -> Int {
        var filteredAppsCount = 0
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ControlListApps")
        fetchRequest.predicate = NSPredicate(format: "childID = %@", argumentArray: [id])
        
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [NSManagedObject]() {
                // Retrieve the appsTime attribute from Core Data
                if let appsTimeString = coreDataObject.value(forKey: "appsTime") as? String {
                    // Convert the apps time string to a Date object
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    if let appsTime = dateFormatter.date(from: appsTimeString) {
                        // Check if the apps time falls within the specified date range
                        if appsTime >= fromDate && appsTime <= toDate {
                            filteredAppsCount += 1
                        }
                    }
                }
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        
        return filteredAppsCount
    }
    
    private func saveContext () {
        if self.appDel.persistentContainer.viewContext.hasChanges {
            do {
                try self.appDel.persistentContainer.viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func fetchModelAndUpdate(obj:InstalledApp) {
        //let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ControlListApps")
        
        let predicate = NSPredicate(format: "childID = %d", obj.childID!)
        let appID = NSPredicate(format: "installedappID = %d", obj.installedappID!)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appID])
        fetchRequest.predicate = compoundPredicate
        //fetchRequest.predicate = predicate
        
        do {
            let matchingObjects = try self.appDel.persistentContainer.viewContext.fetch(fetchRequest)  as? [NSManagedObject]
            if matchingObjects?.count != 0{
                guard let valuess = matchingObjects else {return}
                let values = valuess.first
                values!.setValue(obj.appLimit, forKey: "appLimit")
                values!.setValue(obj.sunday, forKey: "sunday")
                values!.setValue(obj.monday, forKey: "monday")
                values!.setValue(obj.tuesday, forKey: "tuesday")
                values!.setValue(obj.wednesday, forKey: "wednesday")
                values!.setValue(obj.thursday, forKey: "thursday")
                values!.setValue(obj.friday, forKey: "friday")
                values!.setValue(obj.saturday, forKey: "saturday")
                values!.setValue(obj.isBlacklisted, forKey: "isBlacklisted")
                values!.setValue(obj.inDailyLimit, forKey: "inDailyLimit")
                saveContext()
            }
            //return matchingObjects.first
        } catch {
            print("Error fetching data from Core Data: \(error)")
            //return nil
        }
    }
    func fetchAppAndUpdate(obj:InstalledApp) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ControlListApps")
        let predicate = NSPredicate(format: "childID = %d", obj.childID!)
        let appID = NSPredicate(format: "installedappID = %d", obj.installedappID!)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appID])
        fetchRequest.predicate = compoundPredicate
        
        do {
            let matchingObjects = try self.appDel.persistentContainer.viewContext.fetch(fetchRequest)  as? [NSManagedObject]
            if matchingObjects?.count != 0{
                guard let valuess = matchingObjects else {return}
                let values = valuess.first
                values!.setValue(obj.inDailyLimit, forKey: "inDailyLimit")
                saveContext()
            }
            //return matchingObjects.first
        } catch {
            print("Error fetching data from Core Data: \(error)")
            //return nil
        }
    }
    func fetchAppAndUpdateMonitor(obj:SocialMonitoringApps) {
        //let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ControlListApps")
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let predicate = NSPredicate(format: "childID = %d", id)
        let appID = NSPredicate(format: "appPackageName = %@", obj.pkgName)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appID])
        fetchRequest.predicate = compoundPredicate
        //fetchRequest.predicate = predicate
        
        do {
            let matchingObjects = try self.appDel.persistentContainer.viewContext.fetch(fetchRequest)  as? [NSManagedObject]
            if matchingObjects?.count != 0{
                guard let valuess = matchingObjects else {return}
                let values = valuess.first
                values!.setValue(obj.isMonitor.boolToInt(), forKey: "isMonitor")
                saveContext()
            }
            //return matchingObjects.first
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
    }
    func saveControlsModel(myModelArray: [Control]) {
        deleteData(entityName: "ControlsMainList")
        let context = self.appDel.persistentContainer.viewContext
        
        for model in myModelArray {
            let entity = NSEntityDescription.entity(forEntityName: "ControlsMainList", in: context)
            let coreDataObject = NSManagedObject(entity: entity!, insertInto: context)
            coreDataObject.setValue(model.featureID, forKey: "featureID")
            coreDataObject.setValue(model.identifier, forKey: "identifier")
            coreDataObject.setValue(model.childID, forKey: "childID")
            coreDataObject.setValue(model.state, forKey: "state")
            coreDataObject.setValue(model.value, forKey: "value")
            // Save the context
            do {
                try context.save()
            } catch {
                print("Error saving data to Core Data: \(error)")
            }
        }
    }
    
    func saveContentFiltersModel(myModelArray: [ContentFilter]?) {
        deleteData(entityName: "ContentFilters")
        guard let myModelArray = myModelArray, !myModelArray.isEmpty else {
            print("Error: Content filter array is nil or empty")
            return
        }
        
        let context = self.appDel.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "ContentFilters", in: context) else {
            print("Error: Unable to retrieve entity description")
            return
        }
        
        var contentFilterEntities: [ContentFilters] = []
        
        for model in myModelArray {
            let contentFilterEntity = ContentFilters(entity: entity, insertInto: context)
            contentFilterEntity.id = Int64(model.id)
            contentFilterEntity.childID = Int64(model.childId)
            contentFilterEntity.movies = model.mdmPayload.movies.stringValue
            contentFilterEntity.tvshows = model.mdmPayload.tvShows.stringValue
            contentFilterEntity.apps = model.mdmPayload.apps.stringValue
            contentFilterEntity.bookstoreErotica = "\(model.mdmPayload.bookstoreErotica.value)"
            contentFilterEntity.explicitContent = "\(model.mdmPayload.explicitContent.value)"
            
            contentFilterEntities.append(contentFilterEntity)
        }
        
        do {
            try context.save()
            print("Content filters saved successfully.")
        } catch {
            print("Error saving data to Core Data: \(error)")
        }
    }
    
    func fetchContentFiltersFromCoreData(forChildID childID: Int) -> [ContentFilters]? {
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ContentFilters> = ContentFilters.fetchRequest()
        
        // Add a predicate to filter by childID
        fetchRequest.predicate = NSPredicate(format: "childID == %ld", childID)
        
        do {
            let contentFilters = try context.fetch(fetchRequest)
            return contentFilters
        } catch {
            print("Error fetching content filters from Core Data: \(error)")
            return nil
        }
    }
    
    func updateContentFiltersModel(childID: Int, updatedData: [String: Any]) {
        // Fetch existing content filters for the childID
        guard let contentFilters = fetchContentFiltersFromCoreData(forChildID: childID) else {
            print("Error: No content filters found for childID \(childID)")
            return
        }
        
        // Update each content filter with the updated data
        for contentFilter in contentFilters {
            if let apps = updatedData["apps"] as? String {
                contentFilter.apps = apps
            }
            if let movies = updatedData["movies"] as? String {
                contentFilter.movies = movies
            }
            if let tvshows = updatedData["tvshows"] as? String {
                contentFilter.tvshows = tvshows
            }
            if let explicitContent = updatedData["explicitContent"] as? Bool {
                contentFilter.explicitContent = "\(explicitContent)"
            }
            if let bookstoreErotica = updatedData["bookstoreErotica"] as? Bool {
                contentFilter.bookstoreErotica = "\(bookstoreErotica)"
            }
        }
        
        // Save changes to Core Data
        saveChangesToCoreData()
    }
    
    func saveChangesToCoreData() {
        do {
            try appDel.persistentContainer.viewContext.save()
            print("Content filters updated successfully.")
        } catch {
            print("Error saving data to Core Data: \(error)")
        }
    }
    //    func fetchContentFiltersFromCoreData() -> [ContentFilters]? {
    //        let context = self.appDel.persistentContainer.viewContext
    //        let fetchRequest: NSFetchRequest<ContentFilters> = ContentFilters.fetchRequest()
    //
    //        do {
    //            let contentFilters = try context.fetch(fetchRequest)
    //            return contentFilters
    //        } catch {
    //            print("Error fetching content filters from Core Data: \(error)")
    //            return nil
    //        }
    //    }
    
    func saveSchedule(myModelArray: [Schedule]) {
        let context = self.appDel.persistentContainer.viewContext
        for model in myModelArray {
            let entity = NSEntityDescription.entity(forEntityName: "Schedules", in: context)
            let coreDataObject = NSManagedObject(entity: entity!, insertInto: context)
            coreDataObject.setValue(model.id, forKey: "id")
            coreDataObject.setValue(model.name, forKey: "name")
            coreDataObject.setValue(model.childID, forKey: "childID")
            coreDataObject.setValue(model.function, forKey: "functionss")
            coreDataObject.setValue(model.type, forKey: "type")
            coreDataObject.setValue(model.startTime, forKey: "startTime")
            coreDataObject.setValue(model.endTime, forKey: "endTime")
            coreDataObject.setValue(model.onMonday, forKey: "onMonday")
            coreDataObject.setValue(model.onTuesday, forKey: "onTuesday")
            coreDataObject.setValue(model.onWednesday, forKey: "onWednesday")
            coreDataObject.setValue(model.onThursday, forKey: "onThursday")
            coreDataObject.setValue(model.onFriday, forKey: "onFriday")
            coreDataObject.setValue(model.onSaturday, forKey: "onSaturday")
            coreDataObject.setValue(model.onSunday, forKey: "onSunday")
            coreDataObject.setValue(model.status, forKey: "status")
            coreDataObject.setValue(model.isPredefined, forKey: "isPredefined")
            do {
                try context.save()
            } catch {
                print("Error saving data to Core Data: \(error)")
            }
        }
    }
    func deleteSchedule(schedule: Schedule) {
        let context = self.appDel.persistentContainer.viewContext
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let fetchObjectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Schedules")
        let predicate = NSPredicate(format: "childID = %d", childID)
        let idPredicate = NSPredicate(format: "id = %d", schedule.id ?? 0)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, idPredicate])
        fetchObjectRequest.predicate = compoundPredicate
        do {
            if let latestObject = try context.fetch(fetchObjectRequest) as? [NSManagedObject]{
                if latestObject.count != 0 {
                    if let obj = latestObject.first {
                        context.delete(obj)
                        do {
                            try context.save()
                        } catch {
                            print("Error saving data to Core Data: \(error)")
                        }
                    }
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    func getSchedules(identifier: String, childID: Int) -> [Schedule] {
        var myModels: [Schedule] = []
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Schedules")
        let predicate = NSPredicate(format: "childID = %d", childID)
        let appID = NSPredicate(format: "functionss = %@", identifier)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appID])
        fetchRequest.predicate = compoundPredicate
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [NSManagedObject]() {
                var object = Schedule()
                object.id = coreDataObject.value(forKey: "id") as? Int
                object.name = coreDataObject.value(forKey: "name") as? String
                object.childID = coreDataObject.value(forKey: "childID") as? Int
                object.endTime = coreDataObject.value(forKey: "endTime") as? String
                object.startTime = coreDataObject.value(forKey: "startTime") as? String
                object.onMonday = coreDataObject.value(forKey: "onMonday") as? Int
                object.onTuesday = coreDataObject.value(forKey: "onTuesday") as? Int
                object.onWednesday = coreDataObject.value(forKey: "onWednesday") as? Int
                object.onThursday = coreDataObject.value(forKey: "onThursday") as? Int
                object.onFriday = coreDataObject.value(forKey: "onFriday") as? Int
                object.onSaturday = coreDataObject.value(forKey: "onSaturday") as? Int
                object.onSunday = coreDataObject.value(forKey: "onSunday") as? Int
                object.status = coreDataObject.value(forKey: "status") as? Int
                object.isPredefined = coreDataObject.value(forKey: "isPredefined") as? Int
                object.function = coreDataObject.value(forKey: "functionss") as? String
                object.type = coreDataObject.value(forKey: "type") as? String
                print(object)
                myModels.append(object)
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        return myModels
    }
    func getAllSchedules() -> [Schedule] {
        var myModels: [Schedule] = []
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Schedules")
        
        // No predicates are set, so it fetches all Schedules
        fetchRequest.predicate = nil
        
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [] {
                var object = Schedule()
                object.id = coreDataObject.value(forKey: "id") as? Int
                object.name = coreDataObject.value(forKey: "name") as? String
                object.childID = coreDataObject.value(forKey: "childID") as? Int
                object.endTime = coreDataObject.value(forKey: "endTime") as? String
                object.startTime = coreDataObject.value(forKey: "startTime") as? String
                object.onMonday = coreDataObject.value(forKey: "onMonday") as? Int
                object.onTuesday = coreDataObject.value(forKey: "onTuesday") as? Int
                object.onWednesday = coreDataObject.value(forKey: "onWednesday") as? Int
                object.onThursday = coreDataObject.value(forKey: "onThursday") as? Int
                object.onFriday = coreDataObject.value(forKey: "onFriday") as? Int
                object.onSaturday = coreDataObject.value(forKey: "onSaturday") as? Int
                object.onSunday = coreDataObject.value(forKey: "onSunday") as? Int
                object.status = coreDataObject.value(forKey: "status") as? Int
                object.isPredefined = coreDataObject.value(forKey: "isPredefined") as? Int
                object.function = coreDataObject.value(forKey: "functionss") as? String
                object.type = coreDataObject.value(forKey: "type") as? String
                print(object)
                myModels.append(object)
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        return myModels
    }
    
    func getScheduleAndUpdate(childID: Int,identifier: String,id: Int, obj:Schedule) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Schedules")
        let predicate = NSPredicate(format: "childID = %d", childID)
        let appID = NSPredicate(format: "functionss = %@", identifier)
        let iD = NSPredicate(format: "id = %d", id)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appID, iD])
        fetchRequest.predicate = compoundPredicate
        do {
            let matchingObjects = try self.appDel.persistentContainer.viewContext.fetch(fetchRequest)  as? [NSManagedObject]
            if matchingObjects?.count != 0{
                guard let valuess = matchingObjects else {return}
                let values = valuess.first
                values!.setValue(obj.endTime, forKey: "endTime")
                values!.setValue(obj.status, forKey: "status")
                values!.setValue(obj.startTime, forKey: "startTime")
                values!.setValue(obj.endTime, forKey: "endTime")
                values!.setValue(obj.onSaturday, forKey: "onSaturday")
                values!.setValue(obj.onSunday, forKey: "onSunday")
                values!.setValue(obj.onMonday, forKey: "onMonday")
                values!.setValue(obj.onTuesday, forKey: "onTuesday")
                values!.setValue(obj.onWednesday, forKey: "onWednesday")
                values!.setValue(obj.onThursday, forKey: "onThursday")
                values!.setValue(obj.onFriday, forKey: "onFriday")
                values!.setValue(obj.name, forKey: "name")
                saveContext()
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
            //return nil
        }
    }
    //    func saveContacts(myModelArray: [ContactObj]) {
    //        let context = self.appDel.persistentContainer.viewContext
    //        for model in myModelArray {
    //            let entity = NSEntityDescription.entity(forEntityName: "ContactsTable", in: context)
    //            let coreDataObject = NSManagedObject(entity: entity!, insertInto: context)
    //            coreDataObject.setValue(model.id, forKey: "id")
    //            coreDataObject.setValue(model.childID ?? 0, forKey: "childID")
    //            coreDataObject.setValue(model.isWatched , forKey: "isWatched")
    //            coreDataObject.setValue(model.createdAt, forKey: "createdAt")
    //            coreDataObject.setValue(model.contactID, forKey: "contactID")
    //            coreDataObject.setValue(model.contactTime, forKey: "contactTime")
    //            coreDataObject.setValue(model.name, forKey: "name")
    //            coreDataObject.setValue(model.email, forKey: "email")
    //            coreDataObject.setValue(model.phoneMobile, forKey: "phoneMobile")
    //            do {
    //                try context.save()
    //            } catch {
    //                print("Error saving data to Core Data: \(error)")
    //            }
    //        }
    //    }
    //    func saveContacts(myModelArray: [ContactObj]) {
    //        let context = self.appDel.persistentContainer.viewContext
    //        for model in myModelArray {
    //            if let contactID = model.contactID, !contactExists(contactID: contactID, in: context) {
    //                let entity = NSEntityDescription.entity(forEntityName: "ContactsTable", in: context)
    //                let coreDataObject = NSManagedObject(entity: entity!, insertInto: context)
    //                coreDataObject.setValue(model.id, forKey: "id")
    //                coreDataObject.setValue(model.childID ?? 0, forKey: "childID")
    //                coreDataObject.setValue(model.isWatched , forKey: "isWatched")
    //                coreDataObject.setValue(model.createdAt, forKey: "createdAt")
    //                coreDataObject.setValue(contactID, forKey: "contactID")
    //                coreDataObject.setValue(model.contactTime, forKey: "contactTime")
    //                coreDataObject.setValue(model.name, forKey: "name")
    //                coreDataObject.setValue(model.email, forKey: "email")
    //                coreDataObject.setValue(model.phoneMobile, forKey: "phoneMobile")
    //            }
    //        }
    //        do {
    //            try context.save()
    //        } catch {
    //            print("Error saving data to Core Data: \(error)")
    //        }
    //    }
    
    func contactExists(contactID: Int, in context: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactsTable")
        fetchRequest.predicate = NSPredicate(format: "contactID == %@", NSNumber(value: contactID))
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking contact existence: \(error)")
            return false
        }
    }
    
    //    func fetchAllContacts() -> [ContactObj] {
    //        var myModelsArr = [ContactObj]()
    //        let context = self.appDel.persistentContainer.viewContext
    //        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactsTable")
    //        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
    ////        fetchRequest.fetchLimit = 1
    //        do {
    //            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
    //            if let objects = coreDataObjects {
    //                for obj in objects {
    //                    var myModels = ContactObj()
    //                    myModels.childID = obj.value(forKey: "childID") as? Int
    //                    myModels.id = obj.value(forKey: "id") as? Int
    //                    myModels.isWatched = obj.value(forKey: "isWatched") as? Int
    //                    myModels.createdAt = obj.value(forKey: "createdAt") as? String
    //                    myModels.contactID = obj.value(forKey: "contactID") as? Int
    //                    myModels.contactTime = obj.value(forKey: "contactTime") as? String
    //                    myModels.name = obj.value(forKey: "name") as? String
    //                    myModels.email = obj.value(forKey: "email") as? String
    //                    myModels.phoneMobile = obj.value(forKey: "phoneMobile") as? String
    //                    myModelsArr.append(myModels)
    //                }
    //            }
    //        } catch {
    //            print("Error fetching data from Core Data: \(error)")
    //        }
    //        return myModelsArr
    //    }
    
    func saveContacts(myModelArray: [ContactObj]) {
        let context = self.appDel.persistentContainer.viewContext
        for model in myModelArray {
//            if let contactID = model.contactID {
                // Debug: Check if contactExists is causing an issue
//                if contactExists(contactID: contactID, in: context) {
//                    print("Contact with ID \(contactID) already exists, skipping save.")
//                    continue
//                }
                
                let entity = NSEntityDescription.entity(forEntityName: "ContactsTable", in: context)
                let coreDataObject = NSManagedObject(entity: entity!, insertInto: context)
                coreDataObject.setValue(model.id, forKey: "id")
                coreDataObject.setValue(model.childID ?? 0, forKey: "childID")
                coreDataObject.setValue(model.isWatched, forKey: "isWatched")
                coreDataObject.setValue(model.createdAt, forKey: "createdAt")
                coreDataObject.setValue(model.contactID ?? 0, forKey: "contactID")
                coreDataObject.setValue(model.contactTime, forKey: "contactTime")
                coreDataObject.setValue(model.name, forKey: "name")
                coreDataObject.setValue(model.email, forKey: "email")
                coreDataObject.setValue(model.phoneMobile, forKey: "phoneMobile")
                
                // Debug: Print the new contact being saved
                print("Saving new contact: \(model)")
//            }
        }
        do {
            try context.save()
        } catch {
            print("Error saving data to Core Data: \(error)")
        }
    }
    
    func fetchAllContacts() -> [ContactObj] {
        var myModelsArr = [ContactObj]()
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactsTable")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let objects = coreDataObjects {
                for obj in objects {
                    var myModels = ContactObj()
                    myModels.childID = obj.value(forKey: "childID") as? Int
                    myModels.id = obj.value(forKey: "id") as? Int
                    myModels.isWatched = obj.value(forKey: "isWatched") as? Int
                    myModels.createdAt = obj.value(forKey: "createdAt") as? String
                    myModels.contactID = obj.value(forKey: "contactID") as? Int
                    myModels.contactTime = obj.value(forKey: "contactTime") as? String
                    myModels.name = obj.value(forKey: "name") as? String
                    myModels.email = obj.value(forKey: "email") as? String
                    myModels.phoneMobile = obj.value(forKey: "phoneMobile") as? String
                    
                    // Debug: Print each fetched contact
                    print("Fetched contact: \(myModels)")
                    
                    myModelsArr.append(myModels)
                }
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        return myModelsArr
    }
    
    
    
    func fetchChildContacts(childId: Int) -> [ContactObj] {
        var myModelsArr = [ContactObj]()
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactsTable")
        fetchRequest.predicate = NSPredicate(format: "childID = %d", argumentArray: [childId])
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let objects = coreDataObjects {
                for obj in objects {
                    var myModels = ContactObj()
                    myModels.childID = obj.value(forKey: "childID") as? Int
                    myModels.id = obj.value(forKey: "id") as? Int
                    myModels.isWatched = obj.value(forKey: "isWatched") as? Int
                    myModels.createdAt = obj.value(forKey: "createdAt") as? String
                    myModels.contactID = obj.value(forKey: "contactID") as? Int
                    myModels.contactTime = obj.value(forKey: "contactTime") as? String
                    myModels.name = obj.value(forKey: "name") as? String
                    myModels.email = obj.value(forKey: "email") as? String
                    myModels.phoneMobile = obj.value(forKey: "phoneMobile") as? String
                    myModelsArr.append(myModels)
                }
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        return myModelsArr
    }
    func fetchContactAndUpdate(identifier: Int,state: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactsTable")
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let predicate = NSPredicate(format: "childID = %d", id)
        let appID = NSPredicate(format: "id = %d", identifier)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appID])
        fetchRequest.predicate = compoundPredicate
        do {
            let matchingObjects = try self.appDel.persistentContainer.viewContext.fetch(fetchRequest)  as? [NSManagedObject]
            if matchingObjects?.count != 0{
                guard let valuess = matchingObjects else {return}
                let values = valuess.first
                values!.setValue(state, forKey: "isWatched")
                saveContext()
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
    }
    func saveTimeBank(myModelArray: [TimeBankObj]) {
        let context = self.appDel.persistentContainer.viewContext
        for model in myModelArray {
            let entity = NSEntityDescription.entity(forEntityName: "TimeBank", in: context)
            let coreDataObject = NSManagedObject(entity: entity!, insertInto: context)
            coreDataObject.setValue(model.timeBank, forKey: "timeBank")
            coreDataObject.setValue(model.childID ?? 0, forKey: "childID")
            do {
                try context.save()
            } catch {
                print("Error saving data to Core Data: \(error)")
            }
        }
    }
    
    func fetchTimeBank(childId: Int) -> TimeBankObj {
        var myModels = TimeBankObj()
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeBank")
        fetchRequest.predicate = NSPredicate(format: "childID = %d", argumentArray: [childId])
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let obj = coreDataObjects?.first {
                myModels.childID = obj.value(forKey: "childID") as? Int
                myModels.timeBank = obj.value(forKey: "timeBank") as? Int
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        return myModels
    }
    
    func savePlans(plans: [Plan]) {
        deleteData(entityName: "PlanEntity")
        let context = self.appDel.persistentContainer.viewContext
        for plan in plans {
            guard let planEntity = NSEntityDescription.entity(forEntityName: "PlanEntity", in: context) else {
                print("Error: Could not find entity description for PlanEntity")
                continue
            }
            let coreDataObject = NSManagedObject(entity: planEntity, insertInto: context)
            coreDataObject.setValue(Int32(plan.planID ?? 0), forKey: "planID")
            coreDataObject.setValue(plan.identifier, forKey: "identifier")
            coreDataObject.setValue(plan.forAndroid ?? 0, forKey: "forAndroid")
            coreDataObject.setValue(plan.forIos ?? 0, forKey: "forIos")
            coreDataObject.setValue(plan.androidReleased ?? 0, forKey: "androidReleased")
            coreDataObject.setValue(plan.iosReleased ?? 0, forKey: "iosReleased")
            coreDataObject.setValue(plan.status ?? 0, forKey: "status")
            coreDataObject.setValue(plan.value, forKey: "value")
            
            do {
                try context.save()
            } catch {
                print("Error saving plans data to Core Data: \(error)")
            }
        }
    }
    
    func saveChildren(children: [Child]) {
        deleteData(entityName: "ChildrenEntity")
        let context = self.appDel.persistentContainer.viewContext
        for child in children {
            guard let childEntity = NSEntityDescription.entity(forEntityName: "ChildrenEntity", in: context) else {
                print("Error: Could not find entity description for ChildrenEntity")
                continue
            }
            let coreDataObject = NSManagedObject(entity: childEntity, insertInto: context)
            coreDataObject.setValue(Int32(child.childID ?? 0), forKey: "childID")
            coreDataObject.setValue(child.name, forKey: "name")
            coreDataObject.setValue(child.stringValue(forNullableString: child.birthday ?? .null), forKey: "birthday")
            coreDataObject.setValue(child.gender, forKey: "gender")
            coreDataObject.setValue(child.relationship, forKey: "relationship")
            coreDataObject.setValue(child.stringValue(forNullableString: child.email ?? .null), forKey: "email")
            coreDataObject.setValue(child.stringValue(forNullableString: child.phone ?? .null), forKey: "phone")
            coreDataObject.setValue(Int64(child.age ?? 0), forKey: "age")
            coreDataObject.setValue(Int64(child.avatarID ?? 0), forKey: "avatarID")
            coreDataObject.setValue(child.device, forKey: "device")
            coreDataObject.setValue(Int64(child.planID ?? 0), forKey: "planID")
            coreDataObject.setValue(Int64(child.packageID ?? 0), forKey: "packageID")
            coreDataObject.setValue(child.package, forKey: "package")
            coreDataObject.setValue(child.color, forKey: "color")
            coreDataObject.setValue(Int64(child.active ?? 0), forKey: "active")
            coreDataObject.setValue(Int64(child.deleted ?? 0), forKey: "deletedss")
            coreDataObject.setValue(child.stringValue(forNullableString: child.deletedAt ?? .null), forKey: "deletedAt")
            coreDataObject.setValue(Int64(child.superUserID ?? 0), forKey: "superUserID")
            coreDataObject.setValue(child.lastActivity, forKey: "lastActivity")
            coreDataObject.setValue(Int64(child.childEnrolled ?? 0), forKey: "childEnrolled")
            coreDataObject.setValue(child.versionNumber, forKey: "versionNumber")
            coreDataObject.setValue(child.versionCode, forKey: "versionCode")
            coreDataObject.setValue(child.timeZone, forKey: "timeZone")
            coreDataObject.setValue(child.stringValue(forNullableString: child.activationDate ?? .null), forKey: "activationDate")
            coreDataObject.setValue(child.createdAt, forKey: "createdAt")
            coreDataObject.setValue(child.updatedAt, forKey: "updatedAt")
            coreDataObject.setValue(child.agent, forKey: "agent")
            coreDataObject.setValue(Int64(child.deviceID ?? 0), forKey: "deviceID")
            coreDataObject.setValue(child.batteryRemaining, forKey: "batteryRemaining")
            coreDataObject.setValue(child.wifiName, forKey: "wifiName")
            coreDataObject.setValue(child.deviceManufacturer, forKey: "deviceManufacturer")
            coreDataObject.setValue(child.deviceName, forKey: "deviceName")
            coreDataObject.setValue(child.deviceModel, forKey: "deviceModel")
            coreDataObject.setValue(child.deviceOS, forKey: "deviceOS")
            coreDataObject.setValue(child.deviceLanguage, forKey: "deviceLanguage")
            coreDataObject.setValue(child.stringValue(forNullableString: child.deviceTimezone ?? .null), forKey: "deviceTimezone")
            coreDataObject.setValue(child.stringValue(forNullableString: child.deviceImei ?? .null), forKey: "deviceImei")
            coreDataObject.setValue(child.appVersion, forKey: "appVersion")
            coreDataObject.setValue(child.appBuild, forKey: "appBuild")
            
            do {
                try context.save()
            } catch {
                print("Error saving children data to Core Data: \(error)")
            }
        }
    }
    
    func isAnyNewChildExist() -> Bool {
        // Fetch all children data
        guard let children = fetchAllChildren() else {
            print("Error: Could not retrieve children data")
            return false
        }
        
        // Iterate over each child to apply the conditions
        for child in children {
            if child.device?.lowercased() == "android" {
                if let versionNumber = child.versionNumber, versionNumber.contains(".ps") {
                    if let versionCode = child.versionCode, versionCode > "3444" {
                        return true
                    }
                } else {
                    if let versionCode = child.versionCode, versionCode > "4357" {
                        return true
                    }
                }
            }
        }
        
        // Return false if no child meets the conditions
        return false
    }
    
    func isAnyOldChildExist() -> Bool {
        // Fetch all children data
        guard let children = fetchAllChildren() else {
            print("Error: Could not retrieve children data")
            return false
        }
        
        // Iterate over each child to apply the conditions
        for child in children {
            if child.device?.lowercased() == "android" {
                if let versionNumber = child.versionNumber, versionNumber.contains(".ps") {
                    if let versionCode = child.versionCode, versionCode < "3444" {
                        return true
                    }
                } else {
                    if let versionCode = child.versionCode, versionCode <= "4357" {
                        return true
                    }
                }
            }
        }
        
        // Return false if no child meets the conditions
        return false
    }
    
    func checkChildIsOld(childID: Int) -> Bool {
        // Fetch the child record using the provided childID
        guard let child = fetchChild(byID: childID) else {
            print("Child record not found")
            return false
        }
        
        // Check if the child device is Android
        guard let device = child.device, device.lowercased() == "android" else {
            print("Device is not Android")
            return false
        }
        
        // Check if versionNumber contains ".ps"
        if let versionNumber = child.versionNumber, versionNumber.contains(".ps") {
            // If it contains ".ps", check if versionCode is less than 3444
            if let versionCode = child.versionCode, versionCode < "3444" {
                return true
            }
        } else {
            // If it doesn't contain ".ps", check if versionCode is less than or equal to 4357
            if let versionCode = child.versionCode, versionCode <= "4357" {
                return true
            }
        }
        
        // Return false if none of the conditions were met
        return false
    }
    
    func fetchPlans(byPlanID planID: Int) -> [PlanEntity] {
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PlanEntity> = PlanEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "planID == %d", planID)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching plans data: \(error)")
            return []
        }
    }
    
    func fetchChild(byID childID: Int) -> ChildrenEntity? {
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ChildrenEntity> = ChildrenEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "childID == %d", Int32(childID))
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching child data: \(error)")
            return nil
        }
    }
    
    func fetchChildName(byID childID: Int) -> String? {
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ChildrenEntity> = ChildrenEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "childID == %d", Int32(childID))
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first?.name
        } catch {
            print("Error fetching child data: \(error)")
            return nil
        }
    }
    
    func fetchChildAndPlans(byChildID childID: Int) -> (child: ChildrenEntity?, plans: [PlanEntity]) {
        guard let child = fetchChild(byID: childID) else {
            return (nil, [])
        }
        
        let planID = child.planID
        let plans = fetchPlans(byPlanID: Int(planID))
        
        return (child, plans)
    }
    
    func fetchAllChildren() -> [Child]? {
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ChildrenEntity> = ChildrenEntity.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            // Map ChildrenEntity objects to Child objects
            let children = results.compactMap { entity in
                return Child(
                    childID: Int(entity.childID),
                    name: entity.name,
                    birthday: decodeNullableString(entity.birthday),
                    gender: entity.gender,
                    relationship: entity.relationship,
                    email: decodeNullableString(entity.email),
                    phone: decodeNullableString(entity.phone),
                    age: Int(entity.age),
                    avatarID: Int(entity.avatarID),
                    device: entity.device,
                    planID: Int(entity.planID),
                    packageID: Int(entity.packageID),
                    package: entity.package,
                    color: entity.color,
                    active: Int(entity.active),
                    deleted: Int(entity.deletedss),
                    deletedAt: decodeNullableString(entity.deletedAt),
                    superUserID: Int(entity.superUserID),
                    lastActivity: entity.lastActivity,
                    childEnrolled: Int(entity.childEnrolled),
                    versionNumber: entity.versionNumber,
                    versionCode: entity.versionCode,
                    timeZone: entity.timeZone,
                    activationDate: decodeNullableString(entity.activationDate),
                    createdAt: entity.createdAt,
                    updatedAt: entity.updatedAt,
                    agent: entity.agent,
                    deviceID: Int(entity.deviceID),
                    batteryRemaining: entity.batteryRemaining,
                    wifiName: entity.wifiName,
                    deviceManufacturer: entity.deviceManufacturer,
                    deviceName: entity.deviceName,
                    deviceModel: entity.deviceModel,
                    deviceOS: entity.deviceOS,
                    deviceLanguage: entity.deviceLanguage,
                    deviceTimezone: decodeNullableString(entity.deviceTimezone),
                    deviceImei: decodeNullableString(entity.deviceImei),
                    appVersion: entity.appVersion,
                    appBuild: entity.appBuild
                )
            }
            return children
        } catch {
            print("Error fetching all children data: \(error)")
            return nil
        }
    }
    
    func decodeNullableString(_ nullableString: String?) -> NullableString {
        if let stringValue = nullableString {
            return .string(stringValue)
        } else {
            return .null
        }
    }
    
    func saveCoParents(coParentsArray: [[String: Any]]) {
        let context = appDel.persistentContainer.viewContext
        
        for coParentData in coParentsArray {
            guard let entity = NSEntityDescription.entity(forEntityName: "CoParents", in: context) else {
                print("Error: Failed to retrieve entity description for CoParents")
                return
            }
            
            let coreDataObject = NSManagedObject(entity: entity, insertInto: context)
            
            // Set each attribute based on its type and handle null values appropriately
            coreDataObject.setValue(coParentData["user_id"] as? Int64 ?? 0, forKey: "user_id")
            coreDataObject.setValue(coParentData["name"] as? String ?? "", forKey: "name")
            coreDataObject.setValue(coParentData["birthday"] as? String, forKey: "birthday")
            coreDataObject.setValue(coParentData["gender"] as? String ?? "", forKey: "gender")
            coreDataObject.setValue(coParentData["relationship"] as? String ?? "", forKey: "relationship")
            coreDataObject.setValue(coParentData["email"] as? String ?? "", forKey: "email")
            coreDataObject.setValue(coParentData["phone"] as? String, forKey: "phone")
            coreDataObject.setValue(coParentData["profile_img_src"] as? String, forKey: "profile_img_src")
            coreDataObject.setValue(coParentData["cover_img_src"] as? String, forKey: "cover_img_src")
            coreDataObject.setValue(coParentData["color"] as? String ?? "", forKey: "color")
            coreDataObject.setValue(coParentData["active"] as? Bool ?? false, forKey: "active")
            coreDataObject.setValue(coParentData["deleted"] as? Bool ?? false, forKey: "deletedpp")
            coreDataObject.setValue(coParentData["type"] as? String ?? "", forKey: "type")
            coreDataObject.setValue(coParentData["super_user_id"] as? Int64 ?? 0, forKey: "super_user_id")
            coreDataObject.setValue(coParentData["language"] as? String ?? "", forKey: "language")
            coreDataObject.setValue(coParentData["email_complaints"] as? Int16 ?? 0, forKey: "email_complaints")
            coreDataObject.setValue(coParentData["email_bounce"] as? Int16 ?? 0, forKey: "email_bounce")
            coreDataObject.setValue(coParentData["email_verified_at"] as? String, forKey: "email_verified_at")
            coreDataObject.setValue(coParentData["created_at"] as? String ?? "", forKey: "created_at")
            coreDataObject.setValue(coParentData["updated_at"] as? String ?? "", forKey: "updated_at")
            
            do {
                try context.save()
            } catch {
                print("Error saving data to Core Data: \(error)")
            }
        }
    }
    
    
    
    func fetchCoParents() -> [[String: Any]]? {
        let context = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoParents")
        
        do {
            let results = try context.fetch(fetchRequest)
            var coParentsData = [[String: Any]]()
            
            for case let result as NSManagedObject in results {
                var coParentData = [String: Any]()
                coParentData["user_id"] = Int(result.value(forKey: "user_id") as? Int64 ?? 0)
                coParentData["name"] = result.value(forKey: "name") as? String ?? ""
                coParentData["birthday"] = result.value(forKey: "birthday") as? String
                coParentData["gender"] = result.value(forKey: "gender") as? String ?? ""
                coParentData["relationship"] = result.value(forKey: "relationship") as? String ?? ""
                coParentData["email"] = result.value(forKey: "email") as? String ?? ""
                coParentData["phone"] = result.value(forKey: "phone") as? String
                coParentData["profile_img_src"] = result.value(forKey: "profile_img_src") as? String
                coParentData["cover_img_src"] = result.value(forKey: "cover_img_src") as? String
                coParentData["color"] = result.value(forKey: "color") as? String ?? ""
                coParentData["active"] = result.value(forKey: "active") as? Bool ?? false
                coParentData["deleted"] = result.value(forKey: "deletedpp") as? Bool ?? false
                coParentData["type"] = result.value(forKey: "type") as? String ?? ""
                coParentData["super_user_id"] = Int(result.value(forKey: "super_user_id") as? Int64 ?? 0)
                coParentData["language"] = result.value(forKey: "language") as? String ?? ""
                coParentData["email_complaints"] = Int(result.value(forKey: "email_complaints") as? Int16 ?? 0)
                coParentData["email_bounce"] = Int(result.value(forKey: "email_bounce") as? Int16 ?? 0)
                coParentData["email_verified_at"] = result.value(forKey: "email_verified_at") as? String
                coParentData["created_at"] = result.value(forKey: "created_at") as? String ?? ""
                coParentData["updated_at"] = result.value(forKey: "updated_at") as? String ?? ""
                
                coParentsData.append(coParentData)
            }
            
            return coParentsData
        } catch {
            print("Error fetching CoParents data: \(error)")
            return nil
        }
    }
    func deleteCoParent(withId userId: Int) -> Bool {
        let context = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoParents")
        fetchRequest.predicate = NSPredicate(format: "user_id == %ld", userId)
        
        do {
            let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let coParent = fetchResults?.first {
                context.delete(coParent)
                try context.save()
                return true
            }
        } catch {
            print("Error deleting co-parent from Core Data: \(error)")
        }
        
        return false
    }
    
    
    func saveCalls(calls: [Call]) {
        let context = self.appDel.persistentContainer.viewContext
        for call in calls {
            let callEntity = NSEntityDescription.entity(forEntityName: "Calls", in: context)!
            let coreDataObject = NSManagedObject(entity: callEntity, insertInto: context)
            coreDataObject.setValue(call.callID ?? 0, forKey: "callID")
            coreDataObject.setValue(call.name, forKey: "name")
            coreDataObject.setValue(call.number, forKey: "number")
            coreDataObject.setValue(call.type, forKey: "type")
            coreDataObject.setValue(call.callTime, forKey: "callTime")
            coreDataObject.setValue(call.duration, forKey: "duration")
            coreDataObject.setValue(call.durationInSeconds, forKey: "durationInSeconds")
            coreDataObject.setValue(call.contactID ?? 0, forKey: "contactID")
            coreDataObject.setValue(call.childID ?? 0, forKey: "childID")
            coreDataObject.setValue(call.superUserID ?? 0, forKey: "superUserID")
            // Handle optional dateCreated and dateModified if needed
            coreDataObject.setValue(call.deleted ?? false, forKey: "deleteds")
            do {
                try context.save()
            } catch {
                print("Error saving calls data to Core Data: \(error)")
            }
        }
    }
    func fetchCalls(forChildId childId: Int, fromDate: Date, toDate: Date) -> [Call] {
        var calls = [Call]()
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Calls")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        let startDateString = dateFormatter.string(from: fromDate)
        let endDateString = dateFormatter.string(from: toDate)
        
        let predi = NSPredicate(format: "(callTime >= %@) AND (callTime < %@)", startDateString, endDateString)
        let idPred = NSPredicate(format: "childID = %d", childId)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predi, idPred])
        fetchRequest.predicate = compoundPredicate
        
        //        fetchRequest.predicate = NSPredicate(format: "childID = %@ AND callTime >= %@ AND callTime <= %@", argumentArray: [childId, startDateString , endDateString])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let results = results {
                for obj in results {
                    let call = Call(callID: obj.value(forKey: "callID") as? Int,
                                    name: obj.value(forKey: "name") as? String,
                                    number: obj.value(forKey: "number") as? String,
                                    type: obj.value(forKey: "type") as? String,
                                    callTime: obj.value(forKey: "callTime") as? String,
                                    duration: obj.value(forKey: "duration") as? String,
                                    durationInSeconds: obj.value(forKey: "durationInSeconds") as? String,
                                    contactID: obj.value(forKey: "contactID") as? Int,
                                    childID: obj.value(forKey: "childID") as? Int,
                                    superUserID: obj.value(forKey: "superUserID") as? Int,
                                    dateCreated: nil, // Handle dateCreated if needed
                                    dateModified: nil, // Handle dateModified if needed
                                    deleted: obj.value(forKey: "deleteds") as? Int)
                    calls.append(call)
                }
            }
        } catch {
            // Handle fetch error (consider throwing exception or returning empty array)
            print("Error fetching call data for child \(childId) from Core Data: \(error)")
        }
        return calls
    }
    func fetchAllCalls() -> [Call] {
        var calls = [Call]()
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Calls")
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let results = results {
                for obj in results {
                    let call = Call(callID: obj.value(forKey: "callID") as? Int,
                                    name: obj.value(forKey: "name") as? String,
                                    number: obj.value(forKey: "number") as? String,
                                    type: obj.value(forKey: "type") as? String,
                                    callTime: obj.value(forKey: "callTime") as? String,
                                    duration: obj.value(forKey: "duration") as? String,
                                    durationInSeconds: obj.value(forKey: "durationInSeconds") as? String,
                                    contactID: obj.value(forKey: "contactID") as? Int,
                                    childID: obj.value(forKey: "childID") as? Int,
                                    superUserID: obj.value(forKey: "superUserID") as? Int,
                                    dateCreated: nil, // Handle dateCreated if needed
                                    dateModified: nil, // Handle dateModified if needed
                                    deleted: obj.value(forKey: "deleted") as? Int)
                    calls.append(call)
                }
            }
        } catch {
            // Handle fetch error (consider throwing exception or returning empty array)
            print("Error fetching call data from Core Data: \(error)")
        }
        return calls
    }
    
    //    func fetchAllCalls(forChildId childId: Int) -> [Call] {
    //        var calls = [Call]()
    //        let context = self.appDel.persistentContainer.viewContext
    //        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Calls")
    //        fetchRequest.predicate = NSPredicate(format: "childID = %@", argumentArray: [childId])
    //
    //        do {
    //            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
    //            if let results = results {
    //                for obj in results {
    //                    let call = Call(callID: obj.value(forKey: "callID") as? Int,
    //                                    name: obj.value(forKey: "name") as? String,
    //                                    number: obj.value(forKey: "number") as? String,
    //                                    type: obj.value(forKey: "type") as? String,
    //                                    callTime: obj.value(forKey: "callTime") as? String,
    //                                    duration: obj.value(forKey: "duration") as? String,
    //                                    durationInSeconds: obj.value(forKey: "durationInSeconds") as? String,
    //                                    contactID: obj.value(forKey: "contactID") as? Int,
    //                                    childID: obj.value(forKey: "childID") as? Int,
    //                                    superUserID: obj.value(forKey: "superUserID") as? Int,
    //                                    dateCreated: nil, // Handle dateCreated if needed
    //                                    dateModified: nil, // Handle dateModified if needed
    //                                    deleted: obj.value(forKey: "deleteds") as? Int)
    //                    calls.append(call)
    //                }
    //            }
    //        } catch {
    //            // Handle fetch error (consider throwing exception or returning empty array)
    //            print("Error fetching call data for child \(childId) from Core Data: \(error)")
    //        }
    //        return calls
    //    }
    func fetchTotalTalkTime(forChildId childId: Int, fromDate: Date, toDate: Date) -> (calls: [Call], totalDurationInSeconds: Int) {
        var calls = [Call]()
        var totalDurationInSeconds = 0
        
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Calls")
        fetchRequest.predicate = NSPredicate(format: "childID = %@ AND callTime >= %@ AND callTime <= %@", argumentArray: [childId, fromDate as NSDate, toDate as NSDate])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let results = results {
                for obj in results {
                    let call = Call(callID: obj.value(forKey: "callID") as? Int,
                                    name: obj.value(forKey: "name") as? String,
                                    number: obj.value(forKey: "number") as? String,
                                    type: obj.value(forKey: "type") as? String,
                                    callTime: obj.value(forKey: "callTime") as? String,
                                    duration: obj.value(forKey: "duration") as? String,
                                    durationInSeconds: obj.value(forKey: "durationInSeconds") as? String,
                                    contactID: obj.value(forKey: "contactID") as? Int,
                                    childID: obj.value(forKey: "childID") as? Int,
                                    superUserID: obj.value(forKey: "superUserID") as? Int,
                                    dateCreated: nil, // Handle dateCreated if needed
                                    dateModified: nil, // Handle dateModified if needed
                                    deleted: obj.value(forKey: "deleteds") as? Int)
                    calls.append(call)
                    
                    // Calculate total duration
                    if let durationInSeconds = obj.value(forKey: "durationInSeconds") as? Int {
                        totalDurationInSeconds += durationInSeconds
                    }
                }
            }
        } catch {
            // Handle fetch error (consider throwing exception or returning empty array)
            print("Error fetching call data for child \(childId) from Core Data: \(error)")
        }
        return (calls, totalDurationInSeconds)
    }
    
    func saveV1AppUsage(appUsage: [AppUsage]) {
        let context = appDel.persistentContainer.viewContext
        
        for usage in appUsage {
            // Create a new Core Data object for AppUsage
            guard let entity = NSEntityDescription.entity(forEntityName: "V1AppUsage", in: context) else {
                fatalError("Failed to find AppUsage entity")
            }
            let coreDataObject = NSManagedObject(entity: entity, insertInto: context)
            
            // Set values for each property of the Core Data object
            coreDataObject.setValue(usage.childID, forKey: "childID")
            coreDataObject.setValue(usage.appName, forKey: "appName")
            coreDataObject.setValue(usage.packageName, forKey: "packageName")
            coreDataObject.setValue(usage.appUsage, forKey: "appUsage")
            coreDataObject.setValue(usage.appCategory, forKey: "appCategory")
            coreDataObject.setValue(usage.dateUsage, forKey: "dateUsage")
        }
        
        do {
            try context.save()
            print("App usage data saved successfully")
        } catch {
            print("Error saving app usage data to Core Data: \(error)")
        }
    }
    
    func saveAppUsage(appUsage: [AppUsage]) {
        let context = appDel.persistentContainer.viewContext
        
        for usage in appUsage {
            // Create a new Core Data object for AppUsage
            guard let entity = NSEntityDescription.entity(forEntityName: "AppUsageCore", in: context) else {
                fatalError("Failed to find AppUsage entity")
            }
            let coreDataObject = NSManagedObject(entity: entity, insertInto: context)
            
            // Set values for each property of the Core Data object
            coreDataObject.setValue(usage.childID, forKey: "childID")
            coreDataObject.setValue(usage.appName, forKey: "appName")
            coreDataObject.setValue(usage.packageName, forKey: "packageName")
            coreDataObject.setValue(usage.appUsage, forKey: "appUsage")
            coreDataObject.setValue(usage.appCategory, forKey: "appCategory")
            coreDataObject.setValue(usage.dateUsage, forKey: "dateUsage")
        }
        
        do {
            try context.save()
            print("App usage data saved successfully")
        } catch {
            print("Error saving app usage data to Core Data: \(error)")
        }
    }
    
    func doesAppUsageExist() -> Bool {
        // Get the context
        let context = appDel.persistentContainer.viewContext
        
        // Create a fetch request for the AppUsageCore entity
        let fetchRequest = NSFetchRequest<V1AppUsage>(entityName: "V1AppUsage")
        
        do {
            // Execute the fetch request
            let results = try context.fetch(fetchRequest)
            
            // If the results array contains any objects, that means there is data in the AppUsageCore table
            return !results.isEmpty // Data exists if there are results
        } catch {
            // Handle any errors (e.g., fetch failures)
            print("Error fetching data to check if app usage exists: \(error)")
            return false // Return false in case of an error
        }
    }
    
    
    func deleteDataForDate(entityName: String, date: String) {
        let context = appDel.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        
        // Predicate to filter by dateUsage only, without considering childID
        fetchRequest.predicate = NSPredicate(format: "dateUsage == %@", date as CVarArg)
        
        do {
            // Execute the fetch request
            let results = try context.fetch(fetchRequest)
            print("get the count that are delete from db: ", results.count)
            // Loop through the results and delete the matching objects
            for object in results {
                if let objectToDelete = object as? NSManagedObject {
                    context.delete(objectToDelete)
                }
            }
            
            // Save the changes to the context
            try context.save()
            print("Deleted app usage data for date: \(date)")
        } catch {
            // Handle any errors that might occur during fetch or delete
            print("Error deleting app usage data for date \(date): \(error)")
        }
    }
    
    func getMostRecentAppUsageDate() -> String? {
        // Get the context
        let context = appDel.persistentContainer.viewContext
        
        // Create a fetch request for the AppUsageCore entity
        let fetchRequest = NSFetchRequest<V1AppUsage>(entityName: "V1AppUsage")
        
        // Sort the results by dateUsage in descending order to get the most recent date first
        let sortDescriptor = NSSortDescriptor(key: "dateUsage", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Limit the fetch request to 1 result since we only need the most recent one
        fetchRequest.fetchLimit = 1
        
        do {
            // Execute the fetch request
            let results = try context.fetch(fetchRequest)
            
            // Return the dateUsage of the first result if it exists, otherwise return nil
            return results.first?.dateUsage
        } catch {
            // Handle any errors (e.g., fetch failures)
            print("Error fetching the most recent dateUsage: \(error)")
            return nil // Return nil in case of an error
        }
    }
    
    func fetchV1AppUsage(childID: Int, startDate: Date, endDate: Date) -> [String: Any] {
        let context = appDel.persistentContainer.viewContext
        // Create a fetch request for AppUsageCore entities
        let fetchRequest = NSFetchRequest<V1AppUsage>(entityName: "V1AppUsage")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        // Add predicates to filter by childID and date range
        fetchRequest.predicate = NSPredicate(format: "childID == %d AND dateUsage >= %@ AND dateUsage <= %@", childID, startDateString, endDateString)
        
        do {
            let results = try context.fetch(fetchRequest)
            var fetchedAppUsage: [[String: Any]] = []
            var totalUsage = 0
            for result in results {
                // Process the fetched AppUsageCore objects
                let appUsage: [String: Any] = [
                    "total_app_usage": Int(result.appUsage),
                    "app_name": result.appName ?? "",
                    "package_name": result.packageName ?? "",
                    "app_category": result.appCategory ?? "",
                    "date_usage": result.dateUsage ?? Date()
                ]
                fetchedAppUsage.append(appUsage)
                totalUsage += Int(result.appUsage)
            }
            let response: [String: Any] = [
                "status": 200,
                "message": "OK",
                "to_date": endDate,
                "from_date": startDate,
                "appusage": fetchedAppUsage,
                "child_id": childID
            ]
            
            return response
        } catch {
            print("Error fetching app usage data for child \(childID) in the date range \(startDate) to \(endDate): \(error)")
            return [:]
        }
    }
    
    func fetchAppUsage(childID: Int, startDate: Date, endDate: Date) -> [String: Any] {
        let context = appDel.persistentContainer.viewContext
        // Create a fetch request for AppUsageCore entities
        let fetchRequest = NSFetchRequest<AppUsageCore>(entityName: "AppUsageCore")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        // Add predicates to filter by childID and date range
        fetchRequest.predicate = NSPredicate(format: "childID == %d AND dateUsage >= %@ AND dateUsage <= %@", childID, startDateString, endDateString)
        
        do {
            let results = try context.fetch(fetchRequest)
            var fetchedAppUsage: [[String: Any]] = []
            var totalUsage = 0
            for result in results {
                // Process the fetched AppUsageCore objects
                let appUsage: [String: Any] = [
                    "total_app_usage": Int(result.appUsage),
                    "app_name": result.appName ?? "",
                    "package_name": result.packageName ?? "",
                    "app_category": result.appCategory ?? "",
                    "date_usage": result.dateUsage ?? Date()
                ]
                fetchedAppUsage.append(appUsage)
                totalUsage += Int(result.appUsage)
            }
            let response: [String: Any] = [
                "status": 200,
                "message": "OK",
                "to_date": endDate,
                "from_date": startDate,
                "appusage": fetchedAppUsage,
                "child_id": childID
            ]
            
            return response
        } catch {
            print("Error fetching app usage data for child \(childID) in the date range \(startDate) to \(endDate): \(error)")
            return [:]
        }
    }
    
    func fetchAppUsageAndTotal(childID: Int, fromDate: Date, toDate: Date) -> (totalAppUsage: Int, appUsageEntries: [AppUsage]) {
        let context = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUsageCore")
        fetchRequest.predicate = NSPredicate(format: "childID == %d AND dateUsage >= %@ AND dateUsage <= %@", childID, fromDate as NSDate, toDate as NSDate)
        
        do {
            let results = try context.fetch(fetchRequest)
            var totalAppUsage = 0
            var appUsageEntries: [AppUsage] = []
            for case let result as AppUsageCore in results {
                totalAppUsage += Int(result.appUsage)
                let appUsage = AppUsage(childID: Int(result.childID),
                                        appName: result.appName,
                                        packageName: result.packageName,
                                        appUsage: Int(result.appUsage),
                                        appCategory: result.appCategory,
                                        dateUsage: result.dateUsage)
                appUsageEntries.append(appUsage)
            }
            return (totalAppUsage, appUsageEntries)
        } catch {
            print("Error fetching app usage data for child \(childID): \(error)")
            return (0, [])
        }
    }
    
    func fetchControlModels() -> [Control] {
        var myModels: [Control] = []
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ControlsMainList")
        //let idPredicate = NSPredicate(format: "childID == %@", [id])
        fetchRequest.predicate = NSPredicate(format: "childID = %@", argumentArray: [id])
        
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [NSManagedObject]() {
                var object = Control()
                object.identifier = coreDataObject.value(forKey: "installedappID") as? String
                object.featureID = coreDataObject.value(forKey: "featureID") as? Int
                object.childID = coreDataObject.value(forKey: "childID") as? Int
                object.state = coreDataObject.value(forKey: "state") as? Int
                print(object)
                myModels.append(object)
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        
        return myModels
    }
    func fetchControlAndUpdate(identifier: String,state: Int, value:String = "") {
        //let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ControlsMainList")
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let predicate = NSPredicate(format: "childID = %d", id)
        let appID = NSPredicate(format: "identifier = %@", identifier)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appID])
        fetchRequest.predicate = compoundPredicate
        //fetchRequest.predicate = predicate
        do {
            let matchingObjects = try self.appDel.persistentContainer.viewContext.fetch(fetchRequest)  as? [NSManagedObject]
            if matchingObjects?.count != 0{
                guard let valuess = matchingObjects else {return}
                let values = valuess.first
                values!.setValue(state, forKey: "state")
                values!.setValue(value, forKey: "value")
                saveContext()
            }
            //return matchingObjects.first
        } catch {
            print("Error fetching data from Core Data: \(error)")
            //return nil
        }
    }
    func fetchAppBlockControl(identifier: String) -> Control {
        //let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ControlsMainList")
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let predicate = NSPredicate(format: "childID = %d", id)
        let appID = NSPredicate(format: "identifier = %@", identifier)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appID])
        fetchRequest.predicate = compoundPredicate
        var cont = Control()
        do {
            let matchingObjects = try self.appDel.persistentContainer.viewContext.fetch(fetchRequest)  as? [NSManagedObject]
            if matchingObjects?.count != 0{
                guard let valuess = matchingObjects else {return cont}
                let values = valuess.first
                //print("fetched", values!.value(forKey: "identifier") as? String as Any)
                cont.identifier =  values!.value(forKey: "identifier") as? String
                cont.featureID =  values!.value(forKey: "featureID") as? Int
                cont.childID =  values!.value(forKey: "childID") as? Int
                cont.state =  values!.value(forKey: "state") as? Int
                cont.value =  values!.value(forKey: "value") as? String
                return cont
            }
            //return matchingObjects.first
        } catch {
            print("Error fetching data from Core Data: \(error)")
            //return cont
        }
        return cont
    }
    func fetchControlWithChildID(childID: Int,identifier: String) -> Control {
        //let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ControlsMainList")
        //let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let predicate = NSPredicate(format: "childID = %d", childID)
        let appID = NSPredicate(format: "identifier = %@", identifier)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appID])
        fetchRequest.predicate = compoundPredicate
        var cont = Control()
        do {
            let matchingObjects = try self.appDel.persistentContainer.viewContext.fetch(fetchRequest)  as? [NSManagedObject]
            if matchingObjects?.count != 0{
                guard let valuess = matchingObjects else {return cont}
                let values = valuess.first
                //print("fetched", values!.value(forKey: "identifier") as? String as Any)
                cont.identifier =  values!.value(forKey: "identifier") as? String
                cont.featureID =  values!.value(forKey: "featureID") as? Int
                cont.childID =  values!.value(forKey: "childID") as? Int
                cont.state =  values!.value(forKey: "state") as? Int
                cont.value =  values!.value(forKey: "value") as? String
                return cont
            }
            //return matchingObjects.first
        } catch {
            print("Error fetching data from Core Data: \(error)")
            //return cont
        }
        return cont
    }
    func convertDateString(_ dateString: String, fromFormat: String, toFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = toFormat
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        } else {
            print("Invalid date format or string.")
            return nil
        }
    }
    func fetchYoutubeHistorySevenDays(childID: String, date: String, fetchType: SocialHistoryType) -> [youtubeData] {
        let outputDateString = convertDateString(date, fromFormat: "dd MMMM yyyy", toFormat: "yyyy-MM-dd")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: fetchType == .youtube ? CoredataKeys.Entities.APP_YOUTUBE_DATA : CoredataKeys.Entities.APP_TIKTOK_DATA)
        let predicate = NSPredicate(format: "child_id = %@", childID)
        let appID = NSPredicate(format: "time_visit BEGINSWITH[cd] %@", outputDateString!)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appID])
        fetchRequest.predicate = compoundPredicate
        var history = [youtubeData]()
        do {
            let matchingObjects = try self.appDel.persistentContainer.viewContext.fetch(fetchRequest)  as? [NSManagedObject]
            if matchingObjects?.count != 0{
                guard let valuess = matchingObjects else {return history}
                for values in valuess {
                    let browserHistoryId = values.value(forKey: CoredataKeys.Keys.Y_ID) as? String ?? ""
                    let history_child_id = values.value(forKey: CoredataKeys.Keys.Y_CHILD_ID) as? String ?? ""
                    let history_created_at = values.value(forKey: CoredataKeys.Keys.Y_CREATED_AT) as? String ?? ""
                    let history_deleted = values.value(forKey: CoredataKeys.Keys.Y_DELETED) as? String ?? ""
                    let history_domain = values.value(forKey: CoredataKeys.Keys.Y_DOMAIN) as? String ?? ""
                    let history_number_visted = values.value(forKey: CoredataKeys.Keys.Y_NUMBER_VISTIT) as? String ?? ""
                    let history_super_id = values.value(forKey: CoredataKeys.Keys.Y_SUPER_USER_ID) as? String ?? ""
                    let history_time_visit = values.value(forKey: CoredataKeys.Keys.Y_TIME_VIST) as? String ?? ""
                    let history_title = values.value(forKey: CoredataKeys.Keys.Y_TITLE) as? String ?? ""
                    let history_updatedAt = values.value(forKey: CoredataKeys.Keys.Y_UPDATED_AT) as? String ?? ""
                    let history_url = values.value(forKey: CoredataKeys.Keys.Y_URL) as? String ?? ""
                    let dataObj = youtubeData(id: Int(browserHistoryId) ?? 0, superUserID: Int(history_super_id) ?? 0, title: history_title, domain: history_domain, url: history_url, timeVisit: history_time_visit, numberVisits: Int(history_number_visted) ?? 0, childID: Int(history_child_id ) ?? 0, deleted: Int(history_deleted) ?? 0, createdAt: history_created_at, updatedAt: history_updatedAt)
                    history.append(dataObj)
                }
                return history
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        return history
    }
    func fetchAllYoutubeHistory(fetchType: SocialHistoryType) -> [youtubeData] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: fetchType == .youtube ? CoredataKeys.Entities.APP_YOUTUBE_DATA : CoredataKeys.Entities.APP_TIKTOK_DATA)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time_visit", ascending: false)]
        fetchRequest.fetchLimit = 1
        var history = [youtubeData]()
        do {
            let matchingObjects = try self.appDel.persistentContainer.viewContext.fetch(fetchRequest)  as? [NSManagedObject]
            if matchingObjects?.count != 0{
                guard let valuess = matchingObjects else {return history}
                for values in valuess {
                    let browserHistoryId = values.value(forKey: CoredataKeys.Keys.Y_ID) as? String ?? ""
                    let history_child_id = values.value(forKey: CoredataKeys.Keys.Y_CHILD_ID) as? String ?? ""
                    let history_created_at = values.value(forKey: CoredataKeys.Keys.Y_CREATED_AT) as? String ?? ""
                    let history_deleted = values.value(forKey: CoredataKeys.Keys.Y_DELETED) as? String ?? ""
                    let history_domain = values.value(forKey: CoredataKeys.Keys.Y_DOMAIN) as? String ?? ""
                    let history_number_visted = values.value(forKey: CoredataKeys.Keys.Y_NUMBER_VISTIT) as? String ?? ""
                    let history_super_id = values.value(forKey: CoredataKeys.Keys.Y_SUPER_USER_ID) as? String ?? ""
                    let history_time_visit = values.value(forKey: CoredataKeys.Keys.Y_TIME_VIST) as? String ?? ""
                    let history_title = values.value(forKey: CoredataKeys.Keys.Y_TITLE) as? String ?? ""
                    let history_updatedAt = values.value(forKey: CoredataKeys.Keys.Y_UPDATED_AT) as? String ?? ""
                    let history_url = values.value(forKey: CoredataKeys.Keys.Y_URL) as? String ?? ""
                    let dataObj = youtubeData(id: Int(browserHistoryId) ?? 0, superUserID: Int(history_super_id) ?? 0, title: history_title, domain: history_domain, url: history_url, timeVisit: history_time_visit, numberVisits: Int(history_number_visted) ?? 0, childID: Int(history_child_id ) ?? 0, deleted: Int(history_deleted) ?? 0, createdAt: history_created_at, updatedAt: history_updatedAt)
                    history.append(dataObj)
                }
                return history
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        return history
    }
    func fetchYTRecordsForMonth(_ monthNumber: Int,year: Int, fetchType: SocialHistoryType) -> [youtubeData]{
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let calendar = Calendar.current
        var history = [youtubeData]()
        let startDateComponents = DateComponents(year: year, month: monthNumber, day: 1)
        let startDate = calendar.date(from: startDateComponents)!
        
        let endDateComponents = DateComponents(year: year, month: monthNumber, day: 31, hour: 23, minute: 59, second: 59)
        let endDate = calendar.date(from: endDateComponents)!
        let predicate = NSPredicate(format: "(time_visit >= %@) AND (time_visit <= %@)", startDate as NSDate, endDate as NSDate)
        let childIdPredicate = NSPredicate(format: "child_id = %@", "\(id)")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, childIdPredicate])
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: fetchType == .youtube ? CoredataKeys.Entities.APP_YOUTUBE_DATA : CoredataKeys.Entities.APP_TIKTOK_DATA)
        fetchRequest.predicate = compoundPredicate
        do {
            let matchingObjects = try self.appDel.persistentContainer.viewContext.fetch(fetchRequest)  as? [NSManagedObject]
            if matchingObjects?.count != 0{
                guard let valuess = matchingObjects else {return history}
                for values in valuess {
                    let browserHistoryId = values.value(forKey: CoredataKeys.Keys.Y_ID) as? String ?? ""
                    let history_child_id = values.value(forKey: CoredataKeys.Keys.Y_CHILD_ID) as? String ?? ""
                    let history_created_at = values.value(forKey: CoredataKeys.Keys.Y_CREATED_AT) as? String ?? ""
                    let history_deleted = values.value(forKey: CoredataKeys.Keys.Y_DELETED) as? String ?? ""
                    let history_domain = values.value(forKey: CoredataKeys.Keys.Y_DOMAIN) as? String ?? ""
                    let history_number_visted = values.value(forKey: CoredataKeys.Keys.Y_NUMBER_VISTIT) as? String ?? ""
                    let history_super_id = values.value(forKey: CoredataKeys.Keys.Y_SUPER_USER_ID) as? String ?? ""
                    let history_time_visit = values.value(forKey: CoredataKeys.Keys.Y_TIME_VIST) as? String ?? ""
                    let history_title = values.value(forKey: CoredataKeys.Keys.Y_TITLE) as? String ?? ""
                    let history_updatedAt = values.value(forKey: CoredataKeys.Keys.Y_UPDATED_AT) as? String ?? ""
                    let history_url = values.value(forKey: CoredataKeys.Keys.Y_URL) as? String ?? ""
                    let dataObj = youtubeData(id: Int(browserHistoryId) ?? 0, superUserID: Int(history_super_id) ?? 0, title: history_title, domain: history_domain, url: history_url, timeVisit: history_time_visit, numberVisits: Int(history_number_visted) ?? 0, childID: Int(history_child_id ) ?? 0, deleted: Int(history_deleted) ?? 0, createdAt: history_created_at, updatedAt: history_updatedAt)
                    history.append(dataObj)
                }
                return history
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        return history
    }
    
    func fetchWebRecordsForMonth(_ monthNumber: Int,year: Int) -> [AppHistortDataModel]{
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let calendar = Calendar.current
        //let currentDate = Date()
        //let currentYear = calendar.component(.year, from: currentDate)
        var history = [AppHistortDataModel]()
        let startDateComponents = DateComponents(year: year, month: monthNumber, day: 1)
        let startDate = calendar.date(from: startDateComponents)!
        
        let endDateComponents = DateComponents(year: year, month: monthNumber, day: 31, hour: 23, minute: 59, second: 59)
        let endDate = calendar.date(from: endDateComponents)!
        let predicate = NSPredicate(format: "(time_visits >= %@) AND (time_visits <= %@)", startDate as NSDate, endDate as NSDate)
        let childIdPredicate = NSPredicate(format: "child_id = %@", "\(id)")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, childIdPredicate])
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.APP_HISTORY_DATA)
        fetchRequest.predicate = compoundPredicate
        do {
            let results = try  self.appDel.persistentContainer.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                for result in results ?? [NSManagedObject]() {
                    let browserHistoryId = result.value(forKey: CoredataKeys.Keys.B_BROWSERHITORY_ID) as? String ?? ""
                    let history_child_id = result.value(forKey: CoredataKeys.Keys.B_CHILD_ID) as? String ?? ""
                    let history_created_at = result.value(forKey: CoredataKeys.Keys.B_CREATED_AT) as? String ?? ""
                    let history_deleted = result.value(forKey: CoredataKeys.Keys.B_DELETED) as? String ?? ""
                    let history_domain = result.value(forKey: CoredataKeys.Keys.B_DOMAIN) as? String ?? ""
                    let history_number_visted = result.value(forKey: CoredataKeys.Keys.B_NUMBER_VISTIT) as? String ?? ""
                    let history_super_id = result.value(forKey: CoredataKeys.Keys.B_SUPER_USER_ID) as? String ?? ""
                    let history_time_visit = result.value(forKey: CoredataKeys.Keys.B_TIME_VIST) as? String ?? ""
                    let history_title = result.value(forKey: CoredataKeys.Keys.B_TITLE) as? String ?? ""
                    let history_updatedAt = result.value(forKey: CoredataKeys.Keys.B_UPDATED_AT) as? String ?? ""
                    let history_url = result.value(forKey: CoredataKeys.Keys.B_URL) as? String ?? ""
                    let dataObj = AppHistortDataModel(browsinghistoryID: Int(browserHistoryId ) ?? 0, superUserID: Int(history_super_id ) ?? 0, title: history_title, domain: history_domain, url: history_url, timeVisit: history_time_visit, childID: Int(history_child_id ) ?? 0, numberVisits: Int(history_number_visted ) ?? 0, deleted: Int(history_deleted ) ?? 0, createdAt: history_created_at, updatedAt: history_updatedAt)
                    history.append(dataObj)
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        return history
    }
    
    func fetchWebHistoryData(childID: String, date: String) -> [AppHistortDataModel] {
        let outputDateString = convertDateString(date, fromFormat: "dd MMMM yyyy", toFormat: "yyyy-MM-dd")
        var history = [AppHistortDataModel]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.APP_HISTORY_DATA)
        let predicate = NSPredicate(format: "child_id = %@", childID)
        let appID = NSPredicate(format: "time_visits BEGINSWITH[cd] %@", outputDateString ?? "")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, appID])
        fetchRequest.predicate = compoundPredicate
        do {
            let results = try  self.appDel.persistentContainer.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                for result in results ?? [NSManagedObject]() {
                    let browserHistoryId = result.value(forKey: CoredataKeys.Keys.B_BROWSERHITORY_ID) as? String ?? ""
                    let history_child_id = result.value(forKey: CoredataKeys.Keys.B_CHILD_ID) as? String ?? ""
                    let history_created_at = result.value(forKey: CoredataKeys.Keys.B_CREATED_AT) as? String ?? ""
                    let history_deleted = result.value(forKey: CoredataKeys.Keys.B_DELETED) as? String ?? ""
                    let history_domain = result.value(forKey: CoredataKeys.Keys.B_DOMAIN) as? String ?? ""
                    let history_number_visted = result.value(forKey: CoredataKeys.Keys.B_NUMBER_VISTIT) as? String ?? ""
                    let history_super_id = result.value(forKey: CoredataKeys.Keys.B_SUPER_USER_ID) as? String ?? ""
                    let history_time_visit = result.value(forKey: CoredataKeys.Keys.B_TIME_VIST) as? String ?? ""
                    let history_title = result.value(forKey: CoredataKeys.Keys.B_TITLE) as? String ?? ""
                    let history_updatedAt = result.value(forKey: CoredataKeys.Keys.B_UPDATED_AT) as? String ?? ""
                    let history_url = result.value(forKey: CoredataKeys.Keys.B_URL) as? String ?? ""
                    let dataObj = AppHistortDataModel(browsinghistoryID: Int(browserHistoryId ) ?? 0, superUserID: Int(history_super_id ) ?? 0, title: history_title, domain: history_domain, url: history_url, timeVisit: history_time_visit, childID: Int(history_child_id ) ?? 0, numberVisits: Int(history_number_visted ) ?? 0, deleted: Int(history_deleted ) ?? 0, createdAt: history_created_at, updatedAt: history_updatedAt)
                    history.append(dataObj)
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        
        return history
    }
    func fetchAllWebHistory() -> [AppHistortDataModel] {
        var history = [AppHistortDataModel]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.APP_HISTORY_DATA)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time_visits", ascending: false)]
        fetchRequest.fetchLimit = 1
        do {
            let results = try  self.appDel.persistentContainer.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                for result in results ?? [NSManagedObject]() {
                    let browserHistoryId = result.value(forKey: CoredataKeys.Keys.B_BROWSERHITORY_ID) as? String ?? ""
                    let history_child_id = result.value(forKey: CoredataKeys.Keys.B_CHILD_ID) as? String ?? ""
                    let history_created_at = result.value(forKey: CoredataKeys.Keys.B_CREATED_AT) as? String ?? ""
                    let history_deleted = result.value(forKey: CoredataKeys.Keys.B_DELETED) as? String ?? ""
                    let history_domain = result.value(forKey: CoredataKeys.Keys.B_DOMAIN) as? String ?? ""
                    let history_number_visted = result.value(forKey: CoredataKeys.Keys.B_NUMBER_VISTIT) as? String ?? ""
                    let history_super_id = result.value(forKey: CoredataKeys.Keys.B_SUPER_USER_ID) as? String ?? ""
                    let history_time_visit = result.value(forKey: CoredataKeys.Keys.B_TIME_VIST) as? String ?? ""
                    let history_title = result.value(forKey: CoredataKeys.Keys.B_TITLE) as? String ?? ""
                    let history_updatedAt = result.value(forKey: CoredataKeys.Keys.B_UPDATED_AT) as? String ?? ""
                    let history_url = result.value(forKey: CoredataKeys.Keys.B_URL) as? String ?? ""
                    let dataObj = AppHistortDataModel(browsinghistoryID: Int(browserHistoryId ) ?? 0, superUserID: Int(history_super_id ) ?? 0, title: history_title, domain: history_domain, url: history_url, timeVisit: history_time_visit, childID: Int(history_child_id ) ?? 0, numberVisits: Int(history_number_visted ) ?? 0, deleted: Int(history_deleted ) ?? 0, createdAt: history_created_at, updatedAt: history_updatedAt)
                    history.append(dataObj)
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        
        return history
    }
    func saveFamilyFeed(myModelArray: [Datum]) {
        let context = appDel.persistentContainer.viewContext
        
        if #available(iOS 13.0, *) {
            var objectsToInsert: [[String: Any]] = []
            
            for model in myModelArray {
                let object: [String: Any] = [
                    "id": model.id ?? 0,
                    "child_id": model.childID ?? 0,
                    "type": model.type ?? "",
                    "data": model.data ?? "",
                    "requested_time": model.requestedTime ?? "",
                    "created_at": model.createdAt ?? ""
                ]
                objectsToInsert.append(object)
            }
            
            let batchInsert = NSBatchInsertRequest(entity: NSEntityDescription.entity(forEntityName: "FamilyFeed", in: context)!, objects: objectsToInsert)
            do {
                try context.execute(batchInsert)
                print("Batch insertion successful.")
            } catch {
                print("Error during batch insertion: \(error)")
            }
        } else {
            // Fallback for earlier iOS versions
            for model in myModelArray {
                guard let entity = NSEntityDescription.entity(forEntityName: "FamilyFeed", in: context) else { continue }
                let coreDataObject = NSManagedObject(entity: entity, insertInto: context)
                coreDataObject.setValue(model.id, forKey: "id")
                coreDataObject.setValue(model.childID, forKey: "child_id")
                coreDataObject.setValue(model.type, forKey: "type")
                coreDataObject.setValue(model.data, forKey: "data")
                coreDataObject.setValue(model.requestedTime, forKey: "requested_time")
                coreDataObject.setValue(model.createdAt, forKey: "created_at")
                do {
                    try context.save()
                } catch {
                    print("Error saving data to Core Data: \(error)")
                }
            }
        }
    }
    func getLatestFamilyFeed() -> [Datum] {
        var myModels: [Datum] = []
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FamilyFeed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "requested_time", ascending: false)]
        //          fetchRequest.fetchLimit = 1
        
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [NSManagedObject]() {
                var object = Datum(
                    id: coreDataObject.value(forKey: "id") as? Int,
                    childID: coreDataObject.value(forKey: "child_id") as? Int,
                    type: coreDataObject.value(forKey: "type") as? String,
                    data: coreDataObject.value(forKey: "data") as? String,
                    requestedTime: coreDataObject.value(forKey: "requested_time") as? String,
                    createdAt: coreDataObject.value(forKey: "created_at") as? String
                )
                
                print(object)
                myModels.append(object)
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        
        return myModels
    }
    
    //MARK: -TextMessages Handle By DB
    func setTextMsgsToCoreData(myModelArray: [MessageThreadData]) {
        let context = self.appDel.persistentContainer.viewContext
        for model in myModelArray {
            let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.TEXT_MSGS_DATA, in: context)
            let coreDataObject = NSManagedObject(entity: entity!, insertInto: context)
            coreDataObject.setValue(model.child_id ?? 0, forKey: "child_id")
            coreDataObject.setValue(model.thread_id ?? 0, forKey: "thread_id")
            coreDataObject.setValue(model.sms_time, forKey: "sms_time")
            coreDataObject.setValue(model.created_at, forKey: "created_at")
            coreDataObject.setValue(model.sms_id, forKey: "sms_id")
            coreDataObject.setValue(model.contact_name, forKey: "contact_name")
            coreDataObject.setValue(model.body, forKey: "body")
            coreDataObject.setValue(model.type, forKey: "type")
            coreDataObject.setValue(model.isRead, forKey: "isRead")
            do {
                try context.save()
            } catch {
                print("Error saving data to Core Data: \(error)")
            }
        }
    }
    func saveTextMsgsToCoreData(myModelArray: [MessageThreadData]) {
        let context = self.appDel.persistentContainer.viewContext
        if #available(iOS 13.0, *) {
            var objectsToInsert: [[String: Any]] = []
            
            for model in myModelArray {
                let object: [String: Any] = [
                    "child_id": model.child_id ?? 0,
                    "thread_id": model.thread_id ?? 0,
                    "sms_time": model.sms_time ?? Date(),
                    "created_at": model.created_at ?? "",
                    "sms_id": model.sms_id ?? "",
                    "contact_name": model.contact_name ?? "",
                    "body": model.body ?? "",
                    "type": model.type ?? "",
                    "isRead": model.isRead ?? false
                ]
                objectsToInsert.append(object)
            }
            
            let batchInsert = NSBatchInsertRequest(entity: NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.TEXT_MSGS_DATA, in: context)!, objects: objectsToInsert)
            do {
                try context.execute(batchInsert)
                print("Batch insertion successful.")
            } catch {
                print("Error during batch insertion: \(error)")
            }
        } else {
            setTextMsgsToCoreData(myModelArray: myModelArray)
        }
    }
    
    func fetchTextMsgs() -> [MessageThreadData] {
        var myModels: [MessageThreadData] = []
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.TEXT_MSGS_DATA)
        fetchRequest.predicate = NSPredicate(format: "child_id = %d", argumentArray: [id])
        
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [NSManagedObject]() {
                var object = MessageThreadData()
                object.type = coreDataObject.value(forKey: "type") as? String
                object.isRead = coreDataObject.value(forKey: "isRead") as? Int
                object.child_id = coreDataObject.value(forKey: "child_id") as? Int
                object.sms_id = coreDataObject.value(forKey: "sms_id") as? Int
                object.sms_time = coreDataObject.value(forKey: "sms_time") as? String
                object.created_at = coreDataObject.value(forKey: "created_at") as? String
                object.body = coreDataObject.value(forKey: "body") as? String
                object.contact_name = coreDataObject.value(forKey: "contact_name") as? String
                object.thread_id = coreDataObject.value(forKey: "thread_id") as? Int
                print(object)
                myModels.append(object)
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        
        return myModels
    }
    func fetchFilteredTextMsgs(fromDate: String, toDate: String) -> [MessageThreadData] {
        var myModels: [MessageThreadData] = []
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.TEXT_MSGS_DATA)
        fetchRequest.predicate = NSPredicate(format: "child_id = %d AND sms_time >= %@ AND sms_time <= %@", argumentArray: [id, fromDate, toDate])
        
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [NSManagedObject]() {
                var object = MessageThreadData()
                object.type = coreDataObject.value(forKey: "type") as? String
                object.isRead = coreDataObject.value(forKey: "isRead") as? Int
                object.child_id = coreDataObject.value(forKey: "child_id") as? Int
                object.sms_id = coreDataObject.value(forKey: "sms_id") as? Int
                object.sms_time = coreDataObject.value(forKey: "sms_time") as? String
                object.created_at = coreDataObject.value(forKey: "created_at") as? String
                object.body = coreDataObject.value(forKey: "body") as? String
                object.contact_name = coreDataObject.value(forKey: "contact_name") as? String
                object.thread_id = coreDataObject.value(forKey: "thread_id") as? Int
                print(object)
                myModels.append(object)
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        
        return myModels
    }
    
    func getLatestTextMsgs() -> [MessageThreadData] {
        var myModels: [MessageThreadData] = []
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.TEXT_MSGS_DATA)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sms_time", ascending: false)]
        //        fetchRequest.fetchLimit = 1
        
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [NSManagedObject]() {
                var object = MessageThreadData()
                object.type = coreDataObject.value(forKey: "type") as? String
                object.isRead = coreDataObject.value(forKey: "isRead") as? Int
                object.child_id = coreDataObject.value(forKey: "child_id") as? Int
                object.sms_id = coreDataObject.value(forKey: "sms_id") as? Int
                object.sms_time = coreDataObject.value(forKey: "sms_time") as? String
                object.created_at = coreDataObject.value(forKey: "created_at") as? String
                object.body = coreDataObject.value(forKey: "body") as? String
                object.contact_name = coreDataObject.value(forKey: "contact_name") as? String
                object.thread_id = coreDataObject.value(forKey: "thread_id") as? Int
                
                print(object)
                myModels.append(object)
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        
        return myModels
    }
    func getInboxSms() -> [MessageThreadData] {
        let context = self.appDel.persistentContainer.viewContext
        var uniqueObjects: [MessageThreadData] = []
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.TEXT_MSGS_DATA)
        fetchRequest.propertiesToFetch = ["thread_id"]
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.returnsDistinctResults = true
        
        do {
            let results = try context.fetch(fetchRequest) as! [[String: Any]]
            
            for result in results {
                guard let id = result["thread_id"] as? Int else {
                    continue
                }
                let fetchObjectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.TEXT_MSGS_DATA)
                let predicate = NSPredicate(format: "child_id = %d", childID)
                let thr = NSPredicate(format: "thread_id = %d", id)
                let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, thr])
                fetchObjectRequest.predicate = compoundPredicate
                fetchObjectRequest.fetchLimit = 1
                fetchObjectRequest.sortDescriptors = [NSSortDescriptor(key: "sms_time", ascending: false)]
                if let latestObject = try context.fetch(fetchObjectRequest) as? [NSManagedObject]{
                    if latestObject.count != 0 {
                        let obj = latestObject.first?.value(forKey: "thread_id") as? Int
                        let con = latestObject.first?.value(forKey: "contact_name") as? String
                        let sms_time = latestObject.first?.value(forKey: "sms_time") as? String
                        let body = latestObject.first?.value(forKey: "body") as? String
                        let obj2 = MessageThreadData(thread_id: obj, contact_name: con,body: body ,sms_time: sms_time)
                        uniqueObjects.append(obj2)
                    }
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        return uniqueObjects
    }
    func getMsgsAgainstThread(threadID: Int) -> [MessageThreadData] {
        let context = self.appDel.persistentContainer.viewContext
        var uniqueObjects: [MessageThreadData] = []
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let fetchObjectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.TEXT_MSGS_DATA)
        let predicate = NSPredicate(format: "child_id = %d", childID)
        let thr = NSPredicate(format: "thread_id = %d", threadID)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, thr])
        fetchObjectRequest.predicate = compoundPredicate
        fetchObjectRequest.sortDescriptors = [NSSortDescriptor(key: "sms_time", ascending: false)]
        do {
            if let latestObject = try context.fetch(fetchObjectRequest) as? [NSManagedObject]{
                if latestObject.count != 0 {
                    for object in latestObject {
                        let obj = object.value(forKey: "thread_id") as? Int
                        let con = object.value(forKey: "contact_name") as? String
                        let sms_time = object.value(forKey: "sms_time") as? String
                        let typ = object.value(forKey: "type") as? String
                        let body = object.value(forKey: "body") as? String
                        let obj2 = MessageThreadData(thread_id: obj, contact_name: con, body: body, sms_time: sms_time, type: typ)
                        uniqueObjects.append(obj2)
                    }
                    
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        return uniqueObjects
    }
    func fetchSocialForMonth(_ monthNumber: Int,year: Int, appIdentifier: String) -> [SocialApp]{
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let calendar = Calendar.current
        var myModels: [SocialApp] = []
        let startDateComponents = DateComponents(year: year, month: monthNumber, day: 1)
        let startDate = calendar.date(from: startDateComponents)!
        let context = self.appDel.persistentContainer.viewContext
        let endDateComponents = DateComponents(year: year, month: monthNumber, day: 31, hour: 23, minute: 59, second: 59)
        let endDate = calendar.date(from: endDateComponents)!
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as NSDate, endDate as NSDate)
        let childIdPredicate = NSPredicate(format: "child_id = %d", id)
        let appID = NSPredicate(format: "app_package = %@", appIdentifier)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, childIdPredicate, appID])
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.SOCIAL_HISTORY_DATA)
        fetchRequest.predicate = compoundPredicate
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [NSManagedObject]() {
                var object = SocialApp()
                object.appName = coreDataObject.value(forKey: "app_name") as? String
                object.childID   = coreDataObject.value(forKey: "child_id") as? Int
                object.appPackage  = coreDataObject.value(forKey: "app_package") as? String
                object.date =  coreDataObject.value(forKey: "date") as? String
                object.contentType = coreDataObject.value(forKey: "content_type") as? String
                object.contactName = coreDataObject.value(forKey: "contact_name") as? String
                object.body = coreDataObject.value(forKey: "body") as? String
                object.url = coreDataObject.value(forKey: "url") as? String
                object.fromMe =  coreDataObject.value(forKey: "from_me") as? String
                object.isRead =  coreDataObject.value(forKey: "isRead") as? Int
                
                print(object)
                myModels.append(object)
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        return myModels
    }
    func saveWebBlocker(myModelArray: [WebBlockerObj]) {
        //deleteData(entityName: "WebBlocker")
        let context = self.appDel.persistentContainer.viewContext
        
        for model in myModelArray {
            print(model.childID)
            let entity = NSEntityDescription.entity(forEntityName: "WebBlocker", in: context)
            let coreDataObject = NSManagedObject(entity: entity!, insertInto: context)
            coreDataObject.setValue(model.id ?? 0, forKey: "id")
            coreDataObject.setValue(model.childID ?? 0, forKey: "child_id")
            coreDataObject.setValue(model.type ?? "", forKey: "type")
            coreDataObject.setValue(model.url ?? "", forKey: "url")
            coreDataObject.setValue(model.isBlocked ?? 0, forKey: "isBlocked")
            coreDataObject.setValue(model.superUserID ?? 0, forKey: "superUserID")
            do {
                try context.save()
            } catch {
                print("Error saving data to Core Data: \(error)")
            }
        }
    }
    func deletObjWebBlocker(webObj: WebBlockerObj) {
        let context = self.appDel.persistentContainer.viewContext
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let fetchObjectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WebBlocker")
        let predicate = NSPredicate(format: "child_id = %d", childID)
        let idPredicate = NSPredicate(format: "id = %d", webObj.id ?? 0)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, idPredicate])
        fetchObjectRequest.predicate = compoundPredicate
        do {
            if let latestObject = try context.fetch(fetchObjectRequest) as? [NSManagedObject]{
                if latestObject.count != 0 {
                    if let obj = latestObject.first {
                        context.delete(obj)
                        do {
                            try context.save()
                        } catch {
                            print("Error saving data to Core Data: \(error)")
                        }
                    }
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    func getWebBlocker() -> [WebBlockerObj] {
        var webArr = [WebBlockerObj]()
        let context = self.appDel.persistentContainer.viewContext
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let fetchObjectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WebBlocker")
        // fetchObjectRequest.predicate = NSPredicate(format: "childID = %d", argumentArray: [childID])
        let predicate = NSPredicate(format: "child_id = %d", childID)
        fetchObjectRequest.predicate = predicate
        do {
            if let latestObject = try context.fetch(fetchObjectRequest) as? [NSManagedObject]{
                if latestObject.count != 0 {
                    for object in latestObject {
                        let id = object.value(forKey: "id") as? Int
                        let childId = object.value(forKey: "child_id") as? Int
                        let type = object.value(forKey: "type") as? String
                        let url = object.value(forKey: "url") as? String
                        let isBlocked = object.value(forKey: "isBlocked") as? Int
                        let superUserID = object.value(forKey: "superUserID") as? Int
                        let obj2 = WebBlockerObj(id: id, superUserID: superUserID, childID: childId, url: url, type: type, isBlocked: isBlocked)
                        webArr.append(obj2)
                    }
                    
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        return webArr
    }
    
    //MARK: - place Db
    func savePlaces(myModelArray: [PlaceObj]) {
        //deleteData(entityName: "WebBlocker")
        let context = self.appDel.persistentContainer.viewContext
        for model in myModelArray {
            print(model.childID)
            let entity = NSEntityDescription.entity(forEntityName: "PlacesDB", in: context)
            let coreDataObject = NSManagedObject(entity: entity!, insertInto: context)
            coreDataObject.setValue(model.id ?? 0, forKey: "id")
            coreDataObject.setValue(model.childID ?? 0, forKey: "childID")
            coreDataObject.setValue(model.type ?? "", forKey: "type")
            coreDataObject.setValue(model.isActive, forKey: "isActive")
            coreDataObject.setValue(model.userID ?? 0, forKey: "userID")
            coreDataObject.setValue(model.address, forKey: "address")
            coreDataObject.setValue(model.checkinAlert, forKey: "checkinAlert")
            coreDataObject.setValue(model.latitude, forKey: "latitude")
            coreDataObject.setValue(model.longitude, forKey: "longitude")
            coreDataObject.setValue(model.predefined, forKey: "predefined")
            coreDataObject.setValue(model.deleted, forKey: "isdeleted")
            coreDataObject.setValue(model.status, forKey: "status")
            coreDataObject.setValue(model.name, forKey: "name")
            coreDataObject.setValue(model.radius, forKey: "radius")
            coreDataObject.setValue(model.function, forKey: "function")
            do {
                try context.save()
            } catch {
                print("Error saving data to Core Data: \(error)")
            }
        }
    }
    func getPlaces() -> [PlaceObj] {
        var placeArr = [PlaceObj]()
        let context = self.appDel.persistentContainer.viewContext
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let fetchObjectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlacesDB")
        // fetchObjectRequest.predicate = NSPredicate(format: "childID = %d", argumentArray: [childID])
        let predicate = NSPredicate(format: "childID = %d", childID)
        fetchObjectRequest.predicate = predicate
        do {
            if let latestObject = try context.fetch(fetchObjectRequest) as? [NSManagedObject]{
                if latestObject.count != 0 {
                    for object in latestObject {
                        var obj2 = PlaceObj()
                        obj2.id = object.value(forKey: "id") as? Int
                        obj2.childID = object.value(forKey: "childID") as? Int
                        obj2.type = object.value(forKey: "type") as? String
                        obj2.userID = object.value(forKey: "userID") as? Int
                        obj2.isActive = object.value(forKey: "isActive") as? Int
                        obj2.name = object.value(forKey: "name") as? String
                        obj2.function = object.value(forKey: "function") as? String
                        obj2.address = object.value(forKey: "address") as? String
                        obj2.longitude = object.value(forKey: "longitude") as? String
                        obj2.latitude = object.value(forKey: "latitude") as? String
                        obj2.radius = object.value(forKey: "radius") as? Int
                        obj2.predefined = object.value(forKey: "predefined") as? Int
                        obj2.isActive = object.value(forKey: "isActive") as? Int
                        obj2.status = object.value(forKey: "status") as? Int
                        obj2.checkinAlert = object.value(forKey: "checkinAlert") as? Int
                        obj2.deleted = object.value(forKey: "isdeleted") as? Int
                        
                        placeArr.append(obj2)
                    }
                    
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        return placeArr
    }
    func getPlaceAndUpdate(id: Int, obj:PlaceObj) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlacesDB")
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let predicate = NSPredicate(format: "childID = %d", childID)
        let iD = NSPredicate(format: "id = %d", id)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, iD])
        fetchRequest.predicate = compoundPredicate
        do {
            let matchingObjects = try self.appDel.persistentContainer.viewContext.fetch(fetchRequest)  as? [NSManagedObject]
            if matchingObjects?.count != 0{
                guard let valuess = matchingObjects else {return}
                let values = valuess.first
                values!.setValue(obj.id, forKey: "id")
                values!.setValue(obj.childID, forKey: "childID")
                values!.setValue(obj.userID, forKey: "userID")
                values!.setValue(obj.status, forKey: "status")
                values!.setValue(obj.isActive, forKey: "isActive")
                values!.setValue(obj.function, forKey: "function")
                values!.setValue(obj.latitude, forKey: "latitude")
                values!.setValue(obj.longitude, forKey: "longitude")
                values!.setValue(obj.checkinAlert, forKey: "checkinAlert")
                values!.setValue(obj.predefined, forKey: "predefined")
                values!.setValue(obj.radius, forKey: "radius")
                values!.setValue(obj.name, forKey: "name")
                values!.setValue(obj.deleted, forKey: "isdeleted")
                values!.setValue(obj.address, forKey: "address")
                values!.setValue(obj.type, forKey: "type")
                saveContext()
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
            //return nil
        }
    }
    func deletePlace(id: Int) {
        let context = self.appDel.persistentContainer.viewContext
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let fetchObjectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlacesDB")
        let predicate = NSPredicate(format: "childID = %d", childID)
        let idPredicate = NSPredicate(format: "id = %d", id)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, idPredicate])
        fetchObjectRequest.predicate = compoundPredicate
        do {
            if let latestObject = try context.fetch(fetchObjectRequest) as? [NSManagedObject]{
                if latestObject.count != 0 {
                    if let obj = latestObject.first {
                        context.delete(obj)
                        do {
                            try context.save()
                        } catch {
                            print("Error saving data to Core Data: \(error)")
                        }
                    }
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    //Dailyimit
    func saveDailyLimit(myModelArray: [DailyLimitObj]) {
        let context = self.appDel.persistentContainer.viewContext
        for model in myModelArray {
            print(model.childID)
            let entity = NSEntityDescription.entity(forEntityName: "DailyLimitTable", in: context)
            let coreDataObject = NSManagedObject(entity: entity!, insertInto: context)
            coreDataObject.setValue(model.childID ?? 0, forKey: "childID")
            coreDataObject.setValue(model.duration, forKey: "duration")
            coreDataObject.setValue(model.remainingLimit, forKey: "remainingLimit")
            do {
                try context.save()
            } catch {
                print("Error saving data to Core Data: \(error)")
            }
        }
    }
    func getDailyLimit(childID: Int) -> DailyLimitObj {
        var limitObj = DailyLimitObj()
        let context = self.appDel.persistentContainer.viewContext
        //        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let fetchObjectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DailyLimitTable")
        let predicate = NSPredicate(format: "childID = %d", childID)
        fetchObjectRequest.predicate = predicate
        do {
            if let latestObject = try context.fetch(fetchObjectRequest) as? [NSManagedObject]{
                if latestObject.count != 0 {
                    if let object = latestObject.first {
                        var obj2 = DailyLimitObj()
                        obj2.childID = object.value(forKey: "childID") as? Int
                        obj2.remainingLimit = object.value(forKey: "remainingLimit") as? Int
                        obj2.duration = object.value(forKey: "duration") as? Int
                        return obj2
                        
                    }
                    
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        return limitObj
    }
    func getLimitAndUpdate(duration: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DailyLimitTable")
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let predicate = NSPredicate(format: "childID = %d", childID)
        fetchRequest.predicate = predicate
        do {
            let matchingObjects = try self.appDel.persistentContainer.viewContext.fetch(fetchRequest)  as? [NSManagedObject]
            if matchingObjects?.count != 0{
                guard let valuess = matchingObjects else {return}
                let values = valuess.first
                values!.setValue(duration, forKey: "duration")
                saveContext()
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
    }
    
    func saveLocationHis(myModelArray: [LocationObjc]) {
        let context = self.appDel.persistentContainer.viewContext
        for model in myModelArray {
            let entity = NSEntityDescription.entity(forEntityName: "LocationsHistory", in: context)
            let coreDataObject = NSManagedObject(entity: entity!, insertInto: context)
            coreDataObject.setValue(model.childID ?? 0, forKey: "childID")
            coreDataObject.setValue(model.id, forKey: "id")
            coreDataObject.setValue(model.address, forKey: "address")
            coreDataObject.setValue(model.latitude, forKey: "latitude")
            coreDataObject.setValue(model.longitude, forKey: "longitude")
            coreDataObject.setValue(model.accuracy, forKey: "accuracy")
            coreDataObject.setValue(model.speed, forKey: "speed")
            coreDataObject.setValue(model.distance, forKey: "distance")
            coreDataObject.setValue(model.type, forKey: "type")
            coreDataObject.setValue(model.createdAt, forKey: "createdAt")
            coreDataObject.setValue(model.timeIn, forKey: "timeIn")
            do {
                try context.save()
            } catch {
                print("Error saving data to Core Data: \(error)")
            }
        }
    }
    
    func fetchLocationHistoryInTimeRange(_ timeRange: TimeRange) -> [LocationObjc] {
        var locationHistory = [LocationObjc]()
        let context = self.appDel.persistentContainer.viewContext
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)! // Ensure UTC for consistent comparisons
        
        var endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date()
        var startDate: Date = Date()
        
        switch timeRange {
        case .today:
            startDate = calendar.startOfDay(for: endDate)
        case .yesterday:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            startDate = calendar.startOfDay(for: yesterday)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday) ?? yesterday
        case .last7Days:
            let yesterdayStart = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date())) ?? Date()
            startDate = calendar.date(byAdding: .day, value: -6, to: yesterdayStart) ?? Date()
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterdayStart) ?? yesterdayStart
        case .last14Days:
            let yesterdayStart = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date())) ?? Date()
            startDate = calendar.date(byAdding: .day, value: -13, to: yesterdayStart) ?? Date()
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterdayStart) ?? yesterdayStart
        case .last30Days:
            let yesterdayStart = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date())) ?? Date()
            startDate = calendar.date(byAdding: .day, value: -29, to: yesterdayStart) ?? Date()
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterdayStart) ?? yesterdayStart
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)! // UTC
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: endDate)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationsHistory")
        
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let childPredicate = NSPredicate(format: "childID == %d", childID)
        let datePredicate = NSPredicate(format: "timeIn >= %@ AND timeIn <= %@", startDateString, endDateString)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [childPredicate, datePredicate])
        fetchRequest.predicate = compoundPredicate
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            for result in results ?? [] {
                var locationObj = LocationObjc()
                locationObj.id = result.value(forKey: "id") as? Int
                locationObj.childID = result.value(forKey: "childID") as? Int
                locationObj.type = result.value(forKey: "type") as? String
                locationObj.userID = result.value(forKey: "userID") as? Int
                locationObj.address = result.value(forKey: "address") as? String
                locationObj.longitude = result.value(forKey: "longitude") as? String
                locationObj.latitude = result.value(forKey: "latitude") as? String
                locationObj.timeIn = result.value(forKey: "timeIn") as? String
                locationObj.createdAt = result.value(forKey: "createdAt") as? String
                locationObj.distance = result.value(forKey: "distance") as? String
                
                locationHistory.append(locationObj)
            }
        } catch {
            print("Error fetching location history in time range: \(error.localizedDescription)")
        }
        
        return locationHistory
    }

    func getLocByDate(timeStr: String) -> [LocationObjc] {
        var placeArr = [LocationObjc]()
        let outputDateString = convertDateString(timeStr, fromFormat: "EEEE, MMM d, yyyy", toFormat: "yyyy-MM-dd")
        let context = self.appDel.persistentContainer.viewContext
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let fetchObjectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationsHistory")
        let predicate = NSPredicate(format: "childID = %d", childID)
        // let timePredicate = NSPredicate(format: "timeIn = %d", timeStr)
        let time = NSPredicate(format: "timeIn BEGINSWITH[cd] %@", timeStr)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,time])
        fetchObjectRequest.predicate = compoundPredicate
        do {
            if let latestObject = try context.fetch(fetchObjectRequest) as? [NSManagedObject]{
                if latestObject.count != 0 {
                    for object in latestObject {
                        var obj2 = LocationObjc()
                        obj2.id = object.value(forKey: "id") as? Int
                        obj2.childID = object.value(forKey: "childID") as? Int
                        obj2.type = object.value(forKey: "type") as? String
                        obj2.userID = object.value(forKey: "userID") as? Int
                        obj2.address = object.value(forKey: "address") as? String
                        obj2.longitude = object.value(forKey: "longitude") as? String
                        obj2.latitude = object.value(forKey: "latitude") as? String
                        obj2.timeIn = object.value(forKey: "timeIn") as? String
                        obj2.createdAt = object.value(forKey: "createdAt") as? String
                        obj2.distance = object.value(forKey: "distance") as? String
                        
                        placeArr.append(obj2)
                    }
                    
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        return placeArr
    }
    
    func getUniqueDays()-> [String] {
        let context = self.appDel.persistentContainer.viewContext
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationsHistory")
        let predicate = NSPredicate(format: "childID = %d", childID)
        fetchRequest.predicate = predicate
        do {
            let allObjects = try context.fetch(fetchRequest)
            var uniqueDays = Set<String>()
            for object in allObjects {
                if let timeIn = (object as AnyObject).value(forKey: "timeIn") as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures 24-hour format
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.dateFormat = "yyyy-MM-dd"
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures 24-hour format
                    if let date = dateFormatter.date(from: timeIn) {
                        let dateString = dateFormatter2.string(from: date)
                        uniqueDays.insert(dateString)
                    }
                }
            }
            let sorted = uniqueDays.sorted(by: {getDate(str: $0) > getDate(str: $1)})
            return sorted
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        return []
    }
    func getDate(str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: str) {
            print(date)
            return date
        } else {
            print("Error: Unable to convert the string to a Date.")
        }
        return Date()
    }
    func fetchAllLocationHistory() -> [LocationObjc] {
        var myModels: [LocationObjc] = []
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationsHistory")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeIn", ascending: false)]
        fetchRequest.fetchLimit = 1
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [NSManagedObject]() {
                var object = LocationObjc()
                object.timeIn = coreDataObject.value(forKey: "timeIn") as? String
                print(object)
                myModels.append(object)
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
        return myModels
    }
}

enum EntityName: String {
    case control = "Control_Model_DB"
    case controlAppList = "ControlAppList"
    
    
    var attribute: String {
        switch self {
        case .control:
            return "control"
        case .controlAppList:
            return "aapList"
        }
    }
}

enum DBError:String {
    case noData = "No Data Found"
}
enum TimeRange {
    case today
    case yesterday
    case last7Days
    case last14Days
    case last30Days
}

extension DBManager {
    func countMsgObjectsInTimeRange(_ timeRange: TimeRange) -> Int {
        
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.TEXT_MSGS_DATA)
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        
        var count = 0
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)! // Work in UTC
        
        let now = Date()
        var startDate: Date
        var endDate: Date
        
        switch timeRange {
        case .today:
            startDate = calendar.startOfDay(for: now)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate) ?? now
            
        case .yesterday:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
            startDate = calendar.startOfDay(for: yesterday)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
            
        case .last7Days:
            // Exclude today, include yesterday
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            startDate = calendar.date(byAdding: .day, value: -6, to: yesterday)!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            
        case .last14Days:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            startDate = calendar.date(byAdding: .day, value: -13, to: calendar.startOfDay(for: endDate))!
            
        case .last30Days:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            startDate = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: endDate))!
        }
        
        // Date formatter to match database format (UTC, 24-hour)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures 24-hour format
        
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        let predi = NSPredicate(format: "(sms_time >= %@) AND (sms_time <= %@)", startDateString, endDateString)
        let idPred = NSPredicate(format: "child_id = %d", childID)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predi, idPred])
        fetchRequest.predicate = compoundPredicate
        do {
            if let latestObject = try context.fetch(fetchRequest) as? [NSManagedObject]{
                if latestObject.count != 0 {
                    count = latestObject.count
                }
            }
            return count
        } catch {
            print("Error counting objects: \(error.localizedDescription)")
        }
        return 0
    }
    
    func contactsCountInTimeRange(_ timeRange: TimeRange) -> Int {
        let context = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactsTable")
        
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)! // Work in UTC
        
        let now = Date()
        var startDate: Date
        var endDate: Date
        
        switch timeRange {
        case .today:
            startDate = calendar.startOfDay(for: now)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate) ?? now
            
        case .yesterday:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
            startDate = calendar.startOfDay(for: yesterday)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
            
        case .last7Days:
            // Exclude today, include yesterday
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            startDate = calendar.date(byAdding: .day, value: -6, to: yesterday)!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            
        case .last14Days:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            startDate = calendar.date(byAdding: .day, value: -13, to: calendar.startOfDay(for: endDate))!
            
        case .last30Days:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            startDate = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: endDate))!
        }
        
        // Date formatter to match database format (UTC, 24-hour)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures 24-hour format
        
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        print("startDateString:", startDateString)
        print("endDateString:", endDateString)
        
        let datePredicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", startDateString, endDateString)
        let childPredicate = NSPredicate(format: "childID == %d", childID)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, childPredicate])
        
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                return results.count
            }
        } catch {
            print("Error fetching contacts count:", error.localizedDescription)
        }
        
        return 0
    }

    func totalTalkTimeInTimeRange(_ timeRange: TimeRange) -> Int {
        
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Calls")
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        var totalTalkTime = 0
        var count = 0
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)! // Work in UTC
        
        let now = Date()
        var startDate: Date
        var endDate: Date
        
        switch timeRange {
        case .today:
            startDate = calendar.startOfDay(for: now)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate) ?? now
            
        case .yesterday:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
            startDate = calendar.startOfDay(for: yesterday)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
            
        case .last7Days:
            // Exclude today, include yesterday
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            startDate = calendar.date(byAdding: .day, value: -6, to: yesterday)!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            
        case .last14Days:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            startDate = calendar.date(byAdding: .day, value: -13, to: calendar.startOfDay(for: endDate))!
            
        case .last30Days:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            startDate = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: endDate))!
        }
        
        // Date formatter to match database format (UTC, 24-hour)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures 24-hour format
        
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        let predi = NSPredicate(format: "(callTime >= %@) AND (callTime < %@)", startDateString, endDateString)
        let idPred = NSPredicate(format: "childID = %d", childID)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predi, idPred])
        fetchRequest.predicate = compoundPredicate
        
        do {
            if let calls = try context.fetch(fetchRequest) as? [NSManagedObject] {
                for call in calls {
                    if let durationString = call.value(forKey: "durationInSeconds") as? String,
                       let durationInSeconds = Int(durationString) {
                        totalTalkTime += durationInSeconds
                    }
                }
            }
        } catch {
            print("Error counting objects: \(error.localizedDescription)")
        }
        
        return totalTalkTime
    }
    
    func totalV1AppUsageInTimeRange(_ timeRange: TimeRange) -> Int {
        
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "V1AppUsage")
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        
        var totalAppUsage = 0
        var count = 0
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let now = Date()
        var startDate: Date
        var endDate: Date
        
        switch timeRange {
        case .today:
            startDate = calendar.startOfDay(for: now)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate) ?? now
            
        case .yesterday:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
            startDate = calendar.startOfDay(for: yesterday)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
            
        case .last7Days:
            // Exclude today, include yesterday
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            startDate = calendar.date(byAdding: .day, value: -6, to: yesterday)!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            
        case .last14Days:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            startDate = calendar.date(byAdding: .day, value: -13, to: calendar.startOfDay(for: endDate))!
            
        case .last30Days:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            startDate = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: endDate))!
        }
        
        // Date formatter to match database format (UTC, 24-hour)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures 24-hour format
        
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        let predi = NSPredicate(format: "(dateUsage >= %@) AND (dateUsage <= %@)", startDateString, endDateString)
        let idPred = NSPredicate(format: "childID = %d", childID)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predi, idPred])
        fetchRequest.predicate = compoundPredicate
        
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject]{
                for result in results {
                    if let appUsage = result.value(forKey: "appUsage") as? Int64 {
                        totalAppUsage += Int(appUsage)
                    }
                }
            }
        }
        catch {
            print("Error fetching app usage data: \(error.localizedDescription)")
            
        }
        return totalAppUsage
    }
    
    func totalAppUsageInTimeRange(_ timeRange: TimeRange) -> Int {
        
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUsageCore")
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        
        var totalAppUsage = 0
        var count = 0
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)! // Work in UTC
        
        let now = Date()
        var startDate: Date
        var endDate: Date
        
        switch timeRange {
        case .today:
            startDate = calendar.startOfDay(for: now)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate) ?? now
            
        case .yesterday:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
            startDate = calendar.startOfDay(for: yesterday)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
            
        case .last7Days:
            // Exclude today, include yesterday
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            startDate = calendar.date(byAdding: .day, value: -6, to: yesterday)!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            
        case .last14Days:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            startDate = calendar.date(byAdding: .day, value: -13, to: calendar.startOfDay(for: endDate))!
            
        case .last30Days:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            startDate = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: endDate))!
        }
        
        // Date formatter to match database format (UTC, 24-hour)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures 24-hour format
        
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        let predi = NSPredicate(format: "(dateUsage >= %@) AND (dateUsage <= %@)", startDateString, endDateString)
        let idPred = NSPredicate(format: "childID = %d", childID)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predi, idPred])
        fetchRequest.predicate = compoundPredicate
        
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject]{
                for result in results {
                    if let appUsage = result.value(forKey: "appUsage") as? Int64 {
                        totalAppUsage += Int(appUsage)
                    }
                }
            }
        }
        catch {
            print("Error fetching app usage data: \(error.localizedDescription)")
            
        }
        return totalAppUsage
    }
    
    func fetchInstalledAppsInTimeRange(_ timeRange: TimeRange) -> [InstalledApp] {
        
        var installedApps: [InstalledApp] = []
        let context = self.appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ControlListApps")
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)! // Work in UTC
        
        let now = Date()
        var startDate: Date
        var endDate: Date
        
        switch timeRange {
        case .today:
            startDate = calendar.startOfDay(for: now)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate) ?? now
            
        case .yesterday:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
            startDate = calendar.startOfDay(for: yesterday)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
            
        case .last7Days:
            // Exclude today, include yesterday
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            startDate = calendar.date(byAdding: .day, value: -6, to: yesterday)!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            
        case .last14Days:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            startDate = calendar.date(byAdding: .day, value: -13, to: calendar.startOfDay(for: endDate))!
            
        case .last30Days:
            let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now))!
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: yesterday)!
            startDate = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: endDate))!
        }
        
        // Date formatter to match database format (UTC, 24-hour)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures 24-hour format
        
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        let predi = NSPredicate(format: "(appsTime >= %@) AND (appsTime < %@)", startDateString, endDateString)
        let idPred = NSPredicate(format: "childID = %d", childID)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predi, idPred])
        fetchRequest.predicate = compoundPredicate
        
        do {
            let coreDataObjects = try context.fetch(fetchRequest) as? [NSManagedObject]
            for coreDataObject in coreDataObjects ?? [] {
                var object = InstalledApp()
                object.installedappID = coreDataObject.value(forKey: "installedappID") as? Int
                object.appName = coreDataObject.value(forKey: "appName") as? String
                object.childID = coreDataObject.value(forKey: "childID") as? Int
                object.saturday = coreDataObject.value(forKey: "saturday") as? Int
                object.sunday = coreDataObject.value(forKey: "sunday") as? Int
                object.monday = coreDataObject.value(forKey: "monday") as? Int
                object.tuesday = coreDataObject.value(forKey: "tuesday") as? Int
                object.wednesday = coreDataObject.value(forKey: "wednesday") as? Int
                object.thursday = coreDataObject.value(forKey: "thursday") as? Int
                object.friday = coreDataObject.value(forKey: "friday") as? Int
                object.appLimit = coreDataObject.value(forKey: "appLimit") as? String
                object.appsTime = coreDataObject.value(forKey: "appsTime") as? String
                object.isMonitor = coreDataObject.value(forKey: "isMonitor") as? Int
                object.appPackageName = coreDataObject.value(forKey: "appPackageName") as? String
                object.isBlacklisted = coreDataObject.value(forKey: "isBlacklisted") as? Int
                object.inDailyLimit = coreDataObject.value(forKey: "inDailyLimit") as? Int
                object.size = coreDataObject.value(forKey: "size") as? Int
                object.appCategory = coreDataObject.value(forKey: "appCategory") as? String
                object.dateCreated = coreDataObject.value(forKey: "dateCreated") as? String
                object.dateModified = coreDataObject.value(forKey: "dateModified") as? String
                object.deleted = coreDataObject.value(forKey: "deletedm") as? Int
                installedApps.append(object)
            }
        } catch {
            print("Error fetching installed apps data: \(error)")
        }
        return installedApps
    }
}
