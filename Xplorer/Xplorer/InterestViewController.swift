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
        interests.append("Entertainment")
    }
    
    @IBAction func selectGardens(_ sender: UIButton) {
         sender.isSelected = !sender.isSelected
        interests.append("Gardens")
    }
    
    @IBAction func selectHistory(_ sender: UIButton) {
         sender.isSelected = !sender.isSelected
         interests.append("History")
    }
    
    @IBAction func selectFood(_ sender: UIButton) {
         sender.isSelected = !sender.isSelected
        interests.append("Food")
    }
    @IBAction func continuePressed(_ sender: UIButton) {
        UserDefaults.standard.set(interests, forKey: "interests")
        print(UserDefaults.standard.value(forKey: "interests")!)
        performSegue(withIdentifier: "toMainSegue", sender: self)
    }
}
