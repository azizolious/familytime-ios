//
//  LocationHistoryViewController.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 11/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD
import GoogleMaps

class LocationHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GMSMapViewDelegate {
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locDate: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var TopViewForArrows: UIView!
    @IBOutlet weak var viewHideNav: UIView!
    @IBOutlet weak var heightCon: NSLayoutConstraint!
    //MARK: - Variables
    // var delegate: AppDelegate?
    var refreshControl = UIRefreshControl()
    var imgView = UIImageView()
    var contentLbl = UILabel()
    var oopsLbl = UILabel()
    var addPlaceCont: SwiftAddPlacesViewController?
    var dataSource = [LocationModel]()
    var dates : [AnyHashable] = []
    var page = 0
    var package_id : String = ""
    var package_name : String = ""
    var device : String = ""
    var ishiddenBar = false
    var locationHis = [LocationObjc]()
    var currentDate = Date()
    var uniqueDates = [String]()
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uniqueDates = DBManager.shared.getUniqueDays()
        viewHideNav.isHidden = ishiddenBar
        if ishiddenBar {
            heightCon.constant = 0
            
        } else {
            heightCon.constant = 96
        }
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
        //delegate = AppDelegate.getSharedAppDelegateForSwift()
        tableView.register(UINib(nibName: "PlacesCell", bundle: nil), forCellReuseIdentifier: "PlacesCell")
        addPlaceCont = SwiftAddPlacesViewController(nibName: "AddPlacesViewController2~iphone", bundle: nil)
        tableView.delegate = self
        tableView.dataSource = self
        package_id = CoreDataUtility.fetchPackageIdFor(child_id: Int32(child_Id) ?? 0)
        package_name = CoreDataUtility.fetchPackageNameFor(child_id: Int32(child_Id) ?? 0)
        device = CoreDataUtility.fetchPackageDeviceFor(child_id: Int32(child_Id) ?? 0)
        tableView.separatorStyle = .none
        navigationItem.title = NSLocalizedString("location_history_title", comment: "")
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 131.20, zoom: 6)
        mapView?.camera = camera
        initUI()
        //let date = getPreviousDateString(day: 0)
        if uniqueDates.count != 0 {
            self.locationHis = DBManager.shared.getLocByDate(timeStr: uniqueDates[0])
            locDate.text = convertDateString(uniqueDates[0], fromFormat: "yyyy-MM-dd", toFormat: "EEEE, MMM d, yyyy")
        }
        
        if (locationHis.count) > 0 {
            let loc = locationHis[0]
            addAnnotations(loc)
        }
        let packageId = self.package_id
        if (packageId == "1") {
            imgView.isHidden = false
            contentLbl.isHidden = false
            oopsLbl.isHidden = false
            TopViewForArrows.isHidden = true
            mapView.isHidden = true
            showPremiumAlert()
        } else {
            //addPullRefresh()
            BaseViewController.init().showPremiumFeatureView(true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LiveVisitorManager.shared.updateScreen(
            "Location History"
        )
        //navigationController?.isNavigationBarHidden = true
//        ZendeskChatManager.trackEvent("Location History")
        let packageId = self.package_id
        if (packageId == "1") {
            imgView.isHidden = false
            contentLbl.isHidden = false
            TopViewForArrows.isHidden = true
            oopsLbl.isHidden = false
            mapView.isHidden = true
        } else {
            refreshTable()
            //loadDates()
            BaseViewController.init().showPremiumFeatureView(true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - QBRefreshControlDelegate
//    func addPullRefresh() {
//        refreshControl = UIRefreshControl()
//        tableView.addSubview(refreshControl)
//        refreshControl.addTarget(self, action: #selector(loadDates), for: .valueChanged)
//    }
    
    func showPremiumAlert() {
        SwiftFTUtils.showSwiftPremiumPopup(on: self)
    }
    
    func refreshTable() {
        let packageId = self.package_id
        if (packageId == "1") {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
            
        } else {
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
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
    func initUI(){
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
            contentLbl.text = "empty_record".localized
            contentLbl.font = UIFont.systemFont(ofSize: 16)
            contentLbl.lineBreakMode = .byWordWrapping
            contentLbl.numberOfLines = 2
            contentLbl.textAlignment = .center
            contentLbl.isHidden = true
            view.addSubview(contentLbl)
            view.bringSubviewToFront(contentLbl)
            
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            let screenRect = UIScreen.main.bounds
            if screenRect.size.height == 568 {
                imgView = UIImageView(frame: CGRect(x: 115 - 20, y: 152, width: screenRect.size.width - 20, height: 104))
                imgView.contentMode = .scaleAspectFit
                imgView.image = UIImage(named: "ic_empty")
                imgView.isHidden = true
                view.addSubview(imgView)
                view.bringSubviewToFront(imgView)
                oopsLbl = UILabel(frame: CGRect(x: view.bounds.size.width / 2 - 20, y: 259, width: 70, height: 30))
                oopsLbl.text = "oops_title".localized
                oopsLbl.font = UIFont.boldSystemFont(ofSize: 18)
                oopsLbl.isHidden = true
                view.addSubview(oopsLbl)
                view.bringSubviewToFront(oopsLbl)
                contentLbl = UILabel(frame: CGRect(x: 6 - 4, y: 294, width: 362, height: 45))
                contentLbl.lineBreakMode = .byWordWrapping
                contentLbl.textColor = UIColor.lightGray
                contentLbl.text = "empty_record".myModification()
                contentLbl.font = UIFont.systemFont(ofSize: 14)
                contentLbl.lineBreakMode = .byWordWrapping
                contentLbl.numberOfLines = 2
                contentLbl.textAlignment = .center
                contentLbl.isHidden = true
                view.addSubview(contentLbl)
                view.bringSubviewToFront(contentLbl)
            } else {
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
                contentLbl.text = "empty_record".localized
                contentLbl.font = UIFont.systemFont(ofSize: 16)
                contentLbl.lineBreakMode = .byWordWrapping
                contentLbl.numberOfLines = 2
                contentLbl.textAlignment = .center
                contentLbl.isHidden = true
                view.addSubview(contentLbl)
                view.bringSubviewToFront(contentLbl)
            }
        }
    }
    
    // MARK: - Next-Prev history
    @IBAction func requestLocHistory(_ sender: UIButton) {
        if sender.tag == 0 && page < uniqueDates.count-1{
            page += 1
            let getDate = uniqueDates[page]
            let loc = DBManager.shared.getLocByDate(timeStr: getDate)
            self.locationHis = loc
            locDate.text =  convertDateString(getDate, fromFormat: "yyyy-MM-dd", toFormat: "EEEE, MMM d, yyyy")
            tableView.reloadData()
        } else if sender.tag == 1 && page > 0 {
            page -= 1
            let date = uniqueDates[page]
            let loc = DBManager.shared.getLocByDate(timeStr: date)
            self.locationHis = loc
            locDate.text =  convertDateString(date, fromFormat: "yyyy-MM-dd", toFormat: "EEEE, MMM d, yyyy")
            tableView.reloadData()
        }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func ipadBackBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: Location dates from server
//    @objc func loadDates() {
//        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
//        guard let childIDInt = Int(child_Id) else {
//            print("Error: childID is not a valid integer")
//            return
//        }
//        
//        let child_Info = DBManager.shared.fetchChild(byID: childIDInt)
//        
//        //        let child_Info = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id)
//        // print(String(format: "greattt--%ld", Int(delegate?.selectedDashboardChild.child_id)))
//        page = 0
//        dates = []
//        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
//        //---NATIVE API CALLING---//
//        let paramsStr = String(format: "%ld", Int(child_Id) ?? 0)
//        var url = ""
//        let deviceType = child_Info?.device ?? ""
//        if deviceType == "iphone" {
//            url = KLocationDatesiOS+paramsStr
//        } else {
//            url = KLocationDatesAndroid+paramsStr
//        }
//        print("Location history = \(url)")
//        ApiManager.shared().mesh_getApi(withApi: url, withResponse: { [self] json, errorCode, message in
//            DispatchQueue.main.async(execute: { [self] in
//                print("place report date response = \(json)")
//                let msg = (json["message"] == nil ? kErrorGeneral.myModification() : json["message"]) as? String
//                if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
//                    let jsonObject = (json["checkindates"] as? [AnyHashable])
//                    if let jsonObject = jsonObject {
//                        dates = jsonObject
//                    }
//                    MBProgressHUD.hideAllHUDs(for: view, animated: true)
//                    loadLoactions()
//                    TopViewForArrows.isHidden = false
//                    mapView.isHidden = false
//                    imgView.isHidden = true
//                    contentLbl.isHidden = true
//                    oopsLbl.isHidden = true
//                    if dates.count == 0 {
//                        imgView.isHidden = false
//                        contentLbl.isHidden = false
//                        oopsLbl.isHidden = false
//                        TopViewForArrows.isHidden = true
//                        mapView.isHidden = true
//                    }
//                } else {
//                    CommonModel.showAlert("alert_error".localized, msg: msg)
//                    imgView.isHidden = false
//                    contentLbl.isHidden = false
//                    oopsLbl.isHidden = false
//                    TopViewForArrows.isHidden = true
//                    mapView.isHidden = true
//                }
//                refreshTable()
//                MBProgressHUD.hideAllHUDs(for: view, animated: true)
//            })
//        })
//    }
    
//    func loadLoactions() {
//        if dates.count == 0 {
//            return
//        }
//        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
//        guard let childIDInt = Int(child_Id) else {
//            // Handle the error: childID is not a valid integer
//            print("Error: childID is not a valid integer")
//            return
//        }
//        
//        let child_Info = DBManager.shared.fetchChild(byID: childIDInt)
//        
//        //        let child_Info = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id)
//        //set first last date in between next prev button
//        let myDict = dates[page] as? [String : Any]
//        let myDate = myDict?["date"] as? String
//        var date = CommonModel.dateForLocationHistory(myDate ?? "") //d EEE,MMM yy
//        if date == "" {
//            let myDict = dates[page] as? [String : Any]
//            let myDate = myDict?["date"] as? String
//            date = CommonModel.dateForLocationHistory(myDate ?? "") //d EEE,MMM yy
//            date = myDate ?? ""
//        }
//        locDate.text = date
//        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
//        let newDate = CommonModel.date(withTimestamp: date)
//        let calendar = Calendar(identifier: .gregorian)
//        var components: DateComponents? = nil
//        if let date1 = newDate {
//            components = calendar.dateComponents([.year, .month, .day], from: date1)
//            let Day = Int(components?.day ?? 01)
//            let month = Int(components?.month ?? 01)
//            let year = Int(components?.year ?? 2000)
//            var pDate = String(format: "%d-%02d-%02d", year, month, Day)
//            print("here==\(date)")
//            var strdate = date
//            let arrNew = strdate.components(separatedBy: " ")
//            strdate = arrNew.first ?? ""
//            if newDate == nil {
//                pDate = strdate
//                print(pDate)
//            }
//        }
//        let paramsStr = "\(Int(child_Id) ?? 0)/\(myDate ?? "2000-01-01")"
//        var url = ""
//        if child_Info?.device == "iphone" {
//            url = KLocationUrliOS+paramsStr
//        } else {
//            url = KLocationUrlAndroid+paramsStr
//        }
//        
//        print(url)
//        ApiManager.shared().mesh_getApi(withApi: url, withResponse: { [self] json, errorCode, message in
//            DispatchQueue.main.async(execute: { [self] in
//                print("place report date response = \(json)")
//                let msg = (json["message"] == nil ? kErrorGeneral.myModification() : json["message"]) as? String
//                if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
//                    var places: AllLocationModel? = nil
//                    do {
//                        places = try AllLocationModel(dictionary: json)
//                    } catch {
//                    }
//                    if let places = places {
//                        print("\(places)")
//                    }
//                    if let locations = places?.locations as? [LocationModel]{
//                        dataSource = locations
//                    }
//                    if (dataSource.count) > 0 {
//                        //                        let loc = dataSource[0]
//                        //                        addAnnotations(loc)
//                    }
//                }else{
//                    CommonModel.showAlert("alert_error", msg: msg)
//                }
//                refreshTable()
//                MBProgressHUD.hideAllHUDs(for: view, animated: true)
//                
//            })
//        })
//    }
    
    func getDesiredReverseGeoCodeString(_ placeMarkers: [AnyHashable]?) -> String? {
        let placeMarker = placeMarkers?.last as? CLPlacemark
        var textString = "\(placeMarker?.subThoroughfare ?? ""), \(placeMarker?.thoroughfare ?? ""), \(placeMarker?.postalCode ?? ""), \(placeMarker?.locality ?? ""), \(placeMarker?.administrativeArea ?? ""), \(placeMarker?.country ?? "")"
        textString = textString.replacingOccurrences(
            of: "(null),",
            with: "")
        return textString
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return dataSource.count
        return locationHis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesCell", for: indexPath) as! SwiftPlacesCell
        var diff = ""
        let loc = locationHis[indexPath.row]
        if indexPath.row != 0 {
            let nextLoc = locationHis[indexPath.row-1]
            guard let startDate = CommonModel.date(withTimestamp: loc.timeIn) , let endDate = CommonModel.date(withTimestamp: nextLoc.timeIn) else {
                return UITableViewCell()
            }
            diff = CommonModel.remaningTime(startDate, end: endDate) ?? ""
        }
        var serverdate = CommonModel.date(loc.timeIn ?? "", oldFormat: "YYYY-MM-dd HH:mm:ss", format: "yyyy-MM-dd HH:mm")
        if serverdate == nil {
            serverdate = loc.timeIn ?? ""
        }
        let dateFormat7 = DateFormatter()
        dateFormat7.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormat7.locale = Locale(identifier: "en_US_POSIX")
        let date7 = dateFormat7.date(from: serverdate)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        var todayDate: String? = nil
        if let date7 = date7 {
            todayDate = formatter.string(from: date7)
        }
        print("\(diff)")
        if diff == "" {
            print("diff \(diff)")
            cell.place.text = "\(todayDate ?? "")"
        } else {
            cell.place.text = "\(todayDate ?? "")  \(diff)"
        }
        //UK Locale issue
        if todayDate == nil {
            cell.place.text = serverdate
        }
        if loc.address == nil || loc.address?.count == 0 {
            let strFloat = Double(loc.latitude ?? "0.0") ?? 0
            let strFloat2 = Double(loc.longitude ?? "0.0") ?? 0
            let latVal = String(format: "%.02f", strFloat)
            let langVal = String(format: "%.02f", strFloat2)
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: Double(loc.latitude ?? "0.0")!, longitude: Double(loc.longitude ?? "0.0")!)
            geoCoder.reverseGeocodeLocation(location) { [self] placemarks, error in
                if error == nil {
                    var locationGeoCode = getDesiredReverseGeoCodeString(placemarks)
                    locationGeoCode = locationGeoCode?.trimmingCharacters(in: CharacterSet.whitespaces)
                    cell.address.text = "\("location_near".localized) \(locationGeoCode ?? "")"
                }
            }
            
        } else if (loc.address == "") {
            let strFloat = Double(loc.latitude ?? "0.0")!
            let strFloat2 = Double(loc.longitude ?? "0.0")!
            let latVal = String(format: "%.02f", strFloat)
            let langVal = String(format: "%.02f", strFloat2)
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: Double(loc.latitude ?? "0.0")!, longitude: Double(loc.longitude ?? "0.0")!)
            geoCoder.reverseGeocodeLocation(location) { [self] placemarks, error in
                if error == nil {
                    var locationGeoCode = getDesiredReverseGeoCodeString(placemarks)
                    locationGeoCode = locationGeoCode?.trimmingCharacters(in: CharacterSet.whitespaces)
                    cell.address.text = "\("location_near".localized) \(locationGeoCode ?? "")"
                }
            }
            
        } else {
            cell.address.text = "\("location_near".localized) \(loc.address ?? "")"
        }
        cell.editPlace.tag = indexPath.row
        cell.editPlace.setImage(UIImage(named: "geo_edit11.png"), for: .normal)
        let imgName = String(format: "geo0_%i.png", Int(indexPath.row) % 4 + 1)
        cell.placeImg.image = UIImage(named: imgName)
        cell.editPlace.addTarget(self, action: #selector(PlacesViewController.addPlace(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func addPlace(_ sender: UIButton?) {
        let loc = locationHis[sender?.tag ?? 0]
        let place = PlaceModel()
        place.latitude = loc.latitude
        place.longitude = loc.longitude
        place.location = loc.address
        navigationController?.pushViewController(addPlaceCont ?? SwiftAddPlacesViewController(), animated: true)
        addPlaceCont?.mode = "addPlace"
        addPlaceCont?.place = place
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let loc = locationHis[indexPath.row]
        addAnnotations(loc)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    // MARK: - GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude),\(coordinate.longitude)")
    }
    
    // MARK: Annotations on MAP
    func addAnnotations(_ loc: LocationObjc?) {
        mapView?.clear()
        let sydneyMarker = GMSMarker()
        sydneyMarker.icon = UIImage(named: "v2_map_pin")
        sydneyMarker.position = CLLocationCoordinate2DMake(CLLocationDegrees(Double(loc?.latitude ?? "0.0")!), CLLocationDegrees(Double(loc?.longitude ?? "0.0")!))
        sydneyMarker.map = mapView
        let sydney = GMSCameraPosition.camera(
            withLatitude: Double(loc?.latitude ?? "0.0")!,
            longitude: Double(loc?.longitude ?? "0.0")!,
            zoom: 15)
        mapView?.camera = sydney
    }
    @IBAction func reqLocHis(_ sender: UIButton) {
        if sender.tag == 0 && page < dates.count - 1 {
            page += 1
//            loadLoactions()
        } else if sender.tag == 1 && page > 0 {
            page -= 1
//            loadLoactions()
        }
    }
}

struct LocationHistoryCodableModel: Codable {
    var data: [LocationObjc]?
}

// MARK: - Datum
struct LocationObjc: Codable {
    var id, userID, childID: Int?
    var address, latitude, longitude, accuracy: String?
    var speed, distance, type, timeIn: String?
    var createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case childID = "child_id"
        case address, latitude, longitude, accuracy, speed, distance, type
        case timeIn = "time"
        case createdAt = "created_at"
    }
}
