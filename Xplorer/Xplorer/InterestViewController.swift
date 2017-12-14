//
//  InterestViewController.swift
//  Xplorer
//
//  Created by Shashank Khanna on 12/7/17.
//  Copyright © 2017 devan.dutta. All rights reserved.
//

import Foundation
import UIKit

class InterestViewController: UIViewController {
    @IBOutlet weak var kasf: UIButton!
    var interests : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func select_Entertainment(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        /*
         Append only the POI types that can be directly queried in Google Places Web API
         "Entertainment" is incredibly vague, so we will consider:
         "amusement_park", "aquarium", "bowling_alley", "movie_theater", "night_club", "zoo"
         */
        
        interests.append("amusement_park")
        interests.append("aquarium")
        interests.append("bowling_alley")
        interests.append("movie_theater")
        interests.append("zoo")
    }
    
    @IBAction func selectGardens(_ sender: UIButton) {
         sender.isSelected = !sender.isSelected
        interests.append("park")
    }
    
    @IBAction func selectDrinks(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        interests.append("bar")
        interests.append("night_club")
    }
    
    @IBAction func selectFood(_ sender: UIButton) {
         sender.isSelected = !sender.isSelected
        interests.append("restaurant")
    }
    @IBAction func continuePressed(_ sender: UIButton) {
        UserDefaults.standard.set(interests, forKey: "interests")
        //print(UserDefaults.standard.value(forKey: "interests")!)
        performSegue(withIdentifier: "toMainSegue", sender: self)
    }
}
