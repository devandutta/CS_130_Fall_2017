//
//  TimeAndLocationViewController.swift
//  Xplorer
//
//  Created by Devan Dutta on 11/11/17.
//  Copyright © 2017 devan.dutta. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class TimeAndLocationViewController: UIViewController, UITextFieldDelegate, GMSAutocompleteViewControllerDelegate {
    
    //MARK: Properties
    
    
    // Outlets
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endLocation: UITextField!
    @IBOutlet weak var endTime: UITextField!
    
    // Constants and variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isStartPlaceKnown = false
    
    // --------------------
    //MARK: SETUP
    // --------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        startLocation.delegate = self
        startTime.delegate = self
        endLocation.delegate = self
        endTime.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // --------------------
    //MARK: AUTOCOMPLETE
    // --------------------
    
    /**
     This function is invoked whenever the GMSAutocompleteView loads
     */
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
       
        if (!isStartPlaceKnown) {
            self.startLocation.text = "\(place.name), \(place.formattedAddress!)"
            isStartPlaceKnown = true
        } else{
            self.endLocation.text = "\(place.name), \(place.formattedAddress!)"
        }
        
        self.dismiss(animated: true, completion: nil) // dismiss after selecting a place
    }
    
    // fail with error
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error){
        print("Error AutoComplete \(error) )")
    }
    
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     This function deals with presenting the autoComplete view
     whenever the start location is accessed
     */
    @IBAction func openSearchAddressStartPlace(_ sender: UITextField) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        appDelegate.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }

    @IBAction func openSearchAddressEndPlace(_ sender: UITextField) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        appDelegate.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    
    
    // --------------------
    //MARK: UITextFieldDelegate
    // --------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}





