//
//  constants.swift
//  MajorMinorTrainer
//
//  Created by Alexander Nagel on 08.04.21.
//

import Foundation
import UIKit

//
// Constants
//
// https://coolors.co/6b9080-a4c3b2-cce3de-eaf4f4-f6fff8
//
struct K {
    
    struct Color {
        
       
        static let backgroundColor = UIColor(rgb: 0x6B9080) // Wintergreen Dream
        
        static let majorButtonColor = UIColor(rgb: 0xCCE3dE) // Light Cyan
        static let majorButtonTextColor: UIColor = .black
    
        static let minorButtonColor = UIColor(rgb: 0xA4C3B2) // Cambridge Blue
        static let minorButtonTextColor: UIColor = .black
        
        static let buttonTextColor: UIColor = .black
        
        static let rightAnswerColor: UIColor = .green
        static let wrongAnswerColor: UIColor = .red
        
        static let questionMarkColor: UIColor = .white
        static let questionMarkPlayingColor: UIColor = .black
        
        static let selectedLabelBgColor: UIColor = .orange
        static let selectedLabelTextColor: UIColor = .black
    }
    
    struct Sound {
        static let successSound = "SUCCESS"
        static let failureSound = "FAILURE"
    }
    
    struct Image {
        static let successImage = "checkmark"
        static let failureImage = "multiply"
        static let questionImage = "questionmark"
    }
}


//
// color hex extension by "Sulthan" @ https://stackoverflow.com/a/24263296/14506724
//
// let color = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)
// let color2 = UIColor(rgb: 0xFFFFFF)
//
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

