//
//  AboutVC.swift
//  MajorMinorTrainer
//
//  Created by Alexander Nagel on 06.04.21.
//

import UIKit

class AboutVC: UIViewController {

    var aboutVariable: Int = 0
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = K.Color.backgroundColor
        imageView.image = UIImage(named:  "launchScreenImage") 
        
        
    }
    
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.backgroundColor = K.Color.backgroundColor
//    }
    

    
    
}
