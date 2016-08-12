//
//  LocationVC.swift
//  OwnerApp
//
//  Created by Star Developer on 5/11/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import MapKit

class LocationVC: BaseVC, MKMapViewDelegate {
    let APPDELEGATE = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnUpdate: UIButton!
    
    var location = CLLocation(latitude: 0,longitude: 0)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(locationChanged), name: NOTIFICATION_LOCATION, object: nil)
        
        btnUpdate.layer.cornerRadius = 8.0
        btnUpdate.layer.borderWidth = 1.0
        btnUpdate.layer.borderColor = UIColor.whiteColor().CGColor
        btnUpdate.layer.masksToBounds = true
        
        let spaLocation = CLLocationCoordinate2DMake(spaManager.m_Lat, spaManager.m_Lon)
        // Drop a pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = spaLocation
        dropPin.title = "Spa Location"
        mapView.addAnnotation(dropPin)
        mapView.selectAnnotation(dropPin, animated: true)
        mapView.showsUserLocation = true
        
        
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        APPDELEGATE.startUpdatingLocation()
        self._changeBackground()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickMenu(sender: AnyObject) {
        self.toggleLeft()
    }
    @IBAction func onClickUpdate(sender: AnyObject) {
        self.spaManager.m_Lat = location.coordinate.latitude
        self.spaManager.m_Lon = location.coordinate.longitude
        spaManager.requestSaveSpaDetails({ (status) in
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                print("Successfully updated spa location.")
                break
            case .ERROR_INVALID_REQUEST: //Token expires.
                self._showSessionExpiredAlert()
                break
            default:
                print("Failed to update spa location.")
                break
            }
        })
    }

    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - NOTIFICATION_LOCATION
    func locationChanged(notification: NSNotification)
    {
        let userinfo = notification.userInfo
        let lat = userinfo!["latitude"] as! CLLocationDegrees
        let lon = userinfo!["longitude"] as! CLLocationDegrees
        print(lat, lon)
        APPDELEGATE.stopUpdatingLocation()
        location = CLLocation(latitude: lat, longitude: lon)
        
        self.centerMapOnLocation(location)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
