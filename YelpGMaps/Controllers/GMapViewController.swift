//
//  GMapViewController.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 31.05.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import UIKit
import GoogleMaps

class GMapViewController: ParentViewController {
    
    var locationManager = CLLocationManager()
    
    var selectedBusiness: Business!
    
    var scaleChangedBySlider: Bool = false
    
    var isCurrentLocationDefined = false
    
    var markersDict = Dictionary<String, GMSMarker>()
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var segmentedContainer: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var scaleSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.configureSegmentedControl()
        self.configureScaleSlider()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        self.mapView.delegate = self
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !self.isCurrentLocationDefined {
            let currentUserLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
            self.mapView.camera = GMSCameraPosition.camera(withTarget: currentUserLocation.coordinate, zoom: Float(CurrentValues.currentSettings.scale))
            self.mapView.settings.myLocationButton = true
            self.isCurrentLocationDefined = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CurrentValues.isDataNeedToReload {
            self.loadData()
            CurrentValues.isDataNeedToReload = false
        }
    }
    
    @IBAction func segmentSelectionChanged(_ sender: Any) {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = .normal
            break
        case 1:
            self.mapView.mapType = .terrain
            break
        case 2:
            self.mapView.mapType = .hybrid
            break
        default:
            break
        }
    }
    
    func configureSegmentedControl() {
        self.segmentedContainer.backgroundColor = GlobalConstants.Color.primaryDark
        self.segmentedControl.setTitle("Normal", forSegmentAt: 0)
        self.segmentedControl.setTitle("Terrain", forSegmentAt: 1)
        self.segmentedControl.setTitle("Hybrid", forSegmentAt: 2)
    }
    
    func configureScaleSlider() {
        self.scaleSlider.thumbTintColor = GlobalConstants.Color.primaryDark
        self.scaleSlider.tintColor = GlobalConstants.Color.primaryDark
        self.scaleSlider.minimumValue = kGMSMinZoomLevel
        self.scaleSlider.maximumValue = kGMSMaxZoomLevel
        
        let scale = Float(CurrentValues.currentSettings.scale)
        self.scaleSlider.value = scale
        self.mapView.camera = GMSCameraPosition.camera(withTarget: self.mapView.camera.target, zoom: scale)
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowSettings", sender: self)
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        self.loadData()
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        self.scaleChangedBySlider = true
        let zoom = self.scaleSlider.value
        CurrentValues.mapScaling = Int(zoom)
        self.mapView.animate(toZoom: zoom)
    }
    
    @IBAction func showReportButtonTapped(_ sender: Any) {
        let reportAlert = ReportView(frame: CGRect(x: 0, y: 0, width: 280, height: 180))
        self.showCustomAlert(view: reportAlert, isOverlayTransparent: false)
    }
    
    func setuplocationMarker(business: Business) -> GMSMarker? {
        
        if let coordinate = business.coordinate {
            let locationMarker = GMSMarker(position: coordinate)
            
            locationMarker.appearAnimation = .pop
            locationMarker.icon = GMSMarker.markerImage(with: UIColor.blue)
            locationMarker.opacity = 0.75
            
            let userData = ["business": business]
            locationMarker.userData = userData
            locationMarker.map = self.mapView
            return locationMarker
        }
        return nil
    }
    
    func loadData() {
        let lat = self.mapView.camera.target.latitude
        
        let lng = self.mapView.camera.target.longitude
        
        DataService.sharedInstance.loadBusinessesForLatLong(latitude: Double(lat), longitude: Double(lng), successHandler: { array in
            
            var newBusinessesDict = Dictionary<String, Business>()
            for item in array {
                let business = Business(json: item)
                if let id = business.id {
                    newBusinessesDict[id] = business
                }
                
            }
            let newIds = Set(newBusinessesDict.map { $0.key })
            let oldIds = Set(self.markersDict.map { $0.key })

            let toDelete = oldIds.subtracting(newIds)
            let toAdd = newIds.subtracting(oldIds)

            for id in toDelete {
                self.markersDict[id]?.map = nil
                self.markersDict[id] = nil
            }
            
            for id in toAdd {
                self.markersDict[id] = self.setuplocationMarker(business: newBusinessesDict[id]!)
            }
            
        }, errorHandler: { errorMessage in
            self.showAlert(title: "Error", message: errorMessage)
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBusinessDetails" {
            if let dest = segue.destination as? BusinessDetailsViewController {
                dest.business = self.selectedBusiness
            }
        }
    }

}

extension GMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let customInfoWindow = CustomMarkerInfoView(frame: CGRect(x: 0, y: 0, width: 260, height: 120))
        if let userData = marker.userData as? Dictionary<String, Any> {
            let business = userData["business"] as! Business
            customInfoWindow.business = business
            self.selectedBusiness = business
        }
        return customInfoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.performSegue(withIdentifier: "ShowBusinessDetails", sender: self)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        CurrentValues.mapScaling = Int(position.zoom)
        if CurrentValues.currentSettings.updateOnMapChanges {
            self.loadData()
        }
        if !self.scaleChangedBySlider {
            self.scaleSlider.value = position.zoom
        }
        self.scaleChangedBySlider = false
    }
}

extension GMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.mapView.isMyLocationEnabled = true
        }
    }
}


