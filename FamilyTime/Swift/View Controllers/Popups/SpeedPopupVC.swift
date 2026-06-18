//
//  SpeedPopupVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 27/03/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit
import MapKit

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}


class SpeedPopupVC: UIViewController {

    @IBOutlet weak var avatarImageVu:   UIImageView!
    
    
    @IBOutlet weak var nameLbl:         UILabel!
    @IBOutlet weak var timeLbl:         UILabel!
    @IBOutlet weak var limitLbl:        UILabel!
    @IBOutlet weak var currentSpeedLbl: UILabel!
    
    @IBOutlet weak var innerVu:         UIView!
//    @IBOutlet weak var mapview:       GMSMapView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var currentSpeedImageVu: UIImageView!
    
    var delegate        : AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = AppDelegate.getSharedAppDelegateForSwift()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        initialization()
//        appleMapSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK :- CUSTOM ACTIONS
    
    func initialization(){
        
        print("push model = \(delegate?.childPush ?? PushModel())")
        
//        let seconds  = NSDate.secondsDifferenceFromCurrent(toDateString: delegate?.childPush.time)
//        timeLbl.text = (seconds > 60) ? ((seconds > 3600) ? "\(seconds/3600) Hour Ago" : "\(seconds/60) Mins Ago")  : "\(seconds) Secs Ago"
        avatarImageVu.image = delegate?.childPush.gender == "female" ? #imageLiteral(resourceName: "popup_avatar_girl") : #imageLiteral(resourceName: "popup_avatar_boy")
        
        
        nameLbl.text         = delegate?.childPush.childName
        limitLbl.text        = "\(delegate?.childPush.speedLimit ?? "") mph"
        currentSpeedLbl.text = "\(delegate?.childPush.currentSpeed ?? "") mph"
        
//        setup()
        appleMapSetup()
    }
    
    func appleMapSetup()
    {

        
        let date: Date? = getUTCFormate(from: delegate?.childPush.time)
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        if let date = date {
            timeLbl.text = formatter.string(from: date)
        }
        

        
//        let sourcePin = customPin(pinTitle: "", pinSubTitle: "", location: sourceLocation)
//        let destinationPin = customPin(pinTitle: "", pinSubTitle: "", location: destinationLocation)
//        self.mapView.addAnnotation(sourcePin)
//        self.mapView.addAnnotation(destinationPin)
        
        
//        let sourcePin = customPin(pinTitle: "", pinSubTitle: "", location: sourceLocation)
//        self.mapView.addAnnotation(sourcePin)
        
        
        //---18 IS ZOOM LEVEL---//
//        let span: MKCoordinateSpan = MKCoordinateSpanMake(0, CLLocationDegrees(360 / pow(2, 15) * self.view.frame.size.width / 256))
//        self.mapView.setRegion(MKCoordinateRegionMake(sourcePin.coordinate, span), animated: true)
        
        addLocationMarkup(onMap: delegate?.childPush.startLatitude, lon: delegate?.childPush.startLongitude)
        
        if delegate?.childPush.pushType == "overSpeed"{
            
            currentSpeedLbl.textColor = UIColor.red
            currentSpeedImageVu.image =  #imageLiteral(resourceName: "red_car") //[UIImage imageNamed:@"red_car"];
            
            
//            let sourcePin = customPin(pinTitle: "", pinSubTitle: "", location: sourceLocation)
//            self.mapView.addAnnotation(sourcePin)
            
            
//            let marker = GMSMarker()
//            marker.icon = UIImage(named: "speed_pin")
//            marker.position = CLLocationCoordinate2DMake(startLat , startLong)
            
        }
        else
        {
            //---NORMAL SPEED---//
            
            currentSpeedLbl.textColor = UIColor.init(red: 61, green: 211, blue: 54) // color RGBCOLOR(61, 211, 54, 1);
            currentSpeedImageVu.image = #imageLiteral(resourceName: "green_car") //[UIImage imageNamed:@"green_car"];
            addLocationMarkup(onMap: delegate?.childPush.endLatitude, lon: delegate?.childPush.endLongitude)
            
//            let destinationPin = customPin(pinTitle: "", pinSubTitle: "", location: destinationLocation)
//            self.mapView.addAnnotation(destinationPin)
            
                    let startLat  = Double(delegate?.childPush.startLatitude ?? "0") ?? 0.0
                    let startLong = Double(delegate?.childPush.startLongitude ?? "0") ?? 0.0
            
                    let endLat  = Double(delegate?.childPush.endLatitude ?? "0") ?? 0.0
                    let endLong = Double(delegate?.childPush.endLongitude ?? "0") ?? 0.0
            
                    let sourceLocation =      CLLocationCoordinate2D(latitude:startLat, longitude: startLong)
                    let destinationLocation = CLLocationCoordinate2D(latitude:endLat, longitude: endLong)
            
            
            
            drawRoute(source: sourceLocation, destination: destinationLocation)
        }
        
        
        
    }
    
    
    
    func drawRoute(source:CLLocationCoordinate2D, destination:CLLocationCoordinate2D)
    {
        let sourcePlaceMark = MKPlacemark(coordinate: source)
        let destinationPlaceMark = MKPlacemark(coordinate: destination)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            //get route and assign to our route variable
            let route = directionResonse.routes[0]
            
            //add rout to our mapview
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            //setting rect of our mapview to fit the two locations
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
//    func getUTCFormateDate(_ localDate: Date?) -> String? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        var dateString: String? = nil
//        if let localDate = localDate {
//            dateString = dateFormatter.string(from: localDate)
//        }
//        print("\(dateString ?? "")")
//        return dateString
//    }
    
    func getUTCFormate(from localDate: String?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: Date? = dateFormatter.date(from: localDate ?? "")
        return date
    }


    /*
    
    func setup()
    {
        let date: Date? = getUTCFormate(from: delegate?.childPush.time)
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        if let date = date {
            timeLbl.text = formatter.string(from: date)
        }

        let startLat  = Double(delegate?.childPush.startLatitude ?? "0") ?? 0.0
        let startLong = Double(delegate?.childPush.startLongitude ?? "0") ?? 0.0
        
        mapview.clear()
        
            if delegate?.childPush.pushType == "overSpeed"{
                
                currentSpeedLbl.textColor = UIColor.red
                currentSpeedImageVu.image =  #imageLiteral(resourceName: "red_car") //[UIImage imageNamed:@"red_car"];
                
                
                let marker = GMSMarker()
                marker.icon = UIImage(named: "speed_pin")
                marker.position = CLLocationCoordinate2DMake(startLat , startLong)
                marker.map = mapview
                
//                let position = GMSCameraPosition.camera(withLatitude: startLat, longitude: startLong, zoom: 18)
//                mapview.camera = position
                
                let camera = GMSCameraPosition.camera(withLatitude: startLat, longitude: startLong, zoom: 18)
                mapview.camera = camera
            }
            else
            {
                currentSpeedLbl.textColor = UIColor.init(red: 61, green: 211, blue: 54) // color RGBCOLOR(61, 211, 54, 1);
                currentSpeedImageVu.image = #imageLiteral(resourceName: "green_car") //[UIImage imageNamed:@"green_car"];
                
                
//                let startLat  = Double(delegate?.childPush.startLatitude ?? "0") ?? 0.0
//                let startLong = Double(delegate?.childPush.startLongitude ?? "0") ?? 0.0
                
                let endLat  = Double(delegate?.childPush.endLatitude ?? "0") ?? 0.0
                let endLong = Double(delegate?.childPush.endLongitude ?? "0") ?? 0.0
                
//                mapview.clear()
                let markerEnd  = GMSMarker()
                markerEnd.icon = UIImage(named: "speed_pin")
                markerEnd.position = CLLocationCoordinate2DMake(endLat, endLong)
                markerEnd.map  = mapview

                
                let markerStart = GMSMarker()
                markerStart.icon = UIImage(named: "red_speed_pin")
                markerStart.position = CLLocationCoordinate2DMake(startLat, startLong)
                markerStart.map = mapview
                
                
                let camera = GMSCameraPosition.camera(withLatitude: endLat, longitude: endLong, zoom: 15)
                mapview.camera = camera
                
                
                let from = CLLocation(latitude: startLat, longitude: startLong)
                let to = CLLocation(latitude: endLat, longitude: endLong)
                drawRoute(from, destinationLocation: to)
            }
    }
    
    
    func drawRoute(_ startLocation: CLLocation?, destinationLocation: CLLocation?) {
        
        let origin = "\(startLocation?.coordinate.latitude ?? 0.0),\(startLocation?.coordinate.longitude ?? 0.0)"
        let destination = "\(destinationLocation?.coordinate.latitude ?? 0.0),\(destinationLocation?.coordinate.longitude ?? 0.0)"
        
        // TODO: inject Google Maps API key via Config.xcconfig (key blanked — removed from source)
        let mapsKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_API_KEY") as? String ?? ""
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(mapsKey)"
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray
                    self.mapview.clear()
                    
                    OperationQueue.main.addOperation({
                        for route in routes
                        {
                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                            let points   = routeOverviewPolyline.object(forKey: "points")
                            let path     = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 3
                            
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.mapview!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            
                            polyline.map = self.mapview
                            
                        }
                    })
                }catch let error as NSError{
                    print("error:\(error)")
                }
            }
        }).resume()
    }

    
    */

    
    
    //MARK :- UI ACTIONS
    
    @IBAction func closeAction(_ sender: Any) {
        //        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

}

extension SpeedPopupVC : MKMapViewDelegate
{
    //MARK:- MapKit delegates
    
    
    func addLocationMarkup(onMap lat: String?, lon: String?) {
//        mapView.removeAnnotations(mapView.annotations)
        
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: Double(lat ?? "0") ?? 0.0, longitude: Double(lon ?? "0") ?? 0.0)
        mapView.addAnnotation(pin)
        
        //---13 IS ZOOM LEVEL---//
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: CLLocationDegrees(360 / pow(2, 13) * self.view.frame.size.width / 256))
        mapView.setRegion(MKCoordinateRegion(center: pin.coordinate, span: span), animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth   = 4.0
        return renderer
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationIdentifier") as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "apploc")
            pinView?.canShowCallout = true
            pinView?.image = UIImage(named: "speed_pin")
        } else {
            pinView?.annotation = annotation
        }
        
        if delegate?.childPush.pushType == "normalSpeed"{
            let startLat  = Double(delegate?.childPush.startLatitude ?? "0") ?? 0.0
            let startLong = Double(delegate?.childPush.startLongitude ?? "0") ?? 0.0
            
//            let endLat  = Double(delegate?.childPush.endLatitude ?? "0") ?? 0.0
//            let endLong = Double(delegate?.childPush.endLongitude ?? "0") ?? 0.0
            
//            let sourceLocation      =      CLLocationCoordinate2D(latitude:startLat, longitude: startLong)
//            let destinationLocation = CLLocationCoordinate2D(latitude:endLat, longitude: endLong)
            
            if startLat == annotation.coordinate.latitude, startLong == annotation.coordinate.longitude{
                pinView?.image = UIImage(named: "speed_pin")
            }
            else{
                pinView?.image = UIImage(named: "over_speed_pin")
            }
        }
        
        return pinView
    }
}
