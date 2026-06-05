//
//  SwiftAddPlacesViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 27/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import MBProgressHUD
import AddressBookUI
import Contacts
protocol AddPlacesChange: NSObject {
    func callApi()
}
class SwiftAddPlacesViewController: BaseViewController, GMSMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate,UIAlertViewDelegate {
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var addTF: UITextField!
    @IBOutlet weak var distanceSeg: UISegmentedControl!
    @IBOutlet weak var lblEnterTheAddressOrdragme: UILabel!
    @IBOutlet weak var lblPlaceName: UILabel!
    @IBOutlet weak var lblStreetAddress: UILabel!
    @IBOutlet weak var lblSendMeAcknoleghe: UILabel!
    @IBOutlet weak var locAlerts: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var placeTF: UITextField!
    @IBOutlet weak var addPlace: UIButton!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var MapViewContainer: UIView!
    
    //MARK: - VARIABLES
    @objc var place = PlaceModel()
    @objc var mode = ""
    var addButtonn = UIBarButtonItem()
    var currentLocation: CLLocationCoordinate2D?
    var radius: Double = 0.0
    var zoom = -1
    let delegate = UIApplication.shared.delegate as? AppDelegate
    var user = UserModel()
    var locationManager = CLLocationManager()
    var placeName = ""
    var streetAdd = ""
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    weak var delegates: AddPlacesChange?
    var placesArr = [PlaceObj]()
    private var hasSetMapViewFrame: Bool = false
    
    //MARK: - VIEWS LIFE
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentLocation?.latitude ?? 0.0)
        print(currentLocation?.longitude ?? 0.0)
        lblPlaceName.adjustsFontSizeToFitWidth = true
        
        UserDefaults.standard.set("NO", forKey: "gobacknow")
        UserDefaults.standard.synchronize()
        
        do {
            if let object = delegate?.userDefault?.object(forKey: "user") as? [AnyHashable: Any] {
                user = try UserModel(dictionary: object)
            }
        } catch {
        }
        
        if mode == "editing" {
            navigationItem.title = "geo_places_edit_place_title".localized
        } else {
            navigationItem.title = "geo_places_button_1".localized
        }
        
        mapView.delegate = self
        //self.mapView.
        placeTF.delegate = self
        addTF.delegate = self
        if responds(to: #selector(setter: UIViewController.edgesForExtendedLayout)) {
            edgesForExtendedLayout = []
        }
        self.setLocRadius()
        
        self.addPlace.layer.cornerRadius = 3
        self.addPlace.clipsToBounds = true
        //setup Google map
        let camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 6)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        //
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft{
            addTF.semanticContentAttribute = .forceRightToLeft
            placeTF.semanticContentAttribute = .forceRightToLeft
            addTF.textAlignment = .right
            placeTF.textAlignment = .right
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !hasSetMapViewFrame {
            // Define margin
            let margin: CGFloat = 10

            // Calculate the frame with 10pt margin inside MapViewContainer
            let containerBounds = MapViewContainer.bounds
            let mapFrame = CGRect(
                x: margin,
                y: margin,
                width: containerBounds.width - (2 * margin),
                height: containerBounds.height - (2 * margin)
            )

            mapView.frame = mapFrame
            print("MapView frame set with 10pt margin: \(mapFrame)")

            hasSetMapViewFrame = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblEnterTheAddressOrdragme.text = "geo_places_add_places_content_3".localized
        if UserDefaults.standard.object(forKey: "gobacknow") != nil {
            if UserDefaults.standard.object(forKey: "gobacknow") as! String == "YES" {
                UserDefaults.standard.set("NO", forKey: "gobacknow")
                UserDefaults.standard.synchronize()
                navigationController?.popViewController(animated: true)
            }
        }
        
        if mode == "editing" {
            addButtonn.title = "geo_places_button_2".localized
            addPlace.setTitle("geo_places_button_2".localized, for: .normal)
            placeTF.text = place.location
            addTF.text = place.address ?? ""
            locAlerts.isSelected = ((place.checkin_alert == "0") ? false : true)
            
            let location = CLLocationCoordinate2DMake(CLLocationDegrees(Double(place.latitude ?? "0.0") ?? 0.0), CLLocationDegrees(Double(place.longitude ?? "") ?? 0.0))
            print(location.latitude)
            
            self.currentLocation = location
            self.radius = Double(place.radius ?? "0") ?? 0.0
            
            if place.predefined != "1" {
                let add = UIBarButtonItem(image: UIImage(named: "places_delete.png"), style: .plain, target: self, action: #selector(handleDelete(_:)))
                navigationItem.rightBarButtonItems = [add]
            }
            
        } else if mode == "addPlace" {
            addPlace.setTitle("geo_places_button_1".localized, for: .normal)
            addTF.text = place.location
            locAlerts.isSelected = true
            let location = CLLocationCoordinate2DMake(CLLocationDegrees(Double(place.latitude) ?? 0.0), CLLocationDegrees(Double(place.longitude) ?? 0.0))
            currentLocation = location
            radius = 150
            
        } else {
            place = PlaceModel()
            radius = 150
            addPlace.setTitle("geo_places_button_1".localized, for: .normal)
        }
        
        self.setLocRadius()
        if currentLocation?.longitude != nil {
            addPlace.isEnabled = true
            addPlace.backgroundColor = KSetBG(24, 121, 162, 1)
        } else {
            addPlace.isEnabled = false
            addPlace.backgroundColor = UIColor(red: 189 / 255.0, green: 189 / 255.0, blue: 189 / 255.0, alpha: 1)
        }
        
        //hide key board
        placeTF.resignFirstResponder()
        addTF.resignFirstResponder()
        view.setNeedsDisplay()
        
        lblPlaceName.text = "geo_places_add_places_content_1".localized
        lblStreetAddress.text = "geo_places_add_places_content_2".localized
        lblSendMeAcknoleghe.text = "geo_places_add_places_toggle_1".localized
        placeTF.placeholder = "geo_places_add_places_input_content_1".localized
        addTF.placeholder = "geo_places_add_places_input_content_2".localized
    }
    
    func searchLocation() {
        SwiftFTUtils.showHUDAdded(to: view, withText: "Searching...".localized, animated: true)
        let address = "\(addTF.text ?? "")"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { placemarks, error in
            if placemarks?.count != 0 {
                let placemark = placemarks?[0]
                self.currentLocation = placemark?.location?.coordinate
                self.addPlace.isEnabled = true
                self.addPlace.backgroundColor = KSetBG(24, 121, 162, 1)
                self.addCircle(self.currentLocation ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
            } else  {
                CommonModel.showAlert("alert_something_wrong".myModification(), msg: "geo_places_places_alert_content_1".localized)
            }
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
    }
    
    //MARK: - Location Manager
    func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
        // If it's a relatively recent event, turn off updates to save power.
        let location = locations.last
        let eventDate = location?.timestamp
        
        let howRecent = eventDate?.timeIntervalSinceNow
        if abs(Float(howRecent!)) < 15.0 {
            currentLocation = location?.coordinate
            view.setNeedsDisplay()
            self.locationManager.stopUpdatingLocation()
            self.setLocRadius()
        }
    }
    
    //MARK: - UITEXTField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == placeTF {
            placeTF.resignFirstResponder()
        } else {
            addTF.resignFirstResponder()
            self.searchLocation()
        }
        return true
    }
    
    //MARK: - Delete Place
    @objc func handleDelete(_ sender: UIButton?) {
        let alertview = UIAlertView(title: "geo_places_edit_place_alert_1_content_1".localized, message: "geo_places_edit_place_alert_1_content_2".localized, delegate: self, cancelButtonTitle: "cancel_button".localized, otherButtonTitles: "alert_delete".localized)
        
        alertview.tag = sender?.tag ?? 0
        alertview.show()
    }
    
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            return
        }
        //delete place
        ///*
        SwiftFTUtils.showHUDAdded(to: view, withText: "Deleting Place...".localized, animated: true)
        let param = ["data": [["child_id": Int(child_Id ?? "") ?? -1,
                               "id": place.place_id ?? 0]]]
        let urrl = HLConstants.BASE_URL_CORE_2 + "controls/places"
        CoreManager.networkRequest(url: urrl,method: .delete, params: param) { (response: EmptyResponseModel?, statusCode, message) in
            DispatchQueue.main.async {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                
                if (200...206).contains(statusCode ?? 0) {
                    let placeID = self.place.place_id.integer
                    DBManager.shared.deletePlace(id: placeID)
                    let refreshAlert = UIAlertController(title: "settings_card_5_1".localized, message: "geo_places_places_alert_content_4".localized, preferredStyle: UIAlertController.Style.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: { (action: UIAlertAction!) in
                        self.delegates?.callApi()
                        self.navigationController?.popViewController(animated: true)
                    }))
                    
                    self.present(refreshAlert, animated: true, completion: nil)
                } else {
                    CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
                }
                
            }
        }
        
        //*/
//        SwiftFTUtils.showHUDAdded(to: view, withText: "Deleting Place...".localized, animated: true)
//        let childInfoData = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id ?? "")
//        var url = ""
//        
//        if childInfoData.plateformID == 1 {
//            url = String(format: "%@%ld/%@", kPlaces_Delete_android_mesh2, Int(child_Id ?? "") ?? -1, place.place_id)
//        } else {
//            url = String(format: "%@%ld/%@", kPlaces_Delete_ios_mesh2, Int(child_Id ?? "") ?? -1, place.place_id)
//        }
//        print("delete place url = \(url)")
//        ApiManager.shared().deleteApi(withParams: [:], andUrl: url, andController: self) { message, code in
//            DispatchQueue.main.async {
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                if code == 200 {
//                    let refreshAlert = UIAlertController(title: "settings_card_5_1".localized, message: "geo_places_places_alert_content_4".localized, preferredStyle: UIAlertController.Style.alert)
//                    
//                    refreshAlert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: { (action: UIAlertAction!) in
//                        self.navigationController?.popViewController(animated: true)
//                    }))
//                    
//                    self.present(refreshAlert, animated: true, completion: nil)
//                } else {
//                    CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
//                }
//            }
//        }
    }
    
    //MARK: - GMSMapView Delegate
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        self.mapView.clear()
        addCircle(marker.position)
        currentLocation = marker.position
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        currentLocation = coordinate
        self.addCircle(coordinate)
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            
            if placemarks?.count != 0 {
                let placemark = placemarks?[0]
                var address: String? = nil
                print(address)
                if let addressDictionary = placemark?.addressDictionary {
                    address = ABCreateStringWithAddressDictionary(addressDictionary, false)
                }
                if address != nil {
                    address = address?.replacingOccurrences(of: "\n", with: " ")
                    self.addTF.text = address
                    self.addPlace.isEnabled = true
                    self.addPlace.backgroundColor = KSetBG(24, 121, 162, 1)
                }
            }
        }
    }
    
    func addCircle(_ loc: CLLocationCoordinate2D) {
        mapView.clear()
        let marker = GMSMarker()
        marker.isDraggable = true
        marker.icon = UIImage(named: "default_marker")
        marker.position = loc
        marker.map = mapView
        mapView.animate(toLocation: loc)
        let fence = GMSCircle(position: loc, radius: radius)
        print(radius)
        fence.fillColor = UIColor(red: 102.0 / 255, green: 178.0 / 255, blue: 255.0 / 255, alpha: 0.3)
        fence.map = mapView
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func addLocation(_ sender: Any) {
        placeName = placeTF.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
        streetAdd = addTF.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
        print(currentLocation?.latitude)
        if placeName.count <= 0 {
            CommonModel.showAlert("", msg: "geo_places_places_alert_content_3".localized)
        } else if streetAdd.count <= 0 {
            CommonModel.showAlert("", msg: "geo_places_places_alert_content_1".localized)
        } else if currentLocation?.latitude == 0.0 || currentLocation?.latitude == nil {
            CommonModel.showAlert("", msg: "geo_places_places_alert_content_1".localized)
        } else {
            let placesPackageFeature = SwiftCommonUtility.shared.getPackageFeature(withName: "place")
            //delegate?.selectedDashboardChild.getPackageFeature(withName: "place")
            if placesPackageFeature?.is_count_based == 1 {
                if placesArr.count >= Int(placesPackageFeature!.count_limit)! {
                    SwiftFTUtils.showSwiftPremiumPopup(on: self)
                } else {
                    self.doAddPlace()
                }
//                SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
//                
//                let url = String(format: "%@%ld", kPlaces_mesh2, Int(child_Id ?? "") ?? -1)
//                ApiManager.shared().getPlacesApi(withVC: self, andUrl: url) { model, message, statusCode in
//                    DispatchQueue.main.async {
//                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                        if statusCode == 1 {
//                            CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
//                        } else {
//                            if model.status == 200 {
//                                print("api success with message =  \(model.message ?? "")")
//                            } else {
//                                CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
//                            }
//                            if model.data.count >= Int(placesPackageFeature!.count_limit)! {
//                                
//                                SwiftFTUtils.showSwiftPremiumPopup(on: self)
//                                
//                            } else {
//                                self.doAddPlace()
//                            }
//                        }
//                    }
//                }
            } else {
                self.doAddPlace()
            }
        }
    }
    @IBAction func locationAlert(_ sender: UIButton) {
        locAlerts.isSelected = !sender.isSelected
    }
    
    @IBAction func distanceRadius(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            radius = 150.0
        } else if sender.selectedSegmentIndex == 1 {
            radius = 300.0
        } else if sender.selectedSegmentIndex == 2 {
            radius = 500.0
        } else if sender.selectedSegmentIndex == 3 {
            radius = 1000.0
        }
        self.setLocRadius()
    }
    
    //MARK: - Helper
    func doAddPlace() {
        ///*
        if radius==0.0 {
            radius = 150.0
        }
        let childId = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
        let urrl = HLConstants.BASE_URL_CORE_2 + "controls/places"
        var param = [
            "address": streetAdd,
            "child_id": childId,
            "function": "geofence",
            "icon": "ic_geofence_"+placeName,
            "latitude": "\(currentLocation?.latitude ?? 0.0)",
            "longitude": "\(currentLocation?.longitude ?? 0.0)",
            "name": placeName,
            "radius": radius,
            "status": 1,
            "type": "location_based"] as [String : Any]
        if mode == "editing" {
            param["id"] = place.place_id
        }
        CoreManager.networkRequest(url: urrl,method: mode == "editing" ? .put : .post, params: param) { (response: SinglePlacesCodableModel?, statusCode, message) in
            DispatchQueue.main.async {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                if (200...206).contains(statusCode ?? 0) {
                    if self.mode == "editing" {
                        if let obj = response?.place {
                            DBManager.shared.getPlaceAndUpdate(id: obj.id ?? 0, obj: obj)
                        }
                    } else {
                        if let obj = response?.place {
                            let arr = [obj]
                            DBManager.shared.savePlaces(myModelArray: arr)
                        }
                    }
                    CommonModel.showAlert("settings_card_5_1".localized, msg: "geo_places_places_alert_content_4".localized)
                    self.delegates?.callApi()
                    self.navigationController?.popViewController(animated: true)
                } else {
                    CommonModel.showAlert("alert_error".localized, msg: message)
                }
                
            }
        }
       // */
        
        
//        SwiftFTUtils.showHUDAdded(to: view, withText: "Adding Place...", animated: true)
//        if radius==0.0 {
//            radius = 150.0
//        }
//        var params: [AnyHashable : Any] = [:]
//        
//        params["location"] = placeName
//        params["address"] = streetAdd
//        params["latitude"] = "\(currentLocation?.latitude ?? 0.0)"
//        params["longitude"] = "\(currentLocation?.longitude ?? 0.0)"
//        params["radius"] = String(format: "%.2f", radius)
//        params["checkin_alert"] = String(format: "%i", (locAlerts.isSelected) ? 1 : 0)
//        
//        if mode == "editing" {
//            params["id"] = place.place_id
//        }
//        
//        let url = String(format: "%@%ld", kPlaces_mesh2, Int(child_Id ?? "") ?? -1)
//        print("Add or update Place url = \(url) and params = \(params)")
//        
//        ApiManager.shared().putApi(url, params: params, controller: self, isContPresented: false) { message, statusCode in
//            DispatchQueue.main.async {
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                if statusCode == 200 {
//                    CommonModel.showAlert("settings_card_5_1".localized, msg: "geo_places_places_alert_content_4".localized)
//                    self.navigationController?.popViewController(animated: true)
//                } else {
//                    CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
//                }
//            }
//        }
    }
    
    func setLocRadius() {
        if radius <= 150.0 {
            distanceSeg.selectedSegmentIndex = 0
            zoom = 16
        } else if radius <= 300.0 {
            distanceSeg.selectedSegmentIndex = 1
            zoom = 15
        } else if radius <= 500.0 {
            distanceSeg.selectedSegmentIndex = 2
            zoom = 14
        } else if radius <= 1000.0 {
            distanceSeg.selectedSegmentIndex = 3
            zoom = 13
        }
        mapView.animate(toZoom: Float(zoom))
        if currentLocation?.latitude != nil {
            addCircle(currentLocation!)
        }
    }
}

