//
//  ViewController.swift
//  Xplorer
//
//  Created by Devan Dutta on 11/11/17.
//  Copyright © 2017 devan.dutta. All rights reserved.
//

import UIKit
import os.log
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    //MARK: Properties

    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //In case the location preferences have not been set, this is the location of Apple
    let defaultLocation = CLLocation(latitude: 37.33182, longitude: -122.03118)

    /**
     void: viewDidLoad - this function initializes the location manager
     TODO: Move initialization to app delegate since the code is shared
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        //Initialize the location manager
        appDelegate.locationManager = CLLocationManager()
        appDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        appDelegate.locationManager.requestAlwaysAuthorization()
        appDelegate.locationManager.distanceFilter = 50
        appDelegate.locationManager.startUpdatingLocation()
        appDelegate.locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        //Create a Map to show
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // reset location to my location when the button is pressed
        mapView.settings.myLocationButton = true
        
        //Add the map to the view
        view.addSubview(mapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    
    //This method lets you prepare the view controller before it's presented
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    //MARK: Actions
    @IBAction func unwindToMapView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TimeAndLocationViewController {
            //Get the start place and the end place
            let startPlace = sourceViewController.startPlace
            let endPlace = sourceViewController.endPlace
            
            //Get the start time and the end time
            let startTime = sourceViewController.startTimeInfo
            let endTime = sourceViewController.endTimeInfo
            
            print("startPlace: \(startPlace!.name), \(startPlace!.formattedAddress!)")
            print("endPlace: \(endPlace!.name), \(endPlace!.formattedAddress!)")
            
            print("startTime: \(startTime!)")
            print("endTime: \(endTime!)")
            
            //Put start and end markers on map
            addMarker(place: startPlace, type: "start")
            addMarker(place: endPlace, type: "end")
            
            //TODO: This will have to be much more dynamic
            mapView.animate(toZoom: 11)
        }
    }
    
    func addMarker(place: GMSPlace!, type: String) {
        let marker = GMSMarker()
        marker.position = (place?.coordinate)!
        marker.title = place?.name
        marker.snippet = place?.formattedAddress
        if(type == "start") {
            marker.icon = GMSMarker.markerImage(with: .blue)
        }
        
        else if(type == "end") {
            marker.icon = GMSMarker.markerImage(with: .red)
        }
        
        marker.map = mapView
    }

}

//MARK: Delegates

// Delegates to handle events for the location manager.
extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        appDelegate.locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

