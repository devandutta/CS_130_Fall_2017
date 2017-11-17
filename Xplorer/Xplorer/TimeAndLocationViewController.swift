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


/**
 This class is used as the Time and Location Input Controller for the user.
 It is in this view that the user is able to select a start location, start time, end location, and end time.
 
 This class extends UIViewController and implements UITextFieldDelegate and GMSAutocompleteViewControllerDelegate.
 
 Properties:
 *  `lastUITextFieldSelected`:      This property represents the last text field that the user selected and indicates to the view whether to place the user's searched location in the start or end text field.
 *  `startPlace`:                   This property represents the GMSPlace that is the start.
 *  `endPlace`:                     This property represents the GMSPlace that is the end.
 *  `startTimeInfo`:                This property represents the time-zone agnostic start time from a UIDatePicker.
 *  `endTimeInfo`:                  This property represents the time-zone agnostic end time from a UIDatePicker.
 
 Outlets:
 *  startLocation:  UITextField that holds the start location.
 *  endLocation:    UITextField that holds the end location.
 *  startTime:      UIDatePicker that holds the start time.
 *  endTime:        UIDatePicker that holds the end time.
 *  doneButton:     UIBarButtonItem that sits to the right in the navigation bar and only activates once the user has selected valid start and end locations.
 
 Constants:
 *  appDelegate:    This is a reference to the application's AppDelegate object.
 
 */
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
    
    /**
     This method is called when the view is loaded.
     We have overriden it to:
     *  Initially disable the "Done" button.
     *  Set this class as the delegate for the start and end UITextField objects.
     
     - Returns: void
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.isEnabled = false
        startLocation.delegate = self
        endLocation.delegate = self
    }

    /**
 This method is used to dispose of any resources that can be recreated in the event of a memory warning.
     - Returns: void
 */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // --------------------
    //MARK: AUTOCOMPLETE
    // --------------------
    
    /**
     This function is invoked whenever the GMSAutocompleteView loads after tapping on either startLocation or endLocation.
     
     - Parameter viewController:    This object refers to the GMS-specific view controller that called this method.
     - Parameter place:             This object refers to the user's selection in the autofill suggestions.
     
     - Returns: void
     
     If both the startPlace and the endPlace are valid, then the "Done" button is activated.
     
     The view controller dismisses itself after a valid user selection.
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
    
    /**
     
     This method handles GSM-specific view controller issues.
     
     This method is one of the GMSAutocompleteViewControllerDelegate methods.
     
     - Parameter viewController:    This object refers to the GMS-specific view controller that called this method.
     - Parameter error:             Specifies the error that was received from the GMSAutocompleteViewController.
     
     - Returns: void
     */
    // fail with error
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error){
        print("Error AutoComplete \(error) )")
    }
    
    /**
     This method is called when the user cancels entering text.
     This method is one of the GMSAutocompleteViewControllerDelegate methods.
     
     - Parameter viewController:    This object refers to the GMS-specific view controller that called this method.
     
     - Returns: void
     */
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
    This method deals with presenting the AutoCompleteViewController whenever either of the location UITextFields is selected.
     
     - Parameter sender:    This object represents the specific UITextField that was tapped on.
     
     - Returns: void
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
     This method is the action handler (and is specified with @IBAction) for the startLocation UITextField.
     
     - Parameter sender:    This object represents the specific UITextField that was tapped on.
     
     - Returns: void
     */
    @IBAction func openSearchAddressStartPlace(_ sender: UITextField) {
        handleAutocomplete(sender: sender)
    }
    
    /**
     This method is the action handler (and is specified with @IBAction) for the endLocation UITextField.
     
     - Parameter sender: This object represents the specific UITextField that was tapped on.
     
     - Returns: void
     */
    @IBAction func openSearchAddressEndPlace(_ sender: UITextField) {
        handleAutocomplete(sender: sender)
    }
    
    // --------------------
    //MARK: UITextFieldDelegate
    // --------------------
    
    /**
     This method is one of the methods that should be implemented for UITextFieldDelegate.
     
     It specifies what to do when the user presses "Enter".
     
     - Parameter textField: The UITextField whose return button was pressed.
     
     - Returns: true
     
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    /**
     This method tells the delegate that editing stopped for the specified text field.
     
     - Parameter textField: The UITextField for which editing ended.
     
     - Returns: void
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    /**
     This method is used to prepare for a segue.  It notifies the view controller that a segue is about to be performed.
     
     The method checks to see if the sender was a UIBarButtonItem (in this case "Done") and then sets the startTimeInfo and endTimeInfo objects to be relayed to the MapViewController upon the unwindToMapView() method in MapViewController.
     
     - Parameter segue:     The UIStoryboardSegue object that contains information about the view controllers involved in the segue.
     
     - Parameter sender:    The object that initiated the segue.  Based on what the sender is, the behavior of this function can be decided at runtime.
     
     - Returns: void
     */
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
        
        //TODO: FIX THIS!  It is buggy.  The alert disappears almost instantaneously.
        /*
         if (endTime.date <= startTime.date) {
         let timeAlert = UIAlertController(title: "Time Error", message: "The end time must be greater than the start time.", preferredStyle: .alert)
         timeAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {
         _ in NSLog("The \"OK\" alert occurred.")
         }))
         
         self.present(timeAlert, animated: true, completion: nil)
         }
         */
    }

}
