//
//  SwiftPlacesViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 02/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD

class SwiftPlacesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, AddPlacesChange {
    
    //MARK: - IBOutlets
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblText: UILabel!
    
    //MARK: - Variables
    //var delegate = UIApplication.shared.delegate as? AppDelegate
    var isCountBased = false
    var countLimit = -1
    var addButton = UIBarButtonItem()
    var imgView = UIImageView()
    var contentLbl = UILabel()
    var oopsLbl = UILabel()
    var dataSource = [AnyHashable]()
    var refreshControl = UIRefreshControl()
    var addPlacesCont = SwiftAddPlacesViewController()
    var places = [PlaceObj]()
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LiveVisitorManager.shared.updateScreen(
            "Geo Fence Places"
        )
        
        navigationItem.title = "settings_card_2_android_6".localized
        addPlacesCont = SwiftAddPlacesViewController(nibName: "AddPlacesViewController2~iphone", bundle: nil)
        tableView.register(UINib(nibName: "PlacesCell", bundle: nil), forCellReuseIdentifier: "PlacesCell")
        if SwiftFTUtils.isDeviceiPhoneFamily() {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 90
        } else {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 120
        }
        tableView.separatorStyle = .none
        if UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 667 {
            tableView.frame = CGRect(x: 0, y: 20, width: 375, height: 600)
        } else if UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 736 {
            view.frame = CGRect(x: 0, y: 0, width: 414, height: 1800)
            tableView.frame = CGRect(x: 0, y: 20, width: 414, height: 1700)
        }
        
        self.addButton = UIBarButtonItem(title: "add_button".localized, style: .plain, target: self, action: #selector(addPlace(_:)))
        navigationItem.rightBarButtonItems = [self.addButton]
        contactImage.isHidden = true
        lblText.isHidden = true
        lblText.text = lblText.text?.myModification()
        
//        if UI_USER_INTERFACE_IDIOM() == .pad {
//            imgView = UIImageView(frame: CGRect(x: 236, y: 229, width: 296, height: 212))
//            imgView.image = UIImage(named: "ipad_empty")
//            imgView.contentMode = .scaleAspectFill
//            imgView.isHidden = true
//            view.addSubview(imgView)
//            view.bringSubviewToFront(imgView)
//            oopsLbl = UILabel(frame: CGRect(x: view.bounds.size.width / 2 - 40, y: 461, width: 70, height: 30))
//            oopsLbl.text = "oops_title".myModification()
//            oopsLbl.font = UIFont.boldSystemFont(ofSize: 20)
//            oopsLbl.isHidden = true
//            view.addSubview(oopsLbl)
//            view.bringSubviewToFront(oopsLbl)
//            contentLbl = UILabel(frame: CGRect(x: 203, y: 511, width: 362, height: 45))
//            contentLbl.textColor = UIColor.lightGray
//            contentLbl.text = "empty_record".myModification()
//            contentLbl.font = UIFont.systemFont(ofSize: 16)
//            contentLbl.lineBreakMode = .byWordWrapping
//            contentLbl.numberOfLines = 2
//            contentLbl.textAlignment = .center
//            contentLbl.isHidden = true
//            view.addSubview(contentLbl) //
//            view.bringSubviewToFront(contentLbl)
//        }
//        
//        if UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 568 {
//            imgView = UIImageView(frame: CGRect(x: 57, y: 98, width: 206, height: 151))
//            imgView.image = UIImage(named: "ic_empty")
//            imgView.contentMode = .scaleAspectFill
//            imgView.isHidden = true
//            view.addSubview(imgView)
//            view.bringSubviewToFront(imgView)
//            oopsLbl = UILabel(frame: CGRect(x: view.bounds.size.width / 2 - 20, y: 259, width: 70, height: 30))
//            oopsLbl.text = "oops_title".myModification()
//            oopsLbl.font = UIFont.boldSystemFont(ofSize: 18)
//            oopsLbl.isHidden = true
//            view.addSubview(oopsLbl)
//            view.bringSubviewToFront(oopsLbl)
//            contentLbl = UILabel(frame: CGRect(x: 3, y: 294, width: 315, height: 41))
//            contentLbl.textColor = UIColor.lightGray
//            contentLbl.text = "empty_record".myModification()
//            contentLbl.font = UIFont.systemFont(ofSize: 16)
//            contentLbl.lineBreakMode = .byWordWrapping
//            contentLbl.numberOfLines = 2
//            contentLbl.textAlignment = .center
//            contentLbl.isHidden = true
//            view.addSubview(contentLbl)
//            view.bringSubviewToFront(contentLbl)
//        } else if UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 667 {
//            imgView = UIImageView(frame: CGRect(x: 115, y: 152, width: 145, height: 104))
//            imgView.image = UIImage(named: "ic_empty")
//            imgView.contentMode = .scaleAspectFill
//            imgView.isHidden = true
//            view.addSubview(imgView)
//            view.bringSubviewToFront(imgView)
//            oopsLbl = UILabel(frame: CGRect(x: view.bounds.size.width / 2 - 20, y: 266, width: 70, height: 30))
//            oopsLbl.text = "oops_title".myModification()
//            oopsLbl.font = UIFont.boldSystemFont(ofSize: 18)
//            oopsLbl.isHidden = true
//            view.addSubview(oopsLbl)
//            view.bringSubviewToFront(oopsLbl)
//            contentLbl = UILabel(frame: CGRect(x: 30, y: 301, width: 315, height: 41))
//            contentLbl.textColor = UIColor.lightGray
//            contentLbl.text = "empty_record".myModification()
//            contentLbl.font = UIFont.systemFont(ofSize: 17)
//            contentLbl.lineBreakMode = .byWordWrapping
//            contentLbl.numberOfLines = 2
//            contentLbl.textAlignment = .center
//            contentLbl.isHidden = true
//            view.addSubview(contentLbl)
//            view.bringSubviewToFront(contentLbl)
//        } else if UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 736 {
//            imgView = UIImageView(frame: CGRect(x: 127, y: 168, width: 160, height: 114))
//            imgView.image = UIImage(named: "ic_empty")
//            imgView.contentMode = .scaleAspectFill
//            imgView.isHidden = true
//            view.addSubview(imgView)
//            view.bringSubviewToFront(imgView)
//            oopsLbl = UILabel(frame: CGRect(x: view.bounds.size.width / 2 - 20, y: 292, width: 70, height: 30))
//            oopsLbl.text = "oops_title".myModification()
//            oopsLbl.font = UIFont.boldSystemFont(ofSize: 18)
//            oopsLbl.isHidden = true
//            view.addSubview(oopsLbl)
//            view.bringSubviewToFront(oopsLbl)
//            contentLbl = UILabel(frame: CGRect(x: 26, y: 327, width: 362, height: 45))
//            contentLbl.textColor = UIColor.lightGray
//            contentLbl.text = "empty_record".myModification()
//            contentLbl.font = UIFont.systemFont(ofSize: 16)
//            contentLbl.lineBreakMode = .byWordWrapping
//            contentLbl.numberOfLines = 2
//            contentLbl.textAlignment = .center
//            contentLbl.isHidden = true
//            view.addSubview(contentLbl)
//            view.bringSubviewToFront(contentLbl)
//        }
        
        self.addButton.isEnabled = true
        self.addPullRefresh()
        loadPlaces()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let placesPackageFeature = SwiftCommonUtility.shared.getPackageFeature(withName: "place")
        //delegate?.selectedDashboardChild.getPackageFeature(withName: "place")
        self.isCountBased = false
        if placesPackageFeature?.is_count_based == 1 {
            self.isCountBased = true
        }
        self.countLimit = Int(placesPackageFeature?.count_limit ?? "-1") ?? -1
       // loadPlaces()
        self.updateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 568 {
            imgView.isHidden = true
            contentLbl.isHidden = true
            oopsLbl.isHidden = true
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            imgView.isHidden = true
            contentLbl.isHidden = true
            oopsLbl.isHidden = true
        }
        if UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 667 {
            imgView.isHidden = true
            contentLbl.isHidden = true
            oopsLbl.isHidden = true
        } else if UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 736 {
            imgView.isHidden = true
            contentLbl.isHidden = true
            oopsLbl.isHidden = true
        }
        refreshControl.endRefreshing()
    }
    
    
    //MARK: - Helper Functions
    func addPullRefresh() {
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadPlaces), for: .valueChanged)
    }
    
    func refreshTable() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func updateUI() {
        if UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 568 {
            imgView.isHidden = false
            contentLbl.isHidden = false
            oopsLbl.isHidden = false
            contactImage.isHidden = true
            lblText.isHidden = true
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            imgView.isHidden = false
            contentLbl.isHidden = false
            oopsLbl.isHidden = false
            contactImage.isHidden = true
            lblText.isHidden = true
        }
        if UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 667 {
            imgView.isHidden = false
            contentLbl.isHidden = false
            oopsLbl.isHidden = false
            contactImage.isHidden = true
            lblText.isHidden = true
        } else if UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 736 {
            imgView.isHidden = false
            contentLbl.isHidden = false
            oopsLbl.isHidden = false
            contactImage.isHidden = true
            lblText.isHidden = true
            
        }
    }
    func callApi() {
        loadPlaces()
    }
    //MARK: - Places
    func editPlace() {
        tableView.isEditing = !tableView.isEditing
    }
    
    @objc func loadPlaces() {
        self.places = DBManager.shared.getPlaces()
        self.tableView.reloadData()
//        let childId = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
//        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
//        let urrl = HLConstants.BASE_URL_CORE_2 + "controls/places"
//        CoreManager.networkRequest(url: urrl, method: .get) { (response: PlacesCodableModel?, statusCode, message) in
//            DispatchQueue.main.async {
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                if (200...206).contains(statusCode ?? 0) {
//                    self.places = response?.data?.filter({$0.childID == childId}) ?? []
//                    self.tableView.reloadData()
//                } else {
//                    CommonModel.showAlert("alert_error".localized, msg: message)
//                }
//                
//            }
//        }
        
        
        
        
        /*
        
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
        let url = String(format: "\(kPlaces_mesh2)\(Int(child_Id ?? "") ?? -1)")
        ApiManager.shared().getPlacesApi(withVC: self, andUrl: url) { model, message, statusCode in
            print(url)
            self.dataSource.removeAll()
            DispatchQueue.main.async {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                if statusCode == 1 {
                    CommonModel.showAlert("alert_error".localized, msg: message)
                } else if statusCode == 200 {
                    print("api success with message =  \(String(describing: model.message))")
                    if let data = model.data as? [AnyHashable] {
                        self.dataSource = data
                    } else {
                        print("Data is nill")
                    }
                    self.viewDidDisappear(true)
                    self.refreshTable()
                } else {
                    CommonModel.showAlert("alert_error".localized, msg: model.message)
                }
                self.updateUI()
            }
        }
        */
    }
    
    //MARK: - TableView Data Sourse
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return dataSource.count
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "PlacesCell") as? SwiftPlacesCell
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "PlacesCell") as? SwiftPlacesCell
            cell?.accessoryType = .disclosureIndicator
        }
        //let place = dataSource[indexPath.row] as? PlaceModel
        let place = places[indexPath.row]
        cell?.place.text = place.name
        cell?.address.text = place.address
        cell?.editPlace.tag = indexPath.row
        cell?.editPlace.addTarget(self, action: #selector(editing(_:)), for: .touchUpInside)
        cell?.editPlace.setImage(UIImage(named: "edit_1.png"), for: .normal)
        let imgName = String(format: "geo0_\(Int(indexPath.row) % 4 + 1).png")
        cell?.placeImg.image = UIImage(named: imgName)
        viewDidDisappear(true)
        return cell ?? UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editPlace(indexPath.row)
    }
    
    //MARK: - Edit Place
    @objc func editing(_ sender: UIButton?) {
        editPlace(Int(sender?.tag ?? 0))
    }
    
    func editPlace(_ index: Int) {
        addPlacesCont = SwiftAddPlacesViewController(nibName: "AddPlacesViewController2~iphone", bundle: nil)
        addPlacesCont.delegates = self
        addPlacesCont.placesArr = places
        addPlacesCont.mode = "editing"
        let place = places[index]
        let placeClass = PlaceModel()
        placeClass.address = place.address
        placeClass.place_id = place.id?.intToStr()
        placeClass.child_id = place.childID?.intToStr()
        placeClass.checkin_alert = place.checkinAlert?.intToStr()
        placeClass.location = place.name
        placeClass.longitude = place.longitude
        placeClass.latitude = place.latitude
        placeClass.radius = place.radius?.intToStr()
        placeClass.predefined = place.predefined?.intToStr()
        addPlacesCont.place = placeClass
        navigationController?.pushViewController(addPlacesCont, animated: true)
        //addPlacesCont.place = dataSource[index] as! PlaceModel
    }
    
    @objc func addPlace(_ sender: Any) {
        if isCountBased {
            if dataSource.count < countLimit {
                addPlacesCont = SwiftAddPlacesViewController(nibName: "AddPlacesViewController2~iphone", bundle: nil)
                addPlacesCont.delegates = self
                addPlacesCont.placesArr = places
                navigationController?.pushViewController(addPlacesCont, animated: true)
                addPlacesCont.mode = ""
            } else {
                SwiftFTUtils.showSwiftPremiumPopup(on: self)
            }
        } else {
            addPlacesCont = SwiftAddPlacesViewController(nibName: "AddPlacesViewController2~iphone", bundle: nil)
            addPlacesCont.delegates = self
            addPlacesCont.placesArr = places
            navigationController?.pushViewController(addPlacesCont, animated: true)
            addPlacesCont.mode = ""
        }
    }
}
struct PlacesCodableModel: Codable {
    var data: [PlaceObj]?
}
struct SinglePlacesCodableModel: Codable {
    var place: PlaceObj?
}
struct PlaceObj: Codable {
    var id, userID, childID: Int?
    var name, function, type, address: String?
    var latitude, longitude: String?
    var radius, checkinAlert, predefined, isActive: Int?
    var status, deleted: Int?
    var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case childID = "child_id"
        case name, function, type, address, latitude, longitude, radius
        case checkinAlert = "checkin_alert"
        case predefined
        case isActive = "is_active"
        case status, deleted
        case createdAt = "created_at"
    }
}
