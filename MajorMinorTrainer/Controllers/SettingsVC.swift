//
//  SettingsVC.swift
//  MajorMinorTrainer
//
//  Created by Alexander Nagel on 09.04.21.
//

import UIKit

class SettingsVC: UITableViewController {

    @IBOutlet weak var numberOfChordsLabel: UILabel!
    @IBOutlet weak var timeBetweenChordsLabel: UILabel!
    @IBOutlet weak var timeBetweenResultsLabel: UILabel!
    
    var settingsVariable: Int = 0
    
    var numberOfChords: Int? {
        didSet {
            print("Change!!! numberOfChords = \(numberOfChords)")
            if let noc = numberOfChords {
                numberOfChordsLabel?.text = String(noc)
            }
        }
    }
    
    /*{
        get {
            return (self.tabBarController?.viewControllers![0] as! StartVC).trainer.numberOfChords
        }
        set {
            (self.tabBarController?.viewControllers![0] as! StartVC).trainer.numberOfChords = newValue
        }
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        print("inside viewDidAppear: numberOfChords = \(numberOfChords)")
        if let noc = numberOfChords {
            numberOfChordsLabel.text = String(noc)
        }
        
        
        stepper1.wraps = false
        stepper1.autorepeat = true
        stepper1.maximumValue = 5
        stepper1.minimumValue = 1
        stepper1.value = Double(numberOfChords!)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
        //
        // Passing data back to StartVC
        //
        let navController = self.tabBarController?.viewControllers![0] as! UINavigationController
        let destinationVC = navController.topViewController as! StartVC
        if let noc = self.numberOfChords {
            destinationVC.trainer.userSettings.numberOfChords = noc
        }
        
       
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("SETTINGS")
        print(#function)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

  
    @IBOutlet weak var stepper1: UIStepper!
    @IBOutlet weak var stepper2: UIStepper!
    @IBOutlet weak var stepper3: UIStepper!

    @IBAction func stepper1ValueChanged(_ sender: UIStepper) {
        
        numberOfChords = Int(sender.value)
        
    }
    @IBAction func stepper2Pressed(_ sender: UIStepper) {
    }
    @IBAction func stepper3Pressed(_ sender: UIStepper) {
    }
    
}
