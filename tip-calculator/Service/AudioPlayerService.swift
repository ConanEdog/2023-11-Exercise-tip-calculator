//
//  AudioPlayerService.swift
//  tip-calculator
//
//  Created by 方奎元 on 2023/11/7.
//

import Foundation
import AVFoundation

protocol AudioPlayerService {
    func playSound()
}

final class DefaultAudioPlayer: AudioPlayerService {
    
    private var player: AVAudioPlayer?
    
    func playSound() {
        let path = Bundle.main.path(forResource: "click", ofType: "m4a")!
        let url = URL(filePath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    
}
