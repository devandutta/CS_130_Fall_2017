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
        
        
        
        // create a marker to show where you at
        
        let marker = GMSMarker()
        marker.position = defaultLocation.coordinate
        marker.title = "Cupertino"
        marker.snippet = "California"
        marker.map = mapView
        
        
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
        //TODO: THIS IS WHERE WE WILL WANT TO STORE THE TIMES AND LOCATIONS FROM THE TIME AND LOCATION VIEW
    }
    
    //MARK: Actions
    @IBAction func unwindToMapView(sender: UIStoryboardSegue) {
        
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

