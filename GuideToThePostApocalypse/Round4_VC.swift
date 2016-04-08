//
//  ViewController.swift
//  WasteLandSurvivalQuizParse
//
//  Created by Justin Doo on 11/30/15.
//  Copyright © 2015 Justin Doo. All rights reserved.
//

import UIKit
import Parse

class Round4_ViewController: MultiChoiceVC, CountdownTimerDelegate {
  
  
  //MARK:Constants
  
  var round4_objectIDArray = [String]()
  let messages = Messages(next: "Round 5", restart:"")
  
  //MARK: IBOutlets
  
  @IBOutlet var CountDownLabel: UILabel!
  @IBOutlet var QuestionLabel: UILabel!
  @IBOutlet var Button1: UIButton!
  @IBOutlet var Button2: UIButton!
  @IBOutlet var Button3: UIButton!
  @IBOutlet var Button4: UIButton!
  @IBOutlet var PlayerScore: UILabel!
  @IBOutlet var HintButton: UIButton!
  @IBOutlet var FalloutImage: UIImageView!
  
  
  //MARK: ViewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    AddAllGraphics()
    ButtonActions()
    StoreParseDataLocally_Round4()
    
    let currentTotalScore = userDefaults.integerForKey(TOTAL_SCORE_SAVED_KEY)
    totalScore = currentTotalScore
    PlayerScore.text = "Score: \(totalScore)"

    timer = CountdownTimer(timerLabel: self.CountDownLabel, startingMin: 0, startingSec: 16)
    timer.delegate = self
    userDefaults.setObject("Round_4", forKey: CURRENT_ROUND_KEY)
  }
  
//  override func viewWillAppear(animated: Bool) {
//    
//    bannersAndVaultBoys.madVaultBoyImage.center.y += view.bounds.height
//    bannersAndVaultBoys.zeroScoreVaultBoyImage.center.y -= view.bounds.height
//  }
//  
  //MARK: Parse
  
  //Get Random Object
  func GetRandomObjectID_Round4 () {
    
    randomID = Int(arc4random_uniform(UInt32(round4_objectIDArray.count)))
    //creating random 32 bit interger from the objectIDs
  }
  
  //Call Data
  
  func CallData_Round4() {
    //used to call class from parse.com
    
    GetRandomObjectID_Round4 ()
    
    if (round4_objectIDArray.count > 0) {
      
      let query: PFQuery = PFQuery(className: "Round_4")
      query.getObjectInBackgroundWithId(round4_objectIDArray[randomID], block:{
        
        (objectHolder : PFObject?, error : NSError?) -> Void in
        //holds all the objects (ie. questions & answers) created in parse.com
        
        if (error == nil) {
          self.image = objectHolder!["Image"] as! String!
          self.question = objectHolder!["Question"] as! String!
          self.answers = objectHolder!["Answers"] as! Array!
          self.answer = objectHolder!["Answer"] as! String!
          
          if (self.answers.count > 0) {
            
            self.FalloutImage.image = UIImage(named: self.image)
            self.QuestionLabel.text = self.question
            
            self.Button1.setTitle(self.answers[0], forState: UIControlState.Normal)
            self.Button2.setTitle(self.answers[1], forState: UIControlState.Normal)
            self.Button3.setTitle(self.answers[2], forState: UIControlState.Normal)
            self.Button4.setTitle(self.answers[3], forState: UIControlState.Normal)
            self.buttons.hintBtn.enabled = true
            
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
  
  func StoreParseDataLocally_Round4 () {
    
    let objectIDQuery = PFQuery(className: "Round_4")
    // calls "Round_4" class on Parse.com
    objectIDQuery.findObjectsInBackgroundWithBlock({
      (objectsArray : [PFObject]?, error : NSError?) -> Void in
      // takes objects from "QandA" Parse.com class and puts objects in an array, PFObject refers to the objects created in Parse.com
      if error == nil {
        var objectIDs = objectsArray
        
        for i in 0..<objectIDs!.count{
          self.round4_objectIDArray.append(objectIDs![i].objectId!)
          //appending objects downloaded from Parse.com to local array (objectIDPublicArray) - .objectID refers to id number given in parse.com (ex."QF0lrQKW8j")
        }
      } else {
        print("Error: \(error) \(error!.userInfo)")
      }
      dispatch_async(dispatch_get_main_queue()){
        
        objectIDQuery.cachePolicy = PFCachePolicy.NetworkElseCache
      }
      self.CallData_Round4()
    })
  }
  
  //MARK: Remove Used Questions
  
  func RemoveAlreadyUsedQuestion() {
    //adds 1 to the score
    if (round4_objectIDArray.count > 0){
      round4_objectIDArray.removeAtIndex(randomID)
      //randomID = currently asked question
      CallData_Round4()
    }
  }
  
  //MARK: Dismiss Q&A Buttons & Labels
  
  func DismissQandA () {
    
    UIView.animateWithDuration(0.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [.CurveEaseOut], animations: {
      self.bannersAndVaultBoys.rightAnswerBanner.hidden = true
      self.bannersAndVaultBoys.rightAnswerLabel.hidden = true
      self.buttons.hintButton.hidden = true
      self.Button1.hidden = true
      self.Button2.hidden = true
      self.Button3.hidden = true
      self.Button4.hidden = true
      self.QuestionLabel.hidden = true
      self.PlayerScore.hidden = true
      self.CountDownLabel.hidden = true
      self.FalloutImage.hidden = true
      }, completion: nil)
  }
  
  //MARK: Buttons
  
  func ButtonActions () {
    buttons.tryBtn.addTarget(self, action: "restartViewController", forControlEvents: .TouchUpInside)
    buttons.btn.addTarget(self, action: "switchToRoundFive:", forControlEvents: .TouchUpInside)
  }
  
  //Restart
  func restartViewController () ->() {
    self.dismissViewControllerAnimated(true, completion: nil)
    let storyboard = UIStoryboard(name: "Survial", bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier("Round_4")
    self.presentViewController(vc, animated: true, completion: nil)
    self.bannersAndVaultBoys.zeroScoreVaultBoyImage.center.y -= self.view.bounds.height
  }
  
  //Next Round
  func switchToRoundFive (sender:UIButton) {
    
    if(sender.tag == 1){
      UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: [.CurveEaseInOut, .AllowAnimatedContent], animations: {
        self.performSegueWithIdentifier("round4ToRound5Segue", sender: self)
        }, completion: nil)
    }
  }
  
  
  //RightButtonSelected
  func RightButtonSelected (){
    self.ShowRightAnswerBanner(bannersAndVaultBoys.rightAnswerBanner, label: bannersAndVaultBoys.rightAnswerLabel, message: messages.rightAnswerMessage)
    self.ThumbsUpVaultBoy()
    timer.pause()
    stopAudioTimer()
  }
  
  //Button Bounce
  func BounceButton (button: UIButton) {
    let b = button.bounds
    UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: [], animations: {
      button.bounds = CGRect(x: b.origin.x - 20, y: b.origin.y, width: b.size.width + 20, height: b.size.height)
      //gives button bouncy effect
      }, completion: {_ in
        self.ShowWrongAnswerBanner(self.bannersAndVaultBoys.wrongAnswerBanner, label: self.bannersAndVaultBoys.wrongAnswerLabel, message: self.messages.wrongAnswerMessage)
     //   self.MadVaultBoy()
    })
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
  
  //Hint Button
  func setUpWrongAnswers(rightAnswer: Int){
    var answers = ["answer1","answer2","answer3","answer4"]
    btnsArray = [Button1,Button2,Button3,Button4]
    wrongBtnsArray = btnsArray
    wrongBtnsArray.removeAtIndex(rightAnswer)
    answers.removeAtIndex(rightAnswer)
    wrongAnswers = answers
  }
  
  
  //MARK: Timer
  
  func startAudioTimer () {
    self.audioController.playEffect(SoundTimer)
  }
  
  func stopAudioTimer () {
    self.audioController.stopPlayingEffect(SoundTimer)
  }
  
  func countdownEnded() -> Void {
    self.checkInitialTimer()
  }
  
  
  func timerShakeAndReset () {
    self.DisableButtons()
    self.TimerShake()
    if madVaultBoyRunning == false {
     // self.MadVaultBoy()
    }
  }
  func checkInitialTimer () {
    if self.round4_objectIDArray.count == 0 {
    } else {
      self.timerShakeAndReset()
    }
  }
  
  func resetAllTimers () {
    timer.reset()
    timer.start()
    startAudioTimer()
  }
  
  //MARK: Add All Graphics
  func AddAllGraphics() {
    self.view.addSubview(bannersAndVaultBoys.wrongAnswerBanner)
    bannersAndVaultBoys.wrongAnswerBanner.addSubview(bannersAndVaultBoys.wrongAnswerLabel)
//    bannersAndVaultBoys.madVaultBoyImage = UIImageView(image: UIImage(named:"vault boy (walkingdead)_wrong"))
//    bannersAndVaultBoys.madVaultBoyImage.center = CGPoint(x: 180, y: 450)
//    self.view.addSubview(bannersAndVaultBoys.madVaultBoyImage)
    self.view.addSubview(bannersAndVaultBoys.rightAnswerBanner)
    bannersAndVaultBoys.rightAnswerBanner.addSubview(bannersAndVaultBoys.rightAnswerLabel)
    bannersAndVaultBoys.thumbsUpVaultBoyImage = UIImageView(image: UIImage(named:"vault boy (walking dead)"))
    bannersAndVaultBoys.thumbsUpVaultBoyImage.hidden = true
    bannersAndVaultBoys.thumbsUpVaultBoyImage.center = CGPoint(x: 180, y: 450)
    view.addSubview(bannersAndVaultBoys.thumbsUpVaultBoyImage)
    bannersAndVaultBoys.fireworks_2_gold.frame = CGRect(x: 120, y: 80, width: 300,  height: 300)
    self.view.addSubview(bannersAndVaultBoys.fireworks_2_gold)
    bannersAndVaultBoys.congratulationsVaultBoyImage = UIImageView(image: UIImage(named: "vault boy (walking dead)_success"))
    bannersAndVaultBoys.congratulationsVaultBoyImage.hidden = true
    bannersAndVaultBoys.congratulationsVaultBoyImage.center = CGPoint(x: 180, y: 340)
    self.view.addSubview(bannersAndVaultBoys.congratulationsVaultBoyImage)
//    bannersAndVaultBoys.zeroScoreVaultBoyImage = UIImageView(image: UIImage(named: "vault boy (walking dead)_gameover"))
//    bannersAndVaultBoys.zeroScoreVaultBoyImage.center = CGPoint(x: 180, y: 340)
//    self.view.addSubview(bannersAndVaultBoys.zeroScoreVaultBoyImage)
    self.view.addSubview(bannersAndVaultBoys.congratulationsBanner)
    bannersAndVaultBoys.congratulationsBanner.addSubview(bannersAndVaultBoys.congratulationsLabel)
    self.view.addSubview(bannersAndVaultBoys.earnedPerkLabel)
    self.view.addSubview(bannersAndVaultBoys.perkLabel)
    bannersAndVaultBoys.perkLabel.frame = CGRect(x: 115, y: 380, width: 200, height: 200)
    self.view.addSubview(bannersAndVaultBoys.totalScoreLabel)
    self.view.addSubview(bannersAndVaultBoys.failedLabel)
    self.view.addSubview(buttons.tryBtn)
    self.view.addSubview(buttons.btn)
    buttons.btn.setTitle("\(messages.nextRoundMessage)", forState: UIControlState.Normal)
  }
  
  
  //MARK: Vaultboy Animations
  
//  func vaultboyToFront () {
//    if self.mad == true {
//      self.view.bringSubviewToFront(self.bannersAndVaultBoys.madVaultBoyImage)
//    } else {
//      self.view.bringSubviewToFront(self.bannersAndVaultBoys.thumbsUpVaultBoyImage)
//    }
//  }
  
  //MARK: MadVaultBoy
  
//  func MadVaultBoy() {
//    
//    UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
//      self.showMadVaultBoyButtons()
//      timer.pause()
//      }, completion: {_ in
//        UIView.animateWithDuration(1.0, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
//          self.hideMadVaultBoyButtons(self.round4_objectIDArray)
//          self.hintButtonTapped = false
//          madVaultBoyRunning = false
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
//    self.UpdateScoreNegative()
//  }
//  
//  func hideMadVaultBoyButtons(round:[String]) {
//    self.bannersAndVaultBoys.madVaultBoyImage.center.y += self.view.bounds.height
//    self.delay(1, closure: {
//      
//      if round.count == 0 {
//        
//        self.DismissQandA()
//        if self.currentRoundScore == 0 {
//          self.zeroScoreVaultBoy()
//        }else{
//          self.congratulationsVaultBoy("walkingDeadRresize2")
//        }
//      } else {
//        self.EnableButtons()
//        self.resetAllTimers()
//      }
//    })
//  }
  
  
  //MARK: ThumbsUpBoy
  
  func ThumbsUpVaultBoy () {
    
    UIView.transitionWithView(self.bannersAndVaultBoys.thumbsUpVaultBoyImage, duration: 0.7, options: [.TransitionFlipFromBottom], animations: {
      self.showThumbsUpVaultBoyButtons()
      }, completion: {_ in
        UIView.animateWithDuration(1.0, delay: 1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
          self.hideThumbsUpVaultBoyButtons(self.round4_objectIDArray)
          self.hintButtonTapped = false
          currentScore = totalScore + self.currentRoundScore
          totalScore = currentScore
          userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
          userDefaults.synchronize()
          }, completion:nil)
    })
  }
  
  func showThumbsUpVaultBoyButtons () {
    self.RemoveAlreadyUsedQuestion()
    self.stopAudioTimer()
    timer.pause()
    self.audioController.playEffect(SoundDing)
    self.bannersAndVaultBoys.thumbsUpVaultBoyImage.hidden = false
    self.UpdateScorePositive()
  }
  
  func hideThumbsUpVaultBoyButtons(round:[String] ) {
    self.bannersAndVaultBoys.thumbsUpVaultBoyImage.center.y += self.view.bounds.height
    
    self.delay(1, closure: {
      
      if round.count == 0 {
        
        self.DismissQandA()
        self.congratulationsVaultBoy("walkingDeadRresize2")
      } else {
        self.bannersAndVaultBoys.thumbsUpVaultBoyImage.center.y -= self.view.bounds.height
        self.bannersAndVaultBoys.thumbsUpVaultBoyImage.hidden = true
        self.EnableButtons()
        self.resetAllTimers()
      }
    })
  }
  
  func zeroScoreVaultBoy () {
    
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
  
  func congratulationsVaultBoy (gifString: String) {
    
    UIView.transitionWithView(bannersAndVaultBoys.congratulationsVaultBoyImage, duration: 0.7, options: [.TransitionFlipFromTop], animations: {
      self.bannersAndVaultBoys.congratulationsVaultBoyImage.hidden = false
      self.audioController.playEffect(SoundWin)
      self.hintButtonTapped = false
      
      totalScore = self.currentRoundScore
      
      userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
      userDefaults.synchronize()
      
      self.ShowCongratulationsBanner(self.bannersAndVaultBoys.congratulationsBanner, label: self.bannersAndVaultBoys.congratulationsLabel)
      
      }, completion:{_ in
        //gives effect like fireworks are increasing then decreasing in size
        UIView.animateWithDuration(0.5, delay:0, options: [.Repeat, .Autoreverse], animations: {
          self.bannersAndVaultBoys.fireworks_2_gold.alpha = 1.0
          }, completion: nil)
        self.delay(3.0, closure: {
          self.bannersAndVaultBoys.fireworks_2_gold.alpha = 0.0
          self.bannersAndVaultBoys.congratulationsVaultBoyImage.hidden = true
          self.bannersAndVaultBoys.congratulationsBanner.hidden = true
          self.bannersAndVaultBoys.congratulationsLabel.hidden = true
          self.buttons.nextRoundButton.hidden = false
          self.bannersAndVaultBoys.earnedPerkLabel.hidden = false
          self.bannersAndVaultBoys.perkLabel.hidden = false
          self.audioController.playEffect(SoundPerk)
          self.GifMaker(gifString) //"falloutResize"
        })
    })
  }

  
  //MARK: Update Score
  
  func UpdateScoreNegative () {
    self.data.points - pointsPerWrongAnswer
    self.currentRoundScore = self.data.points
    self.PlayerScore.text = "Score: \(totalScore + self.currentRoundScore)"
  }
  
  func UpdateScorePositive () {
    self.data.points += pointsPerQuestion/2
    self.currentRoundScore = self.data.points
    self.PlayerScore.text = "Score: \(totalScore + self.currentRoundScore)"
  }
  
  func UpdateScoreRunOutOfTime () {
    self.data.points -= pointsTimeRunsOut
    self.currentRoundScore = self.data.points
    self.PlayerScore.text = "Score: \(totalScore + self.currentRoundScore)"
  }
  
  
  
  //MARK: IBActions
  
  @IBAction func Button1Action(sender: AnyObject) {
    self.DisableButtons()
    if self.hintButtonTapped == true {
      delay(1.5, closure: {self.unHideBtns()})
    }
    if (self.answer == "0") {
      audioController.playEffect(SoundButtonPressedCorrect)
      RightButtonSelected()
    } else {
      audioController.playEffect(SoundButtonPressed)
      WrongButtonSelected(Button1)
      madVaultBoyRunning = true
    }
  }
  
  
  @IBAction func Button2Action(sender: AnyObject) {
    self.DisableButtons()
    if self.hintButtonTapped == true {
      delay(1.5, closure: {self.unHideBtns()})
    }
    if (self.answer == "1") {
      audioController.playEffect(SoundButtonPressedCorrect)
      RightButtonSelected()
    } else {
      audioController.playEffect(SoundButtonPressed)
      WrongButtonSelected(Button2)
      madVaultBoyRunning = true
    }
  }
  
  
  @IBAction func Button3Action(sender: AnyObject) {
    self.DisableButtons()
    if self.hintButtonTapped == true {
      delay(1.5, closure: {self.unHideBtns()})
    }
    if (self.answer == "2") {
      audioController.playEffect(SoundButtonPressedCorrect)
      RightButtonSelected()
    } else {
      audioController.playEffect(SoundButtonPressed)
      WrongButtonSelected(Button3)
      madVaultBoyRunning = true
    }
  }
  
  
  @IBAction func Button4Action(sender: AnyObject) {
    self.DisableButtons()
    if self.hintButtonTapped == true {
      delay(1.5, closure: {self.unHideBtns()})
    }
    if (self.answer == "3") {
      audioController.playEffect(SoundButtonPressedCorrect)
      RightButtonSelected()
    } else {
      audioController.playEffect(SoundButtonPressed)
      WrongButtonSelected(Button4)
      madVaultBoyRunning = true
    }
  }
  
  @IBAction func hintBntTapped(sender: UIButton) {
    audioController.playEffect(SoundButtonPressed)
    self.HintButton.enabled = false
    let b = HintButton.bounds
    UIView.animateWithDuration(0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: [], animations: {
      self.HintButton.bounds = CGRect(x: b.origin.x, y: b.origin.y, width: b.size.width + 5, height: b.size.height + 5)
      //gives button bouncy effect
      }, completion: {_ in
        self.HintButton.bounds = CGRect(x: b.origin.x, y: b.origin.y, width: b.size.width, height: b.size.height)
        self.hintButtonTapped = true
        self.stringToInt = Int(self.answer)
        self.setUpWrongAnswers(self.stringToInt!)
        self.hideAnAnswer(self.wrongAnswer(self.wrongAnswers.count))
        self.delay(4.0, closure: {self.HintButton.enabled = true})
        self.data.points -= pointsPerMultiHint
        self.currentRoundScore = self.data.points
        self.PlayerScore.text = "Score: \(totalScore + self.currentRoundScore)"
    })
  }
}

