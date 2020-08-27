//
//  SoundPlayer.swift
//  Authentic
//
//  Created by Zdenek Skalnik on 26/06/2017.
//  Copyright © 2017 Prismade Labs GmbH. All rights reserved.
//

import UIKit
import AVFoundation

class SoundPlayerHelper: NSObject {

    static func createPlayerForSound(_ sound: String) -> AVAudioPlayer? {
        
        guard let url = Bundle.main.url(forResource:sound, withExtension: "mp3") else { return nil }
        
        var player: AVAudioPlayer?
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return nil }
            player.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }
        
        return player
    }

}
