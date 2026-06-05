//
//  PlacesHistoryViewController.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 12/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreLocation

let iPhoneX = UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 812
let iPhone6 = UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 667
let iPhone6Plus = UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 736
let iPhone5 = UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 568
let iPhone4 = UIDevice.current.userInterfaceIdiom == .phone && Int(max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)) == 480

class PlacesHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GMSMapViewDelegate {
    
    //MARK: - VARIABLES
    var delegate: AppDelegate?
    var refreshControl = UIRefreshControl()
    
    var imgView = UIImageView()
    var contentLbl = UILabel()
    var oopsLbl = UILabel()
    
    private var package_id : String = ""
    private var package_name : String = ""
    private var device : String = ""
    
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    
    var dataSource = [PlaceVisit]()
    var dates = [AnyHashable]()
    var page = 0
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locDate: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapView2: UIView!
    @IBAction func locHist2(_ sender: Any) {
    }
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var TopViewForArrows: UIView!
    
    //MARK: - VIEW OUTLETS
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        delegate = AppDelegate.getSharedAppDelegateForSwift()
        tableView.delegate = self
        tableView.dataSource = self
        package_id = CoreDataUtility.fetchPackageIdFor(child_id: Int32(child_Id ?? "") ?? -1)
        package_name = CoreDataUtility.fetchPackageNameFor(child_id: Int32(child_Id ?? "") ?? -1)
        device = CoreDataUtility.fetchPackageDeviceFor(child_id: Int32(child_Id ?? "") ?? -1)
        tableView.register(UINib(nibName: "PlacesCell", bundle: nil), forCellReuseIdentifier: "PlacesCell")
        if SwiftFTUtils.isDeviceiPhoneFamily() {
            tableView.rowHeight = 70
        } else {
            tableView.rowHeight = 100
        }
        tableView.separatorStyle = .none
        navigationItem.title = "places_history_title".localized
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 131.20, zoom: 6)
        mapView?.camera = camera
        if UI_USER_INTERFACE_IDIOM() == .pad {
            imgView = UIImageView(frame: CGRect(x: 236, y: 229, width: 296, height: 212))
            imgView.contentMode = .scaleAspectFill
            imgView.image = UIImage(named: "ipad_empty")
            imgView.isHidden = true
            view.addSubview(imgView)
            view.bringSubviewToFront(imgView)
            
            oopsLbl = UILabel(frame: CGRect(x: view.bounds.size.width / 5 , y: 470, width: 70, height: 30))
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
        }else if UIDevice.current.userInterfaceIdiom == .phone{
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
                
            }else{
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
        
        let packageId = self.package_id
        if (packageId == "1") {
            imgView.isHidden = false
            contentLbl.isHidden = false
            oopsLbl.isHidden = false
            TopViewForArrows.isHidden = true
            mapView.isHidden = true
            showPremiumAlert()
        } else {
            addPullRefresh()
            refreshTable()
            loadDates()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ZendeskChatManager.trackEvent("Places history")
        let packageId = self.package_id
        if (packageId == "1") {
            imgView.isHidden = false
            contentLbl.isHidden = false
            oopsLbl.isHidden = false
            TopViewForArrows.isHidden = true
            mapView.isHidden = true
        } else {
            refreshTable()
            loadDates()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - QBRefreshControlDelegate
    func addPullRefresh() {
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadDates), for: .valueChanged)
    }
    func refreshTable() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    // MARK: - Next-Prev history
    @IBAction func requestLocHistory(_ sender: UIButton) {
        if sender.tag == 0 && page < dates.count - 1 {
            page += 1
            loadLoactions()
        } else if sender.tag == 1 && page > 0 {
            page -= 1
            loadLoactions()
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func ipadBackBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func loadDates() {
        page = 0
        dates = []
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
        //        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
        guard let childIDInt = Int(child_Id ?? "") else {
            // Handle the error: childID is not a valid integer
            print("Error: childID is not a valid integer")
            return
        }
        let childInfo_obj = DBManager.shared.fetchChild(byID: childIDInt)
        //        let childInfo_obj = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id ?? "")
        let paramsStr = String(format: "%ld", Int(child_Id ?? "") ?? 0)
        var url = ""
        
        if childInfo_obj?.device == "iphone" {
            url = KPlacesReportDatesUrliOS + paramsStr
        } else {
            url = KPlacesReportDatesUrlAndroid + paramsStr
        }
        
        ApiManager.shared().mesh_getApi(withApi: url, withResponse: { [self] json, errorCode, message in
            DispatchQueue.main.async(execute: { [self] in
                print("place report date response = \(json)")
                let msg = (json["message"] == nil ? kErrorGeneral.myModification() : json["message"]) as? String
                if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
                    let jsonObject = (json["checkindates"] as? [AnyHashable])
                    if let jsonObject = jsonObject {
                        dates = jsonObject
                    }
                    loadLoactions()
                    TopViewForArrows.isHidden = false
                    mapView.isHidden = false
                    imgView.isHidden = true
                    contentLbl.isHidden = true
                    oopsLbl.isHidden = true
                    
                    if dates.count == 0 {
                        imgView.isHidden = false
                        contentLbl.isHidden = false
                        oopsLbl.isHidden = false
                        TopViewForArrows.isHidden = true
                        mapView.isHidden = true
                    }
                }else{
                    CommonModel.showAlert("alert_error".localized, msg: msg)
                    imgView.isHidden = false
                    contentLbl.isHidden = false
                    oopsLbl.isHidden = false
                    TopViewForArrows.isHidden = true
                    mapView.isHidden = true
                }
                refreshTable()
                MBProgressHUD.hideAllHUDs(for: view, animated: true)
            })
        })
    }
    
    func showPremiumAlert() {
        SwiftFTUtils.showSwiftPremiumPopup(on: self)
    }
    
    func loadLoactions() {
        if dates.count == 0 {
            return
        }
        guard let childIDInt = Int(child_Id ?? "") else {
            // Handle the error: childID is not a valid integer
            print("Error: childID is not a valid integer")
            return
        }
        let childInfo_obj = DBManager.shared.fetchChild(byID: childIDInt)
        
        //let childInfo_obj = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id ?? "")
        //set first last date in between next prev button
        let myDict = dates[page] as? [String : Any]
        let myDate = myDict?["date"] as? String
        var date = CommonModel.date(myDate ?? "", oldFormat: "YYYY-MM-dd", format: "EEE,MMM d, yyyy") //d EEE,MMM yy
        if date.isEmpty == true {
            let myDict = dates[page] as? [String : Any]
            let myDate = myDict?["date"] as? String
            date = CommonModel.date(myDate!, oldFormat: "YYYY-MM-dd", format: "EEE, MM d, yyyy") //d EEE,MMM yy
            date = myDate ?? ""
        }
        locDate.text = date
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
        
        let date1 = CommonModel.date(withTimestamp: date)
        let calendar = Calendar(identifier: .gregorian)
        var components: DateComponents? = nil
        if let date1 = date1 {
            components = calendar.dateComponents([.year, .month, .day], from: date1)
            let Day = Int(components?.day ?? 01)
            let month = Int(components?.month ?? 01)
            let year = Int(components?.year ?? 2000)
            var pDate = String(format: "%d-%02d-%02d", year, month, Day)
            print("here==\(date)")
            
            var strdate = date
            let arrNew = strdate.components(separatedBy: " ")
            strdate = arrNew.first ?? ""
            if date1 == nil {
                pDate = strdate
            }
        }
        
        let paramsStr = "\(Int(child_Id ?? "") ?? 0)/\(myDate ?? "2000-01-01")"
        var url = ""
        
        if childInfo_obj?.device == "iphone" {
            url = KPlaceHistoryUrliOS+paramsStr
        } else {
            url = KPlaceHistoryUrlAndroid+paramsStr
        }
        
        ApiManager.shared().mesh_getApi(withApi: url, withResponse: { [self] json, errorCode, message in
            DispatchQueue.main.async(execute: { [self] in
                print("place report date response = \(json)")
                var error: Error?
                let msg = (json["message"] == nil ? kErrorGeneral.myModification() : json["message"]) as? String
                if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
                    var places: AllPlacesVisitModel? = nil
                    do {
                        places = try AllPlacesVisitModel(dictionary: json)
                    } catch {
                        print("do nothing")
                    }
                    if let places = places {
                        print("\(places)")
                    }
                    if let locations = places?.places as? [PlaceVisit]{
                        dataSource = locations
                    }
                    if (dataSource.count) > 0 {
                        let loc = dataSource[0]
                        addAnnotations(loc)
                    }
                }else{
                    CommonModel.showAlert("alert_error".localized, msg: msg)
                }
                refreshTable()
                MBProgressHUD.hideAllHUDs(for: view, animated: true)
                
            })
        })
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesCell", for: indexPath) as! SwiftPlacesCell
        let loc = dataSource[indexPath.row]
        let imgName = String(format: "geo0_%i.png", Int(indexPath.row) % 4 + 1)
        cell.placeImg.image = UIImage(named: imgName)
        cell.place.text = loc.location
        if loc.placecount.count == 1 {
            cell.address.text = "\(loc.placecount ?? "0") " + "places_history_content_1".localized
        } else {
            cell.address.text = "\(loc.placecount ?? "0") " + "places_history_content_2".localized
        }
        cell.editPlace.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let visit = dataSource[indexPath.row]
        addAnnotations(visit)
    }
    
    // MARK: - GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude),\(coordinate.longitude)")
    }
    // MARK: Annotations on MAP
    func addAnnotations(_ loc: PlaceVisit?) {
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
            loadLoactions()
        } else if sender.tag == 1 && page > 0 {
            page -= 1
            loadLoactions()
        }
    }
}
