//
//  TempVC.swift
//  OwnerApp
//
//  Created by Adam on 3/31/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class TempVC: BaseVC {
    let APPDELEGATE = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var timer: NSTimer?

    @IBOutlet weak var lblSpaModeDescription: UILabel!
    @IBOutlet weak var viewCurrentTemperature: UIView!
    @IBOutlet weak var viewSetTemperature: UIView!
    @IBOutlet weak var lblCurrentTemp: UILabel!
    @IBOutlet weak var lblSetTemp: UILabel!
    @IBOutlet weak var imgMarkSetTempLeft: UIImageView!
    @IBOutlet weak var imgMarkSetTempRight: UIImageView!
    @IBOutlet weak var imgMarkCurrentTemp: UIImageView!
    
    @IBOutlet weak var sliderTemperature: UISlider!
    @IBOutlet weak var btnTempInside: UIButton!
    
    @IBOutlet weak var lblAddress1: UILabel!
    @IBOutlet weak var lblWeatherTemp: UILabel!
    @IBOutlet weak var lblWeatherDescription: UILabel!
    
    @IBOutlet weak var imgWeather: UIImageView!
    
    @IBOutlet weak var viewControl1: UIView!
    @IBOutlet weak var viewControl2: UIView!
    @IBOutlet weak var viewControl3: UIView!
    @IBOutlet weak var viewControl4: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        viewControl1.layer.cornerRadius = 8.0
        viewControl1.layer.masksToBounds = true
        viewControl2.layer.cornerRadius = 8.0
        viewControl2.layer.masksToBounds = true
        viewControl3.layer.cornerRadius = 8.0
        viewControl3.layer.masksToBounds = true
        viewControl4.layer.cornerRadius = 8.0
        viewControl4.layer.masksToBounds = true
        
        //UISlider customization: Vertical, ThumbImage
        
        sliderTemperature.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        sliderTemperature.setThumbImage(UIImage(named: "TouchCircle"), forState: .Normal)
        if DeviceType.IS_IPAD || DeviceType.IS_IPAD_PRO {
            //For iPad
            let tFrame = btnTempInside.frame
            sliderTemperature.frame = CGRect(x: tFrame.origin.x, y: tFrame.origin.y-10, width: tFrame.size.width, height: tFrame.size.height+20)
            sliderTemperature.translatesAutoresizingMaskIntoConstraints = true
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = btnTempInside.layer.bounds
        gradientLayer.colors = [
            UIColor(red:245.0/255.0, green:0.0/255.0, blue: 29.0/255.0, alpha: 1.0).CGColor,
            UIColor(red:100.0/255.0, green:193.0/255.0, blue: 223.0/255.0, alpha: 1.0).CGColor
        ]
        gradientLayer.locations = [
            NSNumber(float: 0.0),
            NSNumber(float: 1.0)
        ]
        gradientLayer.cornerRadius = btnTempInside.layer.cornerRadius
        btnTempInside.layer.addSublayer(gradientLayer)
        
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipeRecognizer.direction = .Left
        leftSwipeRecognizer.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(leftSwipeRecognizer)
        
        //Tap gesture on controls
        //let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnSpaOff(_:)))
        //viewControl1.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(locationChanged), name: NOTIFICATION_LOCATION, object: nil)
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewDidAppear(animated: Bool) {
        timer = NSTimer.scheduledTimerWithTimeInterval(REFRESH_TIME_INTERVAL*12, target: self, selector: #selector(updateControls), userInfo: nil, repeats: true)
        self.onValueChanged(sliderTemperature)
        
        self.getSpaInfo()
        //self.getSpaInfoOffline()
        //APPDELEGATE.startUpdatingLocation()
    }
    override func viewDidDisappear(animated: Bool) {
        timer?.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
   

    // MARK: - Slider Event
    @IBAction func onValueChanged(sender: UISlider) {
        let trackRect = sender.trackRectForBounds(sender.bounds)
        let thumbRect = sender.thumbRectForBounds(sender.bounds, trackRect: trackRect, value: sender.value)
        viewSetTemperature.center = CGPointMake(viewSetTemperature.center.x,-thumbRect.origin.x + sender.frame.origin.y+sender.frame.size.height-12)
        imgMarkSetTempLeft.center = CGPointMake(imgMarkSetTempLeft.center.x,viewSetTemperature.center.y)
        imgMarkSetTempRight.center = CGPointMake(imgMarkSetTempRight.center.x,viewSetTemperature.center.y)
        lblSetTemp.text = String.localizedStringWithFormat("%.f°", sender.value)
   
    }
    
    @IBAction func onEditingDidEnd(sender: UISlider) {
        let temperature = Int(round(sender.value))
        callSetDesiredTemp(temperature)
    }
    
    // MARK: - Gesture Handler
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        let controlsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ControlsVC") as UIViewController
        self.slideMenuController()?.changeMainViewController(controlsVC, close: true)
        //self.actionNavigateTo(controlsVC)
    }
    func handleTapOnSpaOff(sender: UITapGestureRecognizer) {
        
        Utility.showMessage(self.view, text: "Please wait...")
        spaManager.requestRunSpaRecipe(spaManager.m_ID) { (status) in
            Utility.hideMessage(self.view)
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                print("Success in TurnSpaOff")
                //self._showAlert("The setting has been applied.")
                break
            default:
                print("Fail in TurnSpaOff")
                self._showAlert("Unable to turn SPA off.")
                break
            }
        }

    }
    // MARK: - Internal methods
    // Get color from gradient color
    func colorOfPoint(point: CGPoint)->UIColor {
        let pixel : [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGBitmapContextCreate(UnsafeMutablePointer(pixel), 1, 1, 8, 4, colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue)
        CGContextTranslateCTM(context, -point.x, -point.y)
        btnTempInside.layer .renderInContext(context!)
        let color = UIColor(red: CGFloat(pixel[0])/255.0, green: CGFloat(pixel[1])/255.0, blue: CGFloat(pixel[2])/255.0, alpha: CGFloat(pixel[3])/255.0)
        return color
        
        
    }
    
    func setCurrentTemperatureIndicator(sender: UISlider) {
        let trackRect = sender.trackRectForBounds(sender.bounds)
        let thumbRect = sender.thumbRectForBounds(sender.bounds, trackRect: trackRect, value: sender.value)
        
        viewCurrentTemperature.center = CGPointMake(viewCurrentTemperature.center.x,-thumbRect.origin.x + sender.frame.origin.y+sender.frame.size.height-12);
        imgMarkCurrentTemp.center = CGPointMake(imgMarkCurrentTemp.center.x,viewCurrentTemperature.center.y);
        lblCurrentTemp.text = String.localizedStringWithFormat("%.f°", sender.value)
        //lblCurrentTemp.textColor = colorOfPoint(CGPointMake(10, viewCurrentTemperature.center.y-btnTempInside.frame.origin.y))
        imgMarkCurrentTemp.backgroundColor = colorOfPoint(CGPointMake(10, viewCurrentTemperature.center.y-btnTempInside.frame.origin.y));
    }
    //RestAPI call
    func callSetDesiredTemp(temperature: Int) {
        spaManager.m_TargetDesiredTemp = temperature
        spaManager.requestControlSetDesiredTemp({ (status) in
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                print("SetDesiredTemp: Successful")
                if(self.spaManager.m_DesiredTemp > self.spaManager.m_CurrentTemp) {
                    self.lblSpaModeDescription.text = String.localizedStringWithFormat("The desired temperature is now %d°, your spa is warming up.", self.spaManager.m_DesiredTemp)
                } else {
                    self.lblSpaModeDescription.text = String.localizedStringWithFormat("The desired temperature is now %d°.", self.spaManager.m_DesiredTemp)
                }
                break
            default:
                print("SetDesiredTemp: Fail.")
                let okAction = UIAlertAction(title: "OK", style: .Default){(action) in
                    self.sliderTemperature.value = Float(self.spaManager.m_DesiredTemp)
                    self.onValueChanged(self.sliderTemperature)
                }
                self._showAlertWithAction("Error", strMsg: "Connection lost.", action: okAction)
                break
            }
        })
    }
    internal func getSpaInfo() {
        Utility.showMessage(self.view, text: "Loading...")
        spaManager.requestFindByUsername(BWGUserManager.sharedInstance.m_strUsername, callback: { (status) in
            Utility.hideMessage(self.view)
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                //Get Weather information according to Spa location
                self.weatherManager.lon = self.spaManager.m_Lon
                self.weatherManager.lat = self.spaManager.m_Lat
                self.getWeatherInfo()
                self._getGeoCode()

                if self.spaManager.m_CurrentTemp != 0 {
                    self.sliderTemperature.value = Float(self.spaManager.m_CurrentTemp)
                    self.setCurrentTemperatureIndicator(self.sliderTemperature)
                }
                if self.spaManager.m_DesiredTemp != 0 {
                    self.sliderTemperature.value = Float(self.spaManager.m_DesiredTemp)
                    self.onValueChanged(self.sliderTemperature)
                    
                    if(self.spaManager.m_DesiredTemp > self.spaManager.m_CurrentTemp) {
                        self.lblSpaModeDescription.text = String.localizedStringWithFormat("The desired temperature is now %d°, your spa is warming up.", self.spaManager.m_DesiredTemp)
                    } else {
                        self.lblSpaModeDescription.text = String.localizedStringWithFormat("The desired temperature is now %d°.", self.spaManager.m_DesiredTemp)
                    }
                }
                

                break
            default:
                print("Failed to get spa.")
                break
            }
        })
    }
    internal func getWeatherInfo() {
        self.weatherManager.requestWeatherWithCallback { (status) in
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                self.lblWeatherTemp.text = String.localizedStringWithFormat("%.f°", (self.weatherManager.temp-273.15)*1.8+32.0)
                self.lblWeatherDescription.text = self.weatherManager.weather_main
                self.imgWeather.image = UIImage(named: self.weatherManager.weather_icon)
                self._changeBackground()
                break
            case .ERROR_CONNECTION_FAILED:
                break
            default:
                print("Failed to get weather info")
                break
            }
        }
    }
    internal func _getGeoCode() {
        if self.spaManager.m_Lat == 0 && self.spaManager.m_Lon == 0 {
            return
        }
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.spaManager.m_Lat, longitude: self.spaManager.m_Lon)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            if placeMark == nil {
                print("Unable to get the address")
                return
            }
            // Address dictionary
            //print(placeMark.addressDictionary)
            //let address = placeMark.addressDictionary!["FormattedAddressLines"]
            //print(address![0])
            //print(address![1])
            //print(address![2])
            
            // Location name
            //let locationName = placeMark.addressDictionary!["Name"] as! String
            // Street address
            //let street = placeMark.addressDictionary!["Thoroughfare"] as! String
            
            var mcity: String
            var mstate: String
            var mzip: String
            // City
            if let city = placeMark.addressDictionary!["City"] as? String {
                mcity = city
            } else {
                return
            }
            // State
            if let state = placeMark.addressDictionary!["State"] as? String {
                mstate = state
            } else {
                return
            }
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? String {
                mzip = zip
            } else {
                return
            }
           
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? String {
                print(country)
            }
            self.spaManager.m_Location = mcity + ", " + mstate + " " + mzip
            self.lblAddress1.text = self.spaManager.m_Location
        })
    }
    
    // MARK: - Test with Offline data
    func getSpaInfoOffline() {
        let jsonFilePath: String = NSBundle.mainBundle().pathForResource("Sample", ofType: "json")!
        let jsonData:NSData = NSData(contentsOfFile: jsonFilePath)!
        let json = JSON(data: jsonData)
        spaManager.m_ID = json["_id"].stringValue
        spaManager.m_RunMode = json["currentState"]["runMode"].stringValue
        spaManager.m_CurrentTemp = json["currentState"]["currentTemp"].intValue
        spaManager.m_TargetDesiredTemp = json["currentState"]["targetDesiredTemp"].intValue
        spaManager.m_DesiredTemp = json["currentState"]["desiredTemp"].intValue
        
        spaManager.m_components.removeAll()
        let componentsState = json["currentState"]["components"].arrayValue
        for component in componentsState {
            if component["availableValues"].count != 0{
                spaManager.m_components.append(component)
            }
        }
        
        //Refresh UI

        if self.spaManager.m_CurrentTemp != 0 {
            self.sliderTemperature.value = Float(self.spaManager.m_CurrentTemp)
            self.setCurrentTemperatureIndicator(self.sliderTemperature)
        }
        if self.spaManager.m_DesiredTemp != 0 {
            self.sliderTemperature.value = Float(self.spaManager.m_DesiredTemp)
            self.onValueChanged(self.sliderTemperature)
        }
        
    }
    
    // MARK: - Timer
    func updateControls() {
        spaManager.requestFindByUsername(BWGUserManager.sharedInstance.m_strUsername, callback: { (status) in
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                if self.spaManager.m_CurrentTemp != 0 {
                    self.sliderTemperature.value = Float(self.spaManager.m_CurrentTemp)
                    self.setCurrentTemperatureIndicator(self.sliderTemperature)
                }
                if self.spaManager.m_DesiredTemp != 0 {
                    self.sliderTemperature.value = Float(self.spaManager.m_DesiredTemp)
                    self.onValueChanged(self.sliderTemperature)
                    if(self.spaManager.m_DesiredTemp > self.spaManager.m_CurrentTemp) {
                        self.lblSpaModeDescription.text = String.localizedStringWithFormat("The desired temperature is now %d°, your spa is warming up.", self.spaManager.m_DesiredTemp)
                    } else {
                        self.lblSpaModeDescription.text = String.localizedStringWithFormat("The desired temperature is now %d°.", self.spaManager.m_DesiredTemp)
                    }
                }
                
                break
            case .ERROR_INVALID_REQUEST: //Token expires.
                self._showSessionExpiredAlert()
                break
            default:
                print("Failed to get spa.")
                break
            }
        })

    }
    
    // MARK: - Click Event
    @IBAction func onClickMenu(sender: AnyObject) {
        self.toggleLeft()
    }
    @IBAction func onClickSpaOff(sender: AnyObject) {
        Utility.showMessage(self.view, text: "Please wait...")
        spaManager.requestRunSpaRecipe(spaManager.m_ID) { (status) in
            Utility.hideMessage(self.view)
            switch status {
            case .SUCCESS_WITH_NO_ERROR:
                print("Success in TurnSpaOff")
                //self._showAlert("The setting has been applied.")
                break
            default:
                print("Fail in TurnSpaOff")
                self._showAlert("Unable to turn SPA off.")
                break
            }
        }
    }
    
    @IBAction func onClickSpaControls(sender: AnyObject) {
        let controlsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ControlsVC") as UIViewController
        
        let leftVC = self.slideMenuController()?.leftViewController as? LeftVC
        let indexPath = NSIndexPath(forRow: LeftMenu.ControlsVC.rawValue, inSection: 0)
        leftVC?.tblMenu.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
        
        self.slideMenuController()?.changeMainViewController(controlsVC, close: true)
    }
    
    @IBAction func onClickNetworkSettings(sender: AnyObject) {
        //let networkVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NetworkSettingsVC") as UIViewController
        //More proper way???
        let leftVC = self.slideMenuController()?.leftViewController as? LeftVC
        let networkVC = leftVC?.networkSettingsVC as! NetworkSettingsVC
        
        let indexPath = NSIndexPath(forRow: LeftMenu.NetworkSettingsVC.rawValue, inSection: 0)
        leftVC?.tblMenu.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
        
        self.slideMenuController()?.changeMainViewController(networkVC, close: true)
    }
    @IBAction func onClickYourAccount(sender: AnyObject) {
        let accountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AccountVC") as UIViewController
        
        let leftVC = self.slideMenuController()?.leftViewController as? LeftVC
        let indexPath = NSIndexPath(forRow: LeftMenu.AccountVC.rawValue, inSection: 0)
        leftVC?.tblMenu.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
        
        self.slideMenuController()?.changeMainViewController(accountVC, close: true)

    }
    
    
    // MARK: - NOTIFICATION_LOCATION
    func locationChanged(notification: NSNotification)
    {
        let userinfo = notification.userInfo
        let lat = userinfo!["latitude"] as! Double
        let lon = userinfo!["longitude"] as! Double
        print(lat, lon)
        weatherManager.lon = lon
        weatherManager.lat = lat
        self.getWeatherInfo()
        APPDELEGATE.stopUpdatingLocation()
        
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
