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
 
 *  `POIList`:              The table list of POIs for the user to select
 *  `resultsReturned`:      The array of results returned by the nearby place lookup in dictionary form
 *  `resultsData`:          The array of PlaceData objects for the returned POI results
 
 *  `startLocation`:        CLLocationCoordinate2D that stores the user's start location
 *  `endLocation`:          CLLocationCoordinate2D that stores the user's end location
 
 Navigation:
 *  override func prepare (for segue: UIStoryboardSegue, sender: Any?): This method lets you prepare the view controller before it's presented
 
 Actions:
 *  @IBAction func unwindToMapView(sender: UIStoryboardSegue): This method allows the TimeAndLocationViewController to unwind to this view controller.
 
 Additional methods:
 addMarker(place: GMSPlace!, type: String): This method adds a marker to the map.
 
 Delegates:
 *  CLLocationManagerDelegate:  The MapViewController has to implement the CLLocationManagerDelegate.
 */

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsReturned.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath as IndexPath)
        let result = resultsReturned[indexPath.row] as? NSDictionary
        cell.textLabel!.text = (result!["name"]) as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = resultsData[indexPath.row]
        
        //Check if the marker is already on the map, if so: remove it
        let position = result.coordinate.coordinate
        for marker:GMSMarker in markers {
            if ((position.latitude == marker.position.latitude) && (position.longitude == marker.position.longitude)) {
                print(marker)
                print("Number of items in markers before removal: \(markers.count)")
                
                let index = markers.index(where: { (item) -> Bool in
                    (item.position.latitude == position.latitude) && (item.position.longitude == position.longitude)
                })
                if(index! > 0) {
                    marker.map = nil
                    markers.remove(at: index!)
                    print("Number of items in markers after removal: \(markers.count)")
                    return
                }
            }
        }
        
        //Now create marker to put on map
        let marker = GMSMarker()
        marker.position = result.coordinate.coordinate
        marker.title = result.name
        marker.snippet = result.name
        
        marker.appearAnimation = .pop
        marker.map = mapView
        markers.append(marker)
        
        updateMapZoom()
        updateMapPolyline()
    }
    
    //MARK: Properties

    //a CLLocation that specifies the current location.
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var markers: [GMSMarker] = []
    var resultsReturned: NSMutableArray = NSMutableArray()
    var resultsData: Array<PlaceData> = Array()
    var startLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var endLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var polylines: [GMSPolyline] = []

    @IBOutlet weak var POIList: UITableView!
    
    //In case the location preferences have not been set, this is the location of Apple headquarters
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
        
        //Register the table view
        POIList.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceCell")
        POIList.dataSource = self
        POIList.delegate = self
        
        //Make the table view look nicer
        POIList.separatorColor = UIColor.blue
        POIList.layer.cornerRadius = 10
        POIList.layer.masksToBounds = true
        
        //Add the map to the view
        view.addSubview(mapView)
        //Make the POI list hidden initially
        POIList.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func sendRequest (request: URLRequest, completion:@escaping (NSData?)->()) {
        URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            return completion(data as! NSData)
        }).resume()
    }
 */
    
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
            // Before getting the start and end place, remove any previous markers that were on the map
            for marker in markers {
                marker.map = nil
            }
            markers.removeAll()
            
            // Also, remove any polylines that were on the map:
            for polyline in polylines {
                polyline.map = nil
            }
            polylines.removeAll()
            
            // Get the start place and the end place
            let startPlace = sourceViewController.startPlace
            let endPlace = sourceViewController.endPlace
            
            // Get the start time and the end time
            let startTime = sourceViewController.startTimeInfo
            let endTime = sourceViewController.endTimeInfo
            
            print("startPlace: \(startPlace!.name), \(startPlace!.formattedAddress!)")
            print("endPlace: \(endPlace!.name), \(endPlace!.formattedAddress!)")
            
            print("startTime: \(startTime!)")
            print("endTime: \(endTime!)")
            
            //Put start and end markers on map
            addMarker(place: startPlace, type: "start")
            addMarker(place: endPlace, type: "end")
            
            startLocation = (startPlace?.coordinate)!
            endLocation = (endPlace?.coordinate)!
            
            /* TODO: Fix map zooming and camera position when receiving new start and end itinerary from user
            //Make the map's camera position be the new start, as opposed to current location
            //  Note that the zoom position is temporary right now, because it will be updated with updateMapZoom()
            let newPosition = GMSCameraPosition.camera(withLatitude: startLocation.latitude, longitude: endLocation.longitude, zoom: 8)
            mapView.camera = newPosition
 */
            
            //Modify the map bounds to include all markers
            updateMapZoom()
            
            
            //Get midpoint
            let longitude1: Double = Double(startPlace!.coordinate.longitude) * .pi / 180
            let longitude2: Double = Double(endPlace!.coordinate.longitude) * .pi / 180
            let latitude1: Double = Double(startPlace!.coordinate.latitude) * .pi / 180
            let latitude2: Double = Double(endPlace!.coordinate.latitude) * .pi / 180
            
            let longitudeDistance = longitude2 - longitude1
            
            let x = cos(latitude2) * cos(longitudeDistance)
            let y = cos(latitude2) * sin(longitudeDistance)
            
            let latitude3 = atan2(sin(latitude1) + sin(latitude2), sqrt((cos(latitude1) + x) * (cos(latitude1) + x) + y * y))
            let longitude3 = longitude1 + atan2(y, cos(latitude1) + x)
            
            var center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude3 * 180 / .pi, longitude: longitude3 * 180 / .pi)
            
            
            // If you would like to see where the center is, then uncomment this code:
            /*
            let marker = GMSMarker()
            marker.position = center
            
            marker.appearAnimation = .pop
            marker.map = mapView
            markers.append(marker)
            
            updateMapZoom()
             */
            
            //Now display POIs:
            let centerLat = String(describing: center.latitude)
            let centerLong = String(describing: center.longitude)

            //Get distance between end points
            let start: CLLocation = CLLocation(latitude: (startPlace?.coordinate.latitude)!, longitude: (startPlace?.coordinate.longitude)!)
            let end: CLLocation = CLLocation(latitude: (endPlace?.coordinate.latitude)!, longitude: (endPlace?.coordinate.longitude)!)
            let endToEndDistanceMeters = end.distance(from: start)
            //Get radius
            let radius = endToEndDistanceMeters / 2
            print("radius: \(radius)")
            let radiusString = String(describing: radius)
            
            var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(centerLat),\(centerLong)&radius=\(radiusString)&type=restaurant&key=\(appDelegate.GMSPlacesWebServicesKey)"
            
            let url = URL(string: urlString)
            let request = URLRequest(url: url!)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.main.async {
                let task = session.dataTask(with: request) {data, response, error in
                    do {
                        let json = (try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary)!
                        let results = json["results"] as? NSArray
                        
                        for place:Any in results! {
                            self.resultsReturned.add(place)
                        }
                        group.leave()
                        return
                    } catch {
                        print(error)
                        group.leave()
                        return
                    }
                }
                task.resume()
            }
            
            group.notify(queue: .main) {
                print("Here are the returned results:")
                //resultsReturned is an array of dictionaries
                for result:Any in self.resultsReturned {
                    if let dictionaryResult = result as? NSDictionary {
                        let placeID = dictionaryResult["id"]
                        let name = dictionaryResult["name"]
                        let geometry = dictionaryResult["geometry"] as? NSDictionary
                        let location = geometry!["location"] as? NSDictionary
                        let latitude = location!["lat"]
                        let longitude = location!["lng"]
                        
                        let placeInfo = PlaceData(name: name as! String, id: placeID as! String, coordinate: CLLocation(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees))
                        
                        self.resultsData.append(placeInfo)
                        
                        print("name: \(String(describing: name))")
                    }
                }
                //TODO: Table data does not reload when user enters new start and end information
                self.POIList.reloadData()
                self.POIList.isHidden = false
                self.view.bringSubview(toFront: self.POIList)
                
            }
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
        
        marker.appearAnimation = .pop
        marker.map = mapView
        markers.append(marker)
    }
    
    func updateMapZoom() {
        let path = GMSMutablePath()
        for marker:GMSMarker in markers {
            path.add(marker.position)
        }
        
        let bounds = GMSCoordinateBounds.init(path: path)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 150)
        
        mapView.animate(with: update)
    }
    
    func updateMapPolyline() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        //Construct the request:
        let originLat = String(describing: startLocation.latitude)
        let originLong = String(describing: startLocation.longitude)
        let endLat = String(describing: endLocation.latitude)
        let endLong = String(describing: endLocation.longitude)
        var url = "https://maps.googleapis.com/maps/api/directions/json?"
        url += "origin=\(originLat),\(originLong)"
        url += "&destination=\(endLat),\(endLong)"
        
        //Add waypoints that are not the start nor end
        var waypointsString = ""
        for marker:GMSMarker in markers {
            var latBool: Bool
            latBool = ((marker.position.latitude != startLocation.latitude) && (marker.position.latitude != endLocation.latitude))
            var lonBool: Bool
            lonBool = ((marker.position.longitude != startLocation.longitude) && (marker.position.longitude != endLocation.longitude))
            
            //The marker is different from the start and end
            if ((latBool == true) && (lonBool == true)) {
                let waypointLatString = String(describing: marker.position.latitude)
                let waypointLonString = String(describing: marker.position.longitude)
                waypointsString += "\(waypointLatString),\(waypointLonString)|"
            }
                
        }
        //Remove last pipe:
        if (waypointsString.last == "|") {
            waypointsString.remove(at: waypointsString.index(before: waypointsString.endIndex))
        }
        url += "&waypoints=optimize:true|"
        url += waypointsString
        url += "&key=\(appDelegate.GMSDirectionsKey)"
        
        print(url)
        
        let formattedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(formattedURL)
        let urlQuery = URL(string: formattedURL!)!
        
        //Query Google Directions API to get polyline back:
        var polylinePoints = ""
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            let task = session.dataTask(with: urlQuery) {data, response, error in
                do {
                    if error != nil {
                        print("error: \(error?.localizedDescription)")
                        return
                    }
                    
                    print("Is valid JSON: \(data)")

                    
                    let json = (try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary)!
                    let routes = json["routes"] as! NSArray
                    let route1 = routes[0] as! NSDictionary
                    let overviewPolyline = route1["overview_polyline"] as? NSDictionary
                    polylinePoints = overviewPolyline!["points"] as! String
                    
                    group.leave()
                    return
                } catch {
                    print(error)
                    group.leave()
                    return
                }
            }
            task.resume()
        }
        
        group.notify(queue: .main) {
            print("Drawing polyline now:")
            let path = GMSMutablePath(fromEncodedPath: polylinePoints)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 3
            polyline.strokeColor = UIColor.blue
            polyline.map = self.mapView
            self.polylines.append(polyline)
            
            let bounds = GMSCoordinateBounds.init(path: path!)
            let update = GMSCameraUpdate.fit(bounds, withPadding: 110)
            self.mapView.animate(with: update)
        }
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

struct PlaceData {
    var name: String
    var id: String
    var coordinate: CLLocation
}

