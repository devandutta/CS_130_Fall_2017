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
    
    // Outlets
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var endLocation: UITextField!
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    // Constants and variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // --------------------
    //MARK: SETUP
    // --------------------
    override func viewDidLoad() {
        super.viewDidLoad()

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
        lastUITextFieldSelected = nil
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}





