//
//  MultiChoiceVC.swift
//  Wastland_Survival_Guide
//
//  Created by Justin Doo on 3/29/16.
//  Copyright © 2016 Justin Doo. All rights reserved.
//

import Foundation
import UIKit


class MultiChoiceVC: UIViewController{
 
  //MARK: Parse Constants
  var randomID = 0 //Used to represent question being displayed
  
  var question: String!
  var answers: [String]!
  var answer: String!
  var wrongAnswers: [String]!
  var btnsArray: [UIButton]!
  var wrongBtnsArray: [UIButton]!
  var stringToInt: Int?
  var hintButtonTapped: Bool = false
  var fireworks: String!
  var currentRoundScore = 0
  var data = GameScore()
  var audioController: AudioController!
  var image: String!

  //MARK: UIConstants
    let buttons = Buttons()
  
  //MARK: ViewDidload
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    self.audioController = AudioController()
    self.audioController.preloadAudioEffects(AudioEffectFiles)
  }
  

 //MARK: Hint Button features
  
  //creates random wrong answer choice number
  func wrongAnswer(wrongAnswerCount: Int) -> Int {
    let wrongAnswer = Int(arc4random_uniform(UInt32(wrongAnswerCount - 1)))
    return wrongAnswer
  }
  
  //assigns a number to hide based on the random number created in the wrong answer function
  func hideAnAnswer(wrongAnswer: Int) {
    if wrongAnswers.count >= 2 {
      wrongAnswers.removeAtIndex(wrongAnswer)
      wrongBtnsArray[wrongAnswer].hidden = true
    }
  }
  
  //resets the buttons on the next question
  func unHideBtns() {
    for btn in btnsArray {
      btn.hidden = false
    }
  }
  
  // Audio Timer
  
  func startAudioTimer () {
    self.audioController.playEffect(SoundTimer)
  }
  
  func stopAudioTimer () {
    self.audioController.stopPlayingEffect(SoundTimer)
  }
}