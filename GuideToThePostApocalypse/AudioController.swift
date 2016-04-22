//
//  Round3_AudioController.swift
//  Wastland_Survival_Guide
//
//  Created by Justin Doo on 1/11/16.
//  Copyright © 2016 Justin Doo. All rights reserved.
//

import Foundation
import AVFoundation

class AudioController {
  
  
  //holds all preloaded sound effects
  var audio = [String:AVAudioPlayer]()
  
  func preloadAudioEffects(effectFileNames:[String]) {
    for effect in audioEffectFiles {
      //1 get the file path URL
      let soundPath = (NSBundle.mainBundle().resourcePath! as NSString).stringByAppendingPathComponent(effect)
      let soundURL = NSURL.fileURLWithPath(soundPath)
      
      //2 load the file contents
      var loadError:NSError?
      let player: AVAudioPlayer!
      do {
        player = try AVAudioPlayer(contentsOfURL: soundURL)
        player.volume = 0.5
      } catch let error as NSError {
        loadError = error
        player = nil
      }
      assert(loadError == nil, "Load sound failed")
      
      //3 prepare the play
      player.numberOfLoops = 0
      player.prepareToPlay()
      
      //4 add to the audio dictionary
      audio[effect] = player
    }
  }
  
  //This method takes in a file name, then looks it up in audio. If the sound exists, you first check if the sound is currently playing. If so, you just need to “rewind” the sound by setting its currentTime to 0; otherwise, you simply call play().
  func playEffect(name:String) {
    if let player = audio[name] {
      if player.playing {
        
        player.currentTime = 0
      } else {
        player.currentTime = 0
        player.play()
        
      }
    }
  }
  
  func stopPlayingEffect(name: String) {
    if let player = audio[name] {
      if player.playing {
        player.stop()
      }
    }
  }
}

