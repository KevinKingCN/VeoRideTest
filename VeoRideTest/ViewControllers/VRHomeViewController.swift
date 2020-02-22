//
//  VRHomeViewController.swift
//  VeoRideTest
//
//  Created by 江传林 on 2020/2/19.
//  Copyright © 2020 ChuanLin Jiang. All rights reserved.
//

import UIKit
import MapKit

class VRHomeViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var startBtn: UIButton?
    var destnAnnotation: MKPointAnnotation?
    
    var isFirstLocation = true  // The first time to get user location
    var isNavigating = false    // Navigation is in progress
    var userLocation = CLLocation(latitude: 41.883497, longitude: -87.664066) // Default is Chicago
    
    var startDate: Date?    // Date of starting navigation
    var startLocation = CLLocation() // Location of start point
    var route = MKRoute()   // Route of navigation

    override func viewDidLoad() {
        super.viewDidLoad()

        VRLocationManager.shared.enableLocationServices()
        setupMapView()
    }
    
    func setupMapView() {
        
        // Create mapView
        mapView = MKMapView()
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        // Setup mapView
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        
        let latDelta = 0.005
        let longDelta = 0.005
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
        
        // Add tap gesture for adding destination annotation
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        mapView.addGestureRecognizer(tap)
        
        // Avoid conflicts with double tap zoom gestures
        let gestures = mapView.subviews.first?.gestureRecognizers
        for recognizer in gestures ?? [] {
            if (recognizer is UITapGestureRecognizer) {
                let doubleTap = recognizer as! UITapGestureRecognizer
                if doubleTap.numberOfTapsRequired == 2 {
                    tap.require(toFail: doubleTap)
                }
            }
        }

    }
    
    func setupStartButton() {

        let startBtn = UIButton(type: .custom)
        self.startBtn = startBtn
        view.addSubview(startBtn)
        
        let btnHeight: CGFloat = 45.0
        startBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.height.equalTo(btnHeight)
            make.width.equalTo(90)
            make.bottom.equalTo(view).offset(-50)
        }
        
        startBtn.layer.cornerRadius = btnHeight * 0.5
        startBtn.layer.masksToBounds = true
        
        startBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        startBtn.setTitle("Start", for: .normal)
        startBtn.setTitleColor(.white, for: .normal)
        startBtn.setBackgroundImage(UIImageWithColor(UIColor(hexCode: "52b5aa")), for: .normal)
        startBtn.addTarget(self, action: #selector(startAction), for: .touchUpInside)
    }
    
    // MARK: User interaction events
    @objc func tapAction(tap: UITapGestureRecognizer)
    {
        if isNavigating {
            return
        }
        
        if destnAnnotation != nil {
            // Remove remaining annotation
            mapView.removeAnnotation(destnAnnotation!)
        }
        
        // Add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapView.convert(tap.location(in: mapView), toCoordinateFrom: mapView)
        annotation.title = "Go there"
        mapView.addAnnotation(annotation)
        
        destnAnnotation = annotation
        
        // Show start button
        if startBtn != nil {
            startBtn!.isHidden = false
        }
        else {
            setupStartButton()
        }
    }
    
    @objc func startAction() {
        
        isNavigating = true
        startDate = Date()
        startLocation = userLocation
        requestToNavigate()
        
        // Change start button to exit button
        let button = startBtn!
        button.snp.updateConstraints { (make) in
            make.width.equalTo(150)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {[weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
        
        button.setTitle("Exit navigation", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.setBackgroundImage(UIImageWithColor(.white), for: .normal)
        button.removeTarget(self, action: #selector(startAction), for: .touchUpInside)
        button.addTarget(self, action: #selector(exitAction), for: .touchUpInside)
    }
    
    @objc func exitAction() {
        
        isNavigating = false
        startBtn!.removeFromSuperview()
        mapView.removeAnnotation(destnAnnotation!)
        mapView.removeOverlay(route.polyline)
        
        startBtn = nil
        startDate = nil
        destnAnnotation = nil
    }
    
    // MARK: Navigation
    func requestToNavigate() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destnAnnotation!.coordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .walking

        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] (response, error) in
            
            if error != nil || response == nil || response!.routes.count <= 0 {
                // Failed and tell the user
                let message = "Sorry, we couldn't get the navigation route. You can try other places."
                VRViewTool.showAlertView(title: "Failed", message: message, currentVC: self, cancelHandler: { (action) in
                    self.exitAction()
                }, otherBtns: nil, otherHandler: nil)
                
                return
            }
            
            let route = response!.routes.first!
            self.route = route
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                           edgePadding: UIEdgeInsets(top: 70, left: 50, bottom: 130, right: 50),
                                           animated: true)
        }
    }
    
    func finishNavigating() {
        
        let vc = VRTripSummaryViewController()
        vc.startCoordinate = startLocation.coordinate
        vc.destnCoordinate = destnAnnotation!.coordinate
        vc.route = route
        vc.startDate = startDate
        vc.endDate = Date()
        
        present(vc, animated: true) { [weak self] in
            self?.exitAction()
        }
    }
    
    // MARK: MKMapViewDelegate Method
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let coordinate = userLocation.coordinate
        if coordinate.latitude == 0 && coordinate.longitude == 0 {
            return
        }
        
        if isFirstLocation {
            mapView.setCenter(userLocation.coordinate, animated: false)
            isFirstLocation = false
        }
        
        if isNavigating {
            // Keep the user's position in the center of the screen during navigation
            mapView.setCenter(userLocation.coordinate, animated: true)
        }
        
        self.userLocation = userLocation.location ?? self.userLocation
        
        if isNavigating {
            let destnCoordinate = destnAnnotation!.coordinate
            let destnLocation = CLLocation(latitude: destnCoordinate.latitude, longitude: destnCoordinate.longitude)
            let distance = self.userLocation.distance(from: destnLocation)
            
            // When within 6 meters of the destination, complete the navigation.
            if distance <= 6.0 {
                finishNavigating()
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor(hexCode: "58c080")
        return renderer
    }
}
