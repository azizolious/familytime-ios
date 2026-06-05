//
//  CoreDataUtility.swift
//  FamilyTime
//
//  Created by Usama-Apps on 02/08/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation
import CoreData
import SDWebImage

@objc class CoreDataUtility: NSObject {
    //MARK: - Variables
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
    
    
    //MARK: - Saving Data Functions
    @objc static func savePackageIdInDatabase(childId:Int32, packageId:Int32, device:String, package:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.PACKAGE_FILE)
        fetchRequest.predicate = NSPredicate(format: "child_id = %@", argumentArray: [childId])
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(package, forKey: CoredataKeys.Keys.PACKAGE_NAME)
                results![0].setValue(packageId, forKey: CoredataKeys.Keys.PLAN_ID)
                results![0].setValue(childId, forKey: CoredataKeys.Keys.CHILD_ID)
                results![0].setValue(device, forKey: CoredataKeys.Keys.DEVICE)
            } else {
                let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.PACKAGE_FILE, in: context)
                let child = NSManagedObject(entity: entity!, insertInto: context)
                child.setValue(package, forKey: CoredataKeys.Keys.PACKAGE_NAME)
                child.setValue(packageId, forKey: CoredataKeys.Keys.PLAN_ID)
                child.setValue(childId, forKey: CoredataKeys.Keys.CHILD_ID)
                child.setValue(device, forKey: CoredataKeys.Keys.DEVICE)
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        do {
            try context.save()
        }
        catch {
            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
    }
    
    @objc static func savePremiumPackageDetails(data: Configuration) {
        let id = "\(String(describing: data.id ?? 0))"
        let configName = data.configName ?? ""
        //let configValue = “\(String(describing: data.configValue ?? 0))”
        let plateformID = "\(String(describing: data.plateformID ?? 0))"
        let plateform = data.plateform ?? ""
        let active = "\(String(describing: data.active ?? 0))"
        let keyValue = data.keyValue ?? ""
        let createdAt = data.createdAt ?? ""
        let updatedAt = data.updatedAt ?? ""
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.CONFIGURATION_FILE)
        fetchRequest.predicate = NSPredicate(format: "configName = %@", argumentArray: [configName])
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(id, forKey: CoredataKeys.Keys.ID)
                results![0].setValue(configName, forKey: CoredataKeys.Keys.CONFIG_NAME)
                //results![0].setValue(configValue, forKey: CoredataKeys.KEY_CONFIG_VALUE)
                results![0].setValue(keyValue, forKey: CoredataKeys.Keys.KEY_VALUE)
                results![0].setValue(plateformID, forKey: CoredataKeys.Keys.platformId)
                results![0].setValue(plateform, forKey: CoredataKeys.Keys.PLATEFORM)
                results![0].setValue(active, forKey: CoredataKeys.Keys.ACTIVE)
                results![0].setValue(createdAt, forKey: CoredataKeys.Keys.createdAt)
                results![0].setValue(updatedAt, forKey: CoredataKeys.Keys.updatedAt)
            } else {
                let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.CONFIGURATION_FILE, in:  context)
                let config = NSManagedObject(entity: entity!, insertInto: context)
                config.setValue(id, forKey: CoredataKeys.Keys.ID)
                config.setValue(configName, forKey: CoredataKeys.Keys.CONFIG_NAME)
                // config.setValue(configValue, forKey: CoredataKeys.KEY_CONFIG_VALUE)
                config.setValue(keyValue, forKey: CoredataKeys.Keys.KEY_VALUE)
                config.setValue(plateformID, forKey: CoredataKeys.Keys.platformId)
                config.setValue(plateform, forKey: CoredataKeys.Keys.PLATEFORM)
                config.setValue(active, forKey: CoredataKeys.Keys.ACTIVE)
                config.setValue(createdAt, forKey: CoredataKeys.Keys.createdAt)
                config.setValue(updatedAt, forKey: CoredataKeys.Keys.updatedAt)
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED,"\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print( StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
    }

    //MARK: SAVING ACCOUNT DATA
    @objc static func saveAccountData(profile: Profile) {
        let id = "\(profile.id ?? 0)"
        let super_ID = "\(profile.superUserID ?? 0)"
        let name = profile.name ?? ""
        let gender = profile.gender ?? ""
        let email = profile.email ?? ""
        let phone = profile.phone ?? ""
        let type = profile.type ?? ""
        let language = profile.language ?? ""
        let createdAt = profile.createdAt ?? ""
        let package = profile.package ?? ""
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.ACCOUNT_DATA_FILE)
        fetchRequest.predicate = NSPredicate(format: "id = %@", argumentArray: [id])
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(id, forKey: CoredataKeys.Keys.ID)
                results![0].setValue(super_ID, forKey: CoredataKeys.Keys.SUPER_USER_ID)
                results![0].setValue(name, forKey: CoredataKeys.Keys.NAME)
                results![0].setValue(gender, forKey: CoredataKeys.Keys.GENDER)
                results![0].setValue(email, forKey: CoredataKeys.Keys.EMAIL)
                results![0].setValue(phone, forKey: CoredataKeys.Keys.PHONE)
                results![0].setValue(type, forKey: CoredataKeys.Keys.TYPE)
                results![0].setValue(language, forKey: CoredataKeys.Keys.LANGUAGE)
                results![0].setValue(createdAt, forKey: CoredataKeys.Keys.CREATED_AT)
                results![0].setValue(package, forKey: CoredataKeys.Keys.PACKAGE)
                results![0].setValue(package, forKey: CoredataKeys.Keys.EMAIL_BOUNCE_ACCOUNT_DATA)
                results![0].setValue(package, forKey: CoredataKeys.Keys.EMAIL_COMPLAINT_ACCOUNT_DATA)
                results![0].setValue(package, forKey: CoredataKeys.Keys.EMAIL_VERIFIED_AT_ACCOUNT_DATA)
            } else {
                let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.ACCOUNT_DATA_FILE, in:  context)
                let config = NSManagedObject(entity: entity!, insertInto:  context)
                config.setValue(id, forKey: CoredataKeys.Keys.ID)
                config.setValue(super_ID, forKey: CoredataKeys.Keys.SUPER_USER_ID)
                config.setValue(name, forKey: CoredataKeys.Keys.NAME)
                config.setValue(gender, forKey: CoredataKeys.Keys.GENDER)
                config.setValue(email, forKey: CoredataKeys.Keys.EMAIL)
                config.setValue(phone, forKey: CoredataKeys.Keys.PHONE)
                config.setValue(type, forKey: CoredataKeys.Keys.TYPE)
                config.setValue(language, forKey: CoredataKeys.Keys.LANGUAGE)
                config.setValue(createdAt, forKey: CoredataKeys.Keys.CREATED_AT)
                config.setValue(package, forKey: CoredataKeys.Keys.PACKAGE)
                config.setValue(package, forKey: CoredataKeys.Keys.EMAIL_COMPLAINT_ACCOUNT_DATA)
                config.setValue(package, forKey: CoredataKeys.Keys.EMAIL_BOUNCE_ACCOUNT_DATA)
                config.setValue(package, forKey: CoredataKeys.Keys.EMAIL_VERIFIED_AT_ACCOUNT_DATA)
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED,"\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print( StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
    }

    //MARK: ACCOUNT SUBSCRIPTION
    @objc static func saveSubscriptionData(subs: SubscriptionsData) {
        let s_id = "\(subs.id ?? 0)"
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.BILLING_DATA_FILE)
        fetchRequest2.predicate = NSPredicate(format: "id = %@", argumentArray: [s_id])
        do {
            let results1 = try  context.fetch(fetchRequest2) as? [NSManagedObject]
            if results1?.count != 0 {
                results1![0].setValue("\(subs.id ?? 0)", forKey: CoredataKeys.Keys.ID)
                results1![0].setValue(subs.subscriptionID ?? "", forKey: CoredataKeys.Keys.SUBSCRIPTION_ID)
                results1![0].setValue(subs.startDate ?? "", forKey: CoredataKeys.Keys.START_DATE)
                results1![0].setValue(subs.endDate ?? "", forKey: CoredataKeys.Keys.END_DATE)
                results1![0].setValue(subs.plan ?? "", forKey: CoredataKeys.Keys.PLAN)
                results1![0].setValue(subs.product ?? "", forKey: CoredataKeys.Keys.PRODUCT)
                results1![0].setValue(subs.psp ?? "", forKey: CoredataKeys.Keys.PSP)
                results1![0].setValue("\(subs.status ?? 0)", forKey: CoredataKeys.Keys.STATUS)
                results1![0].setValue(subs.createdAt ?? "", forKey: CoredataKeys.Keys.CREATED_AT)
            } else {
                let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.BILLING_DATA_FILE, in:  context)
                let entity1 = NSManagedObject(entity: entity!, insertInto:  context)
                entity1.setValue("\(subs.id ?? 0)", forKey: CoredataKeys.Keys.ID)
                entity1.setValue(subs.subscriptionID ?? "", forKey: CoredataKeys.Keys.SUBSCRIPTION_ID)
                entity1.setValue(subs.startDate ?? "", forKey: CoredataKeys.Keys.START_DATE)
                entity1.setValue(subs.endDate ?? "", forKey: CoredataKeys.Keys.END_DATE)
                entity1.setValue(subs.plan ?? "", forKey: CoredataKeys.Keys.PLAN)
                entity1.setValue(subs.product ?? "", forKey: CoredataKeys.Keys.PRODUCT)
                entity1.setValue(subs.psp ?? "", forKey: CoredataKeys.Keys.PSP)
                entity1.setValue("\(subs.status ?? 0)", forKey: CoredataKeys.Keys.STATUS)
                entity1.setValue(subs.createdAt ?? "", forKey: CoredataKeys.Keys.CREATED_AT)
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED,"\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print( StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
    }
    
    //MARK: - SAVE HOME API DATA
    
    //MARK: Save Child Info
    @objc static func saveChildInfoInDatabase(data:ChildData) {
        let child_id = "\(data.childInfo?.childID ?? 0)"
        let fetchRequestChildInfo = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.CHILD_INFO_FILE)
        fetchRequestChildInfo.predicate = NSPredicate(format: "child_id_child_info = %@", argumentArray: [child_id])
        
        do {
            let results = try  context.fetch(fetchRequestChildInfo) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(child_id, forKey: CoredataKeys.Keys.CHILD_ID_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.name ?? "")", forKey: CoredataKeys.Keys.NAME_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.birthday ?? "")", forKey: CoredataKeys.Keys.BIRTHDAY_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.gender ?? "")", forKey: CoredataKeys.Keys.GENDER_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.relationship ?? "" )", forKey: CoredataKeys.Keys.RELATIONSHIP_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.email ?? "")", forKey: CoredataKeys.Keys.EMAIL_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.phone ?? "")", forKey: CoredataKeys.Keys.PHONE_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.plateformID ?? 0)", forKey: CoredataKeys.Keys.PLATEFORM_ID_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.device ?? "")", forKey: CoredataKeys.Keys.DEVICE_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.planID ?? 0)", forKey: CoredataKeys.Keys.PLAN_ID_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.packageID ?? 0)", forKey: CoredataKeys.Keys.PACKAGE_ID_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.package ?? "")", forKey: CoredataKeys.Keys.PACKAGE_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.duration ?? "")", forKey: CoredataKeys.Keys.DURATION_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.expiryDate ?? "")", forKey: CoredataKeys.Keys.EXPAIRY_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.remainingDays ?? "")", forKey: CoredataKeys.Keys.REMAINING_DAYS_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.coverImgSrc ?? "")", forKey: CoredataKeys.Keys.COVER_IMG_SRC_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.profileImgSrc ?? "")", forKey: CoredataKeys.Keys.PROFILE_IMG_SRC_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.color ?? "")", forKey: CoredataKeys.Keys.COLOR_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.phonelockStatus  ?? 0)", forKey: CoredataKeys.Keys.PHONE_LOCK_STATUS_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.active ?? 0)", forKey: CoredataKeys.Keys.ACTIVE_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.deleted ?? 0)", forKey: CoredataKeys.Keys.DELETED_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.deletedBy ?? "")", forKey: CoredataKeys.Keys.DELETED_BY_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.superUserID ?? 0)", forKey: CoredataKeys.Keys.SUPER_USER_ID_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.activationCode ?? "")", forKey: CoredataKeys.Keys.ACTIVATION_CODE_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.dateCreated ?? "")", forKey: CoredataKeys.Keys.DATE_CREATED_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.dateModified ?? "")", forKey: CoredataKeys.Keys.DATE_MODIFIED_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.pushToken ?? "")", forKey: CoredataKeys.Keys.PUSH_TOKEN_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.childEnrolled ?? 0)", forKey: CoredataKeys.Keys.CHILD_ENROLLED_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.childMdmHash ?? "")", forKey: CoredataKeys.Keys.CHILD_MDM_HASH_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.isProductionBuild ?? 0)", forKey: CoredataKeys.Keys.IS_PRODUCTION_BUILD_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.versionNumber ?? "")", forKey: CoredataKeys.Keys.VERSION_NUMBER_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.versionCode ?? "")", forKey: CoredataKeys.Keys.VERSION_CODE_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.subscriptionID ?? "")", forKey: CoredataKeys.Keys.SUBSCRIPTION_ID_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.schoolID ?? "")", forKey: CoredataKeys.Keys.SCHOOL_ID_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.campusID ?? "")", forKey: CoredataKeys.Keys.CAMPUS_ID_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.classID ?? "")", forKey: CoredataKeys.Keys.CLASS_ID_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.resellerID ?? 0)", forKey: CoredataKeys.Keys.RESELLER_ID_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.timeZone ?? "")", forKey: CoredataKeys.Keys.TIME_ZONE_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.isForgetMe ?? 0)", forKey: CoredataKeys.Keys.IS_FOGET_ME_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.apiToken ?? "")", forKey: CoredataKeys.Keys.API_TOKEN_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.activationDate ?? "")", forKey: CoredataKeys.Keys.ACTIVATION_DATE_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.createdAt ?? "")", forKey: CoredataKeys.Keys.CREATED_AT_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.updatedAt ?? "")", forKey: CoredataKeys.Keys.UPDATED_AT_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.uniqueDeviceID ?? "")", forKey: CoredataKeys.Keys.UNIQUE_DEVICE_ID_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.agent ?? "")", forKey: CoredataKeys.Keys.AGENT_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.newSubscriptionID ?? 0)", forKey: CoredataKeys.Keys.NEW_SUBSCRIPTION_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.priority ?? 0)", forKey: CoredataKeys.Keys.PRIORITY_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.deviceOS ?? "")", forKey: CoredataKeys.Keys.DEVICE_OS_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.batteryRemaining ?? "")", forKey: CoredataKeys.Keys.BATTERY_REMAINING_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.wifiName ?? "")", forKey: CoredataKeys.Keys.WIFI_NAME_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.deviceLanguage ?? "")", forKey: CoredataKeys.Keys.DEVICE_LANGUAGE_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.appBuild ?? "")", forKey: CoredataKeys.Keys.APP_BUILD_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.appVersion ?? "")", forKey: CoredataKeys.Keys.APP_VERSION_CHILD_INFO)
                results![0].setValue("\(data.childInfo?.deviceModel ?? "")", forKey: CoredataKeys.Keys.DEVICE_MENUFACTURED_CHILD_INFO)
                //appVersion
                
            } else {
                let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.CHILD_INFO_FILE, in:  context)
                let entity1 = NSManagedObject(entity: entity!, insertInto: context)
                entity1.setValue(child_id, forKey: CoredataKeys.Keys.CHILD_ID_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.name ?? "")", forKey: CoredataKeys.Keys.NAME_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.birthday ?? "")", forKey: CoredataKeys.Keys.BIRTHDAY_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.gender ?? "")", forKey: CoredataKeys.Keys.GENDER_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.relationship ?? "" )", forKey: CoredataKeys.Keys.RELATIONSHIP_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.email ?? "")", forKey: CoredataKeys.Keys.EMAIL_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.phone ?? "")", forKey: CoredataKeys.Keys.PHONE_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.plateformID ?? 0)", forKey: CoredataKeys.Keys.PLATEFORM_ID_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.device ?? "")", forKey: CoredataKeys.Keys.DEVICE_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.planID ?? 0)", forKey: CoredataKeys.Keys.PLAN_ID_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.packageID ?? 0)", forKey: CoredataKeys.Keys.PACKAGE_ID_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.package ?? "")", forKey: CoredataKeys.Keys.PACKAGE_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.duration ?? "")", forKey: CoredataKeys.Keys.DURATION_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.expiryDate ?? "")", forKey: CoredataKeys.Keys.EXPAIRY_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.remainingDays ?? "")", forKey: CoredataKeys.Keys.REMAINING_DAYS_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.coverImgSrc ?? "")", forKey: CoredataKeys.Keys.COVER_IMG_SRC_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.profileImgSrc ?? "")", forKey: CoredataKeys.Keys.PROFILE_IMG_SRC_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.color ?? "")", forKey: CoredataKeys.Keys.COLOR_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.phonelockStatus  ?? 0)", forKey: CoredataKeys.Keys.PHONE_LOCK_STATUS_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.active ?? 0)", forKey: CoredataKeys.Keys.ACTIVE_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.deleted ?? 0)", forKey: CoredataKeys.Keys.DELETED_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.deletedBy ?? "")", forKey: CoredataKeys.Keys.DELETED_BY_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.superUserID ?? 0)", forKey: CoredataKeys.Keys.SUPER_USER_ID_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.activationCode ?? "")", forKey: CoredataKeys.Keys.ACTIVATION_CODE_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.dateCreated ?? "")", forKey: CoredataKeys.Keys.DATE_CREATED_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.dateModified ?? "")", forKey: CoredataKeys.Keys.DATE_MODIFIED_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.pushToken ?? "")", forKey: CoredataKeys.Keys.PUSH_TOKEN_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.childEnrolled ?? 0)", forKey: CoredataKeys.Keys.CHILD_ENROLLED_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.childMdmHash ?? "")", forKey: CoredataKeys.Keys.CHILD_MDM_HASH_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.isProductionBuild ?? 0)", forKey: CoredataKeys.Keys.IS_PRODUCTION_BUILD_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.versionNumber ?? "")", forKey: CoredataKeys.Keys.VERSION_NUMBER_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.versionCode ?? "")", forKey: CoredataKeys.Keys.VERSION_CODE_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.subscriptionID ?? "")", forKey: CoredataKeys.Keys.SUBSCRIPTION_ID_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.schoolID ?? "")", forKey: CoredataKeys.Keys.SCHOOL_ID_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.campusID ?? "")", forKey: CoredataKeys.Keys.CAMPUS_ID_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.classID ?? "")", forKey: CoredataKeys.Keys.CLASS_ID_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.resellerID ?? 0)", forKey: CoredataKeys.Keys.RESELLER_ID_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.timeZone ?? "")", forKey: CoredataKeys.Keys.TIME_ZONE_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.isForgetMe ?? 0)", forKey: CoredataKeys.Keys.IS_FOGET_ME_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.apiToken ?? "")", forKey: CoredataKeys.Keys.API_TOKEN_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.activationDate ?? "")", forKey: CoredataKeys.Keys.ACTIVATION_DATE_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.createdAt ?? "")", forKey: CoredataKeys.Keys.CREATED_AT_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.updatedAt ?? "")", forKey: CoredataKeys.Keys.UPDATED_AT_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.uniqueDeviceID ?? "")", forKey: CoredataKeys.Keys.UNIQUE_DEVICE_ID_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.agent ?? "")", forKey: CoredataKeys.Keys.AGENT_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.newSubscriptionID ?? 0)", forKey: CoredataKeys.Keys.NEW_SUBSCRIPTION_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.priority ?? 0)", forKey: CoredataKeys.Keys.PRIORITY_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.deviceOS ?? "")", forKey: CoredataKeys.Keys.DEVICE_OS_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.batteryRemaining ?? "")", forKey: CoredataKeys.Keys.BATTERY_REMAINING_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.wifiName ?? "")", forKey: CoredataKeys.Keys.WIFI_NAME_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.deviceLanguage ?? "")", forKey: CoredataKeys.Keys.DEVICE_LANGUAGE_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.appBuild ?? "")", forKey: CoredataKeys.Keys.APP_BUILD_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.appVersion ?? "")", forKey: CoredataKeys.Keys.APP_VERSION_CHILD_INFO)
                entity1.setValue("\(data.childInfo?.deviceManufacturer ?? "")", forKey: CoredataKeys.Keys.DEVICE_MENUFACTURED_CHILD_INFO)
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED,"\(error)")
        }
        
        do {
            try  context.save()
        } catch {
            print( StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
    }
    
    //MARK: Save Dashboard Data
    @objc static func saveDashbaordInDatabase(dashboard: [ChildData]) {
        let fetchRequestChildInfo = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.CHILD_INFO_DASHBOARD)
        do {
            let results = try  context.fetch(fetchRequestChildInfo) as? [NSManagedObject]
            for data in dashboard {
                if results?.count != 0 {
                    results![0].setValue("\(data.childInfo?.childID ?? 0)", forKey: CoredataKeys.Keys.CHILD_ID_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.name ?? "")", forKey: CoredataKeys.Keys.NAME_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.birthday ?? "")", forKey: CoredataKeys.Keys.BIRTHDAY_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.gender ?? "")", forKey: CoredataKeys.Keys.GENDER_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.relationship ?? "" )", forKey: CoredataKeys.Keys.RELATIONSHIP_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.email ?? "")", forKey: CoredataKeys.Keys.EMAIL_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.phone ?? "")", forKey: CoredataKeys.Keys.PHONE_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.plateformID ?? 0)", forKey: CoredataKeys.Keys.PLATEFORM_ID_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.device ?? "")", forKey: CoredataKeys.Keys.DEVICE_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.planID ?? 0)", forKey: CoredataKeys.Keys.PLAN_ID_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.packageID ?? 0)", forKey: CoredataKeys.Keys.PACKAGE_ID_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.package ?? "")", forKey: CoredataKeys.Keys.PACKAGE_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.duration ?? "")", forKey: CoredataKeys.Keys.DURATION_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.expiryDate ?? "")", forKey: CoredataKeys.Keys.EXPAIRY_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.remainingDays ?? "")", forKey: CoredataKeys.Keys.REMAINING_DAYS_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.coverImgSrc ?? "")", forKey: CoredataKeys.Keys.COVER_IMG_SRC_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.profileImgSrc ?? "")", forKey: CoredataKeys.Keys.PROFILE_IMG_SRC_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.color ?? "")", forKey: CoredataKeys.Keys.COLOR_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.phonelockStatus  ?? 0)", forKey: CoredataKeys.Keys.PHONE_LOCK_STATUS_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.active ?? 0)", forKey: CoredataKeys.Keys.ACTIVE_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.deleted ?? 0)", forKey: CoredataKeys.Keys.DELETED_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.deletedBy ?? "")", forKey: CoredataKeys.Keys.DELETED_BY_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.superUserID ?? 0)", forKey: CoredataKeys.Keys.SUPER_USER_ID_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.activationCode ?? "")", forKey: CoredataKeys.Keys.ACTIVATION_CODE_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.dateCreated ?? "")", forKey: CoredataKeys.Keys.DATE_CREATED_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.dateModified ?? "")", forKey: CoredataKeys.Keys.DATE_MODIFIED_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.pushToken ?? "")", forKey: CoredataKeys.Keys.PUSH_TOKEN_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.childEnrolled ?? 0)", forKey: CoredataKeys.Keys.CHILD_ENROLLED_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.childMdmHash ?? "")", forKey: CoredataKeys.Keys.CHILD_MDM_HASH_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.isProductionBuild ?? 0)", forKey: CoredataKeys.Keys.IS_PRODUCTION_BUILD_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.versionNumber ?? "")", forKey: CoredataKeys.Keys.VERSION_NUMBER_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.versionCode ?? "")", forKey: CoredataKeys.Keys.VERSION_CODE_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.subscriptionID ?? "")", forKey: CoredataKeys.Keys.SUBSCRIPTION_ID_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.schoolID ?? "")", forKey: CoredataKeys.Keys.SCHOOL_ID_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.campusID ?? "")", forKey: CoredataKeys.Keys.CAMPUS_ID_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.classID ?? "")", forKey: CoredataKeys.Keys.CLASS_ID_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.resellerID ?? 0)", forKey: CoredataKeys.Keys.RESELLER_ID_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.timeZone ?? "")", forKey: CoredataKeys.Keys.TIME_ZONE_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.isForgetMe ?? 0)", forKey: CoredataKeys.Keys.IS_FOGET_ME_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.apiToken ?? "")", forKey: CoredataKeys.Keys.API_TOKEN_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.activationDate ?? "")", forKey: CoredataKeys.Keys.ACTIVATION_DATE_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.createdAt ?? "")", forKey: CoredataKeys.Keys.CREATED_AT_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.updatedAt ?? "")", forKey: CoredataKeys.Keys.UPDATED_AT_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.uniqueDeviceID ?? "")", forKey: CoredataKeys.Keys.UNIQUE_DEVICE_ID_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.agent ?? "")", forKey: CoredataKeys.Keys.AGENT_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.newSubscriptionID ?? 0)", forKey: CoredataKeys.Keys.NEW_SUBSCRIPTION_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.priority ?? 0)", forKey: CoredataKeys.Keys.PRIORITY_DASHBOARD)
                    results![0].setValue("\(data.childInfo?.deviceManufacturer ?? "")", forKey: CoredataKeys.Keys.DEVICE_MENUFACTURED_DASHBOARD)
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.CHILD_INFO_DASHBOARD, in:  context)
                    let entity1 = NSManagedObject(entity: entity!, insertInto: context)
                    entity1.setValue("\(data.childInfo?.childID ?? 0)", forKey: CoredataKeys.Keys.CHILD_ID_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.name ?? "")", forKey: CoredataKeys.Keys.NAME_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.birthday ?? "")", forKey: CoredataKeys.Keys.BIRTHDAY_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.gender ?? "")", forKey: CoredataKeys.Keys.GENDER_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.relationship ?? "" )", forKey: CoredataKeys.Keys.RELATIONSHIP_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.email ?? "")", forKey: CoredataKeys.Keys.EMAIL_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.phone ?? "")", forKey: CoredataKeys.Keys.PHONE_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.plateformID ?? 0)", forKey: CoredataKeys.Keys.PLATEFORM_ID_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.device ?? "")", forKey: CoredataKeys.Keys.DEVICE_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.planID ?? 0)", forKey: CoredataKeys.Keys.PLAN_ID_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.packageID ?? 0)", forKey: CoredataKeys.Keys.PACKAGE_ID_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.package ?? "")", forKey: CoredataKeys.Keys.PACKAGE_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.duration ?? "")", forKey: CoredataKeys.Keys.DURATION_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.expiryDate ?? "")", forKey: CoredataKeys.Keys.EXPAIRY_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.remainingDays ?? "")", forKey: CoredataKeys.Keys.REMAINING_DAYS_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.coverImgSrc ?? "")", forKey: CoredataKeys.Keys.COVER_IMG_SRC_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.profileImgSrc ?? "")", forKey: CoredataKeys.Keys.PROFILE_IMG_SRC_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.color ?? "")", forKey: CoredataKeys.Keys.COLOR_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.phonelockStatus  ?? 0)", forKey: CoredataKeys.Keys.PHONE_LOCK_STATUS_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.active ?? 0)", forKey: CoredataKeys.Keys.ACTIVE_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.deleted ?? 0)", forKey: CoredataKeys.Keys.DELETED_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.deletedBy ?? "")", forKey: CoredataKeys.Keys.DELETED_BY_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.superUserID ?? 0)", forKey: CoredataKeys.Keys.SUPER_USER_ID_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.activationCode ?? "")", forKey: CoredataKeys.Keys.ACTIVATION_CODE_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.dateCreated ?? "")", forKey: CoredataKeys.Keys.DATE_CREATED_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.dateModified ?? "")", forKey: CoredataKeys.Keys.DATE_MODIFIED_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.pushToken ?? "")", forKey: CoredataKeys.Keys.PUSH_TOKEN_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.childEnrolled ?? 0)", forKey: CoredataKeys.Keys.CHILD_ENROLLED_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.childMdmHash ?? "")", forKey: CoredataKeys.Keys.CHILD_MDM_HASH_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.isProductionBuild ?? 0)", forKey: CoredataKeys.Keys.IS_PRODUCTION_BUILD_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.versionNumber ?? "")", forKey: CoredataKeys.Keys.VERSION_NUMBER_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.versionCode ?? "")", forKey: CoredataKeys.Keys.VERSION_CODE_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.subscriptionID ?? "")", forKey: CoredataKeys.Keys.SUBSCRIPTION_ID_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.schoolID ?? "")", forKey: CoredataKeys.Keys.SCHOOL_ID_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.campusID ?? "")", forKey: CoredataKeys.Keys.CAMPUS_ID_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.classID ?? "")", forKey: CoredataKeys.Keys.CLASS_ID_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.resellerID ?? 0)", forKey: CoredataKeys.Keys.RESELLER_ID_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.timeZone ?? "")", forKey: CoredataKeys.Keys.TIME_ZONE_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.isForgetMe ?? 0)", forKey: CoredataKeys.Keys.IS_FOGET_ME_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.apiToken ?? "")", forKey: CoredataKeys.Keys.API_TOKEN_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.activationDate ?? "")", forKey: CoredataKeys.Keys.ACTIVATION_DATE_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.createdAt ?? "")", forKey: CoredataKeys.Keys.CREATED_AT_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.updatedAt ?? "")", forKey: CoredataKeys.Keys.UPDATED_AT_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.uniqueDeviceID ?? "")", forKey: CoredataKeys.Keys.UNIQUE_DEVICE_ID_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.agent ?? "")", forKey: CoredataKeys.Keys.AGENT_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.newSubscriptionID ?? 0)", forKey: CoredataKeys.Keys.NEW_SUBSCRIPTION_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.priority ?? 0)", forKey: CoredataKeys.Keys.PRIORITY_DASHBOARD)
                    entity1.setValue("\(data.childInfo?.deviceManufacturer ?? "")", forKey: CoredataKeys.Keys.DEVICE_MENUFACTURED_DASHBOARD)
                }
                savePreferencesInDatabase(data: data)
                saveDailyLimitInDatabase(data: data)
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED,"\(error)")
        }
        do {
            try  context.save()
        } catch {
            print( StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
    }
    
    //MARK: SAVE PREFERENCES
    @objc static func savePreferencesInDatabase(data:ChildData) {
        let child_id = "\(data.childInfo?.childID ?? 0)"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.PREFERENCE_FILE)
        fetchRequest.predicate = NSPredicate(format: "child_id_pref = %@", argumentArray: [child_id])
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
            let preference = data.preferences ?? [PreferenceData]()
            for pref in preference {
                if results?.count != 0 {
                    let name = pref.name ?? ""
                    let value = pref.value ?? "0"
                    let status = pref.status ?? 0
                    results![0].setValue(child_id, forKey: CoredataKeys.Keys.CHILD_ID_PREFERENCE)
                    results![0].setValue(name, forKey: CoredataKeys.Keys.NAME_PREFERENCE)
                    results![0].setValue(value, forKey: CoredataKeys.Keys.VALUE_PREFERENCE)
                    results![0].setValue(String(describing: status), forKey: CoredataKeys.Keys.STATUS_PREFERENCE)
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.PREFERENCE_FILE, in:  context)
                    let entity1 = NSManagedObject(entity: entity!, insertInto:  context)
                    let name = pref.name ?? ""
                    let value = pref.value ?? "0"
                    let status = pref.status ?? 0
                    entity1.setValue(child_id, forKey: CoredataKeys.Keys.CHILD_ID_PREFERENCE)
                    entity1.setValue(name, forKey: CoredataKeys.Keys.NAME_PREFERENCE)
                    entity1.setValue(value, forKey: CoredataKeys.Keys.VALUE_PREFERENCE)
                    entity1.setValue(String(describing: status), forKey: CoredataKeys.Keys.STATUS_PREFERENCE)
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED,"\(error)")
        }
        
        do {
            try  context.save()
        } catch {
            print( StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
    }
    
    //MARK: UPDATE PREFFERENCE DATA
    
    @objc static func updatePrefferenceData(pref:PreferenceData, child_id: String) {
        //let child_id = "\(data.childInfo?.childID ?? 0)"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.PREFERENCE_FILE)
        fetchRequest.predicate = NSPredicate(format: "child_id_pref = %@", argumentArray: [child_id])
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
                if results?.count != 0 {
                    let name = pref.name ?? ""
                    let value = pref.value ?? "0"
                    let status = pref.status ?? 0
                    results![0].setValue(child_id, forKey: CoredataKeys.Keys.CHILD_ID_PREFERENCE)
                    results![0].setValue(name, forKey: CoredataKeys.Keys.NAME_PREFERENCE)
                    results![0].setValue(value, forKey: CoredataKeys.Keys.VALUE_PREFERENCE)
                    results![0].setValue(String(describing: status), forKey: CoredataKeys.Keys.STATUS_PREFERENCE)
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.PREFERENCE_FILE, in:  context)
                    let entity1 = NSManagedObject(entity: entity!, insertInto:  context)
                    let name = pref.name ?? ""
                    let value = pref.value ?? "0"
                    let status = pref.status ?? 0
                    entity1.setValue(child_id, forKey: CoredataKeys.Keys.CHILD_ID_PREFERENCE)
                    entity1.setValue(name, forKey: CoredataKeys.Keys.NAME_PREFERENCE)
                    entity1.setValue(value, forKey: CoredataKeys.Keys.VALUE_PREFERENCE)
                    entity1.setValue(String(describing: status), forKey: CoredataKeys.Keys.STATUS_PREFERENCE)
                }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED,"\(error)")
        }
        
        do {
            try  context.save()
        } catch {
            print( StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
    }
    
    //MARK: SAVE DAILY LIMIT
    @objc static func saveDailyLimitInDatabase(data:ChildData) {
        let childID = data.dailyLimit?.childID ?? 0
        let dailyLimit = data.dailyLimit
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.DAILY_LIMIT_FILE)
        fetchRequest.predicate = NSPredicate(format: "child_id_dailyLimit = %@", argumentArray: [childID])
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(String(describing: dailyLimit?.childID ?? 0), forKey: CoredataKeys.Keys.CHILD_ID_DAILY_LIMIT)
                results![0].setValue(String(describing: dailyLimit?.autoAdd ?? 0), forKey: CoredataKeys.Keys.AUTO_ADD_DAILY_LIMIT)
                results![0].setValue(String(describing: dailyLimit?.duration ?? 0), forKey: CoredataKeys.Keys.DURATION_DAILY_LIMIT)
                results![0].setValue(String(describing: dailyLimit?.isActive ?? 0), forKey: CoredataKeys.Keys.IS_ACTIVE_DAILY_LIMIT)
                results![0].setValue(String(describing: dailyLimit?.remaining ?? 0), forKey: CoredataKeys.Keys.REMAINING_DAILY_LIMIT)
                results![0].setValue(String(describing: dailyLimit?.remainingLimit ?? 0), forKey: CoredataKeys.Keys.REMAINING_LIMIT_DAILY_LIMIT)
            } else {
                let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.DAILY_LIMIT_FILE, in:  context)
                let entitySaving = NSManagedObject(entity: entity!, insertInto:  context)
                entitySaving.setValue(String(describing: dailyLimit?.childID ?? 0), forKey: CoredataKeys.Keys.CHILD_ID_DAILY_LIMIT)
                entitySaving.setValue(String(describing: dailyLimit?.autoAdd ?? 0), forKey: CoredataKeys.Keys.AUTO_ADD_DAILY_LIMIT)
                entitySaving.setValue(String(describing: dailyLimit?.duration ?? 0), forKey: CoredataKeys.Keys.DURATION_DAILY_LIMIT)
                entitySaving.setValue(String(describing: dailyLimit?.isActive ?? 0), forKey: CoredataKeys.Keys.IS_ACTIVE_DAILY_LIMIT)
                entitySaving.setValue(String(describing: dailyLimit?.remaining ?? 0), forKey: CoredataKeys.Keys.REMAINING_DAILY_LIMIT)
                entitySaving.setValue(String(describing: dailyLimit?.remainingLimit ?? 0), forKey: CoredataKeys.Keys.REMAINING_LIMIT_DAILY_LIMIT)
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED,"\(error)")
        }
        do {
            try  context.save()
        } catch {
            print( StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
    }
    
    //MARK: SAVE CO PARENT
    @objc static func saveCoParentInDatabase(data: HomeData) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.CO_PARENT_FILE)
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            let coParent = data.coParent ?? [CoParent]()
            for parent in coParent {
                if results?.count != 0 {
                    results![0].setValue(String(describing: parent.active ?? 0), forKey: CoredataKeys.Keys.ACTIVE_CO_PARENT)
                    results![0].setValue(parent.color ?? "", forKey: CoredataKeys.Keys.COLOR_CO_PARENT)
                    results![0].setValue(parent.email ?? "", forKey: CoredataKeys.Keys.EMAIL_CO_PARENT)
                    results![0].setValue(parent.gender ?? "", forKey: CoredataKeys.Keys.GENDER_CO_PARENT)
                    results![0].setValue(String(describing: parent.isJoined ?? 0), forKey: CoredataKeys.Keys.IS_JOINED_CO_PARENT)
                    results![0].setValue(String(describing: parent.isSuperParent ?? 0), forKey: CoredataKeys.Keys.IS_SUPER_PARENT_CO_PARENT)
                    results![0].setValue(parent.language ?? "", forKey: CoredataKeys.Keys.LANGUAGE_CO_PARENT)
                    results![0].setValue(parent.name ?? "", forKey: CoredataKeys.Keys.NAME_CO_PARENT)
                    results![0].setValue(parent.relationship ?? "", forKey: CoredataKeys.Keys.RELATIONSHIP_CO_PARENT)
                    results![0].setValue(parent.type ?? "", forKey: CoredataKeys.Keys.TYPE_CO_PARENT)
                    results![0].setValue(String(describing: parent.userID ?? 0), forKey: CoredataKeys.Keys.USER_ID_CO_PARENT)
                    results![0].setValue(String(describing: parent.deleted ?? 0), forKey: CoredataKeys.Keys.DELETED_CO_PARENT)
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.CO_PARENT_FILE, in:  context)
                    let entitySaving = NSManagedObject(entity: entity!, insertInto:  context)
                    entitySaving.setValue(String(describing: parent.active ?? 0), forKey: CoredataKeys.Keys.ACTIVE_CO_PARENT)
                    entitySaving.setValue(parent.color ?? "", forKey: CoredataKeys.Keys.COLOR_CO_PARENT)
                    entitySaving.setValue(parent.email ?? "", forKey: CoredataKeys.Keys.EMAIL_CO_PARENT)
                    entitySaving.setValue(parent.gender ?? "", forKey: CoredataKeys.Keys.GENDER_CO_PARENT)
                    entitySaving.setValue(String(describing: parent.isJoined ?? 0), forKey: CoredataKeys.Keys.IS_JOINED_CO_PARENT)
                    entitySaving.setValue(String(describing: parent.isSuperParent ?? 0), forKey: CoredataKeys.Keys.IS_SUPER_PARENT_CO_PARENT)
                    entitySaving.setValue(parent.language ?? "", forKey: CoredataKeys.Keys.LANGUAGE_CO_PARENT)
                    entitySaving.setValue(parent.name ?? "", forKey: CoredataKeys.Keys.NAME_CO_PARENT)
                    entitySaving.setValue(parent.relationship ?? "", forKey: CoredataKeys.Keys.RELATIONSHIP_CO_PARENT)
                    entitySaving.setValue(parent.type ?? "", forKey: CoredataKeys.Keys.TYPE_CO_PARENT)
                    entitySaving.setValue(String(describing: parent.userID ?? 0), forKey: CoredataKeys.Keys.USER_ID_CO_PARENT)
                    entitySaving.setValue(String(describing: parent.deleted ?? 0), forKey: CoredataKeys.Keys.DELETED_CO_PARENT)
                }
                saveCoParentSettings(data: parent)
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED,"\(error)")
        }
        do {
            try  context.save()
        } catch {
            print( StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
    }
    
    //MARK: SAVE CO PARENT SETTINGS
    @objc static func saveCoParentSettings(data:CoParent) {
        let userId = data.userID ?? 0
        let settings = data.settings ?? [CoParentSettings]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.CO_PARENT_SETTINGS)
        fetchRequest.predicate = NSPredicate(format: "user_id_cp_settings = %@", argumentArray: [userId])
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
            for setting in settings {
                if results?.count != 0 {
                    results![0].setValue(String(describing: userId), forKey: CoredataKeys.Keys.USER_ID_CP_SETTING)
                    results![0].setValue(setting.type ?? "", forKey: CoredataKeys.Keys.TYPE_CP_SETTINGS)
                    results![0].setValue(String(describing: setting.id ?? 0), forKey: CoredataKeys.Keys.ID_CP_SETTINGS)
                    results![0].setValue(setting.displayName ?? "", forKey: CoredataKeys.Keys.DISPLAY_NAME_CP_SETTINGS)
                    results![0].setValue(String(describing: setting.status ?? 0), forKey: CoredataKeys.Keys.STATUS_CP_SETTINGS)
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.CO_PARENT_SETTINGS, in:  context)
                    let entitySaving = NSManagedObject(entity: entity!, insertInto:  context)
                    entitySaving.setValue(String(describing: userId), forKey: CoredataKeys.Keys.USER_ID_CP_SETTING)
                    entitySaving.setValue(setting.type ?? "", forKey: CoredataKeys.Keys.TYPE_CP_SETTINGS)
                    entitySaving.setValue(String(describing: setting.id ?? 0), forKey: CoredataKeys.Keys.ID_CP_SETTINGS)
                    entitySaving.setValue(setting.displayName ?? "", forKey: CoredataKeys.Keys.DISPLAY_NAME_CP_SETTINGS)
                    entitySaving.setValue(String(describing: setting.status ?? 0), forKey: CoredataKeys.Keys.STATUS_CP_SETTINGS)
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED,"\(error)")
        }
        do {
            try  context.save()
        } catch {
            print( StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
    }

    
    //MARK: SAVING HISTORY DATA
     static func saveAppHistoryData(appData: [AppHistortDataModel]) {
         for i in appData{
             let bHistoryId = "\(String(describing: i.browsinghistoryID))"
             let super_ID = "\(String(describing: i.superUserID))"
             let title = i.title
             let domain = i.domain
             let url = i.url ?? ""
             let time_visit = i.timeVisit ?? ""
             let num_visit = "\(String(describing: i.numberVisits))"
             let child_id = "\(String(describing: i.childID ?? 0))"
             let delete_data = "\(String(describing: i.deleted))"
             let created_at = i.createdAt
             let update_at = i.updatedAt
             
             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.APP_HISTORY_DATA)
             fetchRequest.predicate = NSPredicate(format: "time_visits = %@", argumentArray: [time_visit])
             do{
                 let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
                 if results?.count != 0 {
                     results![0].setValue(bHistoryId, forKey: CoredataKeys.Keys.B_BROWSERHITORY_ID)
                     results![0].setValue(super_ID, forKey: CoredataKeys.Keys.B_SUPER_USER_ID)
                     results![0].setValue(title, forKey: CoredataKeys.Keys.B_TITLE)
                     results![0].setValue(domain, forKey: CoredataKeys.Keys.B_DOMAIN)
                     results![0].setValue(url, forKey: CoredataKeys.Keys.B_URL)
                     results![0].setValue(time_visit, forKey: CoredataKeys.Keys.B_TIME_VIST)
                     results![0].setValue(num_visit, forKey: CoredataKeys.Keys.B_NUMBER_VISTIT)
                     results![0].setValue(child_id, forKey: CoredataKeys.Keys.B_CHILD_ID)
                     results![0].setValue(delete_data, forKey: CoredataKeys.Keys.B_DELETED)
                     results![0].setValue(created_at, forKey: CoredataKeys.Keys.B_CREATED_AT)
                     results![0].setValue(update_at, forKey: CoredataKeys.Keys.B_UPDATED_AT)

                 } else {
                     let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.APP_HISTORY_DATA, in:  context)
                     let config = NSManagedObject(entity: entity!, insertInto:  context)
                     config.setValue(bHistoryId, forKey: CoredataKeys.Keys.B_BROWSERHITORY_ID)
                     config.setValue(super_ID, forKey: CoredataKeys.Keys.B_SUPER_USER_ID)
                     config.setValue(title, forKey: CoredataKeys.Keys.B_TITLE)
                     config.setValue(domain, forKey: CoredataKeys.Keys.B_DOMAIN)
                     config.setValue(url, forKey: CoredataKeys.Keys.B_URL)
                     config.setValue(time_visit, forKey: CoredataKeys.Keys.B_TIME_VIST)
                     config.setValue(num_visit, forKey: CoredataKeys.Keys.B_NUMBER_VISTIT)
                     config.setValue(child_id, forKey: CoredataKeys.Keys.B_CHILD_ID)
                     config.setValue(delete_data, forKey: CoredataKeys.Keys.B_DELETED)
                     config.setValue(created_at, forKey: CoredataKeys.Keys.B_CREATED_AT)
                     config.setValue(update_at, forKey: CoredataKeys.Keys.B_UPDATED_AT)
                 }
             }catch {
                 print(StringConstants.Errors.FETCHING_DATA_FAILED,"\(error)")
             }
             do {
                 try  context.save()
             }
             catch {
                 print( StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
             }
         }
    }
    
    //MARK: SAVE YOUTUBE DATA
     static func saveYoutubeHistoryData(appData: [youtubeData]) {
         for i in appData{
             let bHistoryId = "\(i.id ?? 0)"
             let super_ID = "\(i.superUserID ?? 0)"
             let title = i.title
             let domain = i.domain
             let url = i.url
             let time_visit = i.timeVisit ?? ""
             let num_visit = "\(i.numberVisits)"
             let child_id = "\(i.childID ?? 0)"
             let delete_data = "\(i.deleted)"
             let created_at = i.createdAt
             let update_at = i.updatedAt
             
             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.APP_YOUTUBE_DATA)
             fetchRequest.predicate = NSPredicate(format: "time_visit = %@", argumentArray: [time_visit])
             do{
                 let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
                 if results?.count != 0 {
                     results![0].setValue(bHistoryId, forKey: CoredataKeys.Keys.Y_ID)
                     results![0].setValue(super_ID, forKey: CoredataKeys.Keys.Y_SUPER_USER_ID)
                     results![0].setValue(title, forKey: CoredataKeys.Keys.Y_TITLE)
                     results![0].setValue(domain, forKey: CoredataKeys.Keys.Y_DOMAIN)
                     results![0].setValue(url, forKey: CoredataKeys.Keys.Y_URL)
                     results![0].setValue(time_visit, forKey: CoredataKeys.Keys.Y_TIME_VIST)
                     results![0].setValue(num_visit, forKey: CoredataKeys.Keys.Y_NUMBER_VISTIT)
                     results![0].setValue(child_id, forKey: CoredataKeys.Keys.Y_CHILD_ID)
                     results![0].setValue(delete_data, forKey: CoredataKeys.Keys.Y_DELETED)
                     results![0].setValue(created_at, forKey: CoredataKeys.Keys.Y_CREATED_AT)
                     results![0].setValue(update_at, forKey: CoredataKeys.Keys.Y_UPDATED_AT)

                 } else {
                     let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.APP_YOUTUBE_DATA, in:  context)
                     let config = NSManagedObject(entity: entity!, insertInto:  context)
                     config.setValue(bHistoryId, forKey: CoredataKeys.Keys.Y_ID)
                     config.setValue(super_ID, forKey: CoredataKeys.Keys.Y_SUPER_USER_ID)
                     config.setValue(title, forKey: CoredataKeys.Keys.Y_TITLE)
                     config.setValue(domain, forKey: CoredataKeys.Keys.Y_DOMAIN)
                     config.setValue(url, forKey: CoredataKeys.Keys.Y_URL)
                     config.setValue(time_visit, forKey: CoredataKeys.Keys.Y_TIME_VIST)
                     config.setValue(num_visit, forKey: CoredataKeys.Keys.Y_NUMBER_VISTIT)
                     config.setValue(child_id, forKey: CoredataKeys.Keys.Y_CHILD_ID)
                     config.setValue(delete_data, forKey: CoredataKeys.Keys.Y_DELETED)
                     config.setValue(created_at, forKey: CoredataKeys.Keys.Y_CREATED_AT)
                     config.setValue(update_at, forKey: CoredataKeys.Keys.Y_UPDATED_AT)
                 }
             }catch {
                 print(StringConstants.Errors.FETCHING_DATA_FAILED,"\(error)")
             }
             do {
                 try  context.save()
             }
             catch {
                 print( StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
             }
         }
    }
   
    
    //MARK: SAVE TIKTOK DATA
     static func saveTiktokData(appData: [youtubeData]) {
         for i in appData{
             let bHistoryId = "\(i.id)"
             let super_ID = "\(i.superUserID)"
             let title = i.title
             let domain = i.domain
             let url = i.url
             let time_visit = i.timeVisit ?? ""
             let num_visit = "\(i.numberVisits ?? 0)"
             let child_id = "\(i.childID ?? 0)"
             let delete_data = "\(i.deleted)"
             let created_at = i.createdAt
             let update_at = i.updatedAt
             
             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.APP_TIKTOK_DATA)
             fetchRequest.predicate = NSPredicate(format: "time_visit = %@", argumentArray: [time_visit])
             do{
                 let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
                 if results?.count != 0 {
                     results![0].setValue(bHistoryId, forKey: CoredataKeys.Keys.T_ID)
                     results![0].setValue(super_ID, forKey: CoredataKeys.Keys.T_SUPER_USER_ID)
                     results![0].setValue(title, forKey: CoredataKeys.Keys.T_TITLE)
                     results![0].setValue(domain, forKey: CoredataKeys.Keys.T_DOMAIN)
                     results![0].setValue(url, forKey: CoredataKeys.Keys.T_URL)
                     results![0].setValue(time_visit, forKey: CoredataKeys.Keys.T_TIME_VIST)
                     results![0].setValue(num_visit, forKey: CoredataKeys.Keys.T_NUMBER_VISTIT)
                     results![0].setValue(child_id, forKey: CoredataKeys.Keys.T_CHILD_ID)
                     results![0].setValue(delete_data, forKey: CoredataKeys.Keys.T_DELETED)
                     results![0].setValue(created_at, forKey: CoredataKeys.Keys.T_CREATED_AT)
                     results![0].setValue(update_at, forKey: CoredataKeys.Keys.T_UPDATED_AT)

                 } else {
                     let entity = NSEntityDescription.entity(forEntityName: CoredataKeys.Entities.APP_TIKTOK_DATA, in:  context)
                     let config = NSManagedObject(entity: entity!, insertInto:  context)
                     config.setValue(bHistoryId, forKey: CoredataKeys.Keys.T_ID)
                     config.setValue(super_ID, forKey: CoredataKeys.Keys.T_SUPER_USER_ID)
                     config.setValue(title, forKey: CoredataKeys.Keys.T_TITLE)
                     config.setValue(domain, forKey: CoredataKeys.Keys.T_DOMAIN)
                     config.setValue(url, forKey: CoredataKeys.Keys.T_URL)
                     config.setValue(time_visit, forKey: CoredataKeys.Keys.T_TIME_VIST)
                     config.setValue(num_visit, forKey: CoredataKeys.Keys.T_NUMBER_VISTIT)
                     config.setValue(child_id, forKey: CoredataKeys.Keys.T_CHILD_ID)
                     config.setValue(delete_data, forKey: CoredataKeys.Keys.T_DELETED)
                     config.setValue(created_at, forKey: CoredataKeys.Keys.T_CREATED_AT)
                     config.setValue(update_at, forKey: CoredataKeys.Keys.T_UPDATED_AT)
                 }
             }catch {
                 print(StringConstants.Errors.FETCHING_DATA_FAILED,"\(error)")
             }
             do {
                 try  context.save()
             }
             catch {
                 print( StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
             }
         }
    }
    
    
    //MARK: - Fetching Data Functions
    @objc static func fetchPackageIdFor(child_id:Int32) -> String {
        var packageId:String = "0"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.PACKAGE_FILE)
        fetchRequest.predicate = NSPredicate(format: "child_id = %@",
                                             argumentArray: [child_id])
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                if let id = results![0].value(forKey: CoredataKeys.Keys.PLAN_ID) as? Int32{
                    packageId = String(id)
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
        return packageId
    }
    
    @objc static func fetchPackageNameFor(child_id:Int32) -> String {
        var packageName:String = ""
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.PACKAGE_FILE)
        fetchRequest.predicate = NSPredicate(format: "child_id = %@",
                                             argumentArray: [child_id])
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                if let name = results![0].value(forKey: CoredataKeys.Keys.PACKAGE_NAME) as? String{
                    packageName = name
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
        return packageName
    }
    
    @objc static func fetchPackageDeviceFor(child_id:Int32) -> String {
        var deviceName:String = ""
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.PACKAGE_FILE)
        fetchRequest.predicate = NSPredicate(format: "child_id = %@",
                                             argumentArray: [child_id])
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                if let name = results![0].value(forKey: CoredataKeys.Keys.DEVICE) as? String{
                    deviceName = name
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED ,"\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print( StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
        return deviceName
    }
    
    @objc static func fetchPremiumPackageDetailsFor(config_Name:String) -> ConfigurationsDBModel {
        var configName ,configId ,configValue ,platefromID ,plateform ,active ,createdAt , updatedAt ,keyValue : String?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.CONFIGURATION_FILE)
        fetchRequest.predicate = NSPredicate(format: "configName = %@",
                                             argumentArray: [config_Name])
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                let name = results![0].value(forKey: CoredataKeys.Keys.CONFIG_NAME) as? String ?? ""
                let id = results![0].value(forKey: CoredataKeys.Keys.ID) as? String ?? ""
                let value = results![0].value(forKey: CoredataKeys.Keys.CONFIG_VALUE) as? String ?? ""
                let plateformIdText =  results![0].value(forKey: CoredataKeys.Keys.platformId) as? String ?? ""
                let plateformText = results![0].value(forKey: CoredataKeys.Keys.PLATEFORM) as? String ?? ""
                let isActive = results![0].value(forKey: CoredataKeys.Keys.ACTIVE) as? String ?? ""
                let createdAtDate = results![0].value(forKey: CoredataKeys.Keys.createdAt) as? String ?? ""
                let updatedAtDate = results![0].value(forKey: CoredataKeys.Keys.updatedAt) as? String ?? ""
                let keyValueText = results![0].value(forKey: CoredataKeys.Keys.KEY_VALUE) as? String ?? ""
                configName = name
                configId = id
                keyValue = keyValueText
                configValue = value
                platefromID = plateformIdText
                plateform = plateformText
                active = isActive
                createdAt  = createdAtDate
                updatedAt = updatedAtDate
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
        let configuration  = ConfigurationsDBModel(id: configId ?? "", configName: configName ?? "" , configValue: configValue ?? "", keyValue: keyValue ?? "", plateformID: platefromID ?? "", plateform: plateform ?? "", active: active ?? "", createdAt: createdAt ?? "", updatedAt: updatedAt ?? "")
        return configuration
    }
    
    
    @objc static func fetchAccountData(profileId: String) -> Profile {
        var id, super_ID, name, gender, email, phone, type, language, createdAt, package, emailVerifiedAt, emailBounce, emailComplaint : String?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.ACCOUNT_DATA_FILE)
        fetchRequest.predicate = NSPredicate(format: "id = %@", argumentArray: [profileId])
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                let id1 = results![0].value(forKey: CoredataKeys.Keys.ID) as? String ?? ""
                let super_ID1 = results![0].value(forKey: CoredataKeys.Keys.SUPER_USER_ID) as? String ?? ""
                let name1 = results![0].value(forKey: CoredataKeys.Keys.NAME) as? String ?? ""
                let gender1 =  results![0].value(forKey: CoredataKeys.Keys.GENDER) as? String ?? ""
                let email1 = results![0].value(forKey: CoredataKeys.Keys.EMAIL) as? String ?? ""
                let phone1 = results![0].value(forKey: CoredataKeys.Keys.PHONE) as? String ?? ""
                let type1 = results![0].value(forKey: CoredataKeys.Keys.TYPE) as? String ?? ""
                let language1 = results![0].value(forKey: CoredataKeys.Keys.LANGUAGE) as? String ?? ""
                let creatAt1 = results![0].value(forKey: CoredataKeys.Keys.CREATED_AT) as? String ?? ""
                let package1 = results![0].value(forKey: CoredataKeys.Keys.PACKAGE) as? String ?? ""
                let email_Verified = results![0].value(forKey: CoredataKeys.Keys.EMAIL_VERIFIED_AT_ACCOUNT_DATA) as? String ?? ""
                let email_Bounce = results![0].value(forKey: CoredataKeys.Keys.EMAIL_BOUNCE_ACCOUNT_DATA) as? String ?? ""
                let email_Complaint = results![0].value(forKey: CoredataKeys.Keys.EMAIL_COMPLAINT_ACCOUNT_DATA) as? String ?? ""
                id = id1
                super_ID = super_ID1
                name = name1
                gender = gender1
                email = email1
                phone = phone1
                type = type1
                language = language1
                createdAt = creatAt1
                package = package1
                emailVerifiedAt = email_Verified
                emailBounce = email_Bounce
                emailComplaint = email_Complaint
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
        let profileDate  = Profile(id: Int(id ?? ""), superUserID: Int(super_ID ?? ""), name: name ?? "", gender: gender ?? "", email: email ?? "", phone: phone ?? "", type: type ?? "", language: language ?? "", createdAt: createdAt ?? "", package: package ?? "", emailVerifiedAt: emailVerifiedAt, emailBounce: Int(emailBounce ?? ""), emailComplaint: Int(emailComplaint ?? ""))
        return profileDate
    }
    
    //MARK: Fetch CHILD Preferences
    @objc static func fetchPreferenceFromDatabase(child_id:String) -> [PreferenceData] {
        var preferences = [PreferenceData]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.PREFERENCE_FILE)
        fetchRequest.predicate = NSPredicate(format: "child_id_pref = %@", argumentArray: [child_id])
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                for result in results ?? [NSManagedObject]() {
                    let name = result.value(forKey: CoredataKeys.Keys.NAME_PREFERENCE) as? String ?? ""
                    let value = result.value(forKey: CoredataKeys.Keys.VALUE_PREFERENCE) as? String ?? ""
                    let status = result.value(forKey: CoredataKeys.Keys.STATUS_PREFERENCE) as? String ?? ""
                    let data = PreferenceData(name: name, status: Int(status), value: value)
                    preferences.append(data)
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
        return preferences
    }
    
    
    //MARK: Fetch CHILD Preferences
    @objc static func fetchAllPrefferences() -> [PreferenceData] {
        var preferences = [PreferenceData]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.PREFERENCE_FILE)
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                for result in results ?? [NSManagedObject]() {
                    let name = result.value(forKey: CoredataKeys.Keys.NAME_PREFERENCE) as? String ?? ""
                    let value = result.value(forKey: CoredataKeys.Keys.VALUE_PREFERENCE) as? String ?? ""
                    let status = result.value(forKey: CoredataKeys.Keys.STATUS_PREFERENCE) as? String ?? ""
                    let data = PreferenceData(name: name, status: Int(status), value: value)
                    preferences.append(data)
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
        return preferences
    }
    
    
    //MARK: Fetch DAILY LIMITS
    @objc static func fetchDailyLimitsFromDatabase(child_id:String) -> DailyLimit {
        var childID,autoAdd,duration,isActive,remaining,remainingLimit : String?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.DAILY_LIMIT_FILE)
        fetchRequest.predicate = NSPredicate(format: "child_id_dailyLimit = %@", argumentArray: [child_id])
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                autoAdd = results![0].value(forKey: CoredataKeys.Keys.AUTO_ADD_DAILY_LIMIT) as? String ?? ""
                duration = results![0].value(forKey: CoredataKeys.Keys.DURATION_DAILY_LIMIT) as? String ?? ""
                childID = results![0].value(forKey: CoredataKeys.Keys.CHILD_ID_DAILY_LIMIT) as? String ?? ""
                isActive = results![0].value(forKey: CoredataKeys.Keys.IS_ACTIVE_DAILY_LIMIT) as? String ?? ""
                remaining = results![0].value(forKey: CoredataKeys.Keys.REMAINING_DAILY_LIMIT) as? String ?? ""
                remainingLimit = results![0].value(forKey: CoredataKeys.Keys.REMAINING_LIMIT_DAILY_LIMIT) as? String ?? ""
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
        let data = DailyLimit(childID: Int(childID ?? ""), duration: Int(duration ?? ""), remaining: Int(remaining ?? ""), remainingLimit: Int(remainingLimit ?? ""), autoAdd: Int(autoAdd ?? ""), isActive: Int(isActive ?? ""))
        return data
    }
    
    //MARK: Fetch CO PARENT
//    @objc static func fetchCoParentFromDatabase() -> [CoParent] {
//        var coParent = [CoParent]()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.CO_PARENT_FILE)
//        do {
//            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
//            if results?.count != 0 {
//                for result in results ?? [NSManagedObject]() {
//                    let active = result.value(forKey: CoredataKeys.Keys.ACTIVE_CO_PARENT) as? String ?? ""
//                    let color = result.value(forKey: CoredataKeys.Keys.COLOR_CO_PARENT) as? String ?? ""
//                    let email = result.value(forKey: CoredataKeys.Keys.EMAIL_CO_PARENT) as? String ?? ""
//                    let gender = result.value(forKey: CoredataKeys.Keys.GENDER_CO_PARENT) as? String ?? ""
//                    let isJoined = result.value(forKey: CoredataKeys.Keys.IS_JOINED_CO_PARENT) as? String ?? ""
//                    let isSuperPrent = result.value(forKey: CoredataKeys.Keys.IS_SUPER_PARENT_CO_PARENT) as? String ?? ""
//                    let language = result.value(forKey: CoredataKeys.Keys.LANGUAGE_CO_PARENT) as? String ?? ""
//                    let name = result.value(forKey: CoredataKeys.Keys.NAME_CO_PARENT) as? String ?? ""
//                    let relationship = result.value(forKey: CoredataKeys.Keys.RELATIONSHIP_CO_PARENT) as? String ?? ""
//                    let type = result.value(forKey: CoredataKeys.Keys.TYPE_CO_PARENT) as? String ?? ""
//                    let userId = result.value(forKey: CoredataKeys.Keys.USER_ID_CO_PARENT) as? String ?? ""
//                    let deleted = result.value(forKey: CoredataKeys.Keys.DELETED_CO_PARENT) as? String ?? ""
//                    let settings = fetchCoParentSettings(user_id: userId)
//                    let data = CoParent(userID: Int(userId), name: name, gender: gender, email: email, active: Int(active), isJoined: Int(isJoined), relationship: relationship, color: color, deleted: Int(deleted), type: type, language: language, settings: settings, isSuperParent: Int(isSuperPrent))
//                    coParent.append(data)
//                }
//            }
//        } catch {
//            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
//        }
//        do {
//            try  context.save()
//        }
//        catch {
//            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
//        }
//        return coParent
//    }
    
    //MARK: Fetch Co Parent Settings
//    @objc static func fetchCoParentSettings(user_id:String) -> [CoParentSettings] {
//        var settings = [CoParentSettings]()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.CO_PARENT_SETTINGS)
//        do {
//            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
//            if results?.count != 0 {
//                for result in results ?? [NSManagedObject]() {
//                    let status = result.value(forKey: CoredataKeys.Keys.STATUS_CP_SETTINGS) as? String ?? ""
//                    let id = result.value(forKey: CoredataKeys.Keys.ID_CP_SETTINGS) as? String ?? ""
//                    let displayName = result.value(forKey: CoredataKeys.Keys.DISPLAY_NAME_CP_SETTINGS) as? String ?? ""
//                    let type = result.value(forKey: CoredataKeys.Keys.TYPE_CP_SETTINGS) as? String ?? ""
//                    let data = CoParentSettings(id: Int(id), type: type, displayName: displayName, status: Int(status))
//                    settings.append(data)
//                }
//            }
//        } catch {
//            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
//        }
//        do {
//            try  context.save()
//        }
//        catch {
//            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
//        }
//        return settings
//    }
    
    //MARK: Fetch CHILD INFO DATA
//    @objc static func fetchChildInfoFromDatabase(child_id:String) -> ChildInfo {
//        var resellerId : Int?
//        var childId ,name ,birthday ,relationship ,gender ,email ,phone ,platformId ,device ,planId ,packageId ,package ,expairyDate ,remainingDays ,coverImgSrc ,activationCode ,dateCreated ,dateModified ,pushToken ,childEnrolled ,childMdmHash ,timezone ,isForgetMe, apiToken ,activationDate ,createdAt ,updatedAt ,uniqueDeviceId ,agent ,newSubscriptionId ,priority ,deviceId ,batteryRemaining ,wifiName ,deviceManufacturer ,deviceName ,deviceModel ,deviceOs ,deviceLanguage ,deviceTimezone ,deviceImei ,appVersion ,appBuild ,duration ,profileImgSrc ,color ,phonelockStatus ,active ,deleted ,deletedBy, superUserID, isProductionBuild, versionNumber, versionCode, subscriptionId, schoolID, campusID, classID : String?
//        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.CHILD_INFO_FILE)
//        fetchRequest.predicate = NSPredicate(format: "child_id_child_info = %@", argumentArray: [child_id])
//        do {
//            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
//            if results?.count != 0 {
//                childId = results![0].value(forKey: CoredataKeys.Keys.CHILD_ID_CHILD_INFO) as? String ?? ""
//                name = results![0].value(forKey: CoredataKeys.Keys.NAME_CHILD_INFO) as? String ?? ""
//                birthday = results![0].value(forKey: CoredataKeys.Keys.BIRTHDAY_CHILD_INFO) as? String ?? ""
//                gender = results![0].value(forKey: CoredataKeys.Keys.GENDER_CHILD_INFO) as? String ?? ""
//                relationship = results![0].value(forKey: CoredataKeys.Keys.RELATIONSHIP_CHILD_INFO) as? String ?? ""
//                email = results![0].value(forKey: CoredataKeys.Keys.EMAIL_CHILD_INFO) as? String ?? ""
//                phone = results![0].value(forKey: CoredataKeys.Keys.PHONE_CHILD_INFO) as? String ?? ""
//                platformId = results![0].value(forKey: CoredataKeys.Keys.PLATEFORM_ID_CHILD_INFO) as? String ?? ""
//                device = results![0].value(forKey: CoredataKeys.Keys.DEVICE_CHILD_INFO) as? String ?? ""
//                planId = results![0].value(forKey: CoredataKeys.Keys.PLAN_ID_CHILD_INFO) as? String ?? ""
//                packageId = results![0].value(forKey: CoredataKeys.Keys.PACKAGE_ID_CHILD_INFO) as? String ?? ""
//                package = results![0].value(forKey: CoredataKeys.Keys.PACKAGE_CHILD_INFO) as? String ?? ""
//                expairyDate = results![0].value(forKey: CoredataKeys.Keys.EXPAIRY_CHILD_INFO) as? String ?? ""
//                remainingDays = results![0].value(forKey: CoredataKeys.Keys.REMAINING_DAYS_CHILD_INFO) as? String ?? ""
//                coverImgSrc = results![0].value(forKey: CoredataKeys.Keys.COVER_IMG_SRC_CHILD_INFO) as? String ?? ""
//                activationCode = results![0].value(forKey: CoredataKeys.Keys.ACTIVATION_CODE_CHILD_INFO) as? String ?? ""
//                dateCreated = results![0].value(forKey: CoredataKeys.Keys.DATE_CREATED_CHILD_INFO) as? String ?? ""
//                dateModified = results![0].value(forKey: CoredataKeys.Keys.DATE_MODIFIED_CHILD_INFO) as? String ?? ""
//                pushToken = results![0].value(forKey: CoredataKeys.Keys.PUSH_TOKEN_CHILD_INFO) as? String ?? ""
//                childEnrolled = results![0].value(forKey: CoredataKeys.Keys.CHILD_ENROLLED_CHILD_INFO) as? String ?? ""
//                childMdmHash = results![0].value(forKey: CoredataKeys.Keys.CHILD_MDM_HASH_CHILD_INFO) as? String ?? ""
//                resellerId = results![0].value(forKey: CoredataKeys.Keys.RESELLER_ID_CHILD_INFO) as? Int
//                timezone = results![0].value(forKey: CoredataKeys.Keys.TIME_ZONE_CHILD_INFO) as? String ?? ""
//                isForgetMe = results![0].value(forKey: CoredataKeys.Keys.IS_FOGET_ME_CHILD_INFO) as? String ?? ""
//                apiToken = results![0].value(forKey: CoredataKeys.Keys.API_TOKEN_CHILD_INFO) as? String ?? ""
//                activationDate = results![0].value(forKey: CoredataKeys.Keys.ACTIVATION_DATE_CHILD_INFO) as? String ?? ""
//                createdAt = results![0].value(forKey: CoredataKeys.Keys.CREATED_AT_CHILD_INFO) as? String ?? ""
//                updatedAt = results![0].value(forKey: CoredataKeys.Keys.UPDATED_AT_CHILD_INFO) as? String ?? ""
//                uniqueDeviceId = results![0].value(forKey: CoredataKeys.Keys.UNIQUE_DEVICE_ID_CHILD_INFO) as? String ?? ""
//                agent = results![0].value(forKey: CoredataKeys.Keys.AGENT_CHILD_INFO) as? String ?? ""
//                newSubscriptionId = results![0].value(forKey: CoredataKeys.Keys.SUBSCRIPTION_ID_CHILD_INFO) as? String ?? ""
//                priority = results![0].value(forKey: CoredataKeys.Keys.PRIORITY_CHILD_INFO) as? String ?? ""
//                deviceId = results![0].value(forKey: CoredataKeys.Keys.DEVICE_ID_CHILD_INFO) as? String ?? ""
//                batteryRemaining = results![0].value(forKey: CoredataKeys.Keys.BATTERY_REMAINING_CHILD_INFO) as? String ?? ""
//                wifiName = results![0].value(forKey: CoredataKeys.Keys.WIFI_NAME_CHILD_INFO) as? String ?? ""
//                deviceManufacturer = results![0].value(forKey: CoredataKeys.Keys.DEVICE_MENUFACTURED_CHILD_INFO) as? String ?? ""
//                deviceName = results![0].value(forKey: CoredataKeys.Keys.DEVICE_NAME_CHILD_INFO) as? String ?? ""
//                deviceModel = results![0].value(forKey: CoredataKeys.Keys.DEVICE_MODEL_CHILD_INFO) as? String ?? ""
//                deviceOs = results![0].value(forKey: CoredataKeys.Keys.DEVICE_OS_CHILD_INFO) as? String ?? ""
//                deviceLanguage = results![0].value(forKey: CoredataKeys.Keys.DEVICE_LANGUAGE_CHILD_INFO) as? String ?? ""
//                deviceTimezone = results![0].value(forKey: CoredataKeys.Keys.DEVICE_TIME_ZONE_CHILD_INFO) as? String ?? ""
//                deviceImei = results![0].value(forKey: CoredataKeys.Keys.DEVICE_IMEI_CHILD_INFO) as? String ?? ""
//                appVersion = results![0].value(forKey: CoredataKeys.Keys.APP_VERSION_CHILD_INFO) as? String ?? ""
//                appBuild = results![0].value(forKey: CoredataKeys.Keys.APP_BUILD_CHILD_INFO) as? String ?? ""
//                duration = results![0].value(forKey: CoredataKeys.Keys.DURATION_CHILD_INFO) as? String ?? ""
//                profileImgSrc = results![0].value(forKey: CoredataKeys.Keys.PROFILE_IMG_SRC_CHILD_INFO) as? String ?? ""
//                color = results![0].value(forKey: CoredataKeys.Keys.COLOR_CHILD_INFO) as? String ?? ""
//                phonelockStatus = results![0].value(forKey: CoredataKeys.Keys.PHONE_LOCK_STATUS_CHILD_INFO) as? String ?? ""
//                active = results![0].value(forKey: CoredataKeys.Keys.ACTIVE_CHILD_INFO) as? String ?? ""
//                deleted = results![0].value(forKey: CoredataKeys.Keys.DELETED_CHILD_INFO) as? String ?? ""
//                deletedBy = results![0].value(forKey: CoredataKeys.Keys.DELETED_BY_CHILD_INFO) as? String ?? ""
//                superUserID = results![0].value(forKey: CoredataKeys.Keys.SUPER_USER_ID_CHILD_INFO) as? String ?? ""
//                isProductionBuild = results![0].value(forKey: CoredataKeys.Keys.IS_PRODUCTION_BUILD_CHILD_INFO) as? String ?? ""
//                versionNumber = results![0].value(forKey: CoredataKeys.Keys.VERSION_NUMBER_CHILD_INFO) as? String ?? ""
//                versionCode = results![0].value(forKey: CoredataKeys.Keys.VERSION_CODE_CHILD_INFO) as? String ?? ""
//                subscriptionId = results![0].value(forKey: CoredataKeys.Keys.SUBSCRIPTION_ID_CHILD_INFO) as? String ?? ""
//                newSubscriptionId = results![0].value(forKey: CoredataKeys.Keys.NEW_SUBSCRIPTION_CHILD_INFO) as? String ?? ""
//                schoolID = results![0].value(forKey: CoredataKeys.Keys.SCHOOL_ID_CHILD_INFO) as? String ?? ""
//                campusID = results![0].value(forKey: CoredataKeys.Keys.CAMPUS_ID_CHILD_INFO) as? String ?? ""
//                classID = results![0].value(forKey: CoredataKeys.Keys.CLASS_ID_CHILD_INFO) as? String ?? ""
//            }
//        } catch {
//            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
//        }
//        do {
//            try  context.save()
//        }
//        catch {
//            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
//        }
//        
//        let data = ChildInfo(childID: Int(childId ?? ""), name: name ?? "", birthday: birthday ?? "", gender: gender ?? "", relationship: relationship ?? "", email: email ?? "", phone: phone ?? "", plateformID: Int(platformId ?? ""), device: device ?? "", planID: Int(planId ?? ""), packageID: Int(packageId ?? ""), package: package ?? "", duration: duration ?? "", expiryDate: expairyDate ?? "", remainingDays: remainingDays ?? "", coverImgSrc: coverImgSrc ?? "", profileImgSrc: profileImgSrc ?? "", color: color ?? "", phonelockStatus: Int(phonelockStatus ?? ""), active: Int(active ?? ""), deleted: Int(deleted ?? ""), deletedBy: deletedBy ?? "", superUserID: Int(superUserID ?? "") , activationCode: activationCode ?? "", dateCreated: dateCreated ?? "", dateModified: dateModified ?? "", pushToken: pushToken ?? "", childEnrolled: Int(childEnrolled ?? ""), childMdmHash: childMdmHash ?? "", isProductionBuild: Int(isProductionBuild ?? ""), versionNumber: versionNumber ?? "", versionCode: versionCode ?? "", subscriptionID: subscriptionId ?? "", schoolID: schoolID ?? "", campusID: campusID ?? "", classID: classID ?? "", resellerID: resellerId ?? 0, timeZone: timezone ?? "", isForgetMe: Int(isForgetMe ?? ""), apiToken: apiToken ?? "", activationDate: activationDate ?? "", createdAt: createdAt ?? "", updatedAt: updatedAt ?? "", uniqueDeviceID: uniqueDeviceId ?? "", agent: agent ?? "", newSubscriptionID: Int(newSubscriptionId ?? ""), priority: Int(priority ?? ""), deviceID: Int(deviceId ?? ""), batteryRemaining: batteryRemaining ?? "", wifiName: wifiName ?? "", deviceManufacturer: deviceManufacturer ?? "", deviceName: deviceName ?? "", deviceModel: deviceModel ?? "", deviceOS: deviceOs ?? "", deviceLanguage: deviceLanguage ?? "", deviceTimezone: deviceTimezone ?? "", deviceImei: deviceImei ?? "", appVersion: appVersion ?? "", appBuild: appBuild ?? "")
//        return data
//    }
    
    
    
    //MARK: Fetch CHILD DATA
//    @objc static func fetchDashboardFromDatabaseNEW(childssID: String) -> [ChildData] {
//        var resellerId: Int?
//        var childId ,name ,birthday ,relationship ,gender ,email ,phone ,platformId ,device ,planId ,packageId ,package ,expairyDate ,remainingDays ,coverImgSrc ,activationCode ,dateCreated ,dateModified ,pushToken ,childEnrolled ,childMdmHash ,timezone ,isForgetMe, apiToken ,activationDate ,createdAt ,updatedAt ,uniqueDeviceId ,agent ,newSubscriptionId ,priority ,deviceId ,batteryRemaining ,wifiName ,deviceManufacturer ,deviceName ,deviceModel ,deviceOs ,deviceLanguage ,deviceTimezone ,deviceImei ,appVersion ,appBuild ,duration ,profileImgSrc ,color ,phonelockStatus ,active ,deleted ,deletedBy, superUserID, isProductionBuild, versionNumber, versionCode, subscriptionId, schoolID, campusID, classID : String?
//        var dashboardData = [ChildData]()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.CHILD_INFO_DASHBOARD)
//        do {
//            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
//            if results?.count != 0 {
//                for result in results ?? [NSManagedObject]() {
//                    childId = result.value(forKey: CoredataKeys.Keys.CHILD_ID_DASHBOARD) as? String ?? ""
//                    name = result.value(forKey: CoredataKeys.Keys.NAME_DASHBOARD) as? String ?? ""
//                    birthday = result.value(forKey: CoredataKeys.Keys.BIRTHDAY_DASHBOARD) as? String ?? ""
//                    gender = result.value(forKey: CoredataKeys.Keys.GENDER_DASHBOARD) as? String ?? ""
//                    relationship = result.value(forKey: CoredataKeys.Keys.RELATIONSHIP_DASHBOARD) as? String ?? ""
//                    email = result.value(forKey: CoredataKeys.Keys.EMAIL_DASHBOARD) as? String ?? ""
//                    phone = result.value(forKey: CoredataKeys.Keys.PHONE_DASHBOARD) as? String ?? ""
//                    platformId = result.value(forKey: CoredataKeys.Keys.PLATEFORM_ID_DASHBOARD) as? String ?? ""
//                    device = result.value(forKey: CoredataKeys.Keys.DEVICE_DASHBOARD) as? String ?? ""
//                    planId = result.value(forKey: CoredataKeys.Keys.PLAN_ID_DASHBOARD) as? String ?? ""
//                    packageId = result.value(forKey: CoredataKeys.Keys.PACKAGE_ID_DASHBOARD) as? String ?? ""
//                    package = result.value(forKey: CoredataKeys.Keys.PACKAGE_DASHBOARD) as? String ?? ""
//                    expairyDate = result.value(forKey: CoredataKeys.Keys.EXPAIRY_DASHBOARD) as? String ?? ""
//                    remainingDays = result.value(forKey: CoredataKeys.Keys.REMAINING_DAYS_DASHBOARD) as? String ?? ""
//                    coverImgSrc = result.value(forKey: CoredataKeys.Keys.COVER_IMG_SRC_DASHBOARD) as? String ?? ""
//                    activationCode = result.value(forKey: CoredataKeys.Keys.ACTIVATION_CODE_DASHBOARD) as? String ?? ""
//                    dateCreated = result.value(forKey: CoredataKeys.Keys.DATE_CREATED_DASHBOARD) as? String ?? ""
//                    dateModified = result.value(forKey: CoredataKeys.Keys.DATE_MODIFIED_DASHBOARD) as? String ?? ""
//                    pushToken = result.value(forKey: CoredataKeys.Keys.PUSH_TOKEN_DASHBOARD) as? String ?? ""
//                    childEnrolled = result.value(forKey: CoredataKeys.Keys.CHILD_ENROLLED_DASHBOARD) as? String ?? ""
//                    childMdmHash = result.value(forKey: CoredataKeys.Keys.CHILD_MDM_HASH_DASHBOARD) as? String ?? ""
//                    resellerId = result.value(forKey: CoredataKeys.Keys.RESELLER_ID_DASHBOARD) as? Int ?? 0
//                    timezone = result.value(forKey: CoredataKeys.Keys.TIME_ZONE_DASHBOARD) as? String ?? ""
//                    isForgetMe = result.value(forKey: CoredataKeys.Keys.IS_FOGET_ME_DASHBOARD) as? String ?? ""
//                    apiToken = result.value(forKey: CoredataKeys.Keys.API_TOKEN_DASHBOARD) as? String ?? ""
//                    activationDate = result.value(forKey: CoredataKeys.Keys.ACTIVATION_DATE_DASHBOARD) as? String ?? ""
//                    createdAt = result.value(forKey: CoredataKeys.Keys.CREATED_AT_DASHBOARD) as? String ?? ""
//                    updatedAt = result.value(forKey: CoredataKeys.Keys.UPDATED_AT_DASHBOARD) as? String ?? ""
//                    uniqueDeviceId = result.value(forKey: CoredataKeys.Keys.UNIQUE_DEVICE_ID_DASHBOARD) as? String ?? ""
//                    agent = result.value(forKey: CoredataKeys.Keys.AGENT_DASHBOARD) as? String ?? ""
//                    newSubscriptionId = result.value(forKey: CoredataKeys.Keys.SUBSCRIPTION_ID_DASHBOARD) as? String ?? ""
//                    priority = result.value(forKey: CoredataKeys.Keys.PRIORITY_DASHBOARD) as? String ?? ""
//                    deviceId = result.value(forKey: CoredataKeys.Keys.DEVICE_ID_DASHBOARD) as? String ?? ""
//                    batteryRemaining = result.value(forKey: CoredataKeys.Keys.BATTERY_REMAINING_DASHBOARD) as? String ?? ""
//                    wifiName = result.value(forKey: CoredataKeys.Keys.WIFI_NAME_DASHBOARD) as? String ?? ""
//                    deviceManufacturer = result.value(forKey: CoredataKeys.Keys.DEVICE_MENUFACTURED_DASHBOARD) as? String ?? ""
//                    deviceName = result.value(forKey: CoredataKeys.Keys.DEVICE_NAME_DASHBOARD) as? String ?? ""
//                    deviceModel = result.value(forKey: CoredataKeys.Keys.DEVICE_MODEL_DASHBOARD) as? String ?? ""
//                    deviceOs = result.value(forKey: CoredataKeys.Keys.DEVICE_OS_DASHBOARD) as? String ?? ""
//                    deviceLanguage = result.value(forKey: CoredataKeys.Keys.DEVICE_LANGUAGE_DASHBOARD) as? String ?? ""
//                    deviceTimezone = result.value(forKey: CoredataKeys.Keys.DEVICE_TIME_ZONE_DASHBOARD) as? String ?? ""
//                    deviceImei = result.value(forKey: CoredataKeys.Keys.DEVICE_IMEI_DASHBOARD) as? String ?? ""
//                    appVersion = result.value(forKey: CoredataKeys.Keys.APP_VERSION_DASHBOARD) as? String ?? ""
//                    appBuild = result.value(forKey: CoredataKeys.Keys.APP_BUILD_DASHBOARD) as? String ?? ""
//                    duration = result.value(forKey: CoredataKeys.Keys.DURATION_DASHBOARD) as? String ?? ""
//                    profileImgSrc = result.value(forKey: CoredataKeys.Keys.PROFILE_IMG_SRC_DASHBOARD) as? String ?? ""
//                    color = result.value(forKey: CoredataKeys.Keys.COLOR_DASHBOARD) as? String ?? ""
//                    phonelockStatus = result.value(forKey: CoredataKeys.Keys.PHONE_LOCK_STATUS_DASHBOARD) as? String ?? ""
//                    active = result.value(forKey: CoredataKeys.Keys.ACTIVE_DASHBOARD) as? String ?? ""
//                    deleted = result.value(forKey: CoredataKeys.Keys.DELETED_DASHBOARD) as? String ?? ""
//                    deletedBy = result.value(forKey: CoredataKeys.Keys.DELETED_BY_DASHBOARD) as? String ?? ""
//                    superUserID = result.value(forKey: CoredataKeys.Keys.SUPER_USER_ID_DASHBOARD) as? String ?? ""
//                    isProductionBuild = result.value(forKey: CoredataKeys.Keys.IS_PRODUCTION_BUILD_DASHBOARD) as? String ?? ""
//                    versionNumber = result.value(forKey: CoredataKeys.Keys.VERSION_NUMBER_DASHBOARD) as? String ?? ""
//                    versionCode = result.value(forKey: CoredataKeys.Keys.VERSION_CODE_DASHBOARD) as? String ?? ""
//                    subscriptionId = result.value(forKey: CoredataKeys.Keys.SUBSCRIPTION_ID_DASHBOARD) as? String ?? ""
//                    newSubscriptionId = result.value(forKey: CoredataKeys.Keys.NEW_SUBSCRIPTION_DASHBOARD) as? String ?? ""
//                    schoolID = result.value(forKey: CoredataKeys.Keys.SCHOOL_ID_DASHBOARD) as? String ?? ""
//                    campusID = result.value(forKey: CoredataKeys.Keys.CAMPUS_ID_DASHBOARD) as? String ?? ""
//                    classID = result.value(forKey: CoredataKeys.Keys.CLASS_ID_DASHBOARD) as? String ?? ""
//                    
//                    let childInfo = ChildInfo(childID: Int(childId ?? ""), name: name ?? "", birthday: birthday ?? "", gender: gender ?? "", relationship: relationship ?? "", email: email ?? "", phone: phone ?? "", plateformID: Int(platformId ?? ""), device: device ?? "", planID: Int(planId ?? ""), packageID: Int(packageId ?? ""), package: package ?? "", duration: duration ?? "", expiryDate: expairyDate ?? "", remainingDays: remainingDays ?? "", coverImgSrc: coverImgSrc ?? "", profileImgSrc: profileImgSrc ?? "", color: color ?? "", phonelockStatus: Int(phonelockStatus ?? ""), active: Int(active ?? ""), deleted: Int(deleted ?? ""), deletedBy: deletedBy ?? "", superUserID: Int(superUserID ?? "") , activationCode: activationCode ?? "", dateCreated: dateCreated ?? "", dateModified: dateModified ?? "", pushToken: pushToken ?? "", childEnrolled: Int(childEnrolled ?? ""), childMdmHash: childMdmHash ?? "", isProductionBuild: Int(isProductionBuild ?? ""), versionNumber: versionNumber ?? "", versionCode: versionCode ?? "", subscriptionID: subscriptionId ?? "", schoolID: schoolID ?? "", campusID: campusID ?? "", classID: classID ?? "", resellerID: resellerId ?? 0, timeZone: timezone ?? "", isForgetMe: Int(isForgetMe ?? ""), apiToken: apiToken ?? "", activationDate: activationDate ?? "", createdAt: createdAt ?? "", updatedAt: updatedAt ?? "", uniqueDeviceID: uniqueDeviceId ?? "", agent: agent ?? "", newSubscriptionID: Int(newSubscriptionId ?? ""), priority: Int(priority ?? ""), deviceID: Int(deviceId ?? ""), batteryRemaining: batteryRemaining ?? "", wifiName: wifiName ?? "", deviceManufacturer: deviceManufacturer ?? "", deviceName: deviceName ?? "", deviceModel: deviceModel ?? "", deviceOS: deviceOs ?? "", deviceLanguage: deviceLanguage ?? "", deviceTimezone: deviceTimezone ?? "", deviceImei: deviceImei ?? "", appVersion: appVersion ?? "", appBuild: appBuild ?? "")
//                    let preferencesData = fetchPreferenceFromDatabase(child_id: childssID)
//                    let dailyLimtsData = fetchDailyLimitsFromDatabase(child_id: childssID)
//                    let data = ChildData(childInfo: childInfo, preferences: preferencesData, dailyLimit: dailyLimtsData)
//                    dashboardData.append(data)
//                }
//            }
//        } catch {
//            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
//        }
//        do {
//            try  context.save()
//        }
//        catch {
//            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
//        }
//        return dashboardData
//    }
    
    
    //MARK: Fetch Dashboard Data
//    @objc static func fetchDashboardFromDatabase() -> [ChildData] {
//        var resellerId: Int?
//        var childId ,name ,birthday ,relationship ,gender ,email ,phone ,platformId ,device ,planId ,packageId ,package ,expairyDate ,remainingDays ,coverImgSrc ,activationCode ,dateCreated ,dateModified ,pushToken ,childEnrolled ,childMdmHash ,timezone ,isForgetMe, apiToken ,activationDate ,createdAt ,updatedAt ,uniqueDeviceId ,agent ,newSubscriptionId ,priority ,deviceId ,batteryRemaining ,wifiName ,deviceManufacturer ,deviceName ,deviceModel ,deviceOs ,deviceLanguage ,deviceTimezone ,deviceImei ,appVersion ,appBuild ,duration ,profileImgSrc ,color ,phonelockStatus ,active ,deleted ,deletedBy, superUserID, isProductionBuild, versionNumber, versionCode, subscriptionId, schoolID, campusID, classID : String?
//        var dashboardData = [ChildData]()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.CHILD_INFO_DASHBOARD)
//        do {
//            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
//            if results?.count != 0 {
//                for result in results ?? [NSManagedObject]() {
//                    childId = result.value(forKey: CoredataKeys.Keys.CHILD_ID_DASHBOARD) as? String ?? ""
//                    name = result.value(forKey: CoredataKeys.Keys.NAME_DASHBOARD) as? String ?? ""
//                    birthday = result.value(forKey: CoredataKeys.Keys.BIRTHDAY_DASHBOARD) as? String ?? ""
//                    gender = result.value(forKey: CoredataKeys.Keys.GENDER_DASHBOARD) as? String ?? ""
//                    relationship = result.value(forKey: CoredataKeys.Keys.RELATIONSHIP_DASHBOARD) as? String ?? ""
//                    email = result.value(forKey: CoredataKeys.Keys.EMAIL_DASHBOARD) as? String ?? ""
//                    phone = result.value(forKey: CoredataKeys.Keys.PHONE_DASHBOARD) as? String ?? ""
//                    platformId = result.value(forKey: CoredataKeys.Keys.PLATEFORM_ID_DASHBOARD) as? String ?? ""
//                    device = result.value(forKey: CoredataKeys.Keys.DEVICE_DASHBOARD) as? String ?? ""
//                    planId = result.value(forKey: CoredataKeys.Keys.PLAN_ID_DASHBOARD) as? String ?? ""
//                    packageId = result.value(forKey: CoredataKeys.Keys.PACKAGE_ID_DASHBOARD) as? String ?? ""
//                    package = result.value(forKey: CoredataKeys.Keys.PACKAGE_DASHBOARD) as? String ?? ""
//                    expairyDate = result.value(forKey: CoredataKeys.Keys.EXPAIRY_DASHBOARD) as? String ?? ""
//                    remainingDays = result.value(forKey: CoredataKeys.Keys.REMAINING_DAYS_DASHBOARD) as? String ?? ""
//                    coverImgSrc = result.value(forKey: CoredataKeys.Keys.COVER_IMG_SRC_DASHBOARD) as? String ?? ""
//                    activationCode = result.value(forKey: CoredataKeys.Keys.ACTIVATION_CODE_DASHBOARD) as? String ?? ""
//                    dateCreated = result.value(forKey: CoredataKeys.Keys.DATE_CREATED_DASHBOARD) as? String ?? ""
//                    dateModified = result.value(forKey: CoredataKeys.Keys.DATE_MODIFIED_DASHBOARD) as? String ?? ""
//                    pushToken = result.value(forKey: CoredataKeys.Keys.PUSH_TOKEN_DASHBOARD) as? String ?? ""
//                    childEnrolled = result.value(forKey: CoredataKeys.Keys.CHILD_ENROLLED_DASHBOARD) as? String ?? ""
//                    childMdmHash = result.value(forKey: CoredataKeys.Keys.CHILD_MDM_HASH_DASHBOARD) as? String ?? ""
//                    resellerId = result.value(forKey: CoredataKeys.Keys.RESELLER_ID_DASHBOARD) as? Int ?? 0
//                    timezone = result.value(forKey: CoredataKeys.Keys.TIME_ZONE_DASHBOARD) as? String ?? ""
//                    isForgetMe = result.value(forKey: CoredataKeys.Keys.IS_FOGET_ME_DASHBOARD) as? String ?? ""
//                    apiToken = result.value(forKey: CoredataKeys.Keys.API_TOKEN_DASHBOARD) as? String ?? ""
//                    activationDate = result.value(forKey: CoredataKeys.Keys.ACTIVATION_DATE_DASHBOARD) as? String ?? ""
//                    createdAt = result.value(forKey: CoredataKeys.Keys.CREATED_AT_DASHBOARD) as? String ?? ""
//                    updatedAt = result.value(forKey: CoredataKeys.Keys.UPDATED_AT_DASHBOARD) as? String ?? ""
//                    uniqueDeviceId = result.value(forKey: CoredataKeys.Keys.UNIQUE_DEVICE_ID_DASHBOARD) as? String ?? ""
//                    agent = result.value(forKey: CoredataKeys.Keys.AGENT_DASHBOARD) as? String ?? ""
//                    newSubscriptionId = result.value(forKey: CoredataKeys.Keys.SUBSCRIPTION_ID_DASHBOARD) as? String ?? ""
//                    priority = result.value(forKey: CoredataKeys.Keys.PRIORITY_DASHBOARD) as? String ?? ""
//                    deviceId = result.value(forKey: CoredataKeys.Keys.DEVICE_ID_DASHBOARD) as? String ?? ""
//                    batteryRemaining = result.value(forKey: CoredataKeys.Keys.BATTERY_REMAINING_DASHBOARD) as? String ?? ""
//                    wifiName = result.value(forKey: CoredataKeys.Keys.WIFI_NAME_DASHBOARD) as? String ?? ""
//                    deviceManufacturer = result.value(forKey: CoredataKeys.Keys.DEVICE_MENUFACTURED_DASHBOARD) as? String ?? ""
//                    deviceName = result.value(forKey: CoredataKeys.Keys.DEVICE_NAME_DASHBOARD) as? String ?? ""
//                    deviceModel = result.value(forKey: CoredataKeys.Keys.DEVICE_MODEL_DASHBOARD) as? String ?? ""
//                    deviceOs = result.value(forKey: CoredataKeys.Keys.DEVICE_OS_DASHBOARD) as? String ?? ""
//                    deviceLanguage = result.value(forKey: CoredataKeys.Keys.DEVICE_LANGUAGE_DASHBOARD) as? String ?? ""
//                    deviceTimezone = result.value(forKey: CoredataKeys.Keys.DEVICE_TIME_ZONE_DASHBOARD) as? String ?? ""
//                    deviceImei = result.value(forKey: CoredataKeys.Keys.DEVICE_IMEI_DASHBOARD) as? String ?? ""
//                    appVersion = result.value(forKey: CoredataKeys.Keys.APP_VERSION_DASHBOARD) as? String ?? ""
//                    appBuild = result.value(forKey: CoredataKeys.Keys.APP_BUILD_DASHBOARD) as? String ?? ""
//                    duration = result.value(forKey: CoredataKeys.Keys.DURATION_DASHBOARD) as? String ?? ""
//                    profileImgSrc = result.value(forKey: CoredataKeys.Keys.PROFILE_IMG_SRC_DASHBOARD) as? String ?? ""
//                    color = result.value(forKey: CoredataKeys.Keys.COLOR_DASHBOARD) as? String ?? ""
//                    phonelockStatus = result.value(forKey: CoredataKeys.Keys.PHONE_LOCK_STATUS_DASHBOARD) as? String ?? ""
//                    active = result.value(forKey: CoredataKeys.Keys.ACTIVE_DASHBOARD) as? String ?? ""
//                    deleted = result.value(forKey: CoredataKeys.Keys.DELETED_DASHBOARD) as? String ?? ""
//                    deletedBy = result.value(forKey: CoredataKeys.Keys.DELETED_BY_DASHBOARD) as? String ?? ""
//                    superUserID = result.value(forKey: CoredataKeys.Keys.SUPER_USER_ID_DASHBOARD) as? String ?? ""
//                    isProductionBuild = result.value(forKey: CoredataKeys.Keys.IS_PRODUCTION_BUILD_DASHBOARD) as? String ?? ""
//                    versionNumber = result.value(forKey: CoredataKeys.Keys.VERSION_NUMBER_DASHBOARD) as? String ?? ""
//                    versionCode = result.value(forKey: CoredataKeys.Keys.VERSION_CODE_DASHBOARD) as? String ?? ""
//                    subscriptionId = result.value(forKey: CoredataKeys.Keys.SUBSCRIPTION_ID_DASHBOARD) as? String ?? ""
//                    newSubscriptionId = result.value(forKey: CoredataKeys.Keys.NEW_SUBSCRIPTION_DASHBOARD) as? String ?? ""
//                    schoolID = result.value(forKey: CoredataKeys.Keys.SCHOOL_ID_DASHBOARD) as? String ?? ""
//                    campusID = result.value(forKey: CoredataKeys.Keys.CAMPUS_ID_DASHBOARD) as? String ?? ""
//                    classID = result.value(forKey: CoredataKeys.Keys.CLASS_ID_DASHBOARD) as? String ?? ""
//                    
//                    let childInfo = ChildInfo(childID: Int(childId ?? ""), name: name ?? "", birthday: birthday ?? "", gender: gender ?? "", relationship: relationship ?? "", email: email ?? "", phone: phone ?? "", plateformID: Int(platformId ?? ""), device: device ?? "", planID: Int(planId ?? ""), packageID: Int(packageId ?? ""), package: package ?? "", duration: duration ?? "", expiryDate: expairyDate ?? "", remainingDays: remainingDays ?? "", coverImgSrc: coverImgSrc ?? "", profileImgSrc: profileImgSrc ?? "", color: color ?? "", phonelockStatus: Int(phonelockStatus ?? ""), active: Int(active ?? ""), deleted: Int(deleted ?? ""), deletedBy: deletedBy ?? "", superUserID: Int(superUserID ?? "") , activationCode: activationCode ?? "", dateCreated: dateCreated ?? "", dateModified: dateModified ?? "", pushToken: pushToken ?? "", childEnrolled: Int(childEnrolled ?? ""), childMdmHash: childMdmHash ?? "", isProductionBuild: Int(isProductionBuild ?? ""), versionNumber: versionNumber ?? "", versionCode: versionCode ?? "", subscriptionID: subscriptionId ?? "", schoolID: schoolID ?? "", campusID: campusID ?? "", classID: classID ?? "", resellerID: resellerId ?? 0, timeZone: timezone ?? "", isForgetMe: Int(isForgetMe ?? ""), apiToken: apiToken ?? "", activationDate: activationDate ?? "", createdAt: createdAt ?? "", updatedAt: updatedAt ?? "", uniqueDeviceID: uniqueDeviceId ?? "", agent: agent ?? "", newSubscriptionID: Int(newSubscriptionId ?? ""), priority: Int(priority ?? ""), deviceID: Int(deviceId ?? ""), batteryRemaining: batteryRemaining ?? "", wifiName: wifiName ?? "", deviceManufacturer: deviceManufacturer ?? "", deviceName: deviceName ?? "", deviceModel: deviceModel ?? "", deviceOS: deviceOs ?? "", deviceLanguage: deviceLanguage ?? "", deviceTimezone: deviceTimezone ?? "", deviceImei: deviceImei ?? "", appVersion: appVersion ?? "", appBuild: appBuild ?? "")
//                    let preferencesData = fetchPreferenceFromDatabase(child_id: childId ?? "")
//                    let dailyLimtsData = fetchDailyLimitsFromDatabase(child_id: childId ?? "")
//                    let data = ChildData(childInfo: childInfo, preferences: preferencesData, dailyLimit: dailyLimtsData)
//                    dashboardData.append(data)
//                }
//            }
//        } catch {
//            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
//        }
//        do {
//            try  context.save()
//        }
//        catch {
//            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
//        }
//        return dashboardData
//    }
    
    //MARK: - APP HISTORY DATA FETCHING
    
    static func fetchHistoryData() -> [AppHistortDataModel] {
        var coParent = [AppHistortDataModel]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.APP_HISTORY_DATA)
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
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
                    coParent.append(dataObj)
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
        return coParent
    }
    
    
    //MARK: - APP HISTORY DATA FETCHING
     static func fetchYoutubeData() -> [youtubeData] {
        var coParent = [youtubeData]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.APP_YOUTUBE_DATA)
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                for result in results ?? [NSManagedObject]() {
                    let browserHistoryId = result.value(forKey: CoredataKeys.Keys.Y_ID) as? String ?? ""
                    let history_child_id = result.value(forKey: CoredataKeys.Keys.Y_CHILD_ID) as? String ?? ""
                    let history_created_at = result.value(forKey: CoredataKeys.Keys.Y_CREATED_AT) as? String ?? ""
                    let history_deleted = result.value(forKey: CoredataKeys.Keys.Y_DELETED) as? String ?? ""
                    let history_domain = result.value(forKey: CoredataKeys.Keys.Y_DOMAIN) as? String ?? ""
                    let history_number_visted = result.value(forKey: CoredataKeys.Keys.Y_NUMBER_VISTIT) as? String ?? ""
                    let history_super_id = result.value(forKey: CoredataKeys.Keys.Y_SUPER_USER_ID) as? String ?? ""
                    let history_time_visit = result.value(forKey: CoredataKeys.Keys.Y_TIME_VIST) as? String ?? ""
                    let history_title = result.value(forKey: CoredataKeys.Keys.Y_TITLE) as? String ?? ""
                    let history_updatedAt = result.value(forKey: CoredataKeys.Keys.Y_UPDATED_AT) as? String ?? ""
                    let history_url = result.value(forKey: CoredataKeys.Keys.Y_URL) as? String ?? ""
                    let dataObj = youtubeData(id: Int(browserHistoryId) ?? 0, superUserID: Int(history_super_id) ?? 0, title: history_title, domain: history_domain, url: history_url, timeVisit: history_time_visit, numberVisits: Int(history_number_visted) ?? 0, childID: Int(history_child_id ) ?? 0, deleted: Int(history_deleted) ?? 0, createdAt: history_created_at, updatedAt: history_updatedAt)
                    coParent.append(dataObj)
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
        return coParent
    }
    
    //MARK: - APP TIKTOK DATA FETCHING
     static func fetchTiktokData() -> [youtubeData] {
        var coParent = [youtubeData]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.APP_TIKTOK_DATA)
        do {
            let results = try  context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                for result in results ?? [NSManagedObject]() {
                    let browserHistoryId = result.value(forKey: CoredataKeys.Keys.T_ID) as? String ?? ""
                    let history_child_id = result.value(forKey: CoredataKeys.Keys.T_CHILD_ID) as? String ?? ""
                    let history_created_at = result.value(forKey: CoredataKeys.Keys.T_CREATED_AT) as? String ?? ""
                    let history_deleted = result.value(forKey: CoredataKeys.Keys.T_DELETED) as? String ?? ""
                    let history_domain = result.value(forKey: CoredataKeys.Keys.T_DOMAIN) as? String ?? ""
                    let history_number_visted = result.value(forKey: CoredataKeys.Keys.T_NUMBER_VISTIT) as? String ?? ""
                    let history_super_id = result.value(forKey: CoredataKeys.Keys.T_SUPER_USER_ID) as? String ?? ""
                    let history_time_visit = result.value(forKey: CoredataKeys.Keys.T_TIME_VIST) as? String ?? ""
                    let history_title = result.value(forKey: CoredataKeys.Keys.T_TITLE) as? String ?? ""
                    let history_updatedAt = result.value(forKey: CoredataKeys.Keys.T_UPDATED_AT) as? String ?? ""
                    let history_url = result.value(forKey: CoredataKeys.Keys.T_URL) as? String ?? ""
                    
                    let dataObj = youtubeData(id: Int(browserHistoryId ) ?? 0, superUserID: Int(history_super_id ) ?? 0, title: history_title, domain: history_domain, url: history_url, timeVisit: history_time_visit, numberVisits: Int(history_number_visted ) ?? 0, childID: Int(history_child_id ) ?? 0, deleted: Int(history_deleted ) ?? 0, createdAt: history_created_at, updatedAt: history_updatedAt)
                    coParent.append(dataObj)
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
        return coParent
    }
    
    //MARK: - Save Home API Complete Response
    static func saveHomeApiResponseInDatabase(data: HomeData) {
        if let children = data.children {
            saveDashbaordInDatabase(dashboard: children)
            for child in children {
                saveChildInfoInDatabase(data: child)
                savePreferencesInDatabase(data: child)
                saveDailyLimitInDatabase(data: child)
            }
        }
        saveCoParentInDatabase(data: data)
        UserDefaults.standard.set(true, forKey: "TOGLE_STATUS")
        UserDefaults.standard.synchronize()
    }
    
//    static func fetchHomeApiResponseFromDatabase(childId: String) -> HomeDatabaseResponse {
////        let childInfo =  fetchChildInfoFromDatabase(child_id: childId)
//        let preferences =  fetchPreferenceFromDatabase(child_id: childId)
//        let dailyLimit =  fetchDailyLimitsFromDatabase(child_id: childId)
////        let coParents =  fetchCoParentFromDatabase()
////        let data = HomeDatabaseResponse(coParent: coParents, childInfo: childInfo, preferences: preferences, dailyLimit: dailyLimit)
//        return data
//    }
//    
    
    //MARK: - Delete Child From Database
    @objc static func deleteDashboardChildFromDatabase(childId:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.CHILD_INFO_DASHBOARD)
        fetchRequest.predicate = NSPredicate(format: "child_id_DASHBOARD = %@", argumentArray: [childId])
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    context.delete(result)
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
    }
    
    @objc static func deleteChildFromDatabase(childId:String) {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.CHILD_INFO_FILE)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChildrenEntity")
        fetchRequest.predicate = NSPredicate(format: "child_id_child_info = %@", argumentArray: [childId])
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    context.delete(result)
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
    }
    
    static func deleteChildRecordFromDatabase(childID:String) {
        deleteDashboardChildFromDatabase(childId: childID)
        deleteChildFromDatabase(childId: childID)
    }
    
    static func delete_ChildDataFromDB(entity:String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    //PREFERENCE_FILE
    
    static func delete_ChildPrefferenceData(entity:String, childId: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        deletePrChildID(childId: childId)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    
    
    @objc static func deletePrChildID(childId:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Entities.PREFERENCE_FILE)
        fetchRequest.predicate = NSPredicate(format: "child_id_pref = %@", argumentArray: [childId])
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    context.delete(result)
                }
            }
        } catch {
            print(StringConstants.Errors.FETCHING_DATA_FAILED, "\(error)")
        }
        do {
            try  context.save()
        }
        catch {
            print(StringConstants.Errors.SAVING_DATA_FAILED, "\(error)")
        }
    }
    
    //MARK: DELETE HOME DATA
    @objc static func deleteHomeData() {
        CoreDataUtility.delete_ChildDataFromDB(entity: "Child_Info_Dashboard")
        CoreDataUtility.delete_ChildDataFromDB(entity: "Child_Preferences")
        CoreDataUtility.delete_ChildDataFromDB(entity: "ChildrenEntity")
        CoreDataUtility.delete_ChildDataFromDB(entity: "Children_Info")
        CoreDataUtility.delete_ChildDataFromDB(entity: "Co_Parent")
        CoreDataUtility.delete_ChildDataFromDB(entity: "FamilyFeed")
        CoreDataUtility.delete_ChildDataFromDB(entity: "Calls")
        CoreDataUtility.delete_ChildDataFromDB(entity: "Daily_Limit")
        CoreDataUtility.delete_ChildDataFromDB(entity: "Package")
        CoreDataUtility.delete_ChildDataFromDB(entity: CoredataKeys.Entities.APP_HISTORY_DATA)
        CoreDataUtility.delete_ChildDataFromDB(entity: CoredataKeys.Entities.APP_YOUTUBE_DATA)
        CoreDataUtility.delete_ChildDataFromDB(entity: CoredataKeys.Entities.APP_TIKTOK_DATA)
        CoreDataUtility.delete_ChildDataFromDB(entity: CoredataKeys.Entities.SOCIAL_HISTORY_DATA)
        CoreDataUtility.delete_ChildDataFromDB(entity: CoredataKeys.Entities.TEXT_MSGS_DATA)
        CoreDataUtility.delete_ChildDataFromDB(entity: "ContactsTable")
        CoreDataUtility.delete_ChildDataFromDB(entity: "LocationsHistory")
        CoreDataUtility.delete_ChildDataFromDB(entity: "AppUsageCore")
        CoreDataUtility.delete_ChildDataFromDB(entity: "V1AppUsage")
    }
    
    //MARK: UPDATE HOME API ALL DATA
    @objc static func updateAllHomeData(isRequire:Bool = false){
        CoreDataUtility.delete_ChildDataFromDB(entity: "Child_Info_Dashboard")
        CoreDataUtility.delete_ChildDataFromDB(entity: "Child_Preferences")
        CoreDataUtility.delete_ChildDataFromDB(entity: "Children_Info")
        CoreDataUtility.delete_ChildDataFromDB(entity: "ChildrenEntity")
        CoreDataUtility.delete_ChildDataFromDB(entity: "Co_Parent")
        CoreDataUtility.delete_ChildDataFromDB(entity: "Daily_Limit")
//        if isRequire {
//            return
//        }
//        DispatchQueue.main.async {
//            HLApiManager.HomeNetworkCallCore2 { response, error in
//                if let response = response {
//                    if let homeData = response.data {
//                        CoreDataUtility.saveHomeApiResponseInDatabase(data: homeData)
//                    }
//                } else {
//                    print("dashboard background api failed with message = \(error ?? "Nil")")
//                }
//            }
//        }
    }
}
