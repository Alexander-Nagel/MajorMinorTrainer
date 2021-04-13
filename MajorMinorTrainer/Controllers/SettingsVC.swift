//
//  SettingsVC.swift
//  MajorMinorTrainer
//
//  Created by Alexander Nagel on 09.04.21.
//

import UIKit

class SettingsVC: UITableViewController {

    @IBOutlet weak var numberOfChordsLabel: UILabel!
    @IBOutlet weak var pauseBetweenChordsLabel: UILabel!
    @IBOutlet weak var pauseBetweenResultsLabel: UILabel!
    
    var settingsVariable: Int = 0
    
    var numberOfChords: Int?
    {
        didSet {
            print("Change!!! numberOfChords = \(numberOfChords)")
            if let noc = numberOfChords {
                numberOfChordsLabel?.text = String(noc)
            }
        }
    }
    var pauseBetweenChords: Double?
    {
        didSet {
            print("Change!!! pauseBetweenChords = \(pauseBetweenChords)")
            if let pbc = pauseBetweenChords {
                 pauseBetweenChordsLabel?.text = String(pbc)
            }
        }
    }
    var pauseBetweenResults: Double?
    {
        didSet {
            print("Change!!! pauseBetweenResults = \(pauseBetweenResults)")
            if let pbr = pauseBetweenResults {
                pauseBetweenResultsLabel?.text = String(pbr)
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
        print("inside viewDidAppear: pauseBetweenChords = \(pauseBetweenChords)")
        print("inside viewDidAppear: pauseBetweenResults = \(pauseBetweenResults)")
        
        if let noc = numberOfChords {
            numberOfChordsLabel?.text = String(noc)
        }
        if let pbc = pauseBetweenChords {
            pauseBetweenChordsLabel?.text = String(pbc)
        }
        if let pbr = pauseBetweenResults {
            pauseBetweenResultsLabel?.text = String(pbr)
        }
        
        stepper1.wraps = false
        stepper1.autorepeat = true
        stepper1.minimumValue = 1
        stepper1.maximumValue = 5
        stepper1.stepValue = 1
        stepper1.value = Double(numberOfChords!)
        
        stepper2.wraps = false
        stepper2.autorepeat = true
        stepper2.minimumValue = 1.2
        stepper2.maximumValue = 3
        stepper2.stepValue = 0.2
        stepper2.value = Double(pauseBetweenChords!)
        
        stepper3.wraps = false
        stepper3.autorepeat = true
        stepper3.minimumValue = 0.3
        stepper3.maximumValue = 1
        stepper3.stepValue = 0.1
        stepper3.value = Double(pauseBetweenResults!)

        numberOfChordsLabel.textColor = .black
        pauseBetweenChordsLabel.textColor = .black
        pauseBetweenResultsLabel.textColor = .black
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
        //
        // Passing data back to StartVC
        //
        let navController = self.tabBarController?.viewControllers![0] as! UINavigationController
        let destinationVC = navController.topViewController as! StartVC
        if let noc = self.numberOfChords,
           let pbc = self.pauseBetweenChords,
           let pbr = self.pauseBetweenResults {
            destinationVC.trainer.userSettings.numberOfChords = noc
            destinationVC.trainer.userSettings.pauseBetweenChords = pbc
            destinationVC.trainer.userSettings.pauseBetweenResults = pbr
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
       
        pauseBetweenChords = round(Double(sender.value), toDigits: 1)
    
    }
    @IBAction func stepper3Pressed(_ sender: UIStepper) {
      
        pauseBetweenResults = round(Double(sender.value), toDigits: 1)
    
    }
    
}
