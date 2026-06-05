//
//  SwiftSpeedAlertsViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 08/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import GoogleMaps

class SwiftSpeedAlertsViewController: UIViewController, GMSMapViewDelegate {
    
    var speedLimitLabelTitleTopMargin = NSLayoutConstraint()
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var accuracyBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var overspeedLabelTopMargin: NSLayoutConstraint!
    @IBOutlet weak var nameLabelTopMargin: NSLayoutConstraint!
    @IBOutlet weak var currentSpeedLabelTitleTopMargin: NSLayoutConstraint!
    @IBOutlet weak var blueCarLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var currentSpeedLabelRightMargin: NSLayoutConstraint!
    @IBOutlet weak var okButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatraWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var accuracyLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var overspeedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var avatraImageView: UIImageView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var currentSpeedCarImageView: UIImageView!
    @IBOutlet weak var speedLimitTitleLabel: UILabel!
    @IBOutlet weak var currentSpeedTitleLabel: UILabel!
    @IBOutlet weak var currentSpeedLabel: UILabel!
    @IBOutlet weak var speedLimitLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if IS_IPHONE_4() {
            view.frame = CGRect(x: 0.0, y: 0.0, width: 270.0, height: 420.0)
            avatarHeightConstraint.constant = 54
            avatraWidthConstraint.constant = 54
            nameLabelTopMargin.constant = 5
            accuracyBottomMargin.constant = 10
            okButtonHeightConstraint.constant = 40
            blueCarLeftMargin.constant = 10
            currentSpeedLabelRightMargin.constant = 10
            accuracyLabelHeight.constant = 17
            addressLabelHeight.constant = 17
            speedLimitLabelTitleTopMargin.constant = -5
            currentSpeedLabelTitleTopMargin.constant = -5

            nameLabel.font = UIFont(name: "OpenSans", size: 16)
            timeLabel.font = UIFont(name: "OpenSans-Light", size: 12)
            overspeedLabel.font = UIFont(name: "OpenSans-Light", size: 12)
            addressLabel.font = UIFont(name: "OpenSans-Light", size: 11)
            accuracyLabel.font = UIFont(name: "OpenSans-Light", size: 12)
            speedLimitLabel.font = UIFont(name: "OpenSans", size: 16)
            speedLimitTitleLabel.font = UIFont(name: "OpenSans-Light", size: 10)
            currentSpeedLabel.font = UIFont(name: "OpenSans", size: 16)
            currentSpeedTitleLabel.font = UIFont(name: "OpenSans-Light", size: 10)
        } else if IS_IPHONE_5() {
            view.frame = CGRect(x: 0.0, y: 0.0, width: 270.0, height: 420.0)
            avatarHeightConstraint.constant = 54
            avatraWidthConstraint.constant = 54
            nameLabelTopMargin.constant = 5
            accuracyBottomMargin.constant = 10
            okButtonHeightConstraint.constant = 40
            blueCarLeftMargin.constant = 10
            currentSpeedLabelRightMargin.constant = 10
            accuracyLabelHeight.constant = 17
            addressLabelHeight.constant = 17
            speedLimitLabelTitleTopMargin.constant = -5
            currentSpeedLabelTitleTopMargin.constant = -5

            nameLabel.font = UIFont(name: "OpenSans", size: 16)
            timeLabel.font = UIFont(name: "OpenSans-Light", size: 12)
            overspeedLabel.font = UIFont(name: "OpenSans-Light", size: 12)
            addressLabel.font = UIFont(name: "OpenSans-Light", size: 11)
            accuracyLabel.font = UIFont(name: "OpenSans-Light", size: 12)
            speedLimitLabel.font = UIFont(name: "OpenSans", size: 16)
            speedLimitTitleLabel.font = UIFont(name: "OpenSans-Light", size: 10)
            currentSpeedLabel.font = UIFont(name: "OpenSans", size: 16)
            currentSpeedTitleLabel.font = UIFont(name: "OpenSans-Light", size: 10)
            
        } else if IS_IPHONE_6() {
            view.frame = CGRect(x: 0.0, y: 0.0, width: 317.0, height: 450.0)
            avatarHeightConstraint.constant = 72
            avatraWidthConstraint.constant = 72
            nameLabelTopMargin.constant = 5
            accuracyBottomMargin.constant = 15
            okButtonHeightConstraint.constant = 46
            blueCarLeftMargin.constant = 20
            currentSpeedLabelRightMargin.constant = 20
            accuracyLabelHeight.constant = 17
            addressLabelHeight.constant = 17
            speedLimitLabelTitleTopMargin.constant = -5
            currentSpeedLabelTitleTopMargin.constant = -5

            nameLabel.font = UIFont(name: "OpenSans", size: 18)
            timeLabel.font = UIFont(name: "OpenSans-Light", size: 14)
            overspeedLabel.font = UIFont(name: "OpenSans-Light", size: 13)
            addressLabel.font = UIFont(name: "OpenSans-Light", size: 13)
            accuracyLabel.font = UIFont(name: "OpenSans-Light", size: 14)
            speedLimitLabel.font = UIFont(name: "OpenSans", size: 18)
            speedLimitTitleLabel.font = UIFont(name: "OpenSans-Light", size: 10)
            currentSpeedLabel.font = UIFont(name: "OpenSans", size: 18)
            currentSpeedTitleLabel.font = UIFont(name: "OpenSans-Light", size: 10)
            
        } else if IS_IPHONE_6_PLUS() {
            view.frame = CGRect(x: 0.0, y: 0.0, width: 350.0, height: 500.0)
            avatarHeightConstraint.constant = 72
            avatraWidthConstraint.constant = 72
            nameLabelTopMargin.constant = 5
            accuracyBottomMargin.constant = 15
            okButtonHeightConstraint.constant = 52
            speedLimitLabelTitleTopMargin.constant = -5
            currentSpeedLabelTitleTopMargin.constant = -5
            
            nameLabel.font = UIFont(name: "OpenSans", size: 20)
            timeLabel.font = UIFont(name: "OpenSans-Light", size: 15)
            overspeedLabel.font = UIFont(name: "OpenSans-Light", size: 12)
            addressLabel.font = UIFont(name: "OpenSans-Light", size: 14)
            accuracyLabel.font = UIFont(name: "OpenSans-Light", size: 15)
            speedLimitLabel.font = UIFont(name: "OpenSans", size: 20)
            speedLimitTitleLabel.font = UIFont(name: "OpenSans-Light", size: 13)
            currentSpeedLabel.font = UIFont(name: "OpenSans", size: 20)
            currentSpeedTitleLabel.font = UIFont(name: "OpenSans-Light", size: 13)
        } else if IS_IPHONE_X() {
            view.frame = CGRect(x: 0.0, y: 0.0, width: 350.0, height: 500.0)
            avatarHeightConstraint.constant = 72
            avatraWidthConstraint.constant = 72
            nameLabelTopMargin.constant = 5
            accuracyBottomMargin.constant = 15
            okButtonHeightConstraint.constant = 52
            speedLimitLabelTitleTopMargin.constant = -5
            currentSpeedLabelTitleTopMargin.constant = -5
            
            nameLabel.font = UIFont(name: "OpenSans", size: 20)
            timeLabel.font = UIFont(name: "OpenSans-Light", size: 15)
            overspeedLabel.font = UIFont(name: "OpenSans-Light", size: 12)
            addressLabel.font = UIFont(name: "OpenSans-Light", size: 14)
            accuracyLabel.font = UIFont(name: "OpenSans-Light", size: 15)
            speedLimitLabel.font = UIFont(name: "OpenSans", size: 20)
            speedLimitTitleLabel.font = UIFont(name: "OpenSans-Light", size: 13)
            currentSpeedLabel.font = UIFont(name: "OpenSans", size: 20)
            currentSpeedTitleLabel.font = UIFont(name: "OpenSans-Light", size: 13)
        } else {
            
            view.frame = CGRect(x: 0.0, y: 0.0, width: 525.0, height: 715.0)
            avatarHeightConstraint.constant = 116
            avatraWidthConstraint.constant = 116
            nameLabelTopMargin.constant = 30
            accuracyBottomMargin.constant = 20
            okButtonHeightConstraint.constant = 78
            overspeedLabelTopMargin.constant = 10
            blueCarLeftMargin.constant = 50
            currentSpeedLabelRightMargin.constant = 50
            accuracyLabelHeight.constant = 25
            addressLabelHeight.constant = 25
            accuracyBottomMargin.constant = 25
            speedLimitLabelTitleTopMargin.constant = 5
            currentSpeedLabelTitleTopMargin.constant = 5

            nameLabel.font = UIFont(name: "OpenSans", size: 27)
            timeLabel.font = UIFont(name: "OpenSans-Light", size: 22)
            overspeedLabel.font = UIFont(name: "OpenSans-Light", size: 16)
            addressLabel.font = UIFont(name: "OpenSans-Light", size: 20)
            accuracyLabel.font = UIFont(name: "OpenSans-Light", size: 21)
            speedLimitLabel.font = UIFont(name: "OpenSans", size: 36)
            speedLimitTitleLabel.font = UIFont(name: "OpenSans-Light", size: 16)
            currentSpeedLabel.font = UIFont(name: "OpenSans", size: 36)
            currentSpeedTitleLabel.font = UIFont(name: "OpenSans-Light", size: 16)
            okButton.titleLabel?.font = UIFont(name: "OpenSans", size: 22)
        }
    }
    
    func setupData(_ childId: Int, childName: String?, isSon: Bool, startLatitude: Double, startLongitude: Double, endLatitude: Double, endLongitude: Double, speedLimit speedlimit: Int, currentSpeed: Int, address: String?, accuracy: String?, isOverSpeed: Bool, alertTime: String?) {
        
        avatraImageView.image = isSon ? UIImage(named: "avatar_boy1") : UIImage(named: "avatar_girl1")
        nameLabel.text = childName
        let date = getUTCFormate(from: alertTime)
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        if let date = date {
            timeLabel.text = formatter.string(from: date)
        }
        
        if isOverSpeed {
            overspeedLabel.text = "\(childName ?? "") is over speeding"
            currentSpeedLabel.textColor = UIColor.red
            currentSpeedCarImageView.image = UIImage(named: "red_car")
            
            mapview.clear()
            let marker = GMSMarker()
            marker.icon = UIImage(named: "speed_pin")
            marker.position = CLLocationCoordinate2DMake(startLatitude, startLongitude)
            marker.map = mapview
            
            let position = GMSCameraPosition.camera(
                withLatitude: startLatitude,
                longitude: startLongitude,
                zoom: 15)
            mapview.camera = position
            
            let camera = GMSCameraPosition.camera(withLatitude: startLatitude, longitude: startLongitude, zoom: 15)
            mapview.camera = camera
        } else {
            overspeedLabel.text = "\(childName ?? "") is back to normal speed"
            currentSpeedLabel.textColor = RGBCOLOR(61, 211, 54, 1)
            currentSpeedCarImageView.image = UIImage(named: "green_car")
            
            mapview.clear()
            let markerEnd = GMSMarker()
            markerEnd.icon = UIImage(named: "speed_pin")
            markerEnd.position = CLLocationCoordinate2DMake(endLatitude, endLongitude)
            markerEnd.map = mapview
            
            let markerStart = GMSMarker()
            markerStart.icon = UIImage(named: "red_speed_pin")
            markerStart.position = CLLocationCoordinate2DMake(startLatitude, startLongitude)
            markerStart.map = mapview
            
            let position = GMSCameraPosition.camera(
                withLatitude: endLatitude,
                longitude: endLongitude,
                zoom: 15)
            mapview.camera = position
            
            let camera = GMSCameraPosition.camera(withLatitude: endLatitude, longitude: endLongitude, zoom: 15)
            mapview.camera = camera
            
            let from = CLLocation(latitude: startLatitude, longitude: startLongitude)
            let to = CLLocation(latitude: endLatitude, longitude: endLongitude)
            drawRoute(from, to: to)
        }
        currentSpeedLabel.text = String(format: "\(Int(currentSpeed)) kph")
        speedLimitLabel.text = String(format: "\(Int(speedlimit)) kph")
        accuracyLabel.text = "Accuracy: \(accuracy ?? "")"
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: startLatitude, longitude: startLongitude)
        
        geoCoder.reverseGeocodeLocation(location) { [self] placemarks, error in
            if error == nil {
                var locationGeoCode = getDesiredReverseGeoCodeString(placemarks)
                locationGeoCode = locationGeoCode?.trimmingCharacters(in: CharacterSet.whitespaces)
                addressLabel.text = locationGeoCode
            }
        }
    }
    
    func drawRoute(_ from: CLLocation?, to: CLLocation?) {
        
        self.fetchPolyline(withOrigin: from, destination: to) { polyline in
            if (polyline != nil) {
                polyline?.map = self.mapview
            }
            
            let array = [[
                "latitude" : "\(from?.coordinate.latitude ?? 0)",
                "longitude" : "\(from?.coordinate.longitude ?? 0)"
            ], [
                "latitude" : "\(to?.coordinate.latitude ?? 0)",
                "longitude" : "\(to?.coordinate.longitude ?? 0)"
            ]]
            
            var bounds = GMSCoordinateBounds()
            var location = CLLocationCoordinate2D()
            for dictionary in array {
                location.latitude = CLLocationDegrees(Double(dictionary["latitude"] ?? "") ?? 0.0)
                location.longitude = CLLocationDegrees(Double(dictionary["longitude"] ?? "") ?? 0.0)
                bounds = bounds.includingCoordinate(CLLocationCoordinate2DMake(location.latitude, location.longitude))
            }
        }
    }
    
    func fetchPolyline(withOrigin origin: CLLocation?, destination: CLLocation?, completionHandler: @escaping (GMSPolyline?) -> Void) {
        
        let originString = "\(origin?.coordinate.latitude ?? 0),\(origin?.coordinate.longitude ?? 0)"
        let destinationString = "\(destination?.coordinate.latitude ?? 0),\(destination?.coordinate.longitude ?? 0)"
        let directionsAPI = "https://maps.googleapis.com/maps/api/directions/json?"
        let directionsUrlString = "\(directionsAPI)&origin=\(originString)&destination=\(destinationString)&mode=driving"
        let directionsUrl = URL(string: directionsUrlString)!
        URLSession.shared.dataTask(with: directionsUrl) { data, response, error in
            
            var json: [AnyHashable : Any]? = nil
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: []) as? [AnyHashable : Any]
            } catch {
                print("Error parsing data")
            }
            if error != nil {
                completionHandler(nil)
                return
            }
            
            let routesArray = json?["routes"] as? [AnyHashable]
            var polyline: GMSPolyline? = nil
            
            DispatchQueue.main.async {
                if routesArray!.count > 0 {
                    let routeDict = routesArray?[0] as? [AnyHashable : Any]
                    let routeOverviewPolyline = routeDict?["overview_polyline"] as? [AnyHashable : Any]
                    let points = routeOverviewPolyline?["points"] as? String
                    let path = GMSPath(fromEncodedPath: points!)
                    polyline = GMSPolyline(path: path)
                    polyline?.strokeColor = RGBCOLOR(35, 183, 229, 1)
                    polyline?.strokeWidth = 5
                }
                completionHandler(polyline)
            }
        }.resume()
    }
    
    func getDesiredReverseGeoCodeString(_ placeMarkers: [AnyHashable]?) -> String? {
        let placeMarker = placeMarkers?.last as? CLPlacemark
        var textString = "\(placeMarker?.subThoroughfare ?? ""), \(placeMarker?.thoroughfare ?? ""), \(placeMarker?.postalCode ?? ""), \(placeMarker?.locality ?? ""), \(placeMarker?.administrativeArea ?? ""), \(placeMarker?.country ?? "")"
        
        textString = textString.replacingOccurrences(
            of: "(null),",
            with: "")
        return textString
    }
    
    func getUTCFormateDate(_ localDate: Date?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var dateString: String? = nil
        if let localDate = localDate {
            dateString = dateFormatter.string(from: localDate)
        }
        print("\(dateString ?? "")")
        return dateString
    }
    
    func getUTCFormate(from localDate: String?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.date(from: localDate ?? "")
        return dateString
    }
    
    @IBAction func handleOkButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
