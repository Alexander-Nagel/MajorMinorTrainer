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
        
        static let buttonTextColor: UIColor = .white
        static let correctButNotChosenButtonTextColor: UIColor = #colorLiteral(red: 0.3251720667, green: 0.8431780338, blue: 0.411704123, alpha: 1)
        static let wrongButNotChosenButtonTextColor: UIColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
        static let wrongChosenButtonTextColor: UIColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
        
        static let chosenRightAnswerColor: UIColor = #colorLiteral(red: 0.3251720667, green: 0.8431780338, blue: 0.411704123, alpha: 1)
        static let notChosenRightAnswerBGColor: UIColor = #colorLiteral(red: 0.225044248, green: 0.5792186429, blue: 0.2905635965, alpha: 1)
        static let wrongAnswerColor: UIColor = #colorLiteral(red: 0.9921812415, green: 0.1882499158, blue: 0.2627539337, alpha: 1)
        
        static let questionMarkColor: UIColor = .white
        static let questionMarkPlayingColor: UIColor = .black
        
        static let selectedLabelBgColor: UIColor = .orange
        static let selectedLabelTextColor: UIColor = .white
        
        static let settingsTextColor: UIColor = .white
        static let settingsCellColor = UIColor(rgb: 0xCCE3dE) // Light Cyan
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




