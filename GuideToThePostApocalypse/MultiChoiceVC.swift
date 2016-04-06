////
////  MultiChoiceVC.swift
////  Wastland_Survival_Guide
////
////  Created by Justin Doo on 3/29/16.
////  Copyright © 2016 Justin Doo. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//
//class MultiChoiceVC: UIViewController{
// 
//  //MARK: Parse Constants
//  var randomID = 0 //Used to represent question being displayed
//  
//  var question: String!
//  var answers: [String]!
//  var answer: String!
//  var wrongAnswers: [String]!
//  var btnsArray: [UIButton]!
//  var wrongBtnsArray: [UIButton]!
//  var stringToInt: Int?
//  var hintButtonTapped: Bool = false
//  var fireworks: String!
//  var currentRoundScore = 0
//  var mad = false
//  var data = GameScore()
//  var audioController: AudioController!
//  var image: String!
//
//  //MARK: UIConstants
//  var bannersAndVaultBoys = BannersAndVaultBoys()
//    let buttons = Buttons()
//  
//  //MARK: ViewDidload
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//   
//    self.audioController = AudioController()
//    self.audioController.preloadAudioEffects(AudioEffectFiles)
//  }
//  
//  override func viewWillAppear(animated: Bool) {
//    
//    bannersAndVaultBoys.madVaultBoyImage.center.y += view.bounds.height
//    bannersAndVaultBoys.zeroScoreVaultBoyImage.center.y -= view.bounds.height
//  }
//  
//  //MARK: ZeroScoreVaultBoy
//  
//  func zeroScoreVaultBoy () {
//    
//    UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
//
//      self.buttons.tryAgainButton.hidden = false
//      self.bannersAndVaultBoys.failedLabel.hidden = false
//      self.bannersAndVaultBoys.zeroScoreVaultBoyImage.hidden = false
//      self.bannersAndVaultBoys.zeroScoreVaultBoyImage.center.y += self.view.bounds.height
//      self.audioController.playEffect(SoundWrong)
//      currentScore = totalScore + self.currentRoundScore
//      totalScore = currentScore
//      userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
//      userDefaults.synchronize()
//      self.bannersAndVaultBoys.totalScoreLabel.text = "Total Score: \(totalScore)"
//      self.bannersAndVaultBoys.totalScoreLabel.hidden = false
//      
//      
//      }
//      , completion: nil)
//  }
//  
//  //MARK: CongratulationsVaultBoy
//  
//  func congratulationsVaultBoy (gifString: String) {
//    
//    UIView.transitionWithView(bannersAndVaultBoys.congratulationsVaultBoyImage, duration: 0.7, options: [.TransitionFlipFromTop], animations: {
//      self.bannersAndVaultBoys.congratulationsVaultBoyImage.hidden = false
//      self.audioController.playEffect(SoundWin)
//      self.hintButtonTapped = false
//      
//      totalScore = self.currentRoundScore
//      
//      userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
//      userDefaults.synchronize()
//      
//      self.ShowCongratulationsBanner(self.bannersAndVaultBoys.congratulationsBanner, label: self.bannersAndVaultBoys.congratulationsLabel)
//      
//      }, completion:{_ in
//        //gives effect like fireworks are increasing then decreasing in size
//        UIView.animateWithDuration(0.5, delay:0, options: [.Repeat, .Autoreverse], animations: {
//          self.bannersAndVaultBoys.fireworks_2_gold.alpha = 1.0
//          }, completion: nil)
//        self.delay(3.0, closure: {
//          self.bannersAndVaultBoys.fireworks_2_gold.alpha = 0.0
//          self.bannersAndVaultBoys.congratulationsVaultBoyImage.hidden = true
//          self.bannersAndVaultBoys.congratulationsBanner.hidden = true
//          self.bannersAndVaultBoys.congratulationsLabel.hidden = true
//          self.buttons.nextRoundButton.hidden = false
//          self.bannersAndVaultBoys.earnedPerkLabel.hidden = false
//          self.bannersAndVaultBoys.perkLabel.hidden = false
//          self.audioController.playEffect(SoundPerk)
//          self.GifMaker(gifString) //"falloutResize"
//        })
//    })
//  }
//
// //MARK: Hint Button features
//  
//  //creates random wrong answer choice number
//  func wrongAnswer(wrongAnswerCount: Int) -> Int {
//    let wrongAnswer = Int(arc4random_uniform(UInt32(wrongAnswerCount - 1)))
//    return wrongAnswer
//  }
//  
//  //assigns a number to hide based on the random number created in the wrong answer function
//  func hideAnAnswer(wrongAnswer: Int) {
//    if wrongAnswers.count >= 2 {
//      wrongAnswers.removeAtIndex(wrongAnswer)
//      wrongBtnsArray[wrongAnswer].hidden = true
//    }
//  }
//  
//  //resets the buttons on the next question
//  func unHideBtns() {
//    for btn in btnsArray {
//      btn.hidden = false
//    }
//  }
//  
//  
//   //MARK: Vaultboy to Front
//  
//  func vaultboyToFront () {
//    if self.mad == true {
//      self.view.bringSubviewToFront(self.bannersAndVaultBoys.madVaultBoyImage)
//    } else {
//      self.view.bringSubviewToFront(self.bannersAndVaultBoys.thumbsUpVaultBoyImage)
//    }
//  }
//}