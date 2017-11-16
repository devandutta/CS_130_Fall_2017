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

/**
 The MapViewController is the main view controller for our app.  It prominently displays the map and is used to show the user's selected itinerary.
 
 MapViewController extends UIViewController.
 
 
 Properties:
 *  `currentLocation`:      a CLLocation that specifies the current location.
 *  `mapView`:              the main GMS mapview.  This is the view that is displayed full screen in this controller.
 *  `placesClient`:         a GMSPlacesClient variable so that we can make use of the Google Places API.
 *  `zoomLevel`:            indicates the zoom level of the map.
 *  `appDelegate`:          a reference back to the app's AppDelegate object.
 *  `defaultLocation`:      if the app is running in simulator mode, or if the user has not accepted location preferences, the map begins at Apple's headquarters.
 
 Navigation:
 *  override func prepare (for segue: UIStoryboardSegue, sender: Any?): This method lets you prepare the view controller before it's presented
 
 Actions:
 *  @IBAction func unwindToMapView(sender: UIStoryboardSegue): This method allows the TimeAndLocationViewController to unwind to this view controller.
 
 Additional methods:
 addMarker(place: GMSPlace!, type: String): This method adds a marker to the map.
 
 Delegates:
 *  CLLocationManagerDelegate:  The MapViewController has to implement the CLLocationManagerDelegate.
 */

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
     This method is called when the view is loaded.
     We have overriden it to:
     *  Initialize the locationManager object.
     *  Initialize the placesClient object.
     *  Create a map to show:
     -   camera view
     -   map view
     -   center location button
     -   current location
     *  Add the map to the view
     
     - Returns: void
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
    
    /**
     This method is used for the "Done" button in the TimeAndLocationViewController.
     
     Because we want to get back to this view, we need to unwind from the TimeAndLocationViewController.
     To prepare to unwind, we:
     *  Get the start and end places as GMSPlace objects
     *  Get the start and end times from the `UIDatePicker` objects in the TimeAndLocationViewController.
     *  Add markers to the map, specifying the start and end locations that the user selected.
     
     The method is specified with an @IBAction tag to denote that it is an action that an UI element can be linked to.
     
     - Parameter sender: The sender is the object that prepares for and performs the visual transition between two view controllers.  It supports all visual transitions that have been defined in UIKit.
     
     - Returns: void
     
     */
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
    
    /**
     This function adds a marker to the map.
     
     - Parameter place: The GMSPlace that represents the place you want to add to the map.
     - Parameter type:  Specifies whether the marker will be for a "start" or an "end" location.
     - Returns: void
     */
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

/**
 The MapViewController must implement the CLLocationManagerDelegate protocol, which specifies the methods used to receive events from locationManager.
 
 */
extension MapViewController: CLLocationManagerDelegate {
    
    /*
     Tells the delegate that new location data is available.
     
     - Parameter manager:   The location manager object that generated the update event.
     - Parameter locations: An array of CLLocation objects containing the location data. This array always contains at least one object representing the current location. If updates were deferred or if multiple locations arrived before they could be delivered, the array may contain additional entries. The objects in the array are organized in the order in which they occurred. Therefore, the most recent location update is at the end of the array.
     
     - Discussion: Implementation of this method is optional but recommended.
     */
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

