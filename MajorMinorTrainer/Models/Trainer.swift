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
    var startImmediatelyAfterCorrectResult = false 
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
    var beforeFirstRun = true
    var diatonicMode = false
    var repeatingChords = false
    var uniqueChords = false
    
    
    let majorChords = ["C_maj", "C#_maj", "D_maj", "D#_maj", "E_maj", "F_maj", "F#_maj", "G_maj", "G#_maj", "A_maj", "A#_maj", "B_maj"]
    let minorChords = ["C_min", "C#_min", "D_min", "D#_min", "E_min", "F_min", "F#_min", "G_min", "G#_min", "A_min", "A#_min", "B_min"]
    let majorIndices = [0, 2, 4, 5, 7, 9, 11] // 1 2 3  4 5 6 7
    let minorIndices = [0, 2, 3, 5, 7, 8, 10] // 1 2 b3 4 5 b6 b7
    let diatonicChords = [
        ["C_maj", "D_min", "E_min", "F_maj", "G_maj", "A_min"],
        ["Db_maj", "Eb_min", "F_min", "Gb_maj", "Ab_maj", "Bb_min"],
        ["D_maj", "E_min", "F#_min", "G_maj", "A_maj", "B_min"],
        ["Eb_maj", "F_min", "G_min", "Ab_maj", "Bb_maj", "C_min"],
        ["E_maj", "F#_min", "G#_min", "A_maj", "B_maj", "C#_min"],
        ["F_maj", "G_min", "A_min", "Bb_maj", "C_maj", "D_min"],
        ["F#_maj", "G#_min", "A#_min", "B_maj", "C#_maj", "D#_min"],
        ["G_maj", "A_min", "B_min", "C_maj", "D_maj", "E_min"],
        ["Ab_maj", "Bb_min", "C_min", "Db_maj", "Eb_maj", "F_min"],
        ["A_maj", "B_min", "C#_min", "D_maj", "E_maj", "F#_min"],
        ["Bb_maj", "C_min", "D_min", "Eb_maj", "F_maj", "G_min"],
        ["B_maj", "C#_min", "D#_min", "E_maj", "F#_maj", "G#_min"],
        ]
    
    
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
        
        if !diatonicMode {
            //
            // default chromatic mode
            //

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
        } else {
            //
            // diatonic mode
            //
            
            
            let randomKey = diatonicChords[Int.random(in: 0...11)]
            print(randomKey)
            
            for index in 1...userSettings.numberOfChords {
                
                var randomDiatonicChord = ""
                
                if !repeatingChords && !uniqueChords {
                    print("CASE 1")
                    repeat {
                        randomDiatonicChord = randomKey[Int.random(in: 0...5)]
                        print(randomDiatonicChord)
                    } while (randomDiatonicChord == sequence?.last)
                }
                
                // TODO: fix this!
//                if !repeatingChords && uniqueChords {
//                    print("CASE 2")
//                    var isNotUnique = true
//                    repeat {
//                        if let seq = sequence?.contains(randomDiatonicChord) {
//                            randomDiatonicChord = randomKey[Int.random(in: 0...5)]
//                            print(randomDiatonicChord)
//                            print("Contained? \(seq))")
//                            isNotUnique = seq ?
//                            print("isNotUnique = \(isNotUnique)")
//                        }
//                    } while isNotUnique
//                }
                    
                if repeatingChords && !uniqueChords {
                    print("CASE 3")
                    randomDiatonicChord = randomKey[Int.random(in: 0...5)]
                    print(randomDiatonicChord)
                }
                
                //
                // Append found chord to test sequence
                //
                sequence?.append(randomDiatonicChord)
                
                //
                // save chord quality (major or minor)
                //
                solution?.append(randomDiatonicChord.suffix(3) == "maj" ? chordQuality.major : chordQuality.minor)
                
                
            }
        }
    }
}

func round (_ input: Double, toDigits digits: Int) -> Double {
    
    return Double(String(format: "%0.\(digits)f", input)) ?? 0
}
