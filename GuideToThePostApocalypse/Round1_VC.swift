//
//  ViewController.swift
//  WasteLandSurvivalQuizParse
//
//  Created by Justin Doo on 11/30/15.
//  Copyright © 2015 Justin Doo. All rights reserved.
//

import UIKit
import Parse

class Round1_ViewController:  MultiChoiceVC, CountdownTimerDelegate  {
  
  //MARK:Constants
  
  var round1_objectIDArray = [String]()
  
  //MARK: IBOutlets
  
  @IBOutlet var CountDownLabel: UILabel!
  @IBOutlet var QuestionLabel: UILabel!
  @IBOutlet var Button1: UIButton!
  @IBOutlet var Button2: UIButton!
  @IBOutlet var Button3: UIButton!
  @IBOutlet var Button4: UIButton!
  @IBOutlet var PlayerScore: UILabel!
  @IBOutlet var HintButton: UIButton!
  @IBOutlet var BackgroundImage: UIImageView!
  
  //vaultBoys
  @IBOutlet weak var vaultBoyRight: UIImageView!
  @IBOutlet weak var vaultBoyWrong: UIImageView!
  @IBOutlet weak var vaultBoySuccess: UIImageView!
  @IBOutlet weak var vaultBoyFailed: UIImageView!
  
  //buttons
  @IBOutlet weak var tryAgainButton: UIButton!
  @IBOutlet weak var nextRoundButton: UIButton!
  
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
  
  //fireworks
  @IBOutlet weak var fireworksImage: UIImageView!
  
  
  //MARK: ViewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    labelSizeAdjustment()
    hideAllGraphics()
    StoreParseDataLocally_Round1()
    
    currentRoundScore = 0
    PlayerScore.text = "Score: \(totalScore)"
    
    timer = CountdownTimer(timerLabel: self.CountDownLabel, startingMin: 0, startingSec: 16)
    timer.delegate = self
    userDefaults.setObject("Round_1", forKey: CURRENT_ROUND_KEY)
    fireworksImage.alpha = 0
  }
  
  override func viewWillAppear(animated: Bool) {
    
    vaultBoyRightYConstraint.constant = 60
    vaultBoyWrongYConstraint.constant = 58.5
    vaultBoySuccessYConstraint.constant = -64
    vaultBoyFailedYConstraint.constant = 30
    coinYConstraint.constant = 0
    vaultBoyWrongYConstraint.constant += view.bounds.height
    vaultBoyFailedYConstraint.constant -= view.bounds.height
    self.view.layoutIfNeeded()
  }
  
  //MARK: Parse
  
  //Random Object
  
  func GetRandomObjectID_Round1 () {
    
    randomID = Int(arc4random_uniform(UInt32(round1_objectIDArray.count)))
    //creating random 32 bit interger from the objectIDs
  }
  
  //Call Data
  
  func CallData_Round1() {
    //used to call class from parse.com
    
    GetRandomObjectID_Round1 ()
    
    if (round1_objectIDArray.count > 0) {
      
      let query: PFQuery = PFQuery(className: "Round_1")
      query.getObjectInBackgroundWithId(round1_objectIDArray[randomID], block:{
        
        (objectHolder : PFObject?, error : NSError?) -> Void in
        //holds all the objects (ie. questions & answers) created in parse.com
        
        if (error == nil) {
          self.question = objectHolder!["Questions"] as! String!
          self.answers = objectHolder!["Answers"] as! Array!
          self.answer = objectHolder!["Answer"] as! String!
          if (self.answers.count > 0) {
            self.QuestionLabel.text = self.question
            
            self.Button1.setTitle(self.answers[0], forState: UIControlState.Normal)
            self.Button2.setTitle(self.answers[1], forState: UIControlState.Normal)
            self.Button3.setTitle(self.answers[2], forState: UIControlState.Normal)
            self.Button4.setTitle(self.answers[3], forState: UIControlState.Normal)
            self.HintButton.enabled = true
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
  
  func StoreParseDataLocally_Round1 () {
    
    let objectIDQuery = PFQuery(className: "Round_1")
    // calls "Round_1" class on Parse.com
    objectIDQuery.findObjectsInBackgroundWithBlock({
      (objectsArray : [PFObject]?, error : NSError?) -> Void in
      // takes objects from "QandA" Parse.com class and puts objects in an array, PFObject refers to the objects created in Parse.com
      if error == nil {
        var objectIDs = objectsArray
        for i in 0..<objectIDs!.count{
          self.round1_objectIDArray.append(objectIDs![i].objectId!)
          //appending objects downloaded from Parse.com to local array (objectIDPublicArray) - .objectID refers to id number given in parse.com (ex."QF0lrQKW8j")
        }
      } else {
        print("Error: \(error) \(error!.userInfo)")
      }
      dispatch_async(dispatch_get_main_queue()){
        objectIDQuery.cachePolicy = PFCachePolicy.NetworkElseCache
      }
      self.CallData_Round1()
    })
  }
  
  
  //MARK: Remove Used Questions
  
  func RemoveAlreadyUsedQuestion() {
    if (round1_objectIDArray.count > 0){
      round1_objectIDArray.removeAtIndex(randomID)
      //randomID = currently asked question
      CallData_Round1()
    }
  }
  
  //MARK: Dismiss Q&A Buttons & Labels
  
  func DismissQandA () {
    UIView.animateWithDuration(0.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [.CurveEaseOut], animations: {
      self.Button1.hidden = true
      self.Button2.hidden = true
      self.Button3.hidden = true
      self.Button4.hidden = true
      self.QuestionLabel.hidden = true
      self.PlayerScore.hidden = true
      self.CountDownLabel.hidden = true
      self.BackgroundImage.hidden = true
      self.HintButton.hidden = true
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
    QuestionLabel.adjustsFontSizeToFitWidth = true
    youEarnedACoinLabel.adjustsFontSizeToFitWidth = true
    scoreLabel.adjustsFontSizeToFitWidth = true
    youFailedThisRoundLabel.adjustsFontSizeToFitWidth = true
    rightAnswerLabel.adjustsFontSizeToFitWidth = true
    wrongAnswerLabel.adjustsFontSizeToFitWidth = true
    HintButton.titleLabel?.adjustsFontSizeToFitWidth = true
  }
  
  
  
  //MARK: Buttons
  
  //Restart
  func restartViewController () ->() {
    func restartViewController () ->() {
      self.vaultBoyFailedYConstraint.constant += self.view.bounds.height
      viewDidLoad()
      //are
      viewWillAppear(false)
      
    }
    
  }
  
  //Next Round
  func switchToRoundTwo () {
    UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: [.CurveEaseInOut, .AllowAnimatedContent], animations: {
      self.performSegueWithIdentifier("round1ToRound2Segue", sender: self)
      }, completion: nil)
  }
  
  //Button Bounce
  func BounceButton (button: UIButton) {
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
  
  func RightButtonSelected () {
    timer.pause()
    stopAudioTimer()
    thumbsUpVaultBoy()
    self.showRightAnswerBanner()
  }
  
  
  //WrongButtonSelected
  func WrongButtonSelected(sender: AnyObject)
  {
    switch sender.tag {
    case 0: BounceButton(Button1)
    case 1: BounceButton(Button2)
    case 2: BounceButton(Button3)
    case 3: BounceButton(Button4)
    default: print("Wrong Button Selected Error")
    }
  }
  
  //Enable All Buttons
  func EnableButtons () {
    Button1.enabled = true
    Button2.enabled = true
    Button3.enabled = true
    Button4.enabled = true
  }
  
  //Disable All Buttons
  func DisableButtons () {
    Button1.enabled = false
    Button2.enabled = false
    Button3.enabled = false
    Button4.enabled = false
  }
  
  
  
  //MARK: Hint Button
  
  func setUpWrongAnswers(rightAnswer: Int) {
    var answers = ["answer1","answer2","answer3","answer4"]
    btnsArray = [Button1, Button2, Button3, Button4]
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
    self.PlayerScore.text = "Score: \(totalScore)"
  }
  
  func UpdateScorePositive () {
    self.data.points += pointsPerQuestion
    totalScore = self.data.points
    currentRoundScore = self.data.points
    self.PlayerScore.text = "Score: \(totalScore)"
  }
  func UpdateScoreRunOutOfTime () {
    self.data.points -= pointsTimeRunsOut
    totalScore = self.data.points
    currentRoundScore = self.data.points
    self.PlayerScore.text = "Score: \(totalScore)"
  }
  
  
  //MARK: Timer
  
  func countdownEnded() -> Void {
    self.checkInitialTimer()
  }
  
  func timerShakeAndReset () {
    if madVaultBoyRunning == false && thumbsUpBoyRunning == false {
      self.DisableButtons()
      self.UpdateScoreRunOutOfTime()
      self.TimerShake()
      self.madVaultBoy()
    }
  }
  
  func resetAllTimers () {
    timer.reset()
    timer.start()
    startAudioTimer()
  }
  
  func checkInitialTimer () {
    if self.round1_objectIDArray.count == 0 {
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
            self.hideMadVaultBoyButtons(self.round1_objectIDArray)
            madVaultBoyRunning = false
            self.HintButton.enabled = true
        })
    })
  }
  
  func showMadVaultBoyButtons () {
    self.HintButton.enabled = false
    madVaultBoyRunning = true
    timer.pause()
    self.vaultboyToFront()
    self.vaultBoyWrong.hidden = false
    self.audioController.playEffect(SoundWrong)
    self.UpdateScoreNegative()
    self.RemoveAlreadyUsedQuestion()
    self.DisableButtons()
    self.UpdateScoreNegative()
    userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
    userDefaults.synchronize()
    self.vaultBoyWrongYConstraint.constant -= self.view.bounds.height
  }
  
  func hideMadVaultBoyButtons(round:[String]) {
    if self.hintButtonTapped == true {self.unHideBtns()
      self.hintButtonTapped = false
    }
    if round.count == 0 {
      self.DismissQandA()
      if self.currentRoundScore == 0 {
        self.zeroScoreVaultBoy()
      }else{
        self.congratulationsVaultBoy("falloutResize")
      }
    } else {
      self.EnableButtons()
      self.resetAllTimers()
    }
  }
  
  func thumbsUpVaultBoy () {
    self.HintButton.enabled = false
    thumbsUpBoyRunning = true
    self.vaultboyToFront()
    self.stopAudioTimer()
    timer.pause()
    self.RemoveAlreadyUsedQuestion()
    self.audioController.playEffect(SoundDing)
    self.DisableButtons()
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
            self.hideThumbsUpVaultBoyButtons(self.round1_objectIDArray)
            thumbsUpBoyRunning = false
            if self.hintButtonTapped == true {self.unHideBtns()
              self.hintButtonTapped = false
            }
            self.HintButton.enabled = true
        })
    })
  }
  
  
  func hideThumbsUpVaultBoyButtons(round:[String] ) {
    if round.count == 0 {
      self.DismissQandA()
      self.congratulationsVaultBoy("falloutResize")
    } else {
      self.vaultBoyRightYConstraint.constant -= self.view.bounds.height
      self.view.layoutIfNeeded()
      self.vaultBoyRight.hidden = true
      self.EnableButtons()
      self.resetAllTimers()
    }
  }
  
  
  func zeroScoreVaultBoy () {
    self.stopAudioTimer()
    self.audioController.playEffect(SoundWrong)
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
  
  
  func congratulationsVaultBoy (gifString: String) {
    self.stopAudioTimer()
    self.DismissQandA()
    self.view.bringSubviewToFront(vaultBoySuccess)
    self.vaultBoySuccess.hidden = false
    self.audioController.playEffect(SoundWin)
    self.hintButtonTapped = false
    userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
    userDefaults.synchronize()
    UIView.transitionWithView(vaultBoySuccess, duration: 0.7, options: [.TransitionFlipFromTop], animations: {
      self.scoreBanner.hidden = false
      self.scoreLabel.hidden = false
      self.scoreLabel.text = "You scored \(totalScore) points!"
      }, completion:{_ in
        //gives effect like fireworks are increasing then decreasing in size
        UIView.animateWithDuration(0.5, delay:0, options: [.Repeat, .Autoreverse], animations: {
          self.fireworksImage.alpha = 1.0
          }, completion: nil)
        self.delay(3.0, closure: {
          self.fireworksImage.alpha = 0.0
          self.vaultBoySuccess.hidden = true
          self.scoreBanner.hidden = true
          self.scoreLabel.hidden = true
          self.nextRoundButton.hidden = false
          self.youEarnedACoinLabel.hidden = false
          self.audioController.playEffect(SoundPerk)
          let Gif = UIImage.gifWithName("falloutResize")
          self.coin.image = Gif
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
  
  @IBAction func Button1Action(sender: AnyObject) {
    self.DisableButtons()
    if (self.answer == "0") {
      audioController.playEffect(SoundButtonPressedCorrect)
      RightButtonSelected()
    } else {
      audioController.playEffect(SoundButtonPressed)
      WrongButtonSelected(Button1)
    }
  }
  
  @IBAction func Button2Action(sender: AnyObject) {
    self.DisableButtons()
    if (self.answer == "1") {
      audioController.playEffect(SoundButtonPressedCorrect)
      RightButtonSelected()
    } else {
      audioController.playEffect(SoundButtonPressed)
      WrongButtonSelected(Button2)
    }
  }
  
  @IBAction func Button3Action(sender: AnyObject) {
    self.DisableButtons()
    if (self.answer == "2") {
      audioController.playEffect(SoundButtonPressedCorrect)
      RightButtonSelected()
    } else {
      audioController.playEffect(SoundButtonPressed)
      WrongButtonSelected(Button3)
    }
  }
  
  @IBAction func Button4Action(sender: AnyObject) {
    self.DisableButtons()
    if (self.answer == "3") {
      audioController.playEffect(SoundButtonPressedCorrect)
      RightButtonSelected()
    } else {
      audioController.playEffect(SoundButtonPressed)
      WrongButtonSelected(Button4)
    }
  }
  
  @IBAction func nextRoundButton(sender: AnyObject) {
    switchToRoundTwo()
    audioController.playEffect(SoundButtonPressedCorrect)
  }
  
  @IBAction func tryRoundAgainButton(sender: AnyObject) {
    restartViewController()
    audioController.playEffect(SoundButtonPressedCorrect)
  }
  
  
  @IBAction func hintBtnTapped(sender: UIButton) {
    audioController.playEffect(SoundHintButtonPressed)
    self.HintButton.enabled = false
    self.hintButtonTapped = true
    self.stringToInt = Int(self.answer)
    self.setUpWrongAnswers(self.stringToInt!)
    self.hideAnAnswer(self.wrongAnswer(self.wrongAnswers.count))
    self.data.points -= pointsPerMultiHint
    totalScore = self.data.points
    self.PlayerScore.text = "Score: \(totalScore)"
    let b = HintButton.bounds
    UIView.animateWithDuration(0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: [], animations: {
      self.HintButton.bounds = CGRect(x: b.origin.x, y: b.origin.y, width: b.size.width + 5, height: b.size.height + 5)
      //gives button bouncy effect
      }, completion: {_ in
        self.HintButton.bounds = CGRect(x: b.origin.x, y: b.origin.y, width: b.size.width, height: b.size.height)
    })
  }
}
