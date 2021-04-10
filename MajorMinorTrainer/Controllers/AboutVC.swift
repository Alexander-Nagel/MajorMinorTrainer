//
//  AboutVC.swift
//  MajorMinorTrainer
//
//  Created by Alexander Nagel on 06.04.21.
//

import UIKit

class AboutVC: UIViewController {

    var aboutVariable: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(#function)
        
        let vc = self.tabBarController?.viewControllers
        print(vc)
        //let vc = (self.tabBarController?.viewControllers![1] as! StartVC)
        
        //print(vc.trainer.numberOfChords)
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
