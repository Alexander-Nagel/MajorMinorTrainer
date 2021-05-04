//
//  StartVC.swift
//  MajorMinorTrainer
//
//  Created by Alexander Nagel on 06.04.21.
//

import UIKit
import AVFoundation

let DEBUG = false
let DUMP = false

class StartVC: UIViewController {

    //let button: UIButton = UIButton()
    
    var player: AVAudioPlayer?
    var workItem: DispatchWorkItem?
    var queue: DispatchQueue?

    let trainer = Trainer()
   
//
// MARK: - Outlets
//
        
    @IBOutlet weak var hiddenLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var minorLabel: UILabel!

    // ROW 1
    
    @IBOutlet weak var evalImage1: UIImageView!
    
    @IBOutlet weak var majButton1: UIButton!
    @IBOutlet weak var xMarkMaj1: UIImageView!
    @IBOutlet weak var playMaj1: UIImageView!
    
    @IBOutlet weak var minButton1: UIButton!
    @IBOutlet weak var xMarkMin1: UIImageView!
    @IBOutlet weak var playMin1: UIImageView!

    // ROW 2
    
    @IBOutlet weak var evalImage2: UIImageView!

    @IBOutlet weak var majButton2: UIButton!
    @IBOutlet weak var xMarkMaj2: UIImageView!
    @IBOutlet weak var playMaj2: UIImageView!

    @IBOutlet weak var minButton2: UIButton!
    @IBOutlet weak var xMarkMin2: UIImageView!
    @IBOutlet weak var playMin2: UIImageView!

    // ROW 3

    @IBOutlet weak var evalImage3: UIImageView!
    
    @IBOutlet weak var majButton3: UIButton!
    @IBOutlet weak var xMarkMaj3: UIImageView!
    @IBOutlet weak var playMaj3: UIImageView!

    @IBOutlet weak var minButton3: UIButton!
    @IBOutlet weak var xMarkMin3: UIImageView!
    @IBOutlet weak var playMin3: UIImageView!

    // ROW 4
    
    @IBOutlet weak var evalImage4: UIImageView!
   
    @IBOutlet weak var majButton4: UIButton!
    @IBOutlet weak var xMarkMaj4: UIImageView!
    @IBOutlet weak var playMaj4: UIImageView!

    @IBOutlet weak var minButton4: UIButton!
    @IBOutlet weak var xMarkMin4: UIImageView!
    @IBOutlet weak var playMin4: UIImageView!

    // ROW 5
    
    @IBOutlet weak var evalImage5: UIImageView!
   
    @IBOutlet weak var majButton5: UIButton!
    @IBOutlet weak var xMarkMaj5: UIImageView!
    @IBOutlet weak var playMaj5: UIImageView!
    
    @IBOutlet weak var minButton5: UIButton!
    @IBOutlet weak var xMarkMin5: UIImageView!
    @IBOutlet weak var playMin5: UIImageView!

    @IBOutlet weak var buttonColumn1: UIStackView!
    @IBOutlet weak var buttonColumn2: UIStackView!
    @IBOutlet weak var buttonColumn3: UIStackView!
    @IBOutlet weak var buttonColumn4: UIStackView!
    @IBOutlet weak var buttonColumn5: UIStackView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var evaluateButton: UIButton!
    @IBOutlet weak var keyLabel: UILabel!
    
    var buttonColumns: [UIStackView] = []
    var answerButtons: [UIButton] = []
    var majorButtons:  [UIButton] = []
    var minorButtons:  [UIButton] = []
    var xMarkImageViews:  [UIImageView] = []
    var xMarkMajImageViews:  [UIImageView] = []
    var xMarkMinImageViews:  [UIImageView] = []
    var playImageViews: [UIImageView] = []
    var evalutationImageViews: [UIImageView]?
    
//
// MARK: - Lifecycle
//
    override func viewDidLoad() {
        
        //if DUMP {debugDump()}
        if DEBUG {print(#function)}
        
        super.viewDidLoad()
        
        // for index in 1...6 {print(index.toRoman())}
        
        //
        // DELETEME! Retrieve UserDefaults file path
        //
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = documents.appendingPathComponent("tempImage_wb.jpg")
        //print("Documents directory:", imageURL.path)
        
        //
        // Load User Settings
        //
        trainer.loadUserSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //print(#function)
 
        // https://stackoverflow.com/questions/39494454/pass-data-between-viewcontroller-and-tabbarcontroller
        
        //
        // Passing data to SettingsVC ( = subclass of UINavigationController)
        //
        let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        let destinationVC = navController.topViewController as! SettingsVC
        destinationVC.numberOfChords = self.trainer.settings.numberOfChords
        destinationVC.pauseBetweenChords = self.trainer.settings.pauseBetweenChords
        destinationVC.startImmediatelyAfterCorrectResult = self.trainer.settings.autoRestart
        destinationVC.diatonicMode = self.trainer.settings.diatonicMode
        
        trainer.sequence = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if DEBUG {print(#function)}
        
        //
        // Setup Buttons
        //
        buttonColumns = [buttonColumn1, buttonColumn2, buttonColumn3, buttonColumn4, buttonColumn5]
        answerButtons = [majButton1, minButton1, majButton2, minButton2, majButton3, minButton3, majButton4, minButton4, majButton5, minButton5]
        evalutationImageViews = [evalImage1, evalImage2, evalImage3, evalImage4, evalImage5]
        majorButtons = [majButton1, majButton2, majButton3, majButton4, majButton5]
        minorButtons = [minButton1, minButton2, minButton3, minButton4, minButton5]
        xMarkImageViews = [xMarkMaj1, xMarkMin1, xMarkMaj2, xMarkMin2, xMarkMaj3, xMarkMin3, xMarkMaj4, xMarkMin4, xMarkMaj5, xMarkMin5]
        xMarkMajImageViews = [xMarkMaj1, xMarkMaj2, xMarkMaj3, xMarkMaj4, xMarkMaj5]
        xMarkMinImageViews = [xMarkMin1, xMarkMin2, xMarkMin3, xMarkMin4, xMarkMin5]
        playImageViews = [playMaj1, playMin1, playMaj2, playMin2, playMaj3, playMin3, playMaj4, playMin4, playMaj5, playMin5]
        
        //
        // Play button flashes when view appears
        //
        playButton.flash(intervalDuration: 0.1, intervals: 20)
        
        //
        // Init parameters
        //
        trainer.beforeFirstRun = true
        trainer.hasBeenEvaluated = false
        
        //
        // Reset UI
        //
        resetUI()
    }
}

    
//
// MARK: - PLAY BUTTON
//
extension StartVC {
    
    @IBAction func playPressed(_ sender: UIButton) {
        
        //if DUMP {debugDump()}
        //if DEBUG {print(#function)}
        
        guard !trainer.isEvaluating else {
            //print("wait until evaluation is over!")
            return
        }
        
        guard !trainer.isPlaying else {
            //print("wait till playing is over")
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
                //self.evalutationImageViews![arrIndex].tintColor = K.Color.questionMarkPlayingColor
               
                self.majorButtons[arrIndex].flash()
                self.minorButtons[arrIndex].flash()
                self.evalutationImageViews![arrIndex].flash()
                
                
                // play sound
                self.playSound(filename: name)
                
                // set previous questionmark color back to white:
                //if arrIndex > 0 {self.evalutationImageViews![arrIndex-1].tintColor = K.Color.questionMarkColor}
                
                arrIndex += 1
            }
            offset += self.trainer.settings.pauseBetweenChords
        }
        
        //
        // Set last questionmark back to white color
        //
        DispatchQueue.main.asyncAfter(deadline: (.now() + offset)) {
            //self.evalutationImageViews![arrIndex-1].tintColor = K.Color.questionMarkColor
            
            self.trainer.isPlaying = false
            self.trainer.beforeFirstRun = false
            self.repeatButton.isHidden = false
        }
        
        //print("is playing? \(trainer.isPlaying)")
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
            //print("Can't repeat while playing!")
            return
        }
        
        guard !trainer.isEvaluating else {
            //print("Wait until evaluation is over!")
            return
        }
        
        guard trainer.sequence?.count != 0 else {
            //print("trainer.sequence?.count != 0")
            return
        }
        
//        guard trainer.imgColors.count != 0 else {
//            print("trainer.imgColors.count != 0")
//            return
//        }
        
        guard let fileNames = trainer.sequence,
              let solution = trainer.solution else {
            return
        }
        
        //
        // Play chords and set questionmark color of playing chord to black
        //
        var offset = 0.0 // offset in seconds = scheduled time to play each chord
        var arrIndex = 0 // index of imgCols array (that remembers the colors to set back the imgViews). Counts from 0 to 1,2,3 or 4 (according to numberOfChords-1)
       
        trainer.isPlaying = true
        
        //
        // Go through each chord/filename, schedule its playing time
        // When playing time is there: Play it and color imgView temporarily black
        //
        for name in fileNames {
            
            //
            // Schedule playing time of chord: First one immediately, each next one offset seconds later
            //
            DispatchQueue.main.asyncAfter(deadline: (.now() + offset)) {
                
                //
                // Flash while playing back
                //
                if self.trainer.hasBeenEvaluated {
                    
                    //
                    // After Evaluation: Flash solution chord buttons while playing
                    //
                    if solution[arrIndex] == chordQuality.major {
                        self.majorButtons[arrIndex].flash()
                    } else {
                        self.minorButtons[arrIndex].flash()
                    }
                    
                } else {
                    
                    //
                    // Before Evaluation: Flash complete column while playing
                    //
                    self.majorButtons[arrIndex].flash()
                    self.minorButtons[arrIndex].flash()
                    self.evalutationImageViews![arrIndex].flash()
                }
                
                //
                // Play chord
                //
                self.playSound(filename: name)
                
                //
                // Proceed to next imgColors array item
                //
                arrIndex += 1
                
            }
            offset += self.trainer.settings.pauseBetweenChords
        }
            
        //
        // Reset isPlaying flag to false when playing is over
        //
        DispatchQueue.main.asyncAfter(deadline: (.now() + offset)) {
        
            self.trainer.isPlaying = false
        }
        
        //
        // Reset previous maj or min color to green (if it's the solution)
        //
//        let limit = (trainer.settings.numberOfChords - 1)
//        let timeToResetLastColor = (Double(limit + 1) * self.trainer.pauseBetweenResults)
//        print("öööö \(timeToResetLastColor)")
//
//        DispatchQueue.main.asyncAfter(deadline: (.now() + timeToResetLastColor)) {
//
//
//        }
        
    }
}

//
// MARK: - PLAY SOUND
//
extension StartVC {
    
    func playSound(filename: String) {
        
        //if DUMP {debugDump()}
        //if DEBUG {print(#function)}
        
        if filename == "TOGGLE" {
            guard !trainer.isPlaying else {
                //print("no toggle sounds while chords are playing!")
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
                //print(error.localizedDescription)
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

       // if DUMP {debugDump()}
       // if DEBUG {print(#function)}
        
        guard !trainer.isEvaluating else {
            print("wait until evaluation is over!")
            return
        }
        
        guard trainer.sequence?.count != 0 else {
            
            playButton.flash(intervalDuration: 0.1, intervals: 20)
            return
            
        }
        
        if !trainer.hasBeenEvaluated {
            
            //
            // Behaviour before evaluation: Chosen button is colored orange. Play NO sound when presed.
            //
            
            let tag = sender.tag
            // print("Tag = \(tag)")
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
            // Activate evaluateButton (and let it flash!) if all guesses are made
            //
            if !trainer.answer.contains(chordQuality.undefined) {
                evaluateButton.isEnabled = true
                evaluateButton.isHidden = false
                evaluateButton.flash(intervalDuration: 0.1, intervals: 30)
            }
            
            //if DEBUG { print(trainer.answer) }
            
            //
            // Play toggle sound
            //
            playSound(filename: "TOGGLE")
            
        } else {
            
            //
            // Evaluation is over, now chords are being played when buttons are pressed
            //
            let tag = sender.tag
            print("Tag = \(tag)")
            switch tag {
            case 1:
                
                playSound(filename: trainer.getChordNameFromFileName(fileName: (trainer.sequence?[0])!) + "_maj")
            case 2:
                
                playSound(filename: trainer.getChordNameFromFileName(fileName: (trainer.sequence?[0])!) + "_min")
            case 3:
                
                playSound(filename: trainer.getChordNameFromFileName(fileName: (trainer.sequence?[1])!) + "_maj")
            case 4:
                playSound(filename: trainer.getChordNameFromFileName(fileName: (trainer.sequence?[1])!) + "_min")
        
            case 5:
                
                playSound(filename: trainer.getChordNameFromFileName(fileName: (trainer.sequence?[2])!) + "_maj")
            case 6:
                
                playSound(filename: trainer.getChordNameFromFileName(fileName: (trainer.sequence?[2])!) + "_min")
            case 7:
                
                playSound(filename: trainer.getChordNameFromFileName(fileName: (trainer.sequence?[3])!) + "_maj")
            case 8:
                
                playSound(filename: trainer.getChordNameFromFileName(fileName: (trainer.sequence?[3])!) + "_min")
            case 9:
                
                playSound(filename: trainer.getChordNameFromFileName(fileName: (trainer.sequence?[4])!) + "_maj")
            case 10:
                
                playSound(filename: trainer.getChordNameFromFileName(fileName: (trainer.sequence?[4])!) + "_min")
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
        
        guard trainer.solution?.count == trainer.settings.numberOfChords else {
            showAlert("No quizz chords have been chosen yet", message: "Press Play first!")
            return
        }
        
        //
        // Clear eval colors array
        //
        trainer.imgColors = []
        
        //print(trainer.answer)
        //print(trainer.solution)
        
        guard let evalIm = evalutationImageViews else {return}
        
        let limit = (trainer.settings.numberOfChords - 1)
        
        trainer.isEvaluating = true
        
        var offset = 0.0
        for index in 0...limit {
            
            DispatchQueue.main.asyncAfter(deadline: (.now() + offset)) {
                
                if let solution = self.trainer.solution?[index] {
                    
                    let answer = self.trainer.answer[index]
                    
                    //
                    // Extract current Root and Chord Quality from filename
                    //
                    let chordRoot = self.trainer.getChordNameFromFileName(fileName: self.trainer.sequence?[index] ?? "")
                    var chordQual = self.trainer.getChordQualityFromFileName(fileName: self.trainer.sequence?[index] ?? "")
                    //print("root = \(chordRoot)")
                    //print("qual = \(chordQuality)")
                    chordQual = chordQual == "maj" ? "": "m"
                    
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
                        var wrongButNotChosenButton: UIButton?
                        var qual: String = ""
                        
                        if solution == chordQuality.major {
                            buttonToColorGreen = self.majorButtons[index]
                            wrongButNotChosenButton = self.minorButtons[index]
                            qual = "Major"
                            wrongButNotChosenButton?.setTitle("\(chordRoot)m", for: .normal)
                        } else if solution == chordQuality.minor {
                            buttonToColorGreen = self.minorButtons[index]
                            wrongButNotChosenButton = self.majorButtons[index]
                            qual = "Minor"
                            wrongButNotChosenButton?.setTitle("\(chordRoot)", for: .normal)
                        }
                        
                        buttonToColorGreen?.setBackgroundColor(color: K.Color.chosenRightAnswerColor, forState: .selected)
                        buttonToColorGreen?.setTitle("\(chordRoot)\(chordQual)", for: .selected)
                        wrongButNotChosenButton?.setTitleColor(K.Color.wrongButNotChosenButtonTextColor, for: .normal)

                        //
                        // play success sound
                        //
                        self.playSound(filename: K.Sound.successSound)
                        
                        //
                        // remember symbol's color
                        //
                        //self.trainer.imgColors.append("green")
                        
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
                        // Mark unselected button as right
                        //
                        //buttonToColorGreen?.setBackgroundColor(color: K.Color.rightAnswerColor, forState: .normal)
                        buttonToColorGreen?.setTitle("\(chordRoot)\(chordQual)", for: .normal)
                        buttonToColorGreen?.setTitleColor(K.Color.correctButNotChosenButtonTextColor, for: .normal)
                        buttonToColorGreen?.setBackgroundColor(color: K.Color.notChosenRightAnswerBGColor, forState: .normal)
                        
                        //
                        // Mark selected button as wrong
                        //
                        buttonToColorRed?.setBackgroundColor(color: K.Color.wrongAnswerColor, forState: .selected)
                        //buttonToColorRed?.setTitle("Wrong choice: " + wrongQual, for: .selected)
                        if chordQual == "" {
                            // if maj is right, mark min button as wrong
                            self.xMarkMinImageViews[index].isHidden = false
                            buttonToColorRed?.setTitle("\(chordRoot)m", for: .selected)
                        } else {
                            // if min is right, mark maj button as wrong
                            self.xMarkMajImageViews[index].isHidden = false
                            buttonToColorRed?.setTitle("\(chordRoot)", for: .selected)

                        }
                        
                        //
                        // play failure sound
                        //
                        self.playSound(filename: K.Sound.failureSound)
                        
                        //
                        // remember symbol's color
                        //
                        //self.trainer.imgColors.append("red")
                        
                    }
                    
                    //
                    // Show small play buttons on chord buttons
                    //
                    for iv in self.playImageViews {
                        iv.isHidden = false
                    }
                }
            }
            offset += self.trainer.pauseBetweenResults
            //print("offset \(offset) added!")
        }
        
        keyLabel.isHidden = true // TODO! FIX STYLING!
        if let key = trainer.key {
            keyLabel.text = "Root \(key)"
        }
        
        //
        // Reset isPlaying flag to false
        //
        let timeToResetPlayingStatus = (Double(limit + 2) * self.trainer.pauseBetweenResults)
        DispatchQueue.main.asyncAfter(deadline: (.now() + timeToResetPlayingStatus)) {
            self.trainer.isEvaluating = false
            
            //
            // restart if all answer are correct and startImmediatelyAfterCorrectResult is set
            //
            if self.trainer.solution == self.trainer.answer {
                if self.trainer.settings.autoRestart {
                    self.playPressed(self.playButton)
                }
            }
        }
        
        //
        // Disable evaluateButton, set hasBeenEvaluated flag
        //
        evaluateButton.isEnabled = false
        evaluateButton.isHidden = true
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
// MARK: - Reset UI
//
// Called everytime PLAY is pressed. And right after starting.
// Additional one-time setup is done in viewWillAppear()
//
extension StartVC {
    
    func resetUI() {
        
        if DEBUG {print(#function)}
        if DUMP {debugDump()}
        
        if trainer.beforeFirstRun == true {
            repeatButton.isHidden = true
        }
        
        
        //
        // Hide all columns
        //
        for index in 0...4 {
            buttonColumns[index].isHidden = true
            //evalIm[index].isHidden = true
        }

        //
        // Show columns needed for test
        //
        let limit = (trainer.settings.numberOfChords - 1)
        //print("Limit: \(0...limit)")
        for index in 0...limit {
            buttonColumns[index].isHidden = false
        }
        
        //
        // Style buttons
        //
        for button in answerButtons {
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 0
            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            //button.setTitleShadowColor(.yellow, for: .selected)
            button.setTitleColor(K.Color.selectedLabelTextColor, for: .selected)
            button.setTitleColor(K.Color.buttonTextColor, for: .normal)
        }
        
       // majorLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / CGFloat( 180 / -90))
       //majorLabel.backgroundColor = K.Color.majorButtonColor
       
        //minorLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / CGFloat( 180 / -90))
       // minorLabel.backgroundColor = K.Color.minorButtonColor
        
        //
        // Hide all playButtons
        //
        for iv in playImageViews {
            iv.isHidden = true
        }
        
        keyLabel.isHidden = true
        keyLabel.lineBreakMode = .byWordWrapping
        keyLabel.numberOfLines = 0
        keyLabel.font = keyLabel.font.withSize(28)
        keyLabel.textColor = K.Color.selectedLabelBgColor
        
        keyLabel.adjustsFontSizeToFitWidth = true
        
        
        
        //
        // Hide all xmarks
        //
        for iv in xMarkImageViews {
            iv.isHidden = true
            iv.alpha = 0.75
        }
        
        evaluateButton.isHidden = true
        
        //
        // Reset buttons
        //
        for button in majorButtons {
            //button.backgroundColor = K.Color.majorButtonColor
            button.setBackgroundColor(color: K.Color.majorButtonColor, forState: .normal)
            //button.setTitle("Major", for: .normal)
            button.setTitle("", for: .normal)

            button.setTitle("", for: .selected)
        }
        for button in minorButtons {
            //button.backgroundColor = K.Color.minorButtonColor
            button.setBackgroundColor(color: K.Color.minorButtonColor, forState: .normal)
           // button.setTitle("Minor", for: .normal)
            button.setTitle("", for: .normal)

            button.setTitle("", for: .selected)
        }
        
        
        for button in answerButtons {
            button.isSelected = false
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = .byClipping
            //button.titleLabel?.font = UIFont(name: "Helvetica", size:16)
            button.setTitleColor(K.Color.buttonTextColor, for: .normal)
            button.setTitleColor(K.Color.selectedLabelTextColor, for: .selected)
            button.setBackgroundColor(color: K.Color.selectedLabelBgColor, forState: .selected)
        }
        
        //
        // Disable evaluateButton, reset hasBeenEvaluated flag
        //
       // evaluateButton.isEnabled = false
        
        //
        // Set ImageViews to questionmarks
        //
        if let evalIm = evalutationImageViews {
            for index in 0...(trainer.settings.numberOfChords-1) {
                evalIm[index].image = UIImage(systemName: K.Image.questionImage)
                evalIm[index].tintColor = K.Color.questionMarkColor
                trainer.imgColors.append("white")
            }
        }
        
        keyLabel.isHidden = true
        keyLabel.text = ""
        
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



extension Int {
    
    func toRoman() -> String {
        
        var romanNumber = ""
        switch self {
        case 1:
            romanNumber = "I"
        case 2:
            romanNumber = "II"
        case 3:
            romanNumber = "III"
        case 4:
            romanNumber = "IV"
        case 5:
            romanNumber = "V"
        case 6:
            romanNumber = "VI"
        default:
            romanNumber = ""
        }
        
        return romanNumber
    }
    
}
