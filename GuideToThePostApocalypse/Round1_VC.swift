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
    
    if self.questions == nil {
      BackendlessUserFunctions.sharedInstance.getDataFromBackendless(1, rep: { ( questions : BackendlessCollection!) -> () in
        print("Comments have been fetched:")
        
        self.questions = []
        
        for question in questions.data {
          
          let currentQuestion = question as! BackendlessUserFunctions.Questions
          
          self.questions.append(currentQuestion)
        }
        
        dispatch_async(dispatch_get_main_queue()) {
          
          self.populateViewWithData()
        }
        }
        , err: { ( fault : Fault!) -> () in
          print("Questions were not fetched: \(fault)")
        }
      )
    } else {
      populateViewWithData()
    }
    
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
  
  func GetRandomQuestion () {
    
    randomQuestion = Int(arc4random_uniform(UInt32(questions.count)))
    //creating random 32 bit interger from the questions
  }
  

  //Store Data Locally
  
  
//  func getDataFromBackendless () {
//    
//    let backendless = Backendless.sharedInstance()
//    let dataStore = backendless.data.of(BackendlessUserFunctions.Questions.ofClass())
//    
//    let dataQuery = BackendlessDataQuery()
//    dataQuery.whereClause = "round = 1"
//    
//    dataStore.find( dataQuery, response: { ( questions : BackendlessCollection!) -> () in
//      print("Comments have been fetched:")
//        
//        self.questions = []
//        
//        for question in questions.data {
//          
//          let currentQuestion = question as! BackendlessUserFunctions.Questions
//          
//          self.questions.append(currentQuestion)
//        }
//      
//      dispatch_async(dispatch_get_main_queue()) {
//        
//        self.populateViewWithData()
//      }
//      
//      },
//                    
//        error: { ( fault : Fault!) -> () in
//          print("Questions were not fetched: \(fault)")
//      }
//    )
//    
//  }
  
  
  func populateViewWithData() {
    
     GetRandomQuestion() //used to randomize
    
    if questions.count > 0 {
      let currentQuestion = questions[randomQuestion]  //self.questions.first
      print("\(randomQuestion)")
        self.question = currentQuestion.question as String!
        // print("\(self.question)")
        
        let answersJson = currentQuestion.answers as String!
        // print("\(answersJson)")
        
        
        let jsonData: NSData = answersJson.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        let answersArray = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(rawValue: 0)) as! NSArray
        
        self.answers = answersArray as! [String]
        print("\(answersArray)")
        
        self.answer = currentQuestion.answer as String!
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
  }

  }
  
  //MARK: Remove Used Questions
  
  func RemoveAlreadyUsedQuestion() {
    if (questions.count > 0){
      questions.removeAtIndex(randomQuestion)
      print("\(randomQuestion)")
      populateViewWithData()
    }
  }
  
  //MARK: Dismiss Q&A Buttons & Labels
  
  func areBaseGraphicsHidden(buttons: Bool) {
    UIView.animateWithDuration(0.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [.CurveEaseOut], animations: {
      self.Button1.hidden = buttons
      self.Button2.hidden = buttons
      self.Button3.hidden = buttons
      self.Button4.hidden = buttons
      self.QuestionLabel.hidden = buttons
      self.PlayerScore.hidden = buttons
      self.CountDownLabel.hidden = buttons
      self.BackgroundImage.hidden = buttons
      self.HintButton.hidden = buttons
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
    self.vaultBoyFailedYConstraint.constant += self.view.bounds.height
    viewDidLoad()
    areBaseGraphicsHidden(false)
    viewWillAppear(false)
    areButtonsEnabledButtons(true)
    
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
  
  func areButtonsEnabledButtons(enabled: Bool) {
    Button1.enabled = enabled
    Button2.enabled = enabled
    Button3.enabled = enabled
    Button4.enabled = enabled
    HintButton.enabled = enabled
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
      self.areButtonsEnabledButtons(false)
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
    if self.questions.count == 0 {
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
            self.hideMadVaultBoyButtons(self.questions)
            madVaultBoyRunning = false
            //self.HintButton.enabled = true
            })
    })
  }
  
  func showMadVaultBoyButtons () {
    madVaultBoyRunning = true
    timer.pause()
    self.vaultboyToFront()
    self.vaultBoyWrong.hidden = false
    self.audioController.playEffect(SoundWrong)
    self.UpdateScoreNegative()
    self.RemoveAlreadyUsedQuestion()
    self.areButtonsEnabledButtons(false)
    self.UpdateScoreNegative()
    userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
    userDefaults.synchronize()
    self.vaultBoyWrongYConstraint.constant -= self.view.bounds.height
  }
  
  func hideMadVaultBoyButtons(round:[AnyObject]) {
    if self.hintButtonTapped == true {self.unHideBtns()
      self.hintButtonTapped = false
    }
    if round.count == 0 {
      self.areBaseGraphicsHidden(true)
      if self.currentRoundScore == 0 {
        self.zeroScoreVaultBoy()
      }else{
        self.congratulationsVaultBoy("falloutResize")
      }
    } else {
      self.areButtonsEnabledButtons(true)
      self.resetAllTimers()
    }
  }
  
  func thumbsUpVaultBoy () {
    thumbsUpBoyRunning = true
    self.vaultboyToFront()
    self.stopAudioTimer()
    timer.pause()
    self.RemoveAlreadyUsedQuestion()
    self.audioController.playEffect(SoundDing)
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
            self.hideThumbsUpVaultBoyButtons(self.questions)
            thumbsUpBoyRunning = false
            if self.hintButtonTapped == true {self.unHideBtns()
              self.hintButtonTapped = false
            }
            self.HintButton.enabled = true
        })
    })
  }
  
  
  func hideThumbsUpVaultBoyButtons(round:[AnyObject] ) {
    if round.count == 0 {
      self.areBaseGraphicsHidden(true)
      self.congratulationsVaultBoy("falloutResize")
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
    self.areBaseGraphicsHidden(true)
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
    self.areButtonsEnabledButtons(false)
    if (self.answer == "0") {
      audioController.playEffect(SoundButtonPressedCorrect)
      RightButtonSelected()
    } else {
      audioController.playEffect(SoundButtonPressed)
      WrongButtonSelected(Button1)
    }
  }
  
  @IBAction func Button2Action(sender: AnyObject) {
    self.areButtonsEnabledButtons(false)
    if (self.answer == "1") {
      audioController.playEffect(SoundButtonPressedCorrect)
      RightButtonSelected()
    } else {
      audioController.playEffect(SoundButtonPressed)
      WrongButtonSelected(Button2)
    }
  }
  
  @IBAction func Button3Action(sender: AnyObject) {
    self.areButtonsEnabledButtons(false)
    if (self.answer == "2") {
      audioController.playEffect(SoundButtonPressedCorrect)
      RightButtonSelected()
    } else {
      audioController.playEffect(SoundButtonPressed)
      WrongButtonSelected(Button3)
    }
  }
  
  @IBAction func Button4Action(sender: AnyObject) {
    self.areButtonsEnabledButtons(false)
    if (self.answer == "3") {
      audioController.playEffect(SoundButtonPressedCorrect)
      RightButtonSelected()
    } else {
      audioController.playEffect(SoundButtonPressed)
      WrongButtonSelected(Button4)
    }
  }
  
  @IBAction func nextRoundButton(sender: AnyObject) {
    audioController.playEffect(SoundButtonPressedCorrect)
    switchToRoundTwo()
  }
  
  @IBAction func tryRoundAgainButton(sender: AnyObject) {
    audioController.playEffect(SoundButtonPressed)
    restartViewController()
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
