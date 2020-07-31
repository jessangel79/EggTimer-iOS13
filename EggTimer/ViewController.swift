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
    
    // MARK: - Outlets
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView! {
        didSet {
            progressBar.progress = 0
        }
    }
    
//    let eggTimes = ["Soft": 300, "Medium": 420, "Hard": 720]
    let eggTimes = ["Soft": 3, "Medium": 4, "Hard": 7]
    var totalTime = 0
    var secondsPassed = 0
    var timer = Timer()
    var totalTimeDisplay = 0
    
    // MARK: - Properties
    
    private var player: AVAudioPlayer?
    
    // MARK: - Actions
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        totalTime = 0
        secondsPassed = 0
        guard let hardness = sender.currentTitle else { return }
        totalTime = eggTimes[hardness] ?? 0
        timerLabel.text = hardness
        totalTimeDisplay = totalTime
        startTimer()
    }
    
    // MARK: - Methodes

    private func startTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            progressBar.progress = Float(secondsPassed) / Float(totalTime)
            timerLabel.text = "\(String(totalTimeDisplay)) seconds"
            totalTimeDisplay -= 1
//            debugTimer(percentageProgress, secondsPassedFloat, totalTimeFloat)
        } else {
            timer.invalidate()
            timerLabel.text = "Done !"
            playSound(soundName: "alarm_sound")
        }
    }
    
    private func playSound(soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func debugTimer(_ percentageProgress: Float, _ secondsPassedFloat: Float, _ totalTimeFloat: Float) {
        print("percentageProgress \(percentageProgress)")
        print("secondsPassedFloat \(secondsPassedFloat)")
        print("totalTimeFloat \(totalTimeFloat)")
        print("totalTime \(totalTime)")
        print("totalTimeDisplay \(totalTimeDisplay)")
    }

}
