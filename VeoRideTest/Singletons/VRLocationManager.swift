//
//  VRLocationManager.swift
//  VeoRideTest
//
//  Created by 江传林 on 2020/2/19.
//  Copyright © 2020 ChuanLin Jiang. All rights reserved.
//

import UIKit
import MapKit

class VRLocationManager: NSObject, CLLocationManagerDelegate {
    
    private var manager = CLLocationManager()
    
    // MARK: Create or get the singleton
    static let shared = VRLocationManager()
    
    // Make sure the class has only one instance
    // Should not init or copy outside
    private override init() {}
    
    override func copy() -> Any {
        return self // SingletonClass.shared
    }
    
    override func mutableCopy() -> Any {
        return self // SingletonClass.shared
    }
    
    // MARK: Operation
    func enableLocationServices() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            manager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Remind user to authorize
//            showUnauthorizedAlertView()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
//            startUpdatingLocation()
            break
            
        default:
            break
        }
    }
    

    func startUpdatingLocation() {
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    func showUnauthorizedAlertView() {
        print("即将显示未被授权警告框")
        let message = "You have not granted location permission. You will not be able to use location and navigation functions."
        let currentVC = VRViewTool.topViewController!
        let btnTitle = "To setup"
        
        VRViewTool.showAlertView(title: "Alert", message: message, currentVC: currentVC, cancelHandler: nil, otherBtns: [btnTitle], otherHandler: { (index) in
            
            if let bundleId = Bundle.main.bundleIdentifier,
               let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        })
    }
    
    // MARK: CLLocationManagerDelegate Method
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            showUnauthorizedAlertView()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
            break
            
        case .notDetermined:
            break
            
        default:
            break
        }
        
        
    }
    
}
