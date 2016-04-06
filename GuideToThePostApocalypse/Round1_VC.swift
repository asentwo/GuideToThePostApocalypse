////
////  ViewController.swift
////  WasteLandSurvivalQuizParse
////
////  Created by Justin Doo on 11/30/15.
////  Copyright © 2015 Justin Doo. All rights reserved.
////
//
//import UIKit
//import Parse
//
//class Round1_ViewController:  MultiChoiceVC, CountdownTimerDelegate  {
//  
//  //MARK:Constants
//  
//  var round1_objectIDArray = [String]()
//  let messages = Messages(next: "Round 2", restart: "")
//  
//  //MARK: IBOutlets
//  
//  @IBOutlet var CountDownLabel: UILabel!
//  @IBOutlet var QuestionLabel: UILabel!
//  @IBOutlet var Button1: UIButton!
//  @IBOutlet var Button2: UIButton!
//  @IBOutlet var Button3: UIButton!
//  @IBOutlet var Button4: UIButton!
//  @IBOutlet var PlayerScore: UILabel!
//  @IBOutlet var HintButton: UIButton!
//  @IBOutlet var BackgroundImage: UIImageView!
//  
//  //MARK: ViewDidLoad
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    addAllGraphics()
//    ButtonActions()
//    StoreParseDataLocally_Round1()
//    
//    let currentTotalScore = userDefaults.integerForKey(TOTAL_SCORE_SAVED_KEY)
//    totalScore = currentTotalScore
//    PlayerScore.text = "Score: \(totalScore)"
//    
//    timer = CountdownTimer(timerLabel: self.CountDownLabel, startingMin: 0, startingSec: 16)
//    timer.delegate = self
//
//    userDefaults.setObject("Round_1", forKey: CURRENT_ROUND_KEY)
//  }
//  
//  //MARK: Parse
//  
//  //Random Object
//  
//  func GetRandomObjectID_Round1 () {
//    
//    randomID = Int(arc4random_uniform(UInt32(round1_objectIDArray.count)))
//    //creating random 32 bit interger from the objectIDs
//  }
//  
//  //Call Data
//  
//  func CallData_Round1() {
//    //used to call class from parse.com
//    
//    GetRandomObjectID_Round1 ()
//    
//    if (round1_objectIDArray.count > 0) {
//      
//      let query: PFQuery = PFQuery(className: "Round_1")
//      query.getObjectInBackgroundWithId(round1_objectIDArray[randomID], block:{
//        
//        (objectHolder : PFObject?, error : NSError?) -> Void in
//        //holds all the objects (ie. questions & answers) created in parse.com
//        
//        if (error == nil) {
//          self.question = objectHolder!["Questions"] as! String!
//          self.answers = objectHolder!["Answers"] as! Array!
//          self.answer = objectHolder!["Answer"] as! String!
//          if (self.answers.count > 0) {
//            self.QuestionLabel.text = self.question
//            
//            self.Button1.setTitle(self.answers[0], forState: UIControlState.Normal)
//            self.Button2.setTitle(self.answers[1], forState: UIControlState.Normal)
//            self.Button3.setTitle(self.answers[2], forState: UIControlState.Normal)
//            self.Button4.setTitle(self.answers[3], forState: UIControlState.Normal)
//            self.buttons.hintBtn.enabled = true
//            timer.start()
//            self.startAudioTimer()
//          }
//        } else {
//          NSLog("There is an error")
//        }
//      })
//    }
//  }
//  
//  
//  //Store Parse Data Locally
//  
//  func StoreParseDataLocally_Round1 () {
//    
//    let objectIDQuery = PFQuery(className: "Round_1")
//    // calls "Round_1" class on Parse.com
//    objectIDQuery.findObjectsInBackgroundWithBlock({
//      (objectsArray : [PFObject]?, error : NSError?) -> Void in
//      // takes objects from "QandA" Parse.com class and puts objects in an array, PFObject refers to the objects created in Parse.com
//      if error == nil {
//        var objectIDs = objectsArray
//        for i in 0..<objectIDs!.count{
//          self.round1_objectIDArray.append(objectIDs![i].objectId!)
//          //appending objects downloaded from Parse.com to local array (objectIDPublicArray) - .objectID refers to id number given in parse.com (ex."QF0lrQKW8j")
//        }
//      } else {
//        print("Error: \(error) \(error!.userInfo)")
//      }
//      dispatch_async(dispatch_get_main_queue()){
//        objectIDQuery.cachePolicy = PFCachePolicy.NetworkElseCache
//      }
//      self.CallData_Round1()
//    })
//  }
//  
//  //MARK: Add All Graphics
//  func addAllGraphics() {
//    self.view.addSubview(bannersAndVaultBoys.wrongAnswerBanner)
//    bannersAndVaultBoys.wrongAnswerBanner.addSubview(bannersAndVaultBoys.wrongAnswerLabel)
//    self.view.addSubview(bannersAndVaultBoys.madVaultBoyImage)
//    self.view.addSubview(bannersAndVaultBoys.rightAnswerBanner)
//    bannersAndVaultBoys.rightAnswerBanner.addSubview(bannersAndVaultBoys.rightAnswerLabel)
//    view.addSubview(bannersAndVaultBoys.thumbsUpVaultBoyImage)
//    self.view.addSubview(bannersAndVaultBoys.congratulationsBanner)
//    bannersAndVaultBoys.congratulationsBanner.addSubview(bannersAndVaultBoys.congratulationsLabel)
//    self.view.addSubview(bannersAndVaultBoys.fireworks_2_gold)
//    self.view.addSubview(bannersAndVaultBoys.congratulationsVaultBoyImage)
//    self.view.addSubview(bannersAndVaultBoys.zeroScoreVaultBoyImage)
//    self.view.addSubview(bannersAndVaultBoys.earnedPerkLabel)
//    self.view.addSubview(bannersAndVaultBoys.perkLabel)
//    self.view.addSubview(bannersAndVaultBoys.totalScoreLabel)
//    self.view.addSubview(bannersAndVaultBoys.failedLabel)
//    self.view.addSubview(buttons.tryBtn)
//    self.view.addSubview(buttons.btn)
//    buttons.btn.setTitle("\(messages.nextRoundMessage)", forState: UIControlState.Normal)
//  }
//  
//  //MARK: Remove Used Questions
//  
//  func RemoveAlreadyUsedQuestion() {
//    if (round1_objectIDArray.count > 0){
//      round1_objectIDArray.removeAtIndex(randomID)
//      //randomID = currently asked question
//      CallData_Round1()
//    }
//  }
//  
//  //MARK: Dismiss Q&A Buttons & Labels
//  
//  func DismissQandA () {
//    UIView.animateWithDuration(0.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [.CurveEaseOut], animations: {
//      self.bannersAndVaultBoys.rightAnswerBanner.hidden = true
//      self.bannersAndVaultBoys.rightAnswerLabel.hidden = true
//      self.buttons.hintButton.hidden = true
//      self.Button1.hidden = true
//      self.Button2.hidden = true
//      self.Button3.hidden = true
//      self.Button4.hidden = true
//      self.QuestionLabel.hidden = true
//      self.PlayerScore.hidden = true
//      self.CountDownLabel.hidden = true
//      self.BackgroundImage.hidden = true
//      self.HintButton.hidden = true
//      }, completion: nil)
//  }
//  
//  //
//  //MARK: Buttons
//  
//  func ButtonActions () {
//    buttons.tryBtn.addTarget(self, action: "restartViewController", forControlEvents: .TouchUpInside)
//    buttons.btn.addTarget(self, action: "switchToRoundTwo:", forControlEvents: .TouchUpInside)
//  }
//  
//  
//  //Restart
//  func restartViewController () ->() {
//    self.dismissViewControllerAnimated(true, completion: nil)
//    let storyboard = UIStoryboard(name: "Survial", bundle: nil)
//    let vc = storyboard.instantiateViewControllerWithIdentifier("Round_1")
//    self.presentViewController(vc, animated: true, completion: nil)
//    self.bannersAndVaultBoys.zeroScoreVaultBoyImage.center.y -= self.view.bounds.height
//    
//  }
//  
//  //Next Round
//  func switchToRoundTwo (sender:UIButton) {
//    if(sender.tag == 1){
//      UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: [.CurveEaseInOut, .AllowAnimatedContent], animations: {
//        self.performSegueWithIdentifier("round1ToRound2Segue", sender: self)
//        }, completion: nil)
//    }
//  }
//  
//  
//  //Button Bounce
//  func BounceButton (button: UIButton) {
//    let b = button.bounds
//    UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: [], animations: {
//      button.bounds = CGRect(x: b.origin.x - 20, y: b.origin.y, width: b.size.width + 20, height: b.size.height)
//      //gives button bouncy effect
//      }, completion: {_ in
//        self.ShowWrongAnswerBanner(self.bannersAndVaultBoys.wrongAnswerBanner, label: self.bannersAndVaultBoys.wrongAnswerLabel, message: self.messages.wrongAnswerMessage)
//        self.madVaultBoy()
//    })
//  }
//  
//  //RightButtonSelected
//  
//  func RightButtonSelected () {
//    self.ShowRightAnswerBanner(bannersAndVaultBoys.rightAnswerBanner, label: bannersAndVaultBoys.rightAnswerLabel, message: messages.rightAnswerMessage)
//    thumbsUpVaultBoy()
//    timer.pause()
//    stopAudioTimer()
// 
//  }
//
//  
//  //WrongButtonSelected
//  func WrongButtonSelected(sender: AnyObject)
//  {
//    switch sender.tag {
//    case 0: BounceButton(Button1)
//    case 1: BounceButton(Button2)
//    case 2: BounceButton(Button3)
//    case 3: BounceButton(Button4)
//    default: print("Wrong Button Selected Error")
//    }
//  }
//  
//  //Enable All Buttons
//  func EnableButtons () {
//    Button1.enabled = true
//    Button2.enabled = true
//    Button3.enabled = true
//    Button4.enabled = true
//  }
//  
//  //Disable All Buttons
//  func DisableButtons () {
//    Button1.enabled = false
//    Button2.enabled = false
//    Button3.enabled = false
//    Button4.enabled = false
//  }
//  
//  
//  
//  //Hint Button
//  func setUpWrongAnswers(rightAnswer: Int) {
//    var answers = ["answer1","answer2","answer3","answer4"]
//    btnsArray = [Button1, Button2, Button3, Button4]
//    wrongBtnsArray = btnsArray
//    wrongBtnsArray.removeAtIndex(rightAnswer)
//    answers.removeAtIndex(rightAnswer)
//    wrongAnswers = answers
//  }
//  
//  
//  //MARK: Update Score
//  
//  func UpdateScoreNegative () {
//    self.data.points - pointsPerWrongAnswer
//    self.currentRoundScore = self.data.points
//    self.PlayerScore.text = "Score: \(totalScore + self.currentRoundScore)"
//  }
//  
//  func UpdateScorePositive () {
//    self.data.points += pointsPerQuestion/2
//    self.currentRoundScore = self.data.points
//    self.PlayerScore.text = "Score: \(totalScore + self.currentRoundScore)"
//  }
//  func UpdateScoreRunOutOfTime () {
//    self.data.points -= pointsTimeRunsOut
//    self.currentRoundScore = self.data.points
//    self.PlayerScore.text = "Score: \(totalScore + self.currentRoundScore)"
//  }
//  
//  //MARK: Timer
//  
//  func startAudioTimer () {
//    self.audioController.playEffect(SoundTimer)
//  }
//  
//  func stopAudioTimer () {
//    self.audioController.stopPlayingEffect(SoundTimer)
//  }
//  
//  func checkInitialTimer (round:[String]) {
//      if round.count == 0 {
//      } else {
//        self.timerShakeAndReset()
//      }
//  }
//  
//  
//  func countdownEnded() -> Void {
//    self.checkInitialTimer(round1_objectIDArray)
//  }
//
//  
//  func timerShakeAndReset () {
//    self.DisableButtons()
//    self.UpdateScoreRunOutOfTime()
//    self.TimerShake()
//    
//    if madVaultBoyRunning == false {
//      madVaultBoy()
//    }
//  }
//  
//  func resetAllTimers () {
//    timer.reset()
//    timer.start()
//    startAudioTimer()
//  }
//
//  
//  //MARK: MadVaultBoy
//  
//  func madVaultBoy() {
//    UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
//      self.showMadVaultBoyButtons()
//      timer.pause()
//      }, completion: {_ in
//        UIView.animateWithDuration(1.0, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
//          self.hideMadVaultBoyButtons(self.round1_objectIDArray)
//          self.hintButtonTapped = false
//          madVaultBoyRunning = false
//          self.UpdateScoreNegative()
//          currentScore = totalScore + self.currentRoundScore
//          totalScore = currentScore
//          userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
//          userDefaults.synchronize()
//          }, completion: nil)
//    })
//  }
//  func showMadVaultBoyButtons () {
//    self.RemoveAlreadyUsedQuestion()
//    self.mad = true
//    self.vaultboyToFront()
//    self.bannersAndVaultBoys.madVaultBoyImage.hidden = false
//    self.bannersAndVaultBoys.madVaultBoyImage.center.y -= self.view.bounds.height
//    self.audioController.playEffect(SoundWrong)
//  }
//  
//  func hideMadVaultBoyButtons(round:[String]) {
//    self.bannersAndVaultBoys.madVaultBoyImage.center.y += self.view.bounds.height
//    self.stopAudioTimer()
//    self.DisableButtons()
//    self.delay(1, closure: {
//      
//      if round.count == 0 {
//        
//        self.DismissQandA()
//        
//        if self.currentRoundScore == 0 {
//          self.zeroScoreVaultBoy()
//        }else{
//          self.congratulationsVaultBoy("falloutResize")
//        }
//      } else {
//        self.EnableButtons()
//        self.resetAllTimers()
//      }
//    })
//  }
//  
//  //MARK: ThumbsUpBoy
//  
//  func thumbsUpVaultBoy () {
//    UIView.transitionWithView(self.bannersAndVaultBoys.thumbsUpVaultBoyImage, duration: 0.7, options: [.TransitionFlipFromBottom], animations: {
//      self.showThumbsUpVaultBoyButtons()
//      }, completion: {_ in
//        UIView.animateWithDuration(1.0, delay: 1.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
//          self.hideThumbsUpVaultBoyButtons(self.round1_objectIDArray)
//          self.hintButtonTapped = false
//           self.UpdateScorePositive()
//          currentScore = totalScore + self.currentRoundScore
//          totalScore = currentScore
//          userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
//          userDefaults.synchronize()
//          }, completion: nil)
//    })
//  }
//  
//  func showThumbsUpVaultBoyButtons () {
//    self.RemoveAlreadyUsedQuestion()
//    self.stopAudioTimer()
//    timer.pause()
//    self.audioController.playEffect(SoundDing)
//    self.bannersAndVaultBoys.thumbsUpVaultBoyImage.hidden = false
//  }
//  
//  func hideThumbsUpVaultBoyButtons(round:[String] ) {
//    self.bannersAndVaultBoys.thumbsUpVaultBoyImage.center.y += self.view.bounds.height
//    self.DisableButtons()
//    self.delay(1, closure: {
//      
//      if round.count == 0 {
//        
//        self.DismissQandA()
//        self.congratulationsVaultBoy("falloutResize")
//      } else {
//        self.bannersAndVaultBoys.thumbsUpVaultBoyImage.center.y -= self.view.bounds.height
//        self.bannersAndVaultBoys.thumbsUpVaultBoyImage.hidden = true
//        self.EnableButtons()
//        self.resetAllTimers()
//      }
//    })
//  }
// 
//  
//  //MARK: IBActions
//  
//  @IBAction func Button1Action(sender: AnyObject) {
//    self.DisableButtons()
//    if self.hintButtonTapped == true {
//      delay(1.5, closure: {self.unHideBtns()})
//    }
//    if (self.answer == "0") {
//      audioController.playEffect(SoundButtonPressedCorrect)
//      RightButtonSelected()
//    } else {
//      audioController.playEffect(SoundButtonPressed)
//      madVaultBoyRunning = true
//      WrongButtonSelected(Button1)
//    }
//  }
//  
//  @IBAction func Button2Action(sender: AnyObject) {
//    self.DisableButtons()
//    if self.hintButtonTapped == true {
//      delay(1.5, closure: {self.unHideBtns()})
//    }
//    if (self.answer == "1") {
//      audioController.playEffect(SoundButtonPressedCorrect)
//      RightButtonSelected()
//    } else {
//      audioController.playEffect(SoundButtonPressed)
//      madVaultBoyRunning = true
//      WrongButtonSelected(Button2)
//    }
//  }
//  
//  @IBAction func Button3Action(sender: AnyObject) {
//    self.DisableButtons()
//    if self.hintButtonTapped == true {
//      delay(1.5, closure: {self.unHideBtns()})
//    }
//    if (self.answer == "2") {
//      audioController.playEffect(SoundButtonPressedCorrect)
//      RightButtonSelected()
//    } else {
//      audioController.playEffect(SoundButtonPressed)
//      madVaultBoyRunning = true
//      WrongButtonSelected(Button3)
//    }
//  }
//  
//  @IBAction func Button4Action(sender: AnyObject) {
//    self.DisableButtons()
//    if self.hintButtonTapped == true {
//      delay(1.5, closure: {self.unHideBtns()})
//    }
//    if (self.answer == "3") {
//      audioController.playEffect(SoundButtonPressedCorrect)
//      RightButtonSelected()
//    } else {
//      audioController.playEffect(SoundButtonPressed)
//      madVaultBoyRunning = true
//      WrongButtonSelected(Button4)
//    }
//  }
//  
//  @IBAction func hintBtnTapped(sender: UIButton) {
//    audioController.playEffect(SoundHintButtonPressed)
//    self.HintButton.enabled = false
//    let b = HintButton.bounds
//    UIView.animateWithDuration(0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: [], animations: {
//      self.HintButton.bounds = CGRect(x: b.origin.x, y: b.origin.y, width: b.size.width + 5, height: b.size.height + 5)
//      //gives button bouncy effect
//      }, completion: {_ in
//        self.HintButton.bounds = CGRect(x: b.origin.x, y: b.origin.y, width: b.size.width, height: b.size.height)
//        self.hintButtonTapped = true
//        self.stringToInt = Int(self.answer)
//        self.setUpWrongAnswers(self.stringToInt!)
//        self.hideAnAnswer(self.wrongAnswer(self.wrongAnswers.count))
//        self.delay(4.0, closure: {self.HintButton.enabled = true})
//        self.data.points -= pointsPerMultiHint
//        self.currentRoundScore = self.data.points
//        self.PlayerScore.text = "Score: \(totalScore + self.currentRoundScore)"
//    })
//  }
//}
