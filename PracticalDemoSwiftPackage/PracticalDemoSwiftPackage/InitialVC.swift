//
//  InitialVC.swift
//  PracticalDemoSwiftPackage
//
//  Created by Admin on 11/03/21.
//

import UIKit
import swiftPackageNetworkDemo
import CoreLocation

class InitialVC: UIViewController {
    
    var swiftPackage = swiftPackageNetworkDemo()
    
    var locationManager: CLLocationManager?
    
    let url = "https://httpbin.org/post"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        view.backgroundColor = .gray
    }

}


extension InitialVC : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager?.startUpdatingLocation()
            case .denied, .restricted:
                let alert = UIAlertController(title: "Location Services are disabled", message: "Please enable Location Services in your Settings", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                return
            default:
                print("Location not determine")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            swiftPackage.post(url: url, latlong: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude) { (res) in
                print(res)
                
                let alert = UIAlertController(title: "Success", message: "You location Updated successfully.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            print("Current location: \(currentLocation)")
            
            locationManager?.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
