//
//  SwiftContactsWatchListViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 02/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD

class SwiftContactsWatchListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contPrefer: UISwitch!
    @IBOutlet weak var enableLabel: UILabel!
    
    //MARK: - Variables
    var isCountBased = false
    var refreshCont = UIRefreshControl()
    let delegate = UIApplication.shared.delegate as? AppDelegate
    var countLimit = -1
    var IDsAllArray = [Int]()
    var StatusAllArray = [Int]()
    var dataSource = [AnyHashable]()
    var watchedCount = 0
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    var control = Control()
    var contactsArr = [ContactObj]()
    var restrictedContacts = [ContactObj]()
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        contPrefer.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        control = DBManager.shared.fetchAppBlockControl(identifier: "contacts_watch")
        contPrefer.isOn = control.state?.boolValue ?? false
        tableView.isUserInteractionEnabled = contPrefer.isOn
        if UI_USER_INTERFACE_IDIOM() == .pad {
            tableView.register(UINib(nibName: "ContactWatchedListTableViewCell", bundle: nil), forCellReuseIdentifier: "contactCell22")
        } else {
            tableView.register(UINib(nibName: "ContactWatchedListTableViewCell", bundle: nil), forCellReuseIdentifier: "contactCell22")
        }
        tableView.rowHeight = 90
        tableView.separatorStyle = .singleLine
        navigationItem.title = NSLocalizedString("settings_card_2_android_8", comment: "")
        let add = UIBarButtonItem(title: "save_button".localized, style: .plain, target: self, action: #selector(addAppToBlackList))
        navigationItem.rightBarButtonItems = [add]
        if responds(to: #selector(setter: UIViewController.edgesForExtendedLayout)) {
            edgesForExtendedLayout = [] //layout adjustements
        }
        let childId = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        contactsArr = DBManager.shared.fetchChildContacts(childId: childId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LiveVisitorManager.shared.updateScreen(
            "Contact Watchlist"
        )
        
//        ZendeskChatManager.trackEvent("Enable/Disable Watchlist")
        let contactsWatchlistPackageFeature = SwiftCommonUtility.shared.getPackageFeature(withName: "contactwatchlist")
        //delegate?.selectedDashboardChild.getPackageFeature(withName: "contactwatchlist")
        self.isCountBased = false
        if contactsWatchlistPackageFeature?.is_count_based == 1 {
            self.isCountBased = true
        }
        countLimit = Int(contactsWatchlistPackageFeature?.count_limit ?? "0") ?? 0
//        self.refreshView()
//        self.loadContactWatchList()
    }
    
    func refreshView() {
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
        let callsPreference = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id)
        print(callsPreference)
        for i in callsPreference{
            let v = i.name ?? ""
            print(v)
            if v == "contact_watchlist"{
                if i.status == 0{
                    tableView.isUserInteractionEnabled = false
                    contPrefer.isOn = false
                    enableLabel.text = NSLocalizedString("contact_watchlist_switch_2", comment: "")
                    navigationItem.rightBarButtonItem?.isEnabled = false
                }else{
                    tableView.isUserInteractionEnabled = true
                    contPrefer.isOn = true
                    enableLabel.text = NSLocalizedString("contact_watchlist_switch_1", comment: "")
                    navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
        }
    }
    
    @objc func addAppToBlackList() {
        print("MAIN TOGLE STATUS:- \(isCountBased)")
        if !isCountBased {
            self.saveButton()
        } else if IDsAllArray.count > countLimit {
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
            return
        } else {
            self.saveButton()
        }
    }
    
    //MARK: - Location Dates for server
//    func loadContactWatchList() {
//        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
//        StatusAllArray.removeAll()
//        IDsAllArray.removeAll()
//        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
//        let url = String(format: "\(kContactWatchlist_mesh2)\(Int(child_Id ?? "") ?? -1)")
//        ApiManager.shared().mesh2_commonGetApi(withVC: self, andUrl: url) { json in
//            DispatchQueue.main.async {
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                guard let jsonData = json as? NSDictionary else {
//                    return
//                }
//                print("mesh2 contacts watchlist api response = \(json)")
//                if jsonData["status"] as? Int ?? 0 == 200 {
//                    if let data = jsonData["data"] as? NSDictionary {
//                        if let contacts = data["contacts"] as? NSArray {
//                            self.dataSource = contacts as! [AnyHashable]
//                        }
//                    }
//                    self.watchedCount = 0
//                    for temp in self.dataSource {
//                        guard let temp = temp as? [AnyHashable : Any] else {
//                            continue
//                        }
//                        if (temp["is_watched"] as? NSNumber)?.intValue ?? 0 == 1 {
//                            self.watchedCount += 1
//                        }
//                    }
//                    print(String(format: "self.watchedCount=%ld", Int(self.watchedCount)))
//                    for i in 0..<(self.dataSource.count) {
//                        let dic = self.dataSource[i] as? NSDictionary
//                        if let object = dic?["is_watched"] as? Int {
//                            self.StatusAllArray.append(object)
//                        }
//                        let isWatched = dic?["is_watched"] as? Int ?? 0
//                        let id = dic?["id"] as? Int ?? 0
//                        if isWatched == 1 {
//                            print("i = ", i)
//                            self.IDsAllArray.append(id)
//                        }
//                    }
//                } else {
//                    CommonModel.showAlert("alert_error".localized, msg: jsonData["message"] as? String)
//                }
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    //MARK: -TableView Data Sourse and Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        //return dataSource.count
        return contactsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "contactCell22") as? SwiftContactWatchedListTableViewCell
        var firstChar = ""
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "contactCell22") as? SwiftContactWatchedListTableViewCell
            cell?.accessoryType = .disclosureIndicator
        }
        ///*
        let obj = contactsArr[indexPath.row]
        cell?.name.text = obj.name ?? "not_available".localized
        cell?.mobile.text = obj.phoneMobile ?? "contacts_content_3".localized + ": \("not_available".localized)"
        cell?.email.text = obj.email ?? "contacts_content_2".localized + ": \("not_available".localized)"
        if let name = obj.name {
            let index = name.index(name.startIndex, offsetBy: 0)
            firstChar = String(name[index])
        }
        if firstChar == "" {
            cell?.contactImage.setTitle("U", for: .normal)
        } else if firstChar == "." {
            cell?.contactImage.setTitle("U", for: .normal)
        } else {
            cell?.contactImage.setTitle(firstChar.uppercased(), for: .normal)
        }
        if tableView.isUserInteractionEnabled {
            let contactImgName = String(format: "call_circ_\(Int(indexPath.row) % 4 + 1).png")
            cell?.contactImage.setBackgroundImage(UIImage(named: contactImgName), for: .normal)
            cell?.contactImage.setTitleColor(KCallColor[indexPath.row % 4], for: .normal)
            cell?.contactImage.titleLabel?.adjustsFontSizeToFitWidth = true
        } else {
            let contactImgName = String(format: "dis_call_circ_\(Int(indexPath.row) % 4 + 1).png")
            cell?.contactImage.setBackgroundImage(UIImage(named: contactImgName), for: .normal)
            cell?.contactImage.setTitleColor(KCallDisabledColor[indexPath.row % 4], for: .normal)
            cell?.contactImage.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        cell?.sw11.isOn = obj.isWatched?.boolValue ?? false
        
        //*/
        
        
        
        /*
        let model = dataSource[indexPath.row] as? NSDictionary
        cell?.name.text = model?["name"] as? String
        if cell?.name.text == "" {
            cell?.name.text = "not_available".localized
        } else if cell?.name.text == "." {
            cell?.name.text = "not_available".localized
        }
        
        if ((model?["phone_mobile"] as? NSNull) == NSNull()) || model?["phone_mobile"] == nil {
            cell?.mobile.text = "contacts_content_3".localized + ": \("not_available".localized)"
            if ((model?["phone_home"] as? NSNull) == NSNull()) || model?["phone_home"] == nil {
                cell?.mobile.text = "Home: \("not_available".localized)"
                if ((model?["phone_work"] as? NSNull) == NSNull()) || model?["phone_work"] == nil || model?["phone_work"] == nil {
                    cell?.mobile.text = "Work: \("not_available".localized)"
                } else {
                    if let object = model?["phone_work"] {
                        cell?.mobile.text = "Work:\(object)"
                    }
                }
            } else {
                if let object = model?["phone_home"] {
                    cell?.mobile.text = "Home:\(object)"
                }
            }
        } else {
            if let object = model?["phone_mobile"] {
                cell?.mobile.text = "contacts_content_3".localized + ":\(object)"
            }
        }
        if ((model?["email"] as? NSNull) == NSNull()) || model?["email"] == nil {
            cell?.email.text = "contacts_content_2".localized + ": \("not_available".localized)"
        } else {
            if let object = model?["email"] {
                cell?.email.text = "Email: \(object)"
            }
        }
        if let name = model?["name"] as? String {
            let index = name.index(name.startIndex, offsetBy: 0)
            firstChar = String(name[index])
        }
        if firstChar == "" {
            cell?.contactImage.setTitle("U", for: .normal)
        } else if firstChar == "." {
            cell?.contactImage.setTitle("U", for: .normal)
        } else {
            cell?.contactImage.setTitle(firstChar.uppercased(), for: .normal)
        }
        if tableView.isUserInteractionEnabled {
            let contactImgName = String(format: "call_circ_\(Int(indexPath.row) % 4 + 1).png")
            cell?.contactImage.setBackgroundImage(UIImage(named: contactImgName), for: .normal)
            cell?.contactImage.setTitleColor(KCallColor[indexPath.row % 4], for: .normal)
            cell?.contactImage.titleLabel?.adjustsFontSizeToFitWidth = true
            //            cell?.contactImage.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            //            cell?.add.tag = indexPath.row
            //            cell?.add.setImage(UIImage(named: "delete"), for: .normal)
            //            cell?.add.addTarget(self, action: #selector(deleteContact(_:)), for: .touchUpInside)
        } else {
            let contactImgName = String(format: "dis_call_circ_\(Int(indexPath.row) % 4 + 1).png")
            cell?.contactImage.setBackgroundImage(UIImage(named: contactImgName), for: .normal)
            cell?.contactImage.setTitleColor(KCallDisabledColor[indexPath.row % 4], for: .normal)
            cell?.contactImage.titleLabel?.adjustsFontSizeToFitWidth = true
            //            cell?.contactImage.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            //            cell?.add.setImage(UIImage(named: "delete_0"), for: .normal)
        }
        
            cell?.sw11.isOn = false
            if StatusAllArray[indexPath.row] == 1 {
                cell?.sw11.isOn = true
            }
        */
        cell?.sw11.addTarget(self, action: #selector(switch1(_:)), for: .valueChanged)
        cell?.sw11.tag = indexPath.row
        cell?.sw11.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        return cell ?? UITableViewCell()
    }
    
    //MARK: - TableView End
    @objc func deleteContact(_ sender: UIButton?) {
        //---DEPRICATED---//
        print("delete contact")
        print("delete contact")
    }
    
    @IBAction func updateContPrefer(_ sender: UISwitch) {
        //navigationItem.rightBarButtonItem?.isEnabled = sender.isOn
        UserDefaults.standard.set(false, forKey: "TOGLE_STATE")
        self.control.state = self.contPrefer.isOn.boolToInt()
        tableView.isUserInteractionEnabled = sender.isOn
        tableView.reloadData()
//        var onStatus = 0
//        if sender.isOn {
//            onStatus = 1
//            UserDefaults.standard.set(true, forKey: "TOGLE_STATE")
//        }
//        let params = [
//            "name": "contact_watchlist",
//            "status": onStatus,
//            "value": String(onStatus)
//        ] as [String : Any]
//        print(params)
//        CommonModel.updatePreference(params, view: self, isNotification: false)
    }
    
    //MARK: - Switch Button
    @objc func switch1(_ sender: UISwitch) {
        let index = sender.tag
        contactsArr[index].isWatched = sender.isOn.boolToInt()
        if let alreadyObjInd = restrictedContacts.firstIndex(where: {$0.contactID == contactsArr[index].contactID}) {
            restrictedContacts[alreadyObjInd].isWatched = sender.isOn.boolToInt()
        } else {
            restrictedContacts.append(contactsArr[index])
        }
        /*
        var k = 0
        if sender.isOn {
            k = 1
        } else {
            k = 0
        }
        let SwitchState = String(format: "%i", k)
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            print(String(format: "Row=\(Int(indexPath?.row ?? 0))  Section=\(Int(indexPath?.section ?? 0))"))
            let dict = dataSource[indexPath?.row ?? 0] as? NSDictionary
            if k == 1 {
                if let object = dict?["id"] as? Int {
                    IDsAllArray.append(object)
                }
            }
            if k == 0 {
                for i in 0..<(self.IDsAllArray.count) {
                    print("i = ", i)
                    let removingIndex = IDsAllArray[i]
                    let id = (dict?["id"] as? NSNumber)?.intValue ?? 0
                    if removingIndex == id {
                        self.IDsAllArray.remove(at: i)
                    }
                    let statusSwitch = Int(SwitchState) ?? 0
                    StatusAllArray[indexPath?.row ?? 0] = statusSwitch
                    break
                }
            }
        }
        print("StatusAllArray===\(StatusAllArray)")
        print("IDDSSSAllArray===\(IDsAllArray)")
        */
    }
    
    @objc func saveButton() {
        if control.identifier == nil {
            HLApiManager.getControlApi()
            return
        }
//        let control = DBManager.shared.fetchAppBlockControl(identifier: "contacts_watch")
//        if control.state == self.control.state{
//            self.apiCall()
//            return
//        }
        let controlDB = DBManager.shared.fetchAppBlockControl(identifier: "contacts_watch")
        if controlDB.state != control.state {
            SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".myModification(), animated: true)
            
            if let childId = control.childID,
               let featureId = control.featureID,
               let identifier = control.identifier {
                
                HLApiManager.putControlApi(childId: childId, featureId: featureId, state: contPrefer.isOn.boolToInt(), identifier: identifier) {err in
                    if err != nil {
                        SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                        CommonModel.showAlert("alert_error".localized, msg: err ?? "Nothing")
                        return
                    }
                    DBManager.shared.fetchControlAndUpdate(identifier: self.control.identifier ?? "", state: self.contPrefer.isOn.boolToInt())
                    self.apiCall()
                }
            } else {
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong_again")
                print("❌ Missing required params (childId / featureId / identifier)")
            }
        } else {
            self.apiCall()
        }
    }
    
    func apiCall() {
        if restrictedContacts.count == 0 {
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            return
        }
        SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".myModification(), animated: true)
        let url = HLConstants.BASE_URL_CORE_2 + "controls/contact-watchlist"
        var ids = [[String:Any]]()
        restrictedContacts.forEach { obj in
            let objParam = ["id": obj.id,
                            "child_id": obj.childID ?? 0,
                            "status":obj.isWatched ?? 0]
            ids.append(objParam as [String : Any])
        }
        let params = ["data": ids]
        CoreManager.networkRequest(url: url, method: .patch, params: params) { (response: EmptyResponseModel?, statusCode, errorMessages) in
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            if statusCode == 204 {
                self.restrictedContacts.forEach { obj in
                    DBManager.shared.fetchContactAndUpdate(identifier: obj.id ?? 0, state: obj.isWatched ?? 0)
                }
                self.restrictedContacts.removeAll()
                CommonModel.showAlert("settings_card_2_android_8".localized, msg: "contact_watchlist_alert_content_1".localized)
            } else {
                CommonModel.showAlert("alert_error".localized, msg: errorMessages)
            }
        }
    }
    
//    func apiCall() {
//        SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".myModification(), animated: true)
//        let url = String(format: "\(kContactWatchlist_mesh2)\(Int(child_Id ?? "") ?? -1)")
//        print("ARR:- \(IDsAllArray.count)")
//        let params = [
//            "is_active": contPrefer.isOn ? "1" : "0",
//            "ids": IDsAllArray
//        ] as [String : Any]
//        print("url = \(url) and params = \(params)")
//        ApiManager.shared().putApi(url, params: params, controller: self, isContPresented: false) { message, code in
//            DispatchQueue.main.async {
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                if code == 200 {
//                    self.viewWillAppear(true)
//                    self.view.setNeedsLayout()
//                    CommonModel.showAlert("settings_card_2_android_8".localized, msg: "contact_watchlist_alert_content_1".localized)
//                } else {
//                    CommonModel.showAlert("alert_error".localized, msg: kErrorGeneral)
//                }
//            }
//        }
//    }
}
