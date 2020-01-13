//
//  SoundManager.swift
//  Memorama
//
//  Created by Daniela Becerra Gonzalez on 10/01/20.
//  Copyright © 2020 Daniela Becerra Gonzalez. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect:SoundEffect) {
        
        var soundFileName = ""
        
        // Set the file name for the effect we want
        switch effect {
        
        case .flip:
            soundFileName = "cardflip"
        
        case .shuffle:
            soundFileName = "shuffle"
            
        case .match:
            soundFileName = "dingcorrect"
        
        case .nomatch:
            soundFileName = "dingwrong"
        
        }
        
        // Get the sound file path
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        guard bundlePath != nil else {
            print("couldn't find sound file \(soundFileName)")
            return
        }
        
        // Create URL object from the file path
        let soundURL = URL(fileURLWithPath: bundlePath!)
 
        
        do {
            // Create audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            // Play the sound!
            audioPlayer?.play()
        } catch {
            
            // could not create audio player object
            print("couldn't create the audio player object for the sound file \(soundFileName)")
        }
    }
}
