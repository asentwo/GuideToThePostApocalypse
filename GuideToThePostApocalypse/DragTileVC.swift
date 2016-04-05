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

  var randomID = 0 //Used to represent question being displayed
  
  var question: String!
  var letters: String!
  var answer: String!
  var image: String!
  
  var lettersLength: Int!
  var answerLength: Int!
  
  var fireworks: String!
  var currentRoundScore = 0
  
  var mad = false
  
  var data = GameScore()
  var audioController: AudioController!
  
  var targets = [TargetView]()
  var tiles = [TileView]()
  let TileMargin: CGFloat = 10.0
  
  var finalAnimation = false
  
  //MARK: UIConstants
  var bannersAndVaultBoys = BannersAndVaultBoys()
  
   let buttons = Buttons()

  override func viewWillAppear(animated: Bool) {
    
    bannersAndVaultBoys.madVaultBoyImage.center.y += view.bounds.height
    bannersAndVaultBoys.zeroScoreVaultBoyImage.center.y -= view.bounds.height
  }
  
  //MARK: ViewDidload
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.audioController = AudioController()
    self.audioController.preloadAudioEffects(AudioEffectFiles)
  }
  
  //MARK: ZeroScoreVaultBoy
  
  func ZeroScoreVaultBoy () {
    
    UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
      
      self.buttons.tryAgainButton.hidden = false
      self.bannersAndVaultBoys.failedLabel.hidden = false
      self.bannersAndVaultBoys.zeroScoreVaultBoyImage.hidden = false
      self.bannersAndVaultBoys.zeroScoreVaultBoyImage.center.y += self.view.bounds.height
      self.audioController.playEffect(SoundWrong)
      currentScore = totalScore + self.currentRoundScore
      totalScore = currentScore
      userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
      userDefaults.synchronize()

      self.bannersAndVaultBoys.totalScoreLabel.text = "Total Score: \(totalScore)"
      self.bannersAndVaultBoys.totalScoreLabel.hidden = false
      }
      , completion: nil)
  }
  
  
  //MARK: CongratulationsVaultBoy
  
  func CongratulationsVaultBoy(gifName: String) {
    
    UIView.transitionWithView(bannersAndVaultBoys.congratulationsVaultBoyImage, duration: 0.7, options: [.TransitionFlipFromTop], animations: {
      
      self.bannersAndVaultBoys.congratulationsVaultBoyImage.hidden = false
      self.audioController.playEffect(SoundWin)
      currentScore = totalScore + self.currentRoundScore
      totalScore = currentScore
      
      userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
      userDefaults.synchronize()
      
      self.ShowCongratulationsBanner(self.bannersAndVaultBoys.congratulationsBanner, label: self.bannersAndVaultBoys.congratulationsLabel)
      }, completion:{_ in
        
        //adds explosive view behind image
        let explode = ExplodeView(frame:CGRectMake(self.bannersAndVaultBoys.congratulationsVaultBoyImage.center.x - 20, self.bannersAndVaultBoys.congratulationsVaultBoyImage.center.y - 60, 100,100))
        self.bannersAndVaultBoys.congratulationsVaultBoyImage.superview?.addSubview(explode)
        self.bannersAndVaultBoys.congratulationsVaultBoyImage.superview?.sendSubviewToBack(explode)
        
        self.delay(3.0, closure: {
          
          if self.finalAnimation == false { self.buttons.btn.hidden = false }
          self.bannersAndVaultBoys.congratulationsVaultBoyImage.hidden = true
          self.bannersAndVaultBoys.earnedPerkLabel.hidden = false
          self.bannersAndVaultBoys.perkLabel.hidden = false
          self.audioController.playEffect(SoundPerk)
          //add perk gif
          let Gif = UIImage.gifWithName(gifName)
          let View = UIImageView(image: Gif)
          View.hidden = false
          View.frame = CGRect(x: 40.0, y: 170.0, width: View.frame.size.width, height: View.frame.size.height)
          self.view.addSubview(View)
          
          if self.finalAnimation == true {
            
          } else {
            self.bannersAndVaultBoys.congratulationsBanner.hidden = true
            self.bannersAndVaultBoys.congratulationsLabel.hidden = true
          }
          
        
          if self.finalAnimation == true {
          self.delay(5.0, closure: {
            View.removeFromSuperview()
            self.bannersAndVaultBoys.earnedPerkLabel.hidden = true
            self.bannersAndVaultBoys.perkLabel.hidden = true
            self.bannersAndVaultBoys.survivedLabel.hidden = false
            
            UIView.animateWithDuration(0.5, delay:0, options: [.Repeat, .Autoreverse], animations: {
              self.bannersAndVaultBoys.yellowBurst.alpha = 1.0
              }, completion: nil)
            
            //add survived gif
//            let Gif = UIImage.gifWithName("fallout_dancing")
//            let View = UIImageView(image: Gif)
//            View.hidden = false
//            View.frame = CGRect(x: 30.0, y: 200.0, width: View.frame.size.width*1.2, height: View.frame.size.height*1.2)
//            self.view.addSubview(View)
            self.audioController.playEffect(SoundExplosion)
            self.audioController.playEffect(SoundWin)
            self.bannersAndVaultBoys.congratulationsBanner.hidden = true
            self.bannersAndVaultBoys.congratulationsLabel.hidden = true

           //            self.bannersAndVaultBoys.totalScoreLabel.hidden = false
            self.buttons.restartButton.hidden = false
            self.finalAnimation = false
          })
          }
        })
    })
  }
  
  
  //MARK: Vaultboy to Front
  
  func vaultboyToFront () {
    if self.mad == true {
      self.view.bringSubviewToFront(self.bannersAndVaultBoys.madVaultBoyImage)
    } else {
      self.view.bringSubviewToFront(self.bannersAndVaultBoys.thumbsUpVaultBoyImage)
    }
  }
  
  //MARK: Audio Timer
  
  func startAudioTimer () {
    self.audioController.playEffect(SoundTimer30)
  }
  
  func stopAudioTimer () {
    self.audioController.stopPlayingEffect(SoundTimer30)
  }
}



