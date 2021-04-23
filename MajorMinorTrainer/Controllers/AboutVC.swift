//
//  AboutVC.swift
//  MajorMinorTrainer
//
//  Created by Alexander Nagel on 06.04.21.
//

import UIKit

class AboutVC: UIViewController {
    
  //  var aboutVariable: Int = 0
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = K.Color.backgroundColor
        //imageView.image = UIImage(named:  "launchScreenImage")
       
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
       
    
        
        
        
//        let attributedString = NSMutableAttributedString(string: "Want to learn iOS? You should visit the best source of free iOS tutorials!")
//                attributedString.addAttribute(.link, value: "https://www.hackingwithswift.com", range: NSRange(location: 19, length: 55))

        //label.attributedText = attributedString
        
       label.text = "MajorMinorTrainer\n\nThis is an ear training app for musicians that helps to learn to differentiate between major or minor chords.\n\nDescription:\n\n- 1 to 5 random chords will be played\n- Make your guess for each chord: Major or minor?\n- If unsure, repeat the sequence.\n- After all guesses are made, the 'eye' button reveals the solution.\n- You will now be able to play back all correct chords as well as their 'wrong' counterparts.\n\nUser Settings:\n\n- Chose the number of chords to be played as sequence from 1 to 5 chords.\n- Set your preferred delay time between each chord.\n- Auto-Restart enables auto restart after correct results without the need to press the play button.\n- Chose between two main modes: Chromatic mode (plays e.g. F#min, Fmaj, Cmin, E...) oder diatonic mode (plays e.g. G, C, D, Am...)"
//
//
//
//"""
        
        label.textColor = .black
        
    }
    
    //    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    //        cell.backgroundColor = K.Color.backgroundColor
    //    }
    
    
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//           UIApplication.shared.open(URL)
//           return false
//       }
    
    
    
}
