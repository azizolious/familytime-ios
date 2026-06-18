//
//  ContentFilterDetailsVC.swift
//  FamilyTime
//
//  Created by Hammad Lodhi on 09/04/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//

import UIKit

protocol ContentFilterDetailsDelegate: AnyObject {
    func didSelectContentFilter(value: String, forKey key: String)
}

class ContentFilterDetailsVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    weak var delegate: ContentFilterDetailsDelegate?
    var detailsType: ContentFiltersType!
    var list = [String]()
    var selectedItemIndexList = [Int]()
    var childID : String!
    var selectedValue: String?
    var selectedKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let footer = UIView(frame: .zero)
        tblView.tableFooterView = footer
        
        childID = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
        self.loadData()
        
        switch (self.detailsType) {
        case .Movies:
            self.title = "films".localized;
            break
        case .TVShows:
            self.title = "contentfiltertv_title".localized;
            break
        case .Apps:
            self.title = "settings_card_1_android_5".localized;
            break
        default: break;
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didSelectContentFilter(value: selectedValue ?? "" , forKey: selectedKey ?? "")
    }
    
    func loadData() {
        switch detailsType {
        case .Apps:
            list = ["false","4+", "9+", "12+", "17+","true"]
            if let selectedApps = UserDefaults.standard.string(forKey: "selectedApps") {
                selectPreviouslyChosenOption(selectedApps)
            } else {
                selectPreviouslyChosenOption(forKey: "apps")
            }
        case .TVShows:
            list = ["false","TV-Y", "TV-Y7", "TV-G", "TV-PG", "TV-14", "TV-MA","true"]
            if let selectedTVShows = UserDefaults.standard.string(forKey: "selectedTVShows") {
                selectPreviouslyChosenOption(selectedTVShows)
            } else {
                selectPreviouslyChosenOption(forKey: "tvshows")
            }
        case .Movies:
            list = ["false","G", "PG", "PG-13", "R", "NC-17","true"]
            if let selectedMovies = UserDefaults.standard.string(forKey: "selectedMovies") {
                selectPreviouslyChosenOption(selectedMovies)
            } else {
                selectPreviouslyChosenOption(forKey: "movies")
            }
        default:
            break
        }
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
    
    func selectPreviouslyChosenOption(_ selectedValue: String) {
        guard let selectedIndex = list.firstIndex(where: { $0.lowercased() == selectedValue.lowercased() }) else {
            print("Selected value not found in the list.")
            return
        }
        selectedItemIndexList.removeAll()
        handleSelection(at: selectedIndex, allowSave: false)
    }
    
    func selectPreviouslyChosenOption(forKey key: String) {
        guard let childIDString = childID, let childID = Int(childIDString) else {
            print("Invalid childID")
            return
        }
        // Safely unwrap contentFilters
        guard let contentFilters = DBManager.shared.fetchContentFiltersFromCoreData(forChildID: childID) else {
            print("No content filters found.")
            return
        }
        
        for contentFilter in contentFilters {
            // Check if the key exists in the content filter entity
            switch key {
            case "explicitContent":
                if let explicitContent = contentFilter.explicitContent {
                    let selectedValueString = explicitContent.lowercased()
                    if let selectedIndex = list.firstIndex(where: { $0.lowercased() == selectedValueString }) {
                        selectedItemIndexList.removeAll()
                        handleSelection(at: selectedIndex, allowSave: false)
                    }
                }
            case "bookstoreErotica":
                if let bookStoreErotica = contentFilter.bookstoreErotica {
                    let selectedValueString = bookStoreErotica.lowercased()
                    if let selectedIndex = list.firstIndex(where: { $0.lowercased() == selectedValueString }) {
                        selectedItemIndexList.removeAll()
                        handleSelection(at: selectedIndex, allowSave: false)
                    }
                }
            case "apps":
                if let apps = contentFilter.apps {
                    let selectedValueString = apps.lowercased()
                    if let selectedIndex = list.firstIndex(where: { $0.lowercased() == selectedValueString }) {
                        selectedItemIndexList.removeAll()
                        handleSelection(at: selectedIndex, allowSave: false)
                    }
                }
            case "movies":
                if let movies = contentFilter.movies {
                    let selectedValueString = movies.lowercased()
                    if let selectedIndex = list.firstIndex(where: { $0.lowercased() == selectedValueString }) {
                        selectedItemIndexList.removeAll()
                        handleSelection(at: selectedIndex, allowSave: false)
                    }
                }
            case "tvshows":
                if let tvshows = contentFilter.tvshows {
                    let selectedValueString = tvshows.lowercased()
                    if let selectedIndex = list.firstIndex(where: { $0.lowercased() == selectedValueString }) {
                        selectedItemIndexList.removeAll()
                        handleSelection(at: selectedIndex, allowSave: false)
                    }
                }
            default:
                break
            }
        }
    }
    
    //    func selectPreviouslyChosenOption(forKey key: String) {
    //        guard let childIDString = childID, let childID = Int(childIDString) else {
    //            print("Invalid childID")
    //            return
    //        }
    //        let contentFilters = DBManager.shared.getContentFilters(byChildID: childID)
    //        for filter in contentFilters {
    //            if let value = filter.mdmPayload?[key] as? Bool {
    //                // Convert the Bool value to a String for comparison with items in the list
    //                let selectedValueString = String(value)
    //                print(selectedValueString)
    //                if let selectedIndex = list.firstIndex(where: { $0.lowercased() == selectedValueString.lowercased() }) {
    //                    selectedItemIndexList.removeAll()
    //                    handleSelection(at: selectedIndex, allowSave: false)
    //                }
    //                return
    //            }
    //        }
    //    }
    
    //    @IBAction func saveBtnTpd() {
    //
    //        guard childID != nil else {
    //            return
    //        }
    //
    //        guard !self.selectedItemIndexList.isEmpty else {
    //            return
    //        }
    //
    //        let value = self.list[self.selectedItemIndexList.first!]
    //        var key = ""
    //        switch detailsType {
    //        case .Apps:
    //            key = ContentFiltersType.Apps.rawValue.lowercased()
    //            break
    //        case .TVShows:
    //            key = ContentFiltersType.TVShows.rawValue.lowercased()
    //            break
    //        case .Movies:
    //            key = ContentFiltersType.Movies.rawValue.lowercased()
    //            break
    //        default:
    //            break
    //        }
    //
    //        HLApiManager.updateChildContentFilter(childID: self.childID!, key: key, value: value, view: self.view) { (success, message) in
    //
    //            if success {
    //                self.loadData()
    //                DispatchQueue.main.async {
    //                    self.btnSave.isEnabled = false
    //                    self.btnSave.alpha = 0.5
    //                    CommonModel.showAlert("".localized, msg: "child_profile_alert_content".localized)
    //                }
    //            } else {
    //                CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
    //            }
    //
    //        }
    //
    //    }
}

extension ContentFilterDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let conView = UIView(frame: CGRect.init(x: 0, y: 0, width: Device.width, height: 60))
        conView.backgroundColor = UIColor.groupTableViewBackground
        
        let label = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: Device.width - 25, height: 50))
        label.backgroundColor = UIColor.groupTableViewBackground
        label.textColor = UIColor.gray
        label.font = UIFont(name: "OpenSans", size: 17)
        label.adjustsFontSizeToFitWidth = true
        switch (self.detailsType) {
        case .Movies:   label.text = "content_filters_content_3".localized;           break
        case .TVShows:  label.text = "contentfilter_tv_allow".localized;   break
        case .Apps:     label.text = "content_filters_content_6".localized;            break
        default: break;
        }
        conView.addSubview(label)
        return conView;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentfilterdetails")!
        
        if list[indexPath.row] == "false" {
            switch (self.detailsType) {
            case .Movies:  cell.textLabel?.text = "content_filters_content_4".localized;          break
            case .TVShows: cell.textLabel?.text = "contentfilter_tv_dontallow".localized;  break
            case .Apps:    cell.textLabel?.text = "Don't Allow Apps";           break
            default:        break;
            }
        }
        else if list[indexPath.row] == "true" {
            switch (self.detailsType) {
            case .Movies:  cell.textLabel?.text = "content_filters_content_5".localized;          break
            case .TVShows: cell.textLabel?.text = "contentfilter_tv_allowall".localized;  break
            case .Apps:    cell.textLabel?.text = "content_filters_content_2".localized;           break
            default:        break;
            }
        }
        else
        {
            cell.textLabel?.text = self.list[indexPath.row]
        }
        
        if (Device.pad) {
            cell.textLabel?.font = UIFont.appFont(type: .Regular, size: 20.0)
        }
        else {
            cell.textLabel?.font = UIFont.appFont(type: .Regular, size: 17.0)
        }
        
        cell.textLabel?.textColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, a: 1.0)
        
        if self.selectedItemIndexList.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.handleSelection(at: indexPath.row)
    }
    
    func handleSelection(at indexN:Int, allowSave: Bool = true) {
        var index = indexN
        var start = 0
        if self.list[0] == "false" {
            start = 1
            index = indexN + 1
        }
        if self.selectedItemIndexList.isEmpty || self.selectedItemIndexList[0] != (index-start) {
            self.selectedItemIndexList.removeAll()
            for i in start ... index {
                print("Selected: \(index-i)")
                if (start != 1 || index-i != 0) || indexN == 0 {
                    self.selectedItemIndexList.append(index-i)
                }
            }
        }
        else if start != 1 {
        }
        DispatchQueue.main.async {
            self.tblView.reloadData()
            if allowSave {
                if self.selectedItemIndexList.isEmpty {
                    
                    if self.selectedItemIndexList.isEmpty {
                        // Save empty selection to UserDefaults based on the current case
                        switch self.detailsType {
                        case .Apps:
                            UserDefaults.standard.removeObject(forKey: "selectedApps")
                        case .TVShows:
                            UserDefaults.standard.removeObject(forKey: "selectedTVShows")
                        case .Movies:
                            UserDefaults.standard.removeObject(forKey: "selectedMovies")
                        default:
                            break
                        }
                    }
                    //                    self.btnSave.isEnabled = false
                    //                    self.btnSave.alpha = 0.5
                }
                else {
                    // Save selected value to UserDefaults based on the current case
                    let selectedValue = self.list[self.selectedItemIndexList.first!]
                    switch self.detailsType {
                    case .Apps:
                        UserDefaults.standard.set(selectedValue, forKey: "selectedApps")
                    case .TVShows:
                        UserDefaults.standard.set(selectedValue, forKey: "selectedTVShows")
                    case .Movies:
                        UserDefaults.standard.set(selectedValue, forKey: "selectedMovies")
                    default:
                        break
                    }
                }
            }
        }
        guard !self.selectedItemIndexList.isEmpty else {
            return
        }
        
        let selectedValue = self.list[self.selectedItemIndexList.first!]
        self.selectedValue = selectedValue
        switch detailsType {
        case .Apps:
            selectedKey = ContentFiltersType.Apps.rawValue.lowercased()
            break
        case .TVShows:
            selectedKey = ContentFiltersType.TVShows.rawValue.lowercased()
            break
        case .Movies:
            selectedKey = ContentFiltersType.Movies.rawValue.lowercased()
            break
        default:
            break
        }
    }
}
