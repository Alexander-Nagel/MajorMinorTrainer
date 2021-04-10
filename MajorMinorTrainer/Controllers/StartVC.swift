//
//  StartVC.swift
//  MajorMinorTrainer
//
//  Created by Alexander Nagel on 06.04.21.
//

import UIKit
import AVFoundation

let DEBUG = true
let DUMP = false

class StartVC: UIViewController {

    //let button: UIButton = UIButton()
    
    var player: AVAudioPlayer?
    var workItem: DispatchWorkItem?
    var queue: DispatchQueue?

    let trainer = Trainer()
    
    @IBOutlet weak var evalImage1: UIImageView!
    @IBOutlet weak var evalImage2: UIImageView!
    @IBOutlet weak var evalImage3: UIImageView!
    @IBOutlet weak var evalImage4: UIImageView!
    @IBOutlet weak var evalImage5: UIImageView!
    @IBOutlet weak var majButton1: UIButton!
    @IBOutlet weak var minButton1: UIButton!
    @IBOutlet weak var majButton2: UIButton!
    @IBOutlet weak var minButton2: UIButton!
    @IBOutlet weak var majButton3: UIButton!
    @IBOutlet weak var minButton3: UIButton!
    @IBOutlet weak var majButton4: UIButton!
    @IBOutlet weak var minButton4: UIButton!
    @IBOutlet weak var majButton5: UIButton!
    @IBOutlet weak var minButton5: UIButton!
    @IBOutlet weak var buttonColumn1: UIStackView!
    @IBOutlet weak var buttonColumn2: UIStackView!
    @IBOutlet weak var buttonColumn3: UIStackView!
    @IBOutlet weak var buttonColumn4: UIStackView!
    @IBOutlet weak var buttonColumn5: UIStackView!
    
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var evaluateButton: UIButton!
    
    var buttonColumns: [UIStackView]?
    var answerButtons: [UIButton] = []
    var majorButtons:  [UIButton] = []
    var minorButtons:  [UIButton] = []
    var evalutationImageViews: [UIImageView]?
    
    override func viewDidLoad() {
        
        if DUMP {debugDump()}
        if DEBUG {print(#function)}
        
        super.viewDidLoad()
        
       // let barViewControllers = self.tabBarController?.viewControllers
        
        //let svc = barViewControllers![1] as! UINavigationController
        
        //let ssvc = svc as! SettingsVC
        //svc.myOrder = self.myOrder  //shared model
        
    }
   
    
    override func viewWillDisappear(_ animated: Bool) {
        
        print(#function)
        
       

       
        
        // https://stackoverflow.com/questions/39494454/pass-data-between-viewcontroller-and-tabbarcontroller
        
        //
        // Passing data to other Tab ( = subclass of UINavigationController)
        //
        let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        let destinationVC = navController.topViewController as! SettingsVC
        destinationVC.numberOfChords = self.trainer.userSettings.numberOfChords
    }
}

//
// MARK: - Setup Buttons
//
extension StartVC {
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if DUMP {debugDump()}
        if DEBUG {print(#function)}
        
        buttonColumns = [buttonColumn1, buttonColumn2, buttonColumn3, buttonColumn4, buttonColumn5]
        answerButtons = [majButton1, minButton1, majButton2, minButton2, majButton3, minButton3, majButton4, minButton4, majButton5, minButton5]
        evalutationImageViews = [evalImage1, evalImage2, evalImage3, evalImage4, evalImage5]
        majorButtons = [majButton1, majButton2, majButton3, majButton4, majButton5]
        minorButtons = [minButton1, minButton2, minButton3, minButton4, minButton5]
        
        setupButtons()
    }
    
    func setupButtons() {
        
        if DUMP {debugDump()}
        if DEBUG {print(#function)}
        
        guard let columns = buttonColumns, let evalIm = evalutationImageViews else {return}
        
        //
        // Hide all columns
        //
        for index in 0...4 {
            columns[index].isHidden = true
            //evalIm[index].isHidden = true
        }

        //
        // Show columns needed for test
        //
        let limit = (trainer.userSettings.numberOfChords - 1)
        print("Limit: \(0...limit)")
        for index in 0...limit {
            columns[index].isHidden = false
        }
        
        //
        // Style buttons
        //
        
        for button in answerButtons {
            button.layer.cornerRadius = 30
            button.layer.borderWidth = 0
            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            //button.setTitleShadowColor(.yellow, for: .selected)
            button.setTitleColor(K.Color.selectedLabelTextColor, for: .selected)
        }
        
        resetUI()
    }
}
    
//
// MARK: - PLAY BUTTON
//
extension StartVC {
    
    @IBAction func playPressed(_ sender: UIButton) {
        
        if DUMP {debugDump()}
        if DEBUG {print(#function)}
        
        guard !trainer.isEvaluating else {
            print("wait until evaluation is over!")
            return
        }
        
        guard !trainer.isPlaying else {
            print("wait till playing is over")
            return
        }
       
        //
        // Reset buttons + imageViews
        //
        resetUI()
        
        //
        // Clear answers + solution + colors, reset flags
        //
        // trainer.answer = []
        //trainer.solution = []
        //trainer.imgColors = Array(repeating: "white", count: trainer.numberOfChords)
        //trainer.hasBeenEvaluated = false
        //trainer.isPlaying = true
        
        //
        // Create new chord sequence
        //
        trainer.createSequence()
        
        //
        // Unwrap new sequence's chord's filenames
        //
        guard let fileNames = trainer.sequence  /* let solution = trainer.solution */ else {return}
        
        if DEBUG { print(fileNames) }
    
        //
        // Play chords and set questionmark color of current chord to black
        //
        var offset = 0.0
        var arrIndex = 0
        for name in fileNames {
            
            //VORLAGE
           // let workItem = DispatchWorkItem { doExcitingThings() }
          //  DispatchQueue.main.asyncAfter(deadline: .now() + offset, execute: workItem)
          //  workItem.cancel()
          // VORLAGE ENDE
            
            
            DispatchQueue.main.asyncAfter(deadline: (.now() + offset)) {
          
            
                // set current questionmark color to black:
                self.evalutationImageViews![arrIndex].tintColor = K.Color.questionMarkPlayingColor
                
                // play sound
                self.playSound(filename: name)
                
                // set previous questionmark color back to white:
                if arrIndex > 0 {self.evalutationImageViews![arrIndex-1].tintColor = K.Color.questionMarkColor}
                
                arrIndex += 1
                
            }
           
            offset += self.trainer.pauseBetweenChords
        }
        
        //
        // Set last qustionmark back to white color
        //
        DispatchQueue.main.asyncAfter(deadline: (.now() + offset)) {
            self.evalutationImageViews![arrIndex-1].tintColor = K.Color.questionMarkColor
            
            self.trainer.isPlaying = false
        }
        
        print("is playing? \(trainer.isPlaying)")
    }
}

//
// MARK: - REPEAT BUTTON
//
extension StartVC {
    
    @IBAction func repeatPressed(_ sender: UIButton) {
        
        if DUMP {debugDump()}
        if DEBUG {print(#function)}
        
        guard !trainer.isPlaying else {
            print("can't repeat while playing!")
            return
        }
        
        guard !trainer.isEvaluating else {
            print("wait until evaluation is over!")
            return
        }
        
        guard trainer.sequence?.count != 0 else {
            print("äääääääää")
            return
        }
        
        guard trainer.imgColors.count != 0 else {
            print("öööööö")
            return
        }
        
//        guard fileNames.count != 0 else {
//            showAlert("Click Play first!")
//            return
//        }
        
        //repeatButton.flash()
        //print("FLASHING!")
        
        
        print("colors  = \(self.trainer.imgColors)")
        
        guard let fileNames = trainer.sequence, let solution = trainer.solution /*, let answer = trainer.answer */ else {return}
        
        
        //
        // Play chords and set questionmark color of playing chord to black
        //
        var offset = 0.0
        var arrIndex = 0
       
        trainer.isPlaying = true
        
        for name in fileNames {
            DispatchQueue.main.asyncAfter(deadline: (.now() + offset)) {
                
                
                
                self.evalutationImageViews![arrIndex].tintColor = K.Color.questionMarkPlayingColor
                self.playSound(filename: name)
                if arrIndex > 0 {
                    var oldColor = UIColor()
                    let criteria = self.trainer.imgColors[arrIndex-1]
                    switch criteria {
                    case "green":
                        print("\(arrIndex) it's green")
                        oldColor = K.Color.rightAnswerColor
                    case "red":
                        print("\(arrIndex) it's red")
                        oldColor = K.Color.wrongAnswerColor
                    default:
                        print("\(arrIndex) it's black")
                        oldColor = K.Color.questionMarkColor
                    }
                    self.evalutationImageViews![arrIndex-1].tintColor = oldColor
                }
                arrIndex += 1
                
            }
            offset += self.trainer.pauseBetweenChords
        }
            
        //
        // Set last questionmark back to white color
        //
        DispatchQueue.main.asyncAfter(deadline: (.now() + offset)) {
            var oldColor = UIColor()
            let criteria = self.trainer.imgColors[arrIndex-1]
            switch criteria {
            case "green":
                print("\(arrIndex) it's green")
                oldColor = K.Color.rightAnswerColor
            case "red":
                print("\(arrIndex) it's red")
                oldColor = K.Color.wrongAnswerColor
            default:
                print("\(arrIndex) it's black")
                oldColor = K.Color.questionMarkColor
            }
            self.evalutationImageViews![arrIndex-1].tintColor = oldColor
            
            self.trainer.isPlaying = false
        }
     
    }
}

//
// MARK: - PLAY SOUND
//
extension StartVC {
    
    func playSound(filename: String) {
        
        if DUMP {debugDump()}
        if DEBUG {print(#function)}
        
        if filename == "TOGGLE" {
            guard !trainer.isPlaying else {
                print("no toggle sounds while chords are playing!")
                return
            }
        }
        
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else { return }
        do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

                /* iOS 10 and earlier require the following line:
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

                guard let player = player else { return }

                player.play()

            } catch let error {
                print(error.localizedDescription)
            }
    }
}

//
// MARK: - STOP SOUND
//
extension StartVC {
    
    func stopSound() {
        
        guard let player = player else {return}
        if player.isPlaying {
            player.stop()
            print("STOPPING AUDIO")
        }
        
    }
}

//
// MARK: - Chord Button Actions
//
extension StartVC {

    @IBAction func chordButtonPressed(_ sender: UIButton) {

        if DUMP {debugDump()}
        if DEBUG {print(#function)}
        
        guard !trainer.isEvaluating else {
            print("wait until evaluation is over!")
            return
        }
        
//        guard !trainer.hasBeenEvaluated else {
//            showAlert("Press PLAY!", message: "Your answers have been evaluated already.")
//            return
        //        }
        //
        if !trainer.hasBeenEvaluated {
            
            let tag = sender.tag
            print("Tag = \(tag)")
            switch tag {
            case 1:
                
                majButton1.isSelected = true
                minButton1.isSelected = false
                trainer.answer[0] = chordQuality.major
            case 2:
                
                majButton1.isSelected = false
                minButton1.isSelected = true
                trainer.answer[0] = chordQuality.minor
            case 3:
                
                majButton2.isSelected = true
                minButton2.isSelected = false
                trainer.answer[1] = chordQuality.major
            case 4:
                
                majButton2.isSelected = false
                minButton2.isSelected = true
                trainer.answer[1] = chordQuality.minor
            case 5:
                
                majButton3.isSelected = true
                minButton3.isSelected = false
                trainer.answer[2] = chordQuality.major
            case 6:
                
                majButton3.isSelected = false
                minButton3.isSelected = true
                trainer.answer[2] = chordQuality.minor
            case 7:
                
                majButton4.isSelected = true
                minButton4.isSelected = false
                trainer.answer[3] = chordQuality.major
            case 8:
                
                majButton4.isSelected = false
                minButton4.isSelected = true
                trainer.answer[3] = chordQuality.minor
            case 9:
                
                majButton5.isSelected = true
                minButton5.isSelected = false
                trainer.answer[4] = chordQuality.major
            case 10:
                
                majButton5.isSelected = false
                minButton5.isSelected = true
                trainer.answer[4] = chordQuality.minor
            default:
                showAlert("This shouldn't have happened at all.")
            }
            
            //
            // Activate evaluateButton
            //
            if !trainer.answer.contains(chordQuality.undefined) {
                evaluateButton.isEnabled = true
            }
            
            
            if DEBUG { print(trainer.answer) }
            
            playSound(filename: "TOGGLE")
            
        } else {
            
            //
            // Evaluation is over, now chords are being played when buttons are pressed
            //
            let tag = sender.tag
            print("Tag = \(tag)")
            switch tag {
            case 1:
                
                playSound(filename: getChordName(str: (trainer.sequence?[0])!) + "_maj")
            case 2:
                
                playSound(filename: getChordName(str: (trainer.sequence?[0])!) + "_min")
            case 3:
                
                playSound(filename: getChordName(str: (trainer.sequence?[1])!) + "_maj")
            case 4:
                
                playSound(filename: getChordName(str: (trainer.sequence?[1])!) + "_min")
            case 5:
                
                playSound(filename: getChordName(str: (trainer.sequence?[2])!) + "_maj")
            case 6:
                
                playSound(filename: getChordName(str: (trainer.sequence?[2])!) + "_min")
            case 7:
                
                playSound(filename: getChordName(str: (trainer.sequence?[3])!) + "_maj")
            case 8:
                
                playSound(filename: getChordName(str: (trainer.sequence?[3])!) + "_min")
            case 9:
                
                playSound(filename: getChordName(str: (trainer.sequence?[4])!) + "_maj")
            case 10:
                
                playSound(filename: getChordName(str: (trainer.sequence?[4])!) + "_min")
            default:
                showAlert("This shouldn't have happened at all.")
            }
            
            
        }
    }
    
}

//
// MARK: - Evaluate answer
//
extension StartVC {
    
    @IBAction func evaluatePressed(_ sender: UIButton) {
        
        if DUMP {debugDump()}
        if DEBUG {print(#function)}
        
//        guard !trainer.isPlaying else {
//            showAlert("Still Playing - Please Wait!")
//            return
//        }
        
        while trainer.isPlaying {
            return
        }
        
        //guard trainer.answer.count == trainer.numberOfChords  else {
        guard !trainer.answer.contains(chordQuality.undefined) else {
            showAlert("Please make a guess for every chord!", message: "Choose either major or minor.")
            return
        }
        
        guard trainer.solution?.count == trainer.userSettings.numberOfChords else {
            showAlert("No quizz chords have been chosen yet", message: "Press Play first!")
            return
        }
        
        
        //
        // Clear eval colors array
        //
        trainer.imgColors = []
        
        print(trainer.answer)
        print(trainer.solution)
        
        guard let evalIm = evalutationImageViews else {return}
        
        let limit = (trainer.userSettings.numberOfChords - 1)
        print("Limit: \(0...limit)")
        
        trainer.isEvaluating = true
        
        var offset = 0.0
        for index in 0...limit {
            
            DispatchQueue.main.asyncAfter(deadline: (.now() + offset)) {
                
                if let solution = self.trainer.solution?[index] {
                    
                    let answer = self.trainer.answer[index]
                    
                    if answer == solution {
                        
                        //
                        // Right answer
                        //
                        
                        //
                        // use green checkmark as image
                        //
                        evalIm[index].image = UIImage(systemName: K.Image.successImage)
                        evalIm[index].tintColor = .green
                        
                        //
                        // color correct button's text green and display "Right!" text
                        //
                        var buttonToColorGreen: UIButton?
                        var qual: String = ""
                        
                        if solution == chordQuality.major {
                            buttonToColorGreen = self.majorButtons[index]
                            qual = "Major"
                        } else if solution == chordQuality.minor {
                            buttonToColorGreen = self.minorButtons[index]
                            qual = "Minor"
                        }
                        
                        buttonToColorGreen?.setBackgroundColor(color: K.Color.rightAnswerColor, forState: .selected)
                        buttonToColorGreen?.setTitle("Right! " + qual, for: .selected)
                        
                        //
                        // play success sound
                        //
                        self.playSound(filename: K.Sound.successSound)
                        
                        //
                        // remember symbol's color
                        //
                        self.trainer.imgColors.append("green")
                        
                    } else {
                    
                        //
                        // Wrong answer
                        //
                        
                        //
                        // use red X as image
                        //
                        evalIm[index].image = UIImage(systemName: K.Image.failureImage)
                        evalIm[index].tintColor = K.Color.wrongAnswerColor
                        
                        //
                        // color chosen wrong button's text red, other right button' text green
                        //
                        var buttonToColorGreen: UIButton?
                        var buttonToColorRed: UIButton?
                        var rightQual: String = ""
                        var wrongQual: String = ""
                        
                        if solution == chordQuality.major {
                            
                            buttonToColorGreen = self.majorButtons[index]
                            buttonToColorRed = self.minorButtons[index]
                            rightQual = "Major"
                            wrongQual = "Minor"
                            
                        } else if solution == chordQuality.minor {
                            
                            buttonToColorGreen = self.minorButtons[index]
                            buttonToColorRed = self.majorButtons[index]
                            rightQual = "Minor"
                            wrongQual = "Major"
                        }
                        
                        //
                        // Mark selected wrong button
                        //
                        buttonToColorGreen?.setBackgroundColor(color: K.Color.rightAnswerColor, forState: .normal)
                        buttonToColorGreen?.setTitle("Correct answer: " + rightQual, for: .normal)
                        
                        //
                        // Mark unselected right button
                        //
                        buttonToColorRed?.setBackgroundColor(color: K.Color.wrongAnswerColor, forState: .selected)
                        buttonToColorRed?.setTitle("Wrong choice: " + wrongQual, for: .selected)
                        
                        //
                        // play failure sound
                        //
                        self.playSound(filename: K.Sound.failureSound)
                        
                        //
                        // remember symbol's color
                        //
                        self.trainer.imgColors.append("red")
                        
                    }
                    
                    
                    
                    //print("imags count = \(self.trainer.imgColors?.count)")
                    //print("colors  = \(self.trainer.imgColors)")
                    
                    //evalIm[index].isHidden = false
                }
            }
            offset += self.trainer.pauseBetweenResults
            //print("offset \(offset) added!")
        }
        
        //
        // Reset isPlaying flag to false
        //
        let timeToResetPlayingStatus = (Double(limit + 2) * self.trainer.pauseBetweenResults)
        DispatchQueue.main.asyncAfter(deadline: (.now() + timeToResetPlayingStatus)) {
            self.trainer.isEvaluating = false
        }
        
        //
        // Disable evaluateButton, set hasBeenEvaluated flag
        //
        evaluateButton.isEnabled = false
        trainer.hasBeenEvaluated = true
    }
}

//
// MARK: - Show Alert
//
extension StartVC {
    
    func showAlert(_ text: String, message: String? = "") {
        
        if DUMP {debugDump()}
        
        let alert = UIAlertController(title: text, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}

//
// MARK: - blink extension for buttons
//
public extension UIView {
    
  func blink(duration: TimeInterval) {

    
    let initialAlpha: CGFloat = 1
    let finalAlpha: CGFloat = 0.2
    
    alpha = initialAlpha
    
    UIView.animateKeyframes(withDuration: duration, delay: 0, options: .beginFromCurrentState) {
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
        self.alpha = finalAlpha
      }
      
      UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
        self.alpha = initialAlpha
      }
    }
  }
}

//
// MARK: - flash extension for buttons
//
extension UIButton {

    func flash() {

    
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.3
        flash.fromValue = 1
        flash.toValue = 0.0
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 10

        layer.add(flash, forKey: nil)
    }
}

//
// MARK: - Reset UI
//
// Called everytime PLAY is pressed. And right after starting.
// Additional one-time setup is done in setupButtons()
//
extension StartVC {
    
    func resetUI() {
        
        if DEBUG {print(#function)}
        if DUMP {debugDump()}
        
        //
        // Reset buttons
        //
        for button in majorButtons {
            //button.backgroundColor = K.Color.majorButtonColor
            button.setBackgroundColor(color: K.Color.majorButtonColor, forState: .normal)
            button.setTitle("Major", for: .normal)
            button.setTitle("Your guess: Major", for: .selected)
        }
        for button in minorButtons {
            //button.backgroundColor = K.Color.minorButtonColor
            button.setBackgroundColor(color: K.Color.minorButtonColor, forState: .normal)
            button.setTitle("Minor", for: .normal)
            button.setTitle("Your guess: Minor", for: .selected)
        }
        
        
        for button in answerButtons {
            button.isSelected = false
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 3
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = .byClipping
            button.titleLabel?.font = UIFont(name: "Helvetica", size:16)
            button.setTitleColor(K.Color.buttonTextColor, for: .normal)
            button.setTitleColor(K.Color.selectedLabelTextColor, for: .selected)
            button.setBackgroundColor(color: K.Color.selectedLabelBgColor, forState: .selected)
        }
        
        
        //
        // Disable evaluateButton, reset hasBeenEvaluated flag
        //
        evaluateButton.isEnabled = false
        
        //
        // Set ImageViews to questionmarks
        //
        if let evalIm = evalutationImageViews {
            for index in 0...(trainer.userSettings.numberOfChords-1) {
                evalIm[index].image = UIImage(systemName: K.Image.questionImage)
                evalIm[index].tintColor = K.Color.questionMarkColor
                trainer.imgColors.append("white")
            }
        }
    }
}

extension UIButton {

    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        
       // if DEBUG {print(#function)}

        
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }

}

extension StartVC {
    
    func debugDump() {
        
        print("self.trainer.imgColors. = \(self.trainer.imgColors)")
    }
}

extension StartVC {
    
    func getChordName(str: String) -> String {
        
        print()
        var result = ""
        if let index = str.firstIndex(of: "_") {
            result = String(str.prefix(upTo: index))
            print("Chordname = \(result)")
            return result
        }
        return result
    }
}
