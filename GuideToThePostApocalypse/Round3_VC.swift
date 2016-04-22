//
//  ViewController.swift
//  WasteLandSurvivalQuizParse
//
//  Created by Justin Doo on 11/30/15.
//  Copyright © 2015 Justin Doo. All rights reserved.
//

import UIKit
import Parse

class Round3_ViewController: MultiChoiceVC, CountdownTimerDelegate {
  
  
  //MARK:Constants
  
  var round3_objectIDArray = [String]()
  
  //MARK: IBOutlets
  
  @IBOutlet var countDownLabel: UILabel!
  @IBOutlet var questionLabel: UILabel!
  @IBOutlet var button1: UIButton!
  @IBOutlet var button2: UIButton!
  @IBOutlet var button3: UIButton!
  @IBOutlet var button4: UIButton!
  @IBOutlet var playerScore: UILabel!
  @IBOutlet var hintButton: UIButton!
  @IBOutlet var backgroundImage: UIImageView!
  
  //vaultBoy
  @IBOutlet weak var vaultBoyRight: UIImageView!
  @IBOutlet weak var vaultBoyWrong: UIImageView!
  @IBOutlet weak var vaultBoySuccess: UIImageView!
  @IBOutlet weak var vaultBoyFailed: UIImageView!
  
  //fireworks
  @IBOutlet weak var fireworkImage: UIImageView!
  
  //buttons
  @IBOutlet weak var nextRoundButton: UIButton!
  @IBOutlet weak var tryAgainButton: UIButton!
  
  //labels
  @IBOutlet weak var youFailedThisRoundLabel: UILabel!
  @IBOutlet weak var scoreBanner: UIImageView!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var youEarnedACoinLabel: UILabel!
  
  //gif
  @IBOutlet weak var coin: UIImageView!
  
  //wrong/right banners
  @IBOutlet weak var wrongAnswerBanner: UIImageView!
  @IBOutlet weak var wrongAnswerLabel: UILabel!
  @IBOutlet weak var rightAnswerBanner: UIImageView!
  @IBOutlet weak var rightAnswerLabel: UILabel!
  
  //constraints
  
  @IBOutlet weak var vaultBoyRightYConstraint: NSLayoutConstraint!
  @IBOutlet weak var vaultBoyWrongYConstraint: NSLayoutConstraint!
  @IBOutlet weak var vaultBoySuccessYConstraint: NSLayoutConstraint!
  @IBOutlet weak var vaultBoyFailedYConstraint: NSLayoutConstraint!
  @IBOutlet weak var coinYConstraint: NSLayoutConstraint!
  @IBOutlet weak var rightAnswerBannerXConstraint: NSLayoutConstraint!
  @IBOutlet weak var wrongAnswerBannerXConstraint: NSLayoutConstraint!
  
  //MARK: ViewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    labelSizeAdjustment()
    hideAllGraphics()
    storeParseDataLocally_Round3()
    fireworkImage.alpha = 0
    
    let currentTotalScore = userDefaults.integerForKey(TOTAL_SCORE_SAVED_KEY)
    totalScore = currentTotalScore
    self.data.points = totalScore
    playerScore.text = "Score: \(totalScore)"
    currentRoundScore = 0
    timer = CountdownTimer(timerLabel: self.countDownLabel, startingMin: 0, startingSec: 16)
    timer.delegate = self
    userDefaults.setObject("Round_3", forKey: CURRENT_ROUND_KEY)
    
  }
  
  override func viewWillAppear(animated: Bool) {
    
    vaultBoyRightYConstraint.constant = 60
    vaultBoyWrongYConstraint.constant = 108.5
    vaultBoyFailedYConstraint.constant = 30
    coinYConstraint.constant = 0
    vaultBoyWrongYConstraint.constant += view.bounds.height
    vaultBoyFailedYConstraint.constant -= view.bounds.height
    self.view.layoutIfNeeded()
  }
  
  
  //MARK: Parse
  
  //Random Object
  
  func getRandomObjectID_Round3 () {
    
    randomID = Int(arc4random_uniform(UInt32(round3_objectIDArray.count)))
    //creating random 32 bit interger from the objectIDs
    
  }
  
  //Call Parse
  
  func callData_Round3 () {
    
    getRandomObjectID_Round3 ()
    
    if (round3_objectIDArray.count > 0) {
      
      let query: PFQuery = PFQuery(className: "Round_3")
      query.getObjectInBackgroundWithId(round3_objectIDArray[randomID], block:{
        (objectHolder : PFObject?, error : NSError?) -> Void in
        //holds all the objects (ie. questions & answers) created in parse.com
        
        if (error == nil) {
          self.question = objectHolder!["Question"] as! String!
          self.answers = objectHolder!["Answers"] as! Array!
          self.answer = objectHolder!["Answer"] as! String!
          if (self.answers.count > 0) {
            self.questionLabel.text = self.question
            
            self.button1.setTitle(self.answers[0], forState: UIControlState.Normal)
            self.button2.setTitle(self.answers[1], forState: UIControlState.Normal)
            self.button3.setTitle(self.answers[2], forState: UIControlState.Normal)
            self.button4.setTitle(self.answers[3], forState: UIControlState.Normal)
            self.hintButton.enabled = true
            
            timer.start()
            self.startAudioTimer()
          }
          
        } else {
          NSLog("There is an error")
        }
      })
    }
  }
  
  
  //Store Parse Data Locally
  
  func storeParseDataLocally_Round3 () {
    
    let objectIDQuery = PFQuery(className: "Round_3")
    
    objectIDQuery.findObjectsInBackgroundWithBlock({
      (objectsArray : [PFObject]?, error : NSError?) -> Void in
      
      if error == nil {
        var objectIDs = objectsArray
        for i in 0..<objectIDs!.count{
          self.round3_objectIDArray.append(objectIDs![i].objectId!)
          //appending objects downloaded from Parse.com to local array (objectIDPublicArray) - .objectId refers to id number given in parse.com (ex."QF0lrQKW8j")
        }
      } else {
        print("Error: \(error) \(error!.userInfo)")
      }
      dispatch_async(dispatch_get_main_queue()){
        objectIDQuery.cachePolicy = PFCachePolicy.NetworkElseCache
      }
      self.callData_Round3()
    })
  }
  
  //MARK: Remove Used Questions
  
  func removeAlreadyUsedQuestion() {
    if (round3_objectIDArray.count > 0){
      round3_objectIDArray.removeAtIndex(randomID)
      //randomID = currently asked question
      callData_Round3()
    }
  }
  
  //MARK: Dismiss Q&A Buttons & Labels
  
  func areBaseGraphicsHidden(buttons: Bool) {
    UIView.animateWithDuration(0.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [.CurveEaseOut], animations: {
      self.button1.hidden = buttons
      self.button2.hidden = buttons
      self.button3.hidden = buttons
      self.button4.hidden = buttons
      self.questionLabel.hidden = buttons
      self.playerScore.hidden = buttons
      self.countDownLabel.hidden = buttons
      self.backgroundImage.hidden = buttons
      self.hintButton.hidden = buttons
      }, completion: nil)
  }

  //MARK: Graphics
  
  func hideAllGraphics () {
    vaultBoyWrong.hidden = true
    vaultBoyRight.hidden = true
    vaultBoyFailed.hidden = true
    vaultBoySuccess.hidden = true
    tryAgainButton.hidden = true
    nextRoundButton.hidden = true
    youFailedThisRoundLabel.hidden = true
    scoreBanner.hidden = true
    scoreLabel.hidden = true
    youEarnedACoinLabel.hidden = true
    coin.hidden = true
    wrongAnswerBanner.hidden = true
    wrongAnswerLabel.hidden = true
    rightAnswerBanner.hidden = true
    rightAnswerLabel.hidden = true
  }
  
  func labelSizeAdjustment () {
    questionLabel.adjustsFontSizeToFitWidth = true
    youEarnedACoinLabel.adjustsFontSizeToFitWidth = true
    scoreLabel.adjustsFontSizeToFitWidth = true
    youFailedThisRoundLabel.adjustsFontSizeToFitWidth = true
    rightAnswerLabel.adjustsFontSizeToFitWidth = true
    wrongAnswerLabel.adjustsFontSizeToFitWidth = true
    hintButton.titleLabel?.adjustsFontSizeToFitWidth = true
  }
  
  //MARK: Buttons
  
  //Restart
  func restartViewController () ->() {
    self.vaultBoyFailedYConstraint.constant += self.view.bounds.height
    viewDidLoad()
    areBaseGraphicsHidden(false)
    viewWillAppear(false)
    areButtonsEnabledButtons(true)
    
  }
  
  //Next Round
  func switchToRoundFour () {
    UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: [.CurveEaseInOut, .AllowAnimatedContent], animations: {
      self.performSegueWithIdentifier("round3ToRound4Segue", sender: self)
      }, completion: nil)
  }
  
  //Button Bounce
  func bounceButton (button: UIButton) {
    let b = button.bounds
    UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: [], animations: {
      button.bounds = CGRect(x: b.origin.x - 20, y: b.origin.y, width: b.size.width + 20, height: b.size.height)
      //gives button bouncy effect
      }, completion: {_ in
        self.madVaultBoy()
        self.showWrongAnswerBanner()
    })
  }
  
  //RightButtonSelected
  
  func rightButtonSelected () {
    timer.pause()
    stopAudioTimer()
    thumbsUpVaultBoy()
    self.showRightAnswerBanner()
  }
  
  
  //WrongButtonSelected
  func wrongButtonSelected(sender: AnyObject)
  {
    switch sender.tag {
    case 0: bounceButton(button1)
    case 1: bounceButton(button2)
    case 2: bounceButton(button3)
    case 3: bounceButton(button4)
    default: print("Wrong Button Selected Error")
    }
  }
  
  func areButtonsEnabledButtons(enabled: Bool) {
    button1.enabled = enabled
    button2.enabled = enabled
    button3.enabled = enabled
    button4.enabled = enabled
    hintButton.enabled = enabled
  }
  
  
  //MARK: Hint Button features
  
  func setUpWrongAnswers(rightAnswer: Int) {
    var answers = ["answer1","answer2","answer3","answer4"]
    btnsArray = [button1, button2, button3, button4]
    wrongBtnsArray = btnsArray
    wrongBtnsArray.removeAtIndex(rightAnswer)
    answers.removeAtIndex(rightAnswer)
    wrongAnswers = answers
  }
  
  //MARK: Update Score
  
  func UpdateScoreNegative () {
    self.data.points -= pointsPerWrongAnswer/2
    totalScore = self.data.points
    currentRoundScore = self.data.points
    self.playerScore.text = "Score: \(totalScore)"
  }
  
  func UpdateScorePositive () {
    self.data.points += pointsPerQuestion
    totalScore = self.data.points
    currentRoundScore = self.data.points
    self.playerScore.text = "Score: \(totalScore)"
  }
  
  func UpdateScoreRunOutOfTime () {
    self.data.points -= pointsTimeRunsOut
    totalScore = self.data.points
    currentRoundScore = self.data.points
    self.playerScore.text = "Score: \(totalScore)"
  }
  
  
  //MARK: Timer
  
  func countdownEnded() -> Void {
    self.checkInitialTimer()
  }
  
  func timerShakeAndReset () {
    if madVaultBoyRunning == false && thumbsUpBoyRunning == false {
      self.areButtonsEnabledButtons(false)
      self.UpdateScoreRunOutOfTime()
      self.timerShake()
      self.madVaultBoy()
    }
  }
  
  func resetAllTimers () {
    timer.reset()
    timer.start()
    startAudioTimer()
  }
  
  func checkInitialTimer () {
    if self.round3_objectIDArray.count == 0 {
    } else {
      self.timerShakeAndReset()
    }
  }
  
  //MARK: VaultBoy Animations
  
  func vaultboyToFront () {
    if madVaultBoyRunning == true {
      self.view.bringSubviewToFront(self.vaultBoyWrong)
    } else {
      self.view.bringSubviewToFront(self.vaultBoyRight)
    }
  }
  
  
  func madVaultBoy() {
    self.showMadVaultBoyButtons()
    UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
      self.view.layoutIfNeeded()
      }, completion: {_ in
        self.vaultBoyWrongYConstraint.constant += self.view.bounds.height
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
          self.view.layoutIfNeeded()
          }, completion: {_ in
            self.stopAudioTimer()
            self.hideMadVaultBoyButtons(self.round3_objectIDArray)
            madVaultBoyRunning = false
        })
    })
  }
  
  func showMadVaultBoyButtons () {
    madVaultBoyRunning = true
    timer.pause()
    self.vaultboyToFront()
    self.vaultBoyWrong.hidden = false
    self.audioController.playEffect(soundWrong)
    self.UpdateScoreNegative()
    self.removeAlreadyUsedQuestion()
    self.areButtonsEnabledButtons(false)
    self.UpdateScoreNegative()
    userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
    userDefaults.synchronize()
    self.vaultBoyWrongYConstraint.constant -= self.view.bounds.height
  }
  
  func hideMadVaultBoyButtons(round:[String]) {
    if round.count == 0 {
      self.areBaseGraphicsHidden(true)
      if self.currentRoundScore == 0 {
        self.areBaseGraphicsHidden(true)
        self.zeroScoreVaultBoy()
      }else{
        self.congratulationsVaultBoy()
      }
    } else {
      self.areButtonsEnabledButtons(true)
      self.resetAllTimers()
    }
    if self.hintButtonTapped == true {self.unHideBtns()
      self.hintButtonTapped = false
    }
  }
  
  func thumbsUpVaultBoy () {
    thumbsUpBoyRunning = true
    self.vaultboyToFront()
    self.stopAudioTimer()
    timer.pause()
    self.removeAlreadyUsedQuestion()
    self.audioController.playEffect(soundDing)
    self.areButtonsEnabledButtons(false)
    UIView.transitionWithView(self.vaultBoyRight, duration: 0.7, options: [.TransitionFlipFromBottom], animations: {
      self.vaultBoyRight.hidden = false
      }, completion: {_ in
        self.UpdateScorePositive()
        userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
        userDefaults.synchronize()
        self.vaultBoyRightYConstraint.constant += self.view.bounds.height
        UIView.animateWithDuration(1.0, delay: 1.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
          self.view.layoutIfNeeded()
          }, completion: {_ in
            self.hideThumbsUpVaultBoyButtons(self.round3_objectIDArray)
            thumbsUpBoyRunning = false
            if self.hintButtonTapped == true {self.unHideBtns()
              self.hintButtonTapped = false
            }
            self.hintButton.enabled = true
        })
    })
  }
  
  
  func hideThumbsUpVaultBoyButtons(round:[String] ) {
    if round.count == 0 {
      self.areBaseGraphicsHidden(true)
      self.congratulationsVaultBoy()
    } else {
      self.vaultBoyRightYConstraint.constant -= self.view.bounds.height
      self.view.layoutIfNeeded()
      self.vaultBoyRight.hidden = true
      self.areButtonsEnabledButtons(true)
      self.resetAllTimers()
    }
  }
  
  
  func zeroScoreVaultBoy () {
    self.areBaseGraphicsHidden(true)
    self.stopAudioTimer()
    self.audioController.playEffect(soundWrong)
    self.tryAgainButton.hidden = false
    self.youFailedThisRoundLabel.hidden = false
    self.vaultBoyFailed.hidden = false
    self.vaultBoyFailedYConstraint.constant += self.view.bounds.height
    UIView.animateWithDuration(1.0, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
      self.view.layoutIfNeeded()
      }
      , completion: {_ in
        userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
        userDefaults.synchronize()
    })
  }
  
  
  func congratulationsVaultBoy () {
    self.stopAudioTimer()
    self.areBaseGraphicsHidden(true)
    self.view.bringSubviewToFront(vaultBoySuccess)
    self.vaultBoySuccess.hidden = false
    self.audioController.playEffect(soundWin)
    self.hintButtonTapped = false
    userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
    userDefaults.synchronize()
    UIView.transitionWithView(vaultBoySuccess, duration: 0.7, options: [.TransitionFlipFromTop], animations: {
      self.scoreBanner.hidden = false
      self.scoreLabel.hidden = false
      self.scoreLabel.text = "You scored \(totalScore) points!"
      }, completion:{_ in
        
        UIView.animateWithDuration(0.5, delay: 0, options: [.Repeat, .Autoreverse], animations: {
          self.fireworkImage.alpha = 1
          }, completion: nil)
        self.delay(3.0, closure: {
          self.fireworkImage.alpha = 0
          self.vaultBoySuccess.hidden = true
          self.scoreBanner.hidden = true
          self.scoreLabel.hidden = true
          self.nextRoundButton.hidden = false
          self.youEarnedACoinLabel.hidden = false
          self.audioController.playEffect(soundPerk)
          let gif = UIImage.gifWithName("walkingDeadResize1")
          self.coin.image = gif
          self.coin.hidden = false
        })
    })
  }
  
  
  //MARK: Banner Animations
  
  func showWrongAnswerBanner() {
    UIView.transitionWithView(wrongAnswerBanner, duration: 0.20, options: [.CurveEaseOut, .TransitionFlipFromLeft], animations: {
      self.wrongAnswerBanner.hidden = false
      self.view.bringSubviewToFront(self.wrongAnswerBanner)
      }, completion: {_ in
        self.wrongAnswerLabel.hidden = false
        self.view.bringSubviewToFront(self.wrongAnswerLabel)
        self.wrongAnswerBannerXConstraint.constant += self.view.frame.size.width
        UIView.animateWithDuration(0.33, delay: 0.7, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
          self.view.layoutIfNeeded()
          //makes banner fly off screen at end of animation
          }, completion: {_ in
            self.wrongAnswerBanner.hidden = true
            self.wrongAnswerLabel.hidden = true
            self.wrongAnswerBannerXConstraint.constant -= self.view.frame.size.width
            self.view.layoutIfNeeded()
            // changes position of banner from off screen back onto screen & invisible so can be used again
          }
        )}
    )}
  
  func showRightAnswerBanner() {
    UIView.transitionWithView(rightAnswerBanner, duration: 0.20, options: [.CurveEaseOut, .TransitionFlipFromLeft], animations: {
      self.rightAnswerBanner.hidden = false
      self.view.bringSubviewToFront(self.rightAnswerBanner)
      }, completion: {_ in
        self.rightAnswerLabel.hidden = false
        self.view.bringSubviewToFront(self.rightAnswerLabel)
        self.rightAnswerBannerXConstraint.constant += self.view.frame.size.width
        UIView.animateWithDuration(0.33, delay: 0.7, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
          self.view.layoutIfNeeded()
          //makes banner fly off screen at end of animation
          }, completion: {_ in
            self.rightAnswerBanner.hidden = true
            self.rightAnswerLabel.hidden = true
            self.rightAnswerBannerXConstraint.constant -= self.view.frame.size.width
            // changes position of banner from off screen back onto screen & invisible so can be used again
            self.view.layoutIfNeeded()
          }
        )}
    )}
  
  
  //MARK: IBActions
  
  @IBAction func button1Action(sender: AnyObject) {
    areButtonsEnabledButtons(false)
    if (self.answer == "0") {
      audioController.playEffect(soundButtonPressedCorrect)
      rightButtonSelected()
    } else {
      audioController.playEffect(soundButtonPressed)
      wrongButtonSelected(button1)
    }
  }
  
  
  @IBAction func button2Action(sender: AnyObject) {
    areButtonsEnabledButtons(false)
    if (self.answer == "1") {
      audioController.playEffect(soundButtonPressedCorrect)
      rightButtonSelected()
    } else {
      audioController.playEffect(soundButtonPressed)
      wrongButtonSelected(button2)
    }
  }
  
  
  @IBAction func button3Action(sender: AnyObject) {
    areButtonsEnabledButtons(false)
    if (self.answer == "2") {
      audioController.playEffect(soundButtonPressedCorrect)
      rightButtonSelected()
    } else {
      audioController.playEffect(soundButtonPressed)
      wrongButtonSelected(button3)
    }
  }
  
  
  @IBAction func button4Action(sender: AnyObject) {
    areButtonsEnabledButtons(false)
    if (self.answer == "3") {
      audioController.playEffect(soundButtonPressedCorrect)
      rightButtonSelected()
    } else {
      audioController.playEffect(soundButtonPressed)
      wrongButtonSelected(button4)
    }
  }
  
  @IBAction func nextRoundButton(sender: AnyObject) {
    switchToRoundFour()
    audioController.playEffect(soundButtonPressedCorrect)
  }
  
  @IBAction func tryRoundAgainButton(sender: AnyObject) {
    audioController.playEffect(soundButtonPressed)
    restartViewController()
  }
  
  
  @IBAction func hintBtnTapped(sender: UIButton) {
    audioController.playEffect(soundButtonPressed)
    self.hintButton.enabled = false
    self.hintButtonTapped = true
    self.stringToInt = Int(self.answer)
    self.setUpWrongAnswers(self.stringToInt!)
    self.hideAnAnswer(self.wrongAnswer(self.wrongAnswers.count))
    self.data.points -= pointsPerMultiHint
    totalScore = self.data.points
    self.playerScore.text = "Score: \(totalScore)"
    let b = hintButton.bounds
    UIView.animateWithDuration(0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: [], animations: {
      self.hintButton.bounds = CGRect(x: b.origin.x, y: b.origin.y, width: b.size.width + 5, height: b.size.height + 5)
      //gives button bouncy effect
      }, completion: {_ in
        self.hintButton.bounds = CGRect(x: b.origin.x, y: b.origin.y, width: b.size.width, height: b.size.height)
    })
  }
}

