//
//  ContentFiltersVC.swift
//  FamilyTime
//
//  Created by Hammad Lodhi on 06/04/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//

import UIKit

enum ContentFiltersType: String {
    case Apps
    case Movies
    case TVShows
    case ExplicitContent
    case BookStoreErotica
}

@objc class ContentFiltersVC: UIViewController, ContentFilterDetailsDelegate {
    func didSelectContentFilter(value: String, forKey key: String) {
        print(value)
        print(key)
        selectedFilters[key] = value
        btnSave.isEnabled = true
        btnSave.alpha = 1.0
    }
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    
    var explicitContentiTunes = false
    var bookStoreErotica = false
    var itunesLoaded = false
    var iBooksLoaded = false
    var options = [String]()
    var images = [String]()
    
    var childID: String?
    var id : Int = 0
    var saveExplicitContent = false
    var saveBookStoreErotica = false
    var selectedFilters: [String: String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.removeObject(forKey: "selectedApps")
        UserDefaults.standard.removeObject(forKey: "selectedTVShows")
        UserDefaults.standard.removeObject(forKey: "selectedMovies")
        
        self.childID = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
        
        self.title = "ssettings_card_2_ios_3".localized
        
        self.options = ["films".localized, "contentfiltertv_title".localized, "settings_card_1_android_5".localized]
        self.images = ["ic_films2", "ic_tv2", "ic_apps2"];
        
        //        self.loadExplicitContentiTunes()
        //        self.loadBookStoreErotica()
        loadContentFiltersFromDB()
        
        tblView.separatorStyle = .none
        tblView.delegate = self
        tblView.dataSource = self
        
        self.btnSave.isEnabled = false
        self.btnSave.alpha = 0.5
        
        self.btnSave.setTitle(NSLocalizedString("save_button", comment: ""), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //This line is use beacause UI going under navigationbar
        edgesForExtendedLayout = []
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func saveBtnTpd() {
        
        guard let childID = self.childID, let childIDInt = Int(childID) else {
            return
        }
        
        let payloadDict: [String: Any] = [
            "apps": selectedFilters["apps"] ?? "",
            "movies": selectedFilters["movies"] ?? "",
            "tvshows": selectedFilters["tvshows"] ?? "",
            "explicitContent": !explicitContentiTunes,
            "bookstoreErotica": !bookStoreErotica
        ]
        
        // Update Core Data with the updated data
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payloadDict, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("Failed to serialize JSON")
            return
        }
        
        let id = self.id
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
        HLApiManager.putContentFilters(id: id, childId: childIDInt, mdmPayload: jsonString) { error in
            if let error = error {
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                print("Error: \(error)")
                CommonModel.showAlert("alert_error".localized, msg: error )
            } else {
                DBManager.shared.updateContentFiltersModel(childID: childIDInt, updatedData: payloadDict)
                
                //                HLApiManager.getContentFiltersApi()
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                print("Content filters updated successfully.")
                DispatchQueue.main.async {
                    self.btnSave.isEnabled = false
                    self.btnSave.alpha = 0.5
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        //        if saveExplicitContent {
        //            self.saveExplicitContentSettings()
        //            saveExplicitContent = false
        //        }
        //        if saveBookStoreErotica {
        //            self.saveBookStoreEroticaSettings()
        //            saveBookStoreErotica = false
        //        }
        
        self.btnSave.isEnabled = false
        self.btnSave.alpha = 0.5
        
    }
    func loadContentFiltersFromDB() {
        guard let childID = Int(self.childID ?? "") else {
            print("Invalid childID")
            return
        }
        
        if let contentFilters = DBManager.shared.fetchContentFiltersFromCoreData(forChildID: childID) {
            for contentFilter in contentFilters {
                // Access attributes of each content filter entity as needed
                //                print("ID: \(contentFilter.id), Child ID: \(contentFilter.childID)")
                //                print("Movies: \(contentFilter.movies), TV Shows: \(contentFilter.tvshows)")
                //                print("Apps: \(contentFilter.apps), Bookstore Erotica: \(contentFilter.bookstoreErotica)")
                //                print("Explicit Content: \(contentFilter.explicitContent)")
                
                
                self.id = Int(contentFilter.id )
                if let explicitContent = contentFilter.explicitContent {
                    self.explicitContentiTunes = !(explicitContent.lowercased() == "true")
                    selectedFilters[ContentFiltersType.ExplicitContent.rawValue.lowercased()] = explicitContent
                    
                }
                if let bookStoreErotica = contentFilter.bookstoreErotica {
                    self.bookStoreErotica = !(bookStoreErotica.lowercased() == "true")
                    selectedFilters[ContentFiltersType.BookStoreErotica.rawValue.lowercased()] = bookStoreErotica
                }
                if let apps = contentFilter.apps {
                    
                    selectedFilters[ContentFiltersType.Apps.rawValue.lowercased()] = apps
                }
                
                if let movies = contentFilter.movies {
                    
                    selectedFilters[ContentFiltersType.Movies.rawValue.lowercased()] = movies
                }
                if let tvshows = contentFilter.tvshows {
                    
                    selectedFilters[ContentFiltersType.TVShows.rawValue.lowercased()] = tvshows
                }
            }
        }
        
        //        for filter in contentFilters {
        //            self.id = filter.id ?? 0
        //            if let mdmPayload = filter.mdmPayload {
        //                if let explicitContent = mdmPayload["explicitContent"] {
        //                    self.explicitContentiTunes = !explicitContent
        //                    selectedFilters[ContentFiltersType.ExplicitContent.rawValue.lowercased()] = "\(explicitContent)"
        //                }
        //                if let bookStoreErotica = mdmPayload["bookstoreErotica"] {
        //                    self.bookStoreErotica = !bookStoreErotica
        //                    selectedFilters[ContentFiltersType.BookStoreErotica.rawValue.lowercased()] = "\(bookStoreErotica)"
        //                }
        //                if let apps = mdmPayload["apps"] {
        //                    // Convert the boolean value to a string representation
        //                    let appsString = apps ? "true" : "false"
        //                    selectedFilters[ContentFiltersType.Apps.rawValue.lowercased()] = appsString
        //                }
        //
        //                if let movies = mdmPayload["movies"] {
        //                    let movieString = movies ? "true" : "false"
        //                    selectedFilters[ContentFiltersType.Movies.rawValue.lowercased()] = movieString
        //                }
        //                if let tvshows = mdmPayload["tvshows"] {
        //                    let tvShowsString = tvshows ? "true" : "false"
        //                    selectedFilters[ContentFiltersType.TVShows.rawValue.lowercased()] = tvShowsString
        //                }
        //            }
        //        }
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
    
    
    //  MARK:- ExplicitContentiTunes Values
    //    func loadExplicitContentiTunes() {
    //
    //        guard childID != nil else {
    //            return
    //        }
    //
    //        HLApiManager.getExplicitContentiTunesData(childID: childID!, view: self.view) { (response, message) in
    //            guard let value = response else {
    //                CommonModel.showAlert("alert_error".localized, msg: message)
    //                return
    //            }
    //            self.explicitContentiTunes = (value == "true")
    //            DispatchQueue.main.async {
    //                self.tblView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
    //            }
    //        }
    //
    //    }
    
    //    func saveExplicitContentSettings() {
    //
    //        guard childID != nil else {
    //            return
    //        }
    //
    //        let value = self.explicitContentiTunes ? "true" : "false"
    //        let key = ContentFiltersType.ExplicitContent.rawValue.lowercased()
    //
    //        HLApiManager.updateChildContentFilter(childID: self.childID!, key: key, value: value, view: self.view) { (success, message) in
    //
    //            if success {
    //                self.loadExplicitContentiTunes()
    //            } else {
    //                CommonModel.showAlert("alert_error".localized, msg: message)
    //            }
    //
    //        }
    //    }
    
    //  MARK:- BookStoreErotica Values
    //    func loadBookStoreErotica() {
    //
    //        guard childID != nil else {
    //            return
    //        }
    //
    //        HLApiManager.getBookStoreEroticaData(childID: childID!, view: self.view) { (response, message) in
    //            guard let value = response else {
    //                CommonModel.showAlert("alert_error".localized, msg: message)
    //                return
    //            }
    //            self.bookStoreErotica = (value == "true")
    //            DispatchQueue.main.async {
    //                self.tblView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .fade)
    //            }
    //
    //        }
    //
    //    }
    
    //    func saveBookStoreEroticaSettings() {
    //        guard childID != nil else {
    //            return
    //        }
    //
    //        let value = self.bookStoreErotica ? "true" : "false"
    //        let key = ContentFiltersType.BookStoreErotica.rawValue.lowercased()
    //
    //        HLApiManager.updateChildContentFilter(childID: self.childID!, key: key, value: value, view: self.view) { (success, message) in
    //
    //            if success {
    //                self.loadBookStoreErotica()
    //            } else {
    //                CommonModel.showAlert("alert_error".localized, msg: message)
    //            }
    //
    //        }
    //    }
    
    //    func saveBookStoreEroticSettingsLocally() {
    //
    //    }
}

extension ContentFiltersVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        if section == 0 {
            return 15
        }
        return 15
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
//        if section == 0 {
//            let conView = UIView(frame: CGRect.init(x: 0, y: 0, width: Device.width, height: 60))
//            conView.backgroundColor = UIColor.groupTableViewBackground
//            let label = UILabel(frame: CGRect.init(x: 15, y: 0, width: conView.frame.width - 25, height: 60))
//            label.backgroundColor = UIColor.groupTableViewBackground
//            label.textColor = Colors.RGB(138, 138, 138, alpha: 1)
//            label.font = UIFont(name: "OpenSans", size: 16.0)
//            label.text = "content_filters_content_1".localized
//            conView.addSubview(label)
//            return conView
//        }
        let tview = UIView(frame: CGRect(x: 0, y: 0, width: Device.width, height: 15))
        tview.backgroundColor = .clear
        return tview
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "LeftSidesCell") as? SettingTableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "LeftSidesCell") as? SettingTableViewCell
        }
        
        if indexPath.section == 0 {
            cell!.cellLabel.text = self.options[indexPath.row];
            cell!.cellImage.image = UIImage(named:self.images[indexPath.row])
            cell!.cellSwitch.isHidden = true
        }
        else
        {
            cell!.cellLabel.text = (indexPath.row == 0) ? "itunes".localized : "iBooks";
            cell!.cellImage.image = (indexPath.row == 0) ? UIImage(named:"iTunestore") : UIImage(named:"ibook")
            cell!.cellSwitch.isHidden = false
            cell!.selectionStyle = .none
            
            if(indexPath.row == 0)
            {
                cell!.cellSwitch.setOn(self.explicitContentiTunes, animated: false)
            }
            else
            {
                cell!.cellSwitch.setOn(self.bookStoreErotica, animated: false)
            }
            
            cell!.onSwitchChange = { (cellParent) in
                if let cellAffected = cellParent {
                    if(indexPath.section == 1 && indexPath.row == 0)
                    {
                        self.explicitContentiTunes = cellAffected.cellSwitch.isOn
                        self.saveExplicitContent = true
                    }
                    else if(indexPath.section == 1 && indexPath.row == 1)
                    {
                        self.bookStoreErotica = cellAffected.cellSwitch.isOn
                        self.saveBookStoreErotica = true
                    }
                    
                    self.btnSave.isEnabled = true
                    self.btnSave.alpha = 1.0
                }
            }
            
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.section == 0) {
            let vc = HLStoryboard.loadContentFiltersDetailsVC()
            switch indexPath.row {
            case 0: vc.detailsType = .Movies;   break
            case 1: vc.detailsType = .TVShows;  break
            case 2: vc.detailsType = .Apps;     break
            default: break
            }
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

