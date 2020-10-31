//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eggBoilingProgressView: UIProgressView!
    
    
    let eggBoilingDurationsBasedOnHardness: [String: Int] = [
        "Soft": 5,
        "Medium": 7,
        "Hard": 12
    ]
    
    var eggBoilingTimer: Timer?
    var audioPlayer: AVAudioPlayer?
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        guard let currentTitle = sender.currentTitle, let eggBoilingTimeInMinutes = eggBoilingDurationsBasedOnHardness[currentTitle] else {
            return
        }
        
        initiateEggBoilingTimer(withEggBoilingDurationInSeconds: eggBoilingTimeInMinutes)
    }
    
    func initiateEggBoilingTimer(withEggBoilingDurationInSeconds eggBoilingDurationInSeconds: Int) {
        titleLabel.text = "Egg is boiling! Please be patient"
        
        eggBoilingTimer?.invalidate()
        
        eggBoilingProgressView.progress = 0.0
        
        var secondsElapsedSinceEggBoilingTimerStarted = 0
        
        eggBoilingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            secondsElapsedSinceEggBoilingTimerStarted += 1
            
            self.eggBoilingProgressView.progress = Float(secondsElapsedSinceEggBoilingTimerStarted) / Float(eggBoilingDurationInSeconds)
            
            
            if secondsElapsedSinceEggBoilingTimerStarted == eggBoilingDurationInSeconds {
                timer.invalidate()
                
                self.titleLabel.text = "Tada! Egg is boiled"
                
                if let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3"), let player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue) {
                    self.audioPlayer = player
                    player.play()
                }
            }
        }
    }
}
