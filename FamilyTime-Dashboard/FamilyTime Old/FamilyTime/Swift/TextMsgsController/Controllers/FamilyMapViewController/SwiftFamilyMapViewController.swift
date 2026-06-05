//
//  swiftFamilyMapViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 11/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD
import GoogleMaps
import CoreLocation
import MapKit

class SwiftFamilyMapViewController: BaseViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK: - Variables
    let delegate: AppDelegate? = nil
    var location2233: CLLocation?
    var locationManager: CLLocationManager?
   // var allmarkerts: [AnyHashable] = []
    var markers: [GMSMarker] = []
   // var childID = -1
    var isComingFromSideMenu : Bool = false
    private var package_id : String = ""
    private var package_name : String = ""
    private var device : String = ""
    private var hasSetMapViewFrame: Bool = false
    
    var timer: Timer?
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
        guard let childIDInt = Int(child_Id ) else {
        // Handle the error: childID is not a valid integer
        print("Error: childID is not a valid integer")
        return
    }

    let child_info = DBManager.shared.fetchChild(byID: childIDInt)
//        let child_info = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id)
//        if self.childID == -1 {
//            title = "family_locator_title".localized
//        } else {
//            title = "child_locator_title".localized
//        }
//        if !self.isComingFromSideMenu {
            lblTitle.text = "family_locator_title".localized
//        } else {
//            lblTitle.text = "child_locator_title".localized
//        }
        mapView.isHidden = false
        ZendeskChatManager.trackEvent("Family Locator")
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
        package_id = CoreDataUtility.fetchPackageIdFor(child_id: Int32(child_Id) ?? 0)
        package_name = CoreDataUtility.fetchPackageNameFor(child_id: Int32(child_Id) ?? 0)
        device = CoreDataUtility.fetchPackageDeviceFor(child_id: Int32(child_Id) ?? 0)
       // allmarkerts = []
        let button = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(add(_:)))
        navigationItem.rightBarButtonItem = button
        self.mapView.delegate = self
        if child_info?.planID == 1 {
            showPremiumAlert()
        }
//        else {
//            DispatchQueue.main.async {
//                //self.loadAllFamilyLocations()
//            }
//
//        }
        let strRelationShip = UserDefaults.standard.string(forKey: "userRelation") ?? ""
        self.addMarkers(lat: self.location2233?.coordinate.latitude ?? 0.0, long: self.location2233?.coordinate.longitude ?? 0.0, name: "family_locator_content_1".localized, relation: strRelationShip)
        timer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { [weak self] _ in
            self?.performAfter15Seconds()
        }
        postStatus(status: true)
        getLoc()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // --- CORRECTION: Programmatically set the frame here ---
        // This method is called after the view controller's view has laid out its subviews.
        // At this point, self.view.bounds will have its final, correct size.
        if !hasSetMapViewFrame { // Only set once, or when bounds change significantly
            // Assuming mapView should fill the entire view controller's view
            // Adjust this frame if your map is not full screen (e.g., if you have other UI elements)
            // Example: To place it below lblTitle and fill the rest of the screen:
            let topOffset = lblTitle.frame.maxY // Get the bottom edge of lblTitle
            let bottomOffset: CGFloat = 0 // If no bottom bar, or adjust for tab bar etc.
            let width = self.view.bounds.width
            let height = self.view.bounds.height - topOffset - bottomOffset
            
            mapView.frame = CGRect(x: 0, y: topOffset, width: width, height: height)
            print("SwiftFamilyMapViewController: MapView frame set programmatically to \(mapView.frame)")
            
            // If the map should fill the entire view controller's view, simply:
            // mapView.frame = self.view.bounds
            // print("SwiftFamilyMapViewController: MapView frame set programmatically to \(mapView.frame)")
            
            // This ensures the initial camera position is re-applied correctly after the frame is set
            // In case the map was initially at 0,0 and then its frame was set
            //            if mapView.camera.target.latitude == 0.0 && mapView.camera.target.longitude == 0.0 {
            //                let initialCamera = GMSCameraPosition.camera(withLatitude: 31.5204, longitude: 74.3487, zoom: 12.0)
            //                mapView.camera = initialCamera
            //                print("SwiftFamilyMapViewController: Re-setting initial map camera after frame update.")
            //            }
            
            hasSetMapViewFrame = true // Set flag to prevent constant re-setting
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LiveVisitorManager.shared.updateScreen(
            "Family Map"
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        postStatus(status: false)
        timer = nil
        timer?.invalidate()
    }
    
    //MARK: - IBActions
    @IBAction func add(_ sender: Any) {
        //    [_allmarkerts removeAllObjects];
        locationManager?.startUpdatingLocation()
        mapView.clear()
        
        let packageId = self.package_id
        if packageId == "1" {
            showPremiumAlert()
        } else {
            //loadAllFamilyLocations()
        }
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    @objc func performAfter15Seconds() {
        getLoc()
    }
    deinit {
        timer?.invalidate()
    }
    
    //MARK: - Helper Functions
    func showPremiumAlert() {
        SwiftFTUtils.showSwiftPremiumPopup(on: self)
    }
    
    //    func addAnnotationsNew(_ loc: NSDictionary) {
    //        if ((loc["latitude"] as? NSNull) == NSNull()) || ((loc["longitude"] as? NSNull) == NSNull()) {
    //        } else {
    //            print("haha\(Double(loc["latitude"] as? String ?? "") ?? 0.0)")
    //            //    [self.mapView clear];
    //            let sydneyMarker = GMSMarker()
    //            //    sydneyMarker.icon = [UIImage imageNamed:@"glow-marker"];
    //            sydneyMarker.position = CLLocationCoordinate2DMake(CLLocationDegrees(Double(loc["latitude"] as? String ?? "") ?? 0.0), CLLocationDegrees(Double(loc["longitude"] as? String ?? "") ?? 0.0))
    //            sydneyMarker.map = mapView
    //            sydneyMarker.title = loc["name"] as? String ?? ""
    //            if (loc["location_date"] as? NSNull) != NSNull() {
    //                print("date is....", loc["location_date"] as? String ?? "")
    //                let dateString = CommonModel.dateForLocator(loc["location_date"] as? String ?? "")
    //                sydneyMarker.snippet = dateString
    //            } else {
    //                sydneyMarker.snippet = ""
    //            }
    //            print("loc = \(String(describing: loc))")
    //            if (loc["gender"] as? NSNull) == NSNull() || (loc["gender"] as? String == "male") || (loc["gender"] as? String == "Male") {
    //                if loc["color"] as? String == "orange" {
    //                    sydneyMarker.icon = UIImage(named: "o_pin_boy")
    //                }
    //                if loc["color"] as? String == "red" {
    //                    sydneyMarker.icon = UIImage(named: "r_pin_boy")
    //                }
    //                if loc["color"] as? String == "purple" {
    //                    sydneyMarker.icon = UIImage(named: "p_pin_boy")
    //                }
    //                if loc["color"] as? String == "green" {
    //                    sydneyMarker.icon = UIImage(named: "g_pin_boy")
    //                }
    //            } else if (loc["gender"] as? String == "Female") || (loc["gender"] as? String == "female") {
    //                if loc["color"] as? String == "orange" {
    //                    sydneyMarker.icon = UIImage(named: "o_pin_girl")
    //                }
    //                if loc["color"] as? String == "red" {
    //                    sydneyMarker.icon = UIImage(named: "r_pin_girl")
    //                }
    //                if loc["color"] as? String == "purple" {
    //                    sydneyMarker.icon = UIImage(named: "p_pin_girl")
    //                }
    //                if loc["color"] as? String == "green" {
    //                    sydneyMarker.icon = UIImage(named: "g_pin_girl")
    //                }
    //            }
    //            sydneyMarker.icon = UIImage(named: "g_pin_boy")
    //            allmarkerts.append(sydneyMarker)
    //        }
    //    }
    
    //    func loadAllFamilyLocations() {
    //        //    [_mapView clear];
    //        allmarkerts.removeAll()
    //        let selectedChildID = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
    //        SwiftFTUtils.showHUDAdded(to: self.view, withText: "Loading...".myModification(), animated: true)
    //        mapView.isMyLocationEnabled = false
    //        ApiManager.shared().commonGetApi(withVC: self, andUrl: kFamilyMap_Mesh2) { response, error in
    //            DispatchQueue.main.async {
    //                let apiResponse = response as AnyObject
    //                print("response = \(apiResponse)")
    //                let msg = (apiResponse.value(forKey: "message") == nil ? kErrorGeneral.myModification() : apiResponse.value(forKey: "message")) as? String
    //                SwiftFTUtils.hideHUDAdded(to: self.view, animated: false)
    //                //MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    //                if (apiResponse["status"] as? NSNumber)?.intValue ?? 0 == 200 {
    //                    let showChildOnly = self.isComingFromSideMenu
    //                    if showChildOnly {
    //                        self.title = "child_locator_title".localized
    //                        let locations = apiResponse.value(forKey: "response") as? NSArray
    //                        for k in 0..<(locations?.count ?? 0) {
    //                            if let item = locations?[k] as? NSDictionary {
    //                                let id = item["child_id"] as? Int
    //                                let currentChildId = String(describing: id ?? 0)
    //                                if selectedChildID == currentChildId {
    //                                    self.addAnnotationsNew((locations?[k] as? NSDictionary ?? NSDictionary()))
    //                                }
    //                            }
    //                        }
    //                    } else {
    //                        self.title = "family_locator_title".localized
    //                        if self.childID == -1 {
    //                            self.addAnnotations(self.location2233)
    //                        }
    //                        let locations = apiResponse.value(forKey: "response") as? NSArray
    //                        for k in 0..<(locations?.count ?? 0) {
    //                            if self.childID == -1 {
    //                                self.addAnnotationsNew((locations?[k] as? NSDictionary ?? NSDictionary()))
    //                            } else {
    //                                if let item = locations?[k] as? NSDictionary {
    //                                    let id = item["child_id"] as? Int
    //                                    if self.childID == id {
    //                                        self.addAnnotationsNew((locations?[k] as? NSDictionary ?? NSDictionary()))
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    }
    //                    self.loadtoActuall()
    //                } else {
    //                    CommonModel.showAlert("alert_error".localized, msg: msg ?? "Nothing")
    //                }
    //            }
    //        } failure: { error, errorCode in
    //            DispatchQueue.main.async(execute: { [self] in
    //                MBProgressHUD.hideAllHUDs(for: view, animated: true)
    //                CommonModel.showAlert("alert_error".localized, msg: error)
    //            })
    //        }
    //    }
    //MARK: - New Work Started
    
    func postStatus(status: Bool) {
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "Loading...".myModification(), animated: true)
        CoreManager.postFamilyLocatorStatus(status: status) { response, status, message in
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            if (200...206).contains(status ?? 404) {
                print("success")
            }
        }
    }
    
    func getLoc() {
        markers.removeAll()
        CoreManager.getFamilyLocation { response, status, message in
            if (200...206).contains(status ?? 404) {
                self.mapView.clear()
                if let locations = response {
                    for obj in locations {
//                        guard let childIDInt = Int(obj.childID ?? 0) else {
//                        // Handle the error: childID is not a valid integer
//                        print("Error: childID is not a valid integer")
//                        return
//                    }

                    let child = DBManager.shared.fetchChild(byID: obj.childID ?? 0)
                        
                        
//                        let child = CoreDataUtility.fetchChildInfoFromDatabase(child_id: "\(obj.childID ?? 0)")
                        let gender = child?.gender ?? ""
                        self.addMarkers(lat: obj.latitude ?? 0.0, long: obj.longitude ?? 0.0, name: child?.name ?? "Child", relation: gender)
                    }
                    let strRelationShip = UserDefaults.standard.string(forKey: "userRelation") ?? ""
                    self.addMarkers(lat: self.location2233?.coordinate.latitude ?? 0.0, long: self.location2233?.coordinate.longitude ?? 0.0, name: "family_locator_content_1".localized, relation: strRelationShip)
                    self.fitAllMarkers()
                }
            }
        }
    }
    
    func addMarkers(lat:Double, long:Double, name:String, relation:String) {
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker1.title = name
        switch relation {
        case "mother", "Mother":
            marker1.icon = UIImage(named: "pin_woman")
            break
        case "father", "Father":
            marker1.icon = UIImage(named: "pin_man")
            break
        case "male", "Male":
            marker1.icon = UIImage(named: "g_pin_boy")
            break
        case "female", "Female":
            marker1.icon = UIImage(named: "o_pin_girl")
            break
        default:
            marker1.icon = UIImage(named: "g_pin_boy")
        }
        marker1.map = mapView
        markers.append(marker1)
        mapView.selectedMarker = marker1
        
    }
    
    func fitAllMarkers() {
        var bounds = GMSCoordinateBounds()
        for marker in markers {
            bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
        mapView.animate(with: update)
    }
    
    
    //MARK: - New Work End
    //    func addAnnotations(_ loc: CLLocation?) {
    //        //    [self.mapView clear];
    //        let sydneyMarker = GMSMarker()
    //        //    sydneyMarker.icon = [UIImage imageNamed:@"pin_man"];
    //        sydneyMarker.position = CLLocationCoordinate2DMake(loc?.coordinate.latitude ?? 0, loc?.coordinate.longitude ?? 0)
    //        sydneyMarker.map = mapView
    //        let strRelationShip = UserDefaults.standard.string(forKey: "userRelation") ?? ""
    //        if strRelationShip == "Mother" || strRelationShip == "mother" {
    //            sydneyMarker.icon = UIImage(named: "pin_woman")
    //        } else {
    //            sydneyMarker.icon = UIImage(named: "pin_man")
    //        }
    //        sydneyMarker.title = "family_locator_content_1".localized
    //        sydneyMarker.snippet = "\(UIDevice.current.model)"
    //        allmarkerts.append(sydneyMarker)
    //    }
    
    //    func loadtoActuall() {
    //        //    NSArray *myMarkers;   // array of marker which sets in Mapview
    //        let myMarkers = allmarkerts
    //        //     NSArray *myMarkers=_mapView.
    //        let path = GMSMutablePath()
    //        for marker in myMarkers {
    //            guard let marker = marker as? GMSMarker else {
    //                continue
    //            }
    //            path.add(marker.position)
    //        }
    //        let bounds = GMSCoordinateBounds(path: path)
    //        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 90))
    //        print("zoom max level=\(mapView.maxZoom)")
    //        print("zoom min level=\(mapView.minZoom)")
    //        print("current zoom level=\(mapView.camera.zoom)")
    //        self.mapView.isHidden = false
    //    }
    
    //MARK: - GMS MapView Delegate
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude),\(coordinate.longitude)")
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let title = marker.title {
            print("You tapped at \(title)")
        }
    }
    
    //MARK: - Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        // If it's a relatively recent event, turn off updates to save power.
        //     [_mapView clear];
        location2233 = locations.last
        //    [self addAnnotations:location2233];
        locationManager?.stopUpdatingLocation()
    }
    
    //    func allChildren() {
    //        if UserDefaults.standard.object(forKey: "ChildrenAll") != nil {
    //            let arr = UserDefaults.standard.object(forKey: "ChildrenAll") as? [AnyHashable]
    //            for k in 0..<(arr?.count ?? 0) {
    //                addAnnotationsNew11(arr?[k] as? NSDictionary as? [String : Any])
    //            }
    //        }
    //        loadtoActuall()
    //    }
    
    //    func addAnnotationsNew11(_ loc: [String : Any]?) {
    //        let strlat = loc?["lat"] as? String
    //        let strlong = loc?["long"] as? String
    //        //gender
    //        //    NSLog(@"haha%f",[[loc objectForKey:@"latitude"] doubleValue]);
    //        //    [self.mapView clear];
    //        let sydneyMarker = GMSMarker()
    //        sydneyMarker.position = CLLocationCoordinate2DMake(CLLocationDegrees(Double(strlat ?? "") ?? 0.0), CLLocationDegrees(Double(strlong ?? "") ?? 0.0))
    //        sydneyMarker.map = mapView
    //        sydneyMarker.title = ""
    //        sydneyMarker.snippet = ""
    //        sydneyMarker.icon = UIImage(named: "g_pin_boy")
    //        allmarkerts.append(sydneyMarker)
    //    }
    
    //MARK: - Drawing Lines
    //    func drawRoute(_ myOrigin: CLLocationCoordinate2D, destination myDestination: CLLocationCoordinate2D) {
    //        fetchPolyline(withOrigin: myOrigin, destination: myDestination) { polyline1 in
    //            if let polyline1 = polyline1 {
    //                polyline1.map = self.mapView
    //            }
    //        }
    //    }
    
    //    func fetchPolyline(withOrigin origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completionHandler: @escaping (GMSPolyline?) -> Void) {
    //        let originString = "\(origin.latitude),\(origin.longitude)"
    //        let destinationString = "\(destination.latitude),\(destination.longitude)"
    //        let directionsAPI = "https://maps.googleapis.com/maps/api/directions/json?"
    //        let directionsUrlString = "\(directionsAPI)&origin=\(originString)&destination=\(destinationString)&mode=driving"
    //        let directionsUrl = URL(string: directionsUrlString)
    //        //        var fetchDirectionsTask: URLSessionDataTask?
    //        URLSession.shared.dataTask(with: directionsUrl!) { (data, response, error) in
    //            DispatchQueue.main.async {
    //                var json: [AnyHashable : Any]? = nil
    //                do {
    //                    json = try JSONSerialization.jsonObject(with: data!, options: []) as? [AnyHashable : Any]
    //                } catch {
    //
    //                }
    //                if error != nil {
    //                    completionHandler(nil)
    //                    return
    //                }
    //                let routesArray = json?["routes"] as? [AnyHashable]
    //                var polyline: GMSPolyline? = nil
    //                if routesArray!.count > 0 {
    //                    let routeDict = routesArray?[0] as? [AnyHashable : Any]
    //                    let routeOverviewPolyline = routeDict?["overview_polyline"] as? [AnyHashable : Any]
    //                    let points = routeOverviewPolyline?["points"] as? String
    //                    let path = GMSPath(fromEncodedPath: points ?? "")
    //                    polyline = GMSPolyline(path: path)
    //                    polyline?.strokeColor = UIColor.red
    //                    polyline?.strokeWidth = 5.0
    //                }
    //                completionHandler(polyline)
    //            }
    //        }.resume()
    //    }
}


struct FamilyLocatorCodable: Codable {
    var locations: [ChildLocation]?
    enum CodingKeys: String, CodingKey {
        case locations = "data"
    }
}
struct ChildLocation: Codable {
    var longitude, latitude: Double?
    var childID, superUserID, status: Int?
    
    enum CodingKeys: String, CodingKey {
        case longitude, latitude
        case childID = "child_id"
        case superUserID = "super_user_id"
        case status
    }
}
