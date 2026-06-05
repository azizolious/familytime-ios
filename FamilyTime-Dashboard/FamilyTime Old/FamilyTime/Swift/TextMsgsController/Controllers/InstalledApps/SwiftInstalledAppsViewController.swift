//
//  InstalledAppsViewController.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 13/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD

class SwiftInstalledAppsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var imgView = UIImageView()
    var contentLbl = UILabel()
    var oopsLbl = UILabel()
    var stringts: String?
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource=[BlistAppModel]()
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    
    var delegate: AppDelegate?
    var refreshCont = UIRefreshControl()
    
    private var dictionary = [String : Any]()
    private var blockedCount = 0
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    
    //MARK: - VIEWS LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        dictionary = [String : Any]()
        delegate = AppDelegate.getSharedAppDelegateForSwift()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "PlacesCell", bundle: nil), forCellReuseIdentifier: "PlacesCell")
        if SwiftFTUtils.isDeviceiPhoneFamily() {
            tableView.rowHeight = 70
        } else {
            tableView.rowHeight = 100
        }
        tableView.separatorStyle = .none
        navigationItem.title = "installed_apps_title".localized
//        callAppApi()
//        loadAppList()
        loadDataFromDB()
        addPullDownRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        if ((self.navigationController?.viewControllers.contains(self)) != nil) {
            self.navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
        
    }
    
    // MARK: pull down refresh
    func addPullDownRefresh() {
        refreshCont = UIRefreshControl()
        tableView.addSubview(refreshCont)
//        refreshCont.addTarget(self, action: #selector(loadAppList), for: .valueChanged)
        refreshCont.addTarget(self, action: #selector(loadDataFromDB), for: .valueChanged)

    }
    
    func refreshTable() {
        refreshCont.endRefreshing()
        tableView.reloadData()
        MBProgressHUD.hideAllHUDs(for: view, animated: true)
    }
    @objc func loadDataFromDB() {
        let fetchData = DBManager.shared.fetchDataAndConvertToModels()
        // Convert fetched data to BlistAppModel
        let convertedData = fetchData.map { installedApp -> BlistAppModel in
            let blistAppModel = BlistAppModel()
            blistAppModel.child_id = "\(installedApp.childID ?? 0)"
            blistAppModel.app_name = installedApp.appName
            // Map other attributes as needed
            blistAppModel.app_category = installedApp.appCategory
            blistAppModel.app_package_name = installedApp.appPackageName
            blistAppModel.date_created = installedApp.dateCreated
            blistAppModel.date_modified = installedApp.dateModified
            blistAppModel.deleted = Int32(installedApp.deleted ?? 0)
            blistAppModel.installedapp_id = "\(installedApp.installedappID ?? 0)"
            blistAppModel.is_blacklisted = Int32(installedApp.isBlacklisted ?? 0)
            blistAppModel.size = Float(installedApp.size ?? 0)
            return blistAppModel
        }
        self.dataSource = convertedData
        
        // Handle data manipulation and UI updates
        for item in dataSource {
            if !["app", "system", "important"].contains(item.app_category.lowercased()) {
                item.app_category = "app"
            }
        }
        
        // Sort and update UI
        sortWithCategories()
        if dataSource.isEmpty {
            view.backgroundColor = UIColor.white
            contactImage.isHidden = false
            lblText.isHidden = false
            tableView.isHidden = true
            onthebook()
        } else {
            contactImage.isHidden = true
            lblText.isHidden = true
            tableView.isHidden = false
            tableView.delegate = self
            tableView.dataSource = self
            refreshTable()
        }
    }


//    func callAppApi() {
//        DispatchQueue.main.async {
//            self.loadAppList()
//        }
//    }
    
    // MARK: Location dates from server
//    @objc func loadAppList() {
//        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
//        
//        //---NATIVE API CALLING---//
//        let paramStr = String(format: "%ld", Int(child_Id ?? "") ?? 0)
//        let url = KInstalledApps+paramStr
//        print(url)
//        ApiManager.shared().mesh_getApi(withApi: url, withResponse: { [self] json, errorCode, message in
//            
//            DispatchQueue.main.async(execute: { [self] in
//                let msg = (json["message"] == nil ? kErrorGeneral.myModification() : json["message"]) as? String
//                if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
//                    var model: AllBlistAppsModel? = nil
//                    do {
//                        model = try AllBlistAppsModel(dictionary: json)
//                    } catch {
//                        
//                    }
//                    if let installedAppList = model?.installedAppList as? [BlistAppModel]{
//                        dataSource = installedAppList
//                    }
//                    for items in dataSource {
//                        
//                        if (items.app_category.lowercased() != "app") && (items.app_category.lowercased() != "system") && (items.app_category.lowercased() != "important") {
//                            print("\(String(describing: items.app_category))")
//                            items.app_category = "app"
//                        }
//                    }
//                    print(dataSource)
//                    sortWithCategories()
//                    if dataSource.count == 0 {
//                        view.backgroundColor = UIColor.white
//                        
//                        contactImage.isHidden = false
//                        lblText.isHidden = false
//                        tableView.isHidden = true
//                        onthebook()
//                        MBProgressHUD.hideAllHUDs(for: view, animated: true)
//                    }else{
//                        contactImage.isHidden = true
//                        lblText.isHidden = true
//                        tableView.isHidden = false
//                        tableView.delegate = self
//                        tableView.dataSource = self
//                        refreshTable()
//                    }
//                }else{
//                    CommonModel.showAlert("alert_error".myModification(), msg: msg)
//                    view.backgroundColor = UIColor.white
//                    contactImage.removeFromSuperview()
//                    lblText.removeFromSuperview()
//                    tableView.isHidden = true
//                    onthebook()
//                }
//            })
//        })
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        contactImage.isHidden = true
        lblText.isHidden = true
        if UI_USER_INTERFACE_IDIOM() == .pad {
            imgView.isHidden = true
            contentLbl.isHidden = true
            oopsLbl.isHidden = true
            view.backgroundColor = UIColorFromRGB(0xefeff4)
        }
        if UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 667 {
            imgView.isHidden = true
            contentLbl.isHidden = true
            oopsLbl.isHidden = true
            view.backgroundColor = UIColorFromRGB(0xefeff4)
        }else if UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 736 {
            imgView.isHidden = true
            contentLbl.isHidden = true
            oopsLbl.isHidden = true
            view.backgroundColor = UIColorFromRGB(0xefeff4)
        }
    }
    
    func sortWithCategories() {
        blockedCount = 0
        dictionary = [String : [BlistAppModel]]()
        for model in dataSource {
            var array = dictionary[model.app_category.lowercased()] as? [BlistAppModel]
            if array == nil {
                array = []
                array?.append(model)
            } else {
                array?.append(model)
            }
            dictionary[model.app_category.lowercased()]=array
            if model.is_blacklisted == 1 {
                blockedCount += 1
            }
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return (dictionary["system"] as? [BlistAppModel])?.count ?? 0
            
        } else if section == 1 {
            
            return (dictionary["important"] as? [BlistAppModel])?.count ?? 0
            
        } else if section == 2 {
            
            return (dictionary["app"] as? [BlistAppModel])?.count ?? 0
        }
        return (dictionary["app"] as? [BlistAppModel])?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            if (dictionary["system"] as? [BlistAppModel])?.count ?? 0 > 0 {
                if SwiftFTUtils.isDeviceiPhoneFamily() {
                    return 35.0
                } else {
                    return 80.0
                }
            } else {
                return 0.0
            }
        }else if section == 1 {
            if (dictionary["important"] as? [BlistAppModel])?.count ?? 0 > 0 {
                if SwiftFTUtils.isDeviceiPhoneFamily() {
                    return 35.0
                } else {
                    return 80.0
                }
            } else {
                return 0.0
            }
        }else if section == 2 {
            if (dictionary["app"] as? [BlistAppModel])?.count ?? 0 > 0 {
                if SwiftFTUtils.isDeviceiPhoneFamily() {
                    return 35.0
                } else {
                    return 80.0
                }
            } else {
                return 0.0
            }
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: (SwiftFTUtils.isDeviceiPhoneFamily()) ? 35.0 : 80.0))
        label.backgroundColor = RGBCOLOR(235.0, 235.0, 241.0, 1.0)
        if SwiftFTUtils.isDeviceiPhoneFamily() {
            label.font = UIFont(name: "OpenSans", size: 15)
        }else{
            label.font = UIFont(name: "OpenSans", size: 15)
        }
        label.textColor = RGBCOLOR(96.0, 96.0, 96.0, 1.0)
        if section == 0 {
            label.text = "   \("installed_apps_content_1".localized)"
        } else if section == 1 {
            label.text = "   \("installed_apps_content_3".localized)"
        } else if section == 2 {
            label.text = "   \("installed_apps_content_2".localized)"
        } else {
            label.text = "   \("installed_apps_content_2".localized)"
        }
        return label
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Determine the key based on section
        var key: String
        switch indexPath.section {
        case 0:
            key = "system"
        case 1:
            key = "important"
        case 2:
            key = "app"
        default:
            key = "app"
        }
        
        // Dequeue the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesCell", for: indexPath) as! SwiftPlacesCell
        
        // Safely unwrap and convert child_Id to Int
        if let child_Id = child_Id, let childIdInt = Int(child_Id) {
            let chilInfo_Object = DBManager.shared.fetchChild(byID: childIdInt)
            
            // Fetch the model
            let model = (dictionary[key] as? [BlistAppModel])?[indexPath.row]
            cell.place.text = model?.app_name
            
            // Calculate and set file size
            let fileSize: Float = ((model?.size ?? 0) / 1024) / 1000
            if fileSize == 0.0 {
                cell.address.text = String(format: "%.2f KB", (fileSize / 1024) / 100)
            } else {
                cell.address.text = String(format: "%.2f MB", fileSize)
            }
            
            // Set text alignment based on semantic content attribute
            if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                cell.address.textAlignment = .right
            } else {
                cell.address.textAlignment = .left
            }
            
            // Set editPlace tag and image based on blacklist status
            cell.editPlace.tag = indexPath.row
            if let is_blacklisted = model?.is_blacklisted {
                print("\(is_blacklisted)")
            }
            
            if model?.is_blacklisted != 0 {
                cell.editPlace.setImage(UIImage(named: "lock"), for: .normal)
            } else {
                cell.editPlace.setImage(UIImage(named: "unlock"), for: .normal)
            }
            
            // Set the place image
            let imgName = String(format: "iappsFilled_%i.png", Int(indexPath.row) % 4 + 1)
            cell.placeImg.image = UIImage(named: imgName)
            
            // Show or hide editPlace based on device type
            if chilInfo_Object?.device == "iphone" {
                cell.editPlace.isHidden = true
            } else {
                cell.editPlace.isHidden = false
            }
            
            // Temporarily hide editPlace
            cell.editPlace.isHidden = true
            
            // Set font if device is iPhone
            if SwiftFTUtils.isDeviceiPhoneFamily() {
                cell.place.font = UIFont(name: "OpenSans", size: 17)
            }
        } else {
            // Hide the cell if child_Id is not available or not convertible to Int
            cell.isHidden = true
        }
        
        return cell
    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        var key: String?
//        if indexPath.section == 0 {
//            key = "system"
//        } else if indexPath.section == 1 {
//            key = "important"
//        } else if indexPath.section == 2 {
//            key = "app"
//        } else {
//            key = "app"
//        }
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesCell", for: indexPath) as! SwiftPlacesCell
//        let chilInfo_Object = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id ?? "")
//        let model = (dictionary[key ?? "app"] as? [BlistAppModel])?[indexPath.row]
//        cell.place.text = model?.app_name
//        let fileSize: Float = ((model?.size ?? 0) / 1024) / 1000
//        if fileSize == 0.0 {
//            cell.address.text = String(format: "%.2f KB", (fileSize / 1024) / 100)
//        } else {
//            cell.address.text = String(format: "%.2f MB", fileSize)
//        }
//        
//        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
//            
//            cell.address.textAlignment = .right
//            
//        } else {
//            
//            cell.address.textAlignment = .left
//            
//        }
//        
//        cell.editPlace.tag = indexPath.row
//        if let is_blacklisted = model?.is_blacklisted {
//            print("\(is_blacklisted)")
//        }
//        
//        if (model?.is_blacklisted != 0){
//            cell.editPlace.setImage(UIImage(named: "lock"), for: .normal)
//        } else {
//            cell.editPlace.setImage(UIImage(named: "unlock"), for: .normal)
//        }
//        let imgName = String(format: "iappsFilled_%i.png", Int(indexPath.row) % 4 + 1)
//        cell.placeImg.image = UIImage(named: imgName)
//        
//        if chilInfo_Object.device == "iphone" {
//            cell.editPlace.isHidden = true
//        } else {
//            cell.editPlace.isHidden = false
//        }
//        
//        cell.editPlace.isHidden = true
//        //  [self viewDidDisappear:YES];
//        
//        if SwiftFTUtils.isDeviceiPhoneFamily() {
//            cell.place.font = UIFont(name: "OpenSans", size: 17)
//        }
//        return cell
//    }
    
    func onthebook() {
        refreshCont.endRefreshing()
        MBProgressHUD.hideAllHUDs(for: view, animated: true)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            imgView = UIImageView(frame: CGRect(x: 236, y: 229, width: 296, height: 212))
            imgView.contentMode = .scaleAspectFill
            imgView.image = UIImage(named: "ipad_empty")
            imgView.isHidden = false
            view.addSubview(imgView)
            view.bringSubviewToFront(imgView)
            
            oopsLbl = UILabel(frame: CGRect(x: view.bounds.size.width / 2 - 40, y: 461, width: 70, height: 30))
            oopsLbl.text = "oops_title".localized
            oopsLbl.font = UIFont.boldSystemFont(ofSize: 20)
            oopsLbl.isHidden = false
            view.addSubview(oopsLbl)
            view.bringSubviewToFront(oopsLbl)
            
            contentLbl = UILabel(frame: CGRect(x: 203, y: 511, width: 362, height: 45))
            contentLbl.lineBreakMode = .byWordWrapping
            contentLbl.textColor = UIColor.lightGray
            contentLbl.text = "empty_record".localized
            contentLbl.font = UIFont.systemFont(ofSize: 16)
            contentLbl.lineBreakMode = .byWordWrapping
            contentLbl.numberOfLines = 2
            contentLbl.textAlignment = .center
            contentLbl.isHidden = false
            view.addSubview(contentLbl)
            view.bringSubviewToFront(contentLbl)
            
        }else if UIDevice.current.userInterfaceIdiom == .phone {
            
            imgView = UIImageView(frame: CGRect(x: 115, y: 152, width: 145, height: 104))
            imgView.contentMode = .scaleAspectFill
            imgView.image = UIImage(named: "ic_empty")
            imgView.isHidden = false
            view.addSubview(imgView)
            view.bringSubviewToFront(imgView)
            
            oopsLbl = UILabel(frame: CGRect(x: view.bounds.size.width / 2 - 20, y: 266, width: 70, height: 30))
            oopsLbl.text = "oops_title".localized
            oopsLbl.font = UIFont.boldSystemFont(ofSize: 18)
            oopsLbl.isHidden = false
            view.addSubview(oopsLbl)
            view.bringSubviewToFront(oopsLbl)
            
            contentLbl = UILabel(frame: CGRect(x: 6, y: 301, width: 362, height: 45))
            contentLbl.lineBreakMode = .byWordWrapping
            contentLbl.textColor = UIColor.lightGray
            contentLbl.text = "empty_record".localized
            contentLbl.font = UIFont.systemFont(ofSize: 16)
            contentLbl.lineBreakMode = .byWordWrapping
            contentLbl.numberOfLines = 2
            contentLbl.textAlignment = .center
            contentLbl.isHidden = false
            view.addSubview(contentLbl)
            view.bringSubviewToFront(contentLbl)
            
        }
    }
    
}
