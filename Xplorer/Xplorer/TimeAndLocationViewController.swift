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
    var lastUITextFieldSelected: UITextField?
    var startPlace: GMSPlace?
    var endPlace: GMSPlace?
    var startTimeInfo: NSDate?
    var endTimeInfo: NSDate?
    
    // Outlets
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var endLocation: UITextField!
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // Constants and variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // --------------------
    //MARK: SETUP
    // --------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.isEnabled = false
        startLocation.delegate = self
        endLocation.delegate = self
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
        lastUITextFieldSelected?.text = "\(place.name), \(place.formattedAddress!)"
        if (lastUITextFieldSelected === startLocation) {
            startPlace = place
        }
        else {
            endPlace = place
        }
        lastUITextFieldSelected = nil
        
        if((startPlace != nil) && (endPlace != nil)) {
            doneButton.isEnabled = true
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
    This function deals with presenting the autoComplete view whenever either of the location UITextFields are selected
    */
    func handleAutocomplete(sender: UITextField) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        appDelegate.locationManager.startUpdatingLocation()
        lastUITextFieldSelected = sender
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    //MARK: Actions
    
    /**
     This function is the action handler for the start location text field
     */
    @IBAction func openSearchAddressStartPlace(_ sender: UITextField) {
        handleAutocomplete(sender: sender)
    }

    /**
     This function is the action handler for the end location text field
     */
    @IBAction func openSearchAddressEndPlace(_ sender: UITextField) {
        handleAutocomplete(sender: sender)
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //Note that the 3 equal signs do not indicate a typo.  They are the identity operator.
        //Specifically, they are checking if the object referenced by sender is the same as doneButton
        guard let button = sender as? UIBarButtonItem, button === doneButton else {
            print("The done button was not pressed")
            return
        }
        
        startTimeInfo = startTime.date as NSDate
        endTimeInfo = endTime.date as NSDate
    }

}





