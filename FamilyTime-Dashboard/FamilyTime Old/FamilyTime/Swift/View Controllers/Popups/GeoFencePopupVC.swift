//
//  GeoFencePopupVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 26/03/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit

class GeoFencePopupVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var avatarImageVu:       UIImageView!
    @IBOutlet weak var nameLbl:             UILabel!
    @IBOutlet weak var titleLbl:            UILabel!
    @IBOutlet weak var timeLbl:             UILabel!
    @IBOutlet weak var addressLbl:          UILabel!
    @IBOutlet weak var accuracyLbl:         UILabel!
    @IBOutlet weak var innerVu:             UIView!
    @IBOutlet weak var mapVu:               MKMapView!
    
    //MARK: - Variables
    var delegate : AppDelegate?
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = AppDelegate.getSharedAppDelegateForSwift()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        initialization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - IBActions
    @IBAction func closeAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "kGeofenceLatitude")
        UserDefaults.standard.removeObject(forKey: "kGeofenceLongitude")
        UserDefaults.standard.removeObject(forKey: "push_child_Time")
        UserDefaults.standard.removeObject(forKey: "push_child_gender")
        UserDefaults.standard.removeObject(forKey: "checkInChildName")
        UserDefaults.standard.removeObject(forKey: "push_child_address")
        UserDefaults.standard.removeObject(forKey: "push_child_accuracy")
        UserDefaults.standard.removeObject(forKey: "push_child_type")
        UserDefaults.standard.removeObject(forKey: "push_child_place")
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    func initialization(){
        //        let seconds  = NSDate.secondsDifferenceFromCurrent(toDateString: delegate?.childPush.time)
        //        timeLbl.text = (seconds > 60) ? ((seconds > 3600) ? "\(seconds/3600) Hour Ago" : "\(seconds/60) Mins Ago")  : "\(seconds) Secs Ago"
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.locale = Locale(identifier: "en_US_POSIX")
        let pushTime = UserDefaults.standard.string(forKey: "push_child_Time")
        if let time = pushTime {
            let push_date = df.date(from: time)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "hh:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            let pushTime = formatter.string(from: push_date ?? Date())
            timeLbl.text = pushTime
        }
        let gen = UserDefaults.standard.string(forKey: "push_child_gender")
        if let gender = gen {
            avatarImageVu.image = gender == "female" ? #imageLiteral(resourceName: "popup_avatar_girl") : #imageLiteral(resourceName: "popup_avatar_boy")
        }
        let name = UserDefaults.standard.string(forKey: "checkInChildName")  ?? ""
        nameLbl.text = name
//        if let childName = delegate?.childPush.childName {
//            nameLbl.text = childName
//        }
        
        let adr = UserDefaults.standard.string(forKey: "push_child_address")
        if let address = adr {
            addressLbl.text = address
        }
       // accuracyLbl.isHidden = true
        let accuracy = UserDefaults.standard.string(forKey: "push_child_accuracy")
        accuracyLbl.text    = "alert_check_in_content_2".localized+": \(accuracy ?? "")"
        
        let tpe = UserDefaults.standard.string(forKey: "push_child_type")
        if let pushType = tpe {
            let latitude = UserDefaults.standard.string(forKey: "kGeofenceLatitude")  ?? ""
            let longitude = UserDefaults.standard.string(forKey: "kGeofenceLongitude")  ?? ""
            let place = UserDefaults.standard.string(forKey: "push_child_place")
            if pushType == "checkin" {
               
                if let placeName = place {
                    let string = "alert_check_in_content_1".localized
                    let replaced = string.replacingOccurrences(of: "xyz", with: placeName)
                    titleLbl.text = replaced
                    addLocationMarkup(onMap: latitude, lon: longitude, name: placeName)
                }
            } else if pushType == "checkout" {
                if let placeName = place {
                    let string = "alert_check_out_content_1".localized
                    let replaced = string.replacingOccurrences(of: "xyz", with: placeName)
                    titleLbl.text = replaced
                    addLocationMarkup(onMap: latitude, lon: longitude, name: placeName)
                }
            }
        }
    }
    
}

// MARK: - MKMapViewDelegate
extension GeoFencePopupVC : MKMapViewDelegate {
    func addLocationMarkup(onMap lat: String?, lon: String?, name: String?) {
        mapVu.removeAnnotations(mapVu.annotations)
        let pin = MKPointAnnotation()
        pin.title = name
        pin.coordinate = CLLocationCoordinate2D(latitude: Double(lat ?? "0") ?? 0.0, longitude: Double(lon ?? "0") ?? 0.0)
        mapVu.addAnnotation(pin)
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: CLLocationDegrees(360 / pow(2, 18) * self.view.frame.size.width / 256))
        mapVu.setRegion(MKCoordinateRegion(center: pin.coordinate, span: span), animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationIdentifier") as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "apploc")
            pinView?.canShowCallout = true
            pinView?.image = UIImage(named: "v2_map_pin")
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
}
