//
//  ContactsViewController.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 12/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD

class ContactsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
    
    //MARK: - VARIABLES
    var imgView = UIImageView()
    var contentLbl=UILabel()
    var oopsLbl = UILabel()
    var dataSource = [ContactsModel]()
    var contactColors = [UIColor?]()
    
    var delegate = UIApplication.shared.delegate as? AppDelegate
    var refreshControl = UIRefreshControl()
    
    private var nextPageURL: String = ""
    private var baseURL: String = ""
    private var isBaseURL = false
    
    private var package_id : String = ""
    private var package_name : String = ""
    private var device : String = ""
    var ishiddenBar = false
    
    private var watchlistCount = 0
    var colorArray = [UIColor(red: 255, green: 132, blue: 0), UIColor(red: 114, green: 102, blue: 186), UIColor(red: 240, green: 80, blue: 80), UIColor(red: 162, green: 201, blue: 34)]
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var viewNavBar: UIView!
    @IBOutlet weak var navbarHeightConst: NSLayoutConstraint!
    
    //MARK: - VIEWS LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "contacts_title".localized
        
        tableView.register(UINib(nibName: "ContactCells", bundle: nil), forCellReuseIdentifier: "ContactsTableViewCell")
        tableView.rowHeight = 85
        tableView.separatorStyle = .singleLine
        
        dataSource = [ContactsModel]()
        contactColors = KCallColor
        
        nextPageURL = ""
        
        package_id = CoreDataUtility.fetchPackageIdFor(child_id: Int32(child_Id ?? "") ?? -1)
        package_name = CoreDataUtility.fetchPackageNameFor(child_id: Int32(child_Id ?? "") ?? -1)
        device = CoreDataUtility.fetchPackageDeviceFor(child_id: Int32(child_Id ?? "") ?? -1)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            
            imgView = UIImageView(frame: CGRect(x: 236, y: 229, width: 296, height: 212))
            imgView.contentMode = .scaleAspectFill
            imgView.image = UIImage(named: "ipad_empty")
            imgView.isHidden = true
            view.addSubview(imgView)
            view.bringSubviewToFront(imgView)
            
            oopsLbl = UILabel(frame: CGRect(x: view.bounds.size.width / 2 - 40, y: 461, width: 70, height: 30))
            oopsLbl.text = "oops_title".localized
            oopsLbl.font = UIFont.boldSystemFont(ofSize: 20)
            oopsLbl.isHidden = true
            view.addSubview(oopsLbl)
            view.bringSubviewToFront(oopsLbl)
            
            contentLbl = UILabel(frame: CGRect(x: 203, y: 511, width: 362, height: 45))
            contentLbl.lineBreakMode = .byWordWrapping
            contentLbl.textColor = UIColor.lightGray
            contentLbl.text = "contacts_content_1".localized
            contentLbl.font = UIFont.systemFont(ofSize: 16)
            contentLbl.lineBreakMode = .byWordWrapping
            contentLbl.numberOfLines = 2
            contentLbl.textAlignment = .center
            contentLbl.isHidden = true
            view.addSubview(contentLbl)
            view.bringSubviewToFront(contentLbl)
            
        }else if UIDevice.current.userInterfaceIdiom == .phone {
            
            imgView = UIImageView(frame: CGRect(x: 115, y: 152, width: 145, height: 104))
            imgView.contentMode = .scaleAspectFill
            imgView.image = UIImage(named: "ic_empty")
            imgView.isHidden = true
            view.addSubview(imgView)
            view.bringSubviewToFront(imgView)
            
            oopsLbl = UILabel(frame: CGRect(x: view.bounds.size.width / 2 - 20, y: 266, width: 70, height: 30))
            oopsLbl.text = "oops_title".localized
            oopsLbl.font = UIFont.boldSystemFont(ofSize: 18)
            oopsLbl.isHidden = true
            view.addSubview(oopsLbl)
            view.bringSubviewToFront(oopsLbl)
            
            contentLbl = UILabel(frame: CGRect(x: 6, y: 301, width: 362, height: 45))
            contentLbl.lineBreakMode = .byWordWrapping
            contentLbl.textColor = UIColor.lightGray
            contentLbl.text = "contacts_content_1".localized
            contentLbl.font = UIFont.systemFont(ofSize: 16)
            contentLbl.lineBreakMode = .byWordWrapping
            contentLbl.numberOfLines = 2
            contentLbl.textAlignment = .center
            contentLbl.isHidden = true
            view.addSubview(contentLbl)
            view.bringSubviewToFront(contentLbl)
        }
        
//        baseURL = String(format: "%@%ld", kGet_Contacts_mesh2, Int(child_Id ?? "") ?? 0)
        nextPageURL = ""
        isBaseURL = true
        
        lblText.text = "contacts_content_1".localized
//        let packageId = self.package_id
//        if (packageId == "1") {
//            showPremiumAlert()
//        } else {
            //addPullRefresh()
            DispatchQueue.main.async {
                let contacts = DBManager.shared.fetchChildContacts(childId: Int(self.child_Id ?? "0") ?? 0)
                self.convertCodableToClass(contacts: contacts)
                //self.loadContacts()
            }
            showPremiumFeatureView(true)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showPremiumAlert() {
        SwiftFTUtils.showSwiftPremiumPopup(on: self)
    }
    
    func updateUI() {
        if dataSource.count == 0 {
            tableView.isHidden = true
            imgView.isHidden = false
            contentLbl.isHidden = false
            oopsLbl.isHidden = false
            view.backgroundColor = UIColor.white
            
            contactImage.isHidden = true
            lblText.isHidden = true
        }else{
            tableView.isHidden = false
            imgView.isHidden = true
            contentLbl.isHidden = true
            oopsLbl.isHidden = true
            view.backgroundColor = UIColor.white
            
            contactImage.isHidden = false
            lblText.isHidden = false
        }
    }
    
    // MARK: Places
//    func loadContacts() {
//        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
//        
//        //---MESH2 IMPLEMENTATION---//
//        let url = isBaseURL ? baseURL : nextPageURL
//        print("url to load contacts = \(url)")
//        ApiManager.shared().mesh2_commonGetApi(withVC: self, andUrl: url, withResponse: { [self] json in
//            DispatchQueue.main.async(execute: { [self] in
//                MBProgressHUD.hideAllHUDs(for: view, animated: true)
//                
//                print("json response = \(json)")
//                
//                guard let json = json as? [String:Any] else{
//                    return
//                }
//                let msg = (json["message"] == nil ? kErrorGeneral.localized : json["message"]) as? String ?? ""
//                
//                if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
//                    var mainModel: AllContactsModel? = nil
//                    
//                    do {
//                        
//                        mainModel = try AllContactsModel(dictionary: json)
//                    } catch {
//                        
//                        print("error in parsing")
//                    }
//                    watchlistCount = 0
//                    if let data = mainModel?.contacts?.data {
//                        for model in data {
//                            guard let model = model as? ContactsModel else {
//                                continue
//                            }
//                            if model.is_watched == 1 {
//                                watchlistCount += 1
//                            }
//                        }
//                    }
//                    print(String(format: "contacts count = %lu", UInt(mainModel?.contacts?.data?.count ?? 0)))
//                    
//                    if mainModel?.contacts?.next_page_url != nil {
//                        nextPageURL = mainModel?.contacts?.next_page_url ?? ""
//                    } else {
//                        nextPageURL = ""
//                    }
//                    if isBaseURL {
//                        dataSource = mainModel?.contacts?.data as? [ContactsModel] ?? [ContactsModel]()
//                    } else {
//                        let array = mainModel?.contacts?.data as? [ContactsModel]
//                        dataSource.append(contentsOf: array ?? [ContactsModel]())
//                    }
//                    viewDidDisappear(true)
//                    refreshTable()
//                    
//                }else{
//                    CommonModel.showAlert("alert_error".localized, msg: msg)
//                }
//                dataSource = (dataSource as NSArray).sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as! [ContactsModel]
//                
//                contactImage.isHidden = false
//                lblText.isHidden = false
//                updateUI()
//            })
//        })
//    }
    
    func convertCodableToClass(contacts: [ContactObj]) {
        dataSource.removeAll()
        contacts.forEach { obj in
            let obj2 = ContactsModel()
            obj2.email = obj.email
            obj2.is_watched = Int32(obj.isWatched ?? 0)
            obj2.phone_home = obj.phoneMobile
            obj2.name = obj.name
            obj2.phone_mobile = obj.phoneMobile
            dataSource.append(obj2)
        }
        contactImage.isHidden = false
        lblText.isHidden = false
        updateUI()
        tableView.reloadData()
    }
    
    // MARK: - QBRefreshControlDelegate
    func addPullRefresh() {
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
    }
    
    @objc func refreshControlAction() {
        isBaseURL = true
       // loadContacts()
    }
    
    func refreshTable() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell", for: indexPath) as? ContactsTableViewCell ?? ContactsTableViewCell()
        
        let contact = dataSource[indexPath.row]
        
        if let child_Id = child_Id, let childIdInt = Int(child_Id) {
            let childInfo_obj = DBManager.shared.fetchChild(byID: childIdInt)
            
            cell.name?.text = contact.name ?? ""
            
            if let phone_mobile = contact.phone_mobile {
                cell.mobile?.text = "\("contacts_content_3".localized): \(phone_mobile)"
            } else if let phone_work = contact.phone_work {
                cell.mobile?.text = "\("Work:".localized) \(phone_work)"
            } else if let phone_home = contact.phone_home {
                cell.mobile?.text = "\("Home:".localized) \(phone_home)"
            } else {
                cell.mobile?.text = "Phone: \("not_available".localized)"
            }
            
            if let email = contact.email {
                cell.email?.text = "\("contacts_content_2".localized): \(email)"
            } else {
                cell.email?.text = "\("contacts_content_2".localized): \("not_available".localized)"
            }
            
//            if let name = contact.name, !name.isEmpty {
//                cell.contactImage?.setTitle("\(name[name.startIndex])".uppercased(), for: .normal)
//            } else {
//                cell.contactImage?.setTitle("?", for: .normal)
//            }
            
//            let contactImgName = String(format: "call_circ_%i.png", Int(indexPath.row) % 4 + 1)
//            cell.contactImage?.setBackgroundImage(UIImage(named: contactImgName), for: .normal)
//            cell.contactImage?.setTitleColor(colorArray[indexPath.row % 4], for: .normal)
            
            if contact.is_watched != 0 {
                cell.add?.setImage(UIImage(named: "blacklist_select.png"), for: .normal)
            } else {
                cell.add?.setImage(UIImage(named: "blacklist_unselect.png"), for: .normal)
            }
            cell.add?.tag = indexPath.row
            if SwiftFTUtils.isDeviceiPhoneFamily() {
                cell.name?.font = UIFont(name: "OpenSans", size: 17)
                cell.mobile?.font = UIFont(name: "OpenSans", size: 14)
                cell.email?.font = UIFont(name: "OpenSans", size: 14)
            }
            if childInfo_obj?.device == "iphone" {
                cell.add?.isHidden = true
            } else {
                cell.add?.isHidden = false
            }
            //ADDED TEMPORARILY: FAHAD
            cell.add?.isHidden = true
            viewDidDisappear(true)
        } else {
            // Handle the case where child_Id is not available or not convertible to Int
            // For now, let's just hide the cell
            cell.isHidden = true
        }
        
        return cell
    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell", for: indexPath) as? ContactsTableViewCell ?? ContactsTableViewCell()
//        
//        let contact = dataSource[indexPath.row]
//        let childInfo_Object = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id ?? "")
//        cell.name?.text = contact.name ?? ""
//        
//        if contact.phone_mobile != nil {
//            if let phone_mobile = contact.phone_mobile {
//                cell.mobile?.text = "\("contacts_content_3".localized): \(phone_mobile)"
//            }
//        } else {
//            if contact.phone_work != nil {
//                cell.mobile?.text = "\("Work:".localized ) \(contact.phone_work ?? "")"
//            } else if contact.phone_home != nil {
//                cell.mobile?.text = "\("Home:".localized) \(contact.phone_home ?? "")"
//            } else {
//                cell.mobile?.text = "Phone: \("not_available".localized)"
//            }
//        }
//        if contact.email != nil {
//            cell.email?.text = "\("contacts_content_2".localized): \(contact.email ?? "")"
//        } else {
//            cell.email?.text = "\("contacts_content_2".localized): \("not_available".localized)"
//        }
//        if contact.name != nil , contact.name.count > 0{
//            cell.contactImage?.setTitle("\(contact.name[contact.name.index(contact.name.startIndex, offsetBy: 0)])".uppercased(), for: .normal)
//        }else{
//            cell.contactImage?.setTitle("?", for: .normal)
//        }
//        
//        let contactImgName = String(format: "call_circ_%i.png", Int(indexPath.row) % 4 + 1)
//        cell.contactImage?.setBackgroundImage(UIImage(named: contactImgName), for: .normal)
//        cell.contactImage?.setTitleColor(colorArray[indexPath.row % 4], for: .normal)
//        
//        if (contact.is_watched != 0) {
//            cell.add?.setImage(UIImage(named: "blacklist_select.png"), for: .normal)
//        } else {
//            cell.add?.setImage(UIImage(named: "blacklist_unselect.png"), for: .normal)
//        }
//        cell.add?.tag = indexPath.row
//        if SwiftFTUtils.isDeviceiPhoneFamily() {
//            cell.name?.font = UIFont(name: "OpenSans", size: 17)
//            cell.mobile?.font = UIFont(name: "OpenSans", size: 14)
//            cell.email?.font = UIFont(name: "OpenSans", size: 14)
//        }
//        if childInfo_Object.device == "iphone" {
//            cell.add?.isHidden = true
//        } else {
//            cell.add?.isHidden = false
//        }
//        //ADDED TEMPORARILY: FAHAD
//        cell.add?.isHidden = true
//        viewDidDisappear(true)
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ aScrollView: UIScrollView) {
        
        if let lastVisibleCell = tableView.visibleCells.last {
            var path: IndexPath? = nil
            print(lastVisibleCell)
            path = tableView.indexPath(for: lastVisibleCell)
            if let tPath = path {
                if tPath.section == 0 && tPath.row == dataSource.count - 1 {
                    print("load more cells")
                    // Do something here
                    if nextPageURL.count > 0 {
                        isBaseURL = false
                       // loadContacts()
                    }
                }
            }
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        if ((self.navigationController?.viewControllers.contains(self)) != nil) {
            print("available")
            self.navigationController?.popViewController(animated: true)
        } else {
            print("not available")
            dismiss(animated: true)
        }
        dismiss(animated: true)
    }
}
struct ContactsCodableModel: Codable {
    var contacts: [ContactObj]?
}

// MARK: - Contact
struct ContactObj: Codable {
    var id, childID, contactID: Int?
    var name, email, phoneMobile: String?
    var isWatched: Int?
    var contactTime, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case childID = "child_id"
        case contactID = "contact_id"
        case name, email
        case phoneMobile = "phone_mobile"
        case isWatched = "is_watched"
        case contactTime = "contact_time"
        case createdAt = "created_at"
    }
}
