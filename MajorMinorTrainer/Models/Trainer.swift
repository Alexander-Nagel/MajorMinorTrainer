//
//  Trainer.swift
//  MajorMinorTrainer
//
//  Created by Alexander Nagel on 06.04.21.
//

import Foundation

enum chordQuality: Int {
    case major = 1
    case minor = 2
    case undefined = 3
}

struct UserSettings {
    var numberOfChords: Int = 3
    var pauseBetweenChords = 1.2
    var pauseBetweenResults = 0.3
}


class Trainer {
    
    var userSettings = UserSettings()
    //var numberOfChords = 4
    //var pauseBetweenChords = 1.1
    //var pauseBetweenResults = 0.6
    var sequence: [String]? = []
    var solution: [chordQuality]? = []
    var answer: [chordQuality] = []
    var imgColors: [String] = []
    var isPlaying = false
    var isEvaluating = false
    var hasBeenEvaluated = false
    
    
    let majorChords = ["C_maj", "C#_maj", "D_maj", "D#_maj", "E_maj", "F_maj", "F#_maj", "G_maj", "G#_maj", "A_maj", "A#_maj", "B_maj"]
    let minorChords = ["C_min", "C#_min", "D_min", "D#_min", "E_min", "F_min", "F#_min", "G_min", "G#_min", "A_min", "A#_min", "B_min"]
    
    
    
    
    init() {
        answer = Array(repeating: chordQuality.undefined, count: userSettings.numberOfChords)
        imgColors = []
    }
    
    func createSequence(){

        sequence = []
        solution = []
        answer = Array(repeating: chordQuality.undefined, count: userSettings.numberOfChords)
        imgColors = Array(repeating: "white", count: userSettings.numberOfChords)
        //imgColors = []
        hasBeenEvaluated = false
        isPlaying = true
        
        for _ in 1...userSettings.numberOfChords {
            
            guard let quality = chordQuality(rawValue: Int.random(in: 1...2)) else {
               return
            }
            
            solution?.append(quality)
            
            if quality == chordQuality.major {
                let chord = majorChords[Int.random(in: 0...11)]
                //print(chord)
                sequence?.append(chord)
            } else {
                let chord = minorChords[Int.random(in: 0...11)]
                //print(chord)
                sequence?.append(chord)
            }
            //print(sequence)
        }
    }
}

func round (_ input: Double, toDigits digits: Int) -> Double {
    
    return Double(String(format: "%0.\(digits)f", input)) ?? 0
}
