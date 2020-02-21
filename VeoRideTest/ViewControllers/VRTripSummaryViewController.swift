//
//  VRTripSummaryViewController.swift
//  VeoRideTest
//
//  Created by 江传林 on 2020/2/21.
//  Copyright © 2020 ChuanLin Jiang. All rights reserved.
//

import UIKit
import MapKit

class VRTripSummaryViewController: UIViewController, MKMapViewDelegate {
    
    var startCoordinate: CLLocationCoordinate2D!
    var destnCoordinate: CLLocationCoordinate2D!
    var route = MKRoute()
    
    var startDate: Date!
    var endDate: Date!
    
    private var mapView: MKMapView!
    private var durationStr = ""
    private var distanceStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupViews()
    }
    
    func setupData() {
                
        // Calculate trip time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let startTimeStr = dateFormatter.string(from: startDate)
        
        let startTimeStamp = startDate.timeIntervalSince1970
        let endTimeStamp = endDate.timeIntervalSince1970
        let duration = Int((endTimeStamp - startTimeStamp) / 60.0)
        durationStr = startTimeStr + "  " + "\(duration)" + "min"
        
        // Calculate mileage
        let mileage = Int(route.distance)
        distanceStr = "\(mileage)" + "m"
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        // Create stick to drop down and dismiss this viewController
        let stickView = UIView()
        view.addSubview(stickView)
        stickView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(45)
            make.height.equalTo(6)
        }
        stickView.backgroundColor = UIColor(hexCode: "F0F0F2")
        stickView.layer.cornerRadius = 3
        stickView.layer.masksToBounds = true

        
        // Create mapView
        mapView = MKMapView()
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(stickView).offset(30)
            make.left.equalTo(view).offset(25)
            make.right.equalTo(view).offset(-25)
            make.height.equalTo(200)
        }
        
        renderRouteOnMap()
        
        // Create infomation labels
        for i in 0 ..< 2 {
            // Title Label
            let titleLabel = UILabel()
            view.addSubview(titleLabel)
            
            let labelHeight = 30
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(25)
                make.width.equalTo(90)
                make.height.equalTo(labelHeight)
                make.top.equalTo(mapView.snp.bottom).offset(20 + labelHeight * i)
            }
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = UIColor(hexCode: "999999")
            titleLabel.text = i == 0 ? "Trip duration" : "Total stroke"
            
            // Content Label
            let contentLabel = UILabel()
            view.addSubview(contentLabel)
            
            contentLabel.snp.makeConstraints { (make) in
                make.left.equalTo(titleLabel.snp.right)
                make.right.equalTo(view).offset(-10)
                make.height.equalTo(titleLabel)
                make.top.equalTo(titleLabel)
            }
            contentLabel.font = UIFont.systemFont(ofSize: 14)
            contentLabel.textColor = UIColor(hexCode: "333333")
            contentLabel.text = i == 0 ? durationStr : distanceStr
        }
    }
    
    func renderRouteOnMap() {
        
        // Add annotations for start point and destination
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = startCoordinate
        startAnnotation.title = "Starting Point"
        mapView.addAnnotation(startAnnotation)
        
        let destnAnnotation = MKPointAnnotation()
        destnAnnotation.coordinate = destnCoordinate
        destnAnnotation.title = "Destination"
        mapView.addAnnotation(destnAnnotation)
        
        // Render route
        mapView.addOverlay(route.polyline)
        mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 40, left: 30, bottom: 40, right: 30), animated: true)
    }
    
    // MARK: MKMapViewDelegate Method
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor(hexCode: "58c080")
        return renderer
    }
}
