//
//  DragTileVC.swift
//  Wastland_Survival_Guide
//
//  Created by Justin Doo on 3/29/16.
//  Copyright © 2016 Justin Doo. All rights reserved.
//

import Foundation
import UIKit

class DragTileVC: UIViewController {
  
  var lettersLength: Int!
  var answerLength: Int!
  
  var fireworks: String!
  var currentRoundScore = 0
  
  var data = GameScore()
  var audioController: AudioController!
  
  var targets = [TargetView]()
  var tiles = [TileView]()
  let TileMargin: CGFloat = 10.0
  
  //MARK: ViewDidload
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.audioController = AudioController()
    self.audioController.preloadAudioEffects(AudioEffectFiles)
  }

  //MARK: Audio Timer
  
  func startAudioTimer () {
    self.audioController.playEffect(SoundTimer30)
  }
  
  func stopAudioTimer () {
    self.audioController.stopPlayingEffect(SoundTimer30)
  }
}



