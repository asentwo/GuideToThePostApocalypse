//
//  Round6_ViewController.swift
//  Wastland_Survival_Guide
//
//  Created by Justin Doo on 1/16/16.
//  Copyright © 2016 Justin Doo. All rights reserved.
//

import UIKit


class Round2_ViewController: DragTileVC, CountdownTimerDelegate {
  
  
  //MARK:Constants
  var buttons = Buttons()
  
  //tiles and targets
  var mainTileTargetView: UIView!
  var tileTargetView0: UIView!
  var tileTargetView1: UIView!
  var tileTargetView2: UIView!
  var tileTargetView3: UIView!
  var tileTargetView4: UIView!
  var tileTargetView5: UIView!
  
  //MARK: IBOutlets
  @IBOutlet var FalloutImage: UIImageView!
  @IBOutlet var QuestionLabel: UILabel!
  @IBOutlet var PlayerScore: UILabel!
  @IBOutlet var CountDownLabel: UILabel!
 
  
  
  //VaultBoys
  @IBOutlet weak var vaultBoyWrong: UIImageView!
  @IBOutlet weak var vaultBoyRight: UIImageView!
  @IBOutlet weak var vaultBoyFailed: UIImageView!
  @IBOutlet weak var vaultBoySuccess: UIImageView!
  
  //buttons
  @IBOutlet weak var tryAgain: UIButton!
  @IBOutlet weak var nextRound: UIButton!
  
  //labels
  @IBOutlet weak var youFailedThisRound: UILabel!
  @IBOutlet weak var scoreBanner: UIImageView!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var youEarrnedACoin: UILabel!
  
  //gif
  @IBOutlet weak var coin: UIImageView!
  
  //wrong/right banners
  @IBOutlet weak var wrongAnswerBanner: UIImageView!
  @IBOutlet weak var wrongAnswerLabel: UILabel!
  @IBOutlet weak var rightAnswerBanner: UIImageView!
  @IBOutlet weak var rightAnswerLabel: UILabel!
  
  //constraints
  @IBOutlet weak var vaultBoyWrongYConstraint: NSLayoutConstraint!
  @IBOutlet weak var vaultBoyRightYConstraint: NSLayoutConstraint!
  @IBOutlet weak var vaultBoyFailedYConstraint: NSLayoutConstraint!
  @IBOutlet weak var vaultBoySuccessYConstraint: NSLayoutConstraint!
  @IBOutlet weak var coinYConstraint: NSLayoutConstraint!
  @IBOutlet weak var rightAnswerBannerXConstraint: NSLayoutConstraint!
  @IBOutlet weak var wrongAnswerBannerXConstraint: NSLayoutConstraint!
  
  //MARK: ViewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    hideAllGraphics()
    labelSizeAdjustment()
    ButtonActions()
   
    //add tile view
    let tileView = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
    self.view.addSubview(tileView)
    self.tileTargetView0 = tileView
    self.mainTileTargetView = self.tileTargetView0
    self.view.addSubview(buttons.hintBtn)

    //timer/ Score
    timer = CountdownTimer(timerLabel: self.CountDownLabel, startingMin: 0, startingSec:31)
    timer.delegate = self
    
    userDefaults.setObject("Round_2", forKey: CURRENT_ROUND_KEY)
    let currentTotalScore = userDefaults.integerForKey(TOTAL_SCORE_SAVED_KEY)
    totalScore = currentTotalScore
    self.data.points = totalScore
    PlayerScore.text = "Score: \(totalScore)"
    currentRoundScore = 0
    
    
    if self.questions == nil {
      BackendlessUserFunctions.sharedInstance.getDataFromBackendless(2, rep: { ( questions : BackendlessCollection!) -> () in
        print("Comments have been fetched:")
        
        self.questions = []
        
        for question in questions.data {
          
          let currentQuestion = question as! BackendlessUserFunctions.Questions
          
          self.questions.append(currentQuestion)
        }
        
        dispatch_async(dispatch_get_main_queue()) {
          
          self.tryAgainQuestions = self.questions
          self.populateViewWithData()
        }
        }
        , err: { ( fault : Fault!) -> () in
          print("Questions were not fetched: \(fault)")
        }
      )
    } else {
      
      dispatch_async(dispatch_get_main_queue()) {
        self.tryAgainQuestions = self.questions
        self.populateViewWithData()
      }
    }


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
    
    self.randomQuestion = Int(arc4random_uniform(UInt32(self.questions.count)))
    //creating random 32 bit interger from the questions
  }
  
  
  
  //Parse JSON
  
  
  func populateViewWithData() {
    
    GetRandomQuestion() //used to randomize
    
    if self.questions.count > 0 {
      let currentQuestion = self.questions[self.randomQuestion]
      
      self.question = currentQuestion.question as String!
      self.answer = currentQuestion.answer as String!
      self.image = currentQuestion.image as String!
      self.letters = currentQuestion.letters as String!
      
     if (self.questions.count > 0) {
        self.QuestionLabel.text = self.question
        self.FalloutImage.image = UIImage(named: self.image)
        self.lettersLength = self.letters.characters.count
        self.answerLength = self.answer.characters.count
      
        self.newTile()
        self.setTiles()
        self.buttons.hintBtn.enabled = true
        timer.start()
        self.startAudioTimer()
      }
     }
    else {
      
      NSLog("There are no more questions")

    }
  }
  
  
  //MARK: Remove Used Questions
  
  func RemoveAlreadyUsedQuestion() {
    if (self.questions.count > 0){
      self.questions.removeAtIndex(self.randomQuestion)
      populateViewWithData()
      print("\(self.questions.count)")
    }
  }
  
  //MARK: Dismiss Q&A
  
  func areBaseGraphicsHidden(hidden: Bool) {
    UIView.animateWithDuration(0.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [.CurveEaseOut], animations: {
      self.buttons.hintButton.hidden = hidden
      self.FalloutImage.hidden = hidden
      self.QuestionLabel.hidden = hidden
      self.PlayerScore.hidden = hidden
      self.CountDownLabel.hidden = hidden
      }, completion: nil)
  }
  
  
  //MARK: VaultBoy Animation
  
  func vaultboyToFront () {
    if madVaultBoyRunning == true {
      self.view.bringSubviewToFront(vaultBoyWrong)
    } else {
      self.view.bringSubviewToFront(vaultBoyRight)
    }
  }
  
  func MadVaultBoy() {
    self.buttons.hintBtn.enabled = false
    removeTiles()
    madVaultBoyRunning = true
    self.vaultboyToFront()
    vaultBoyWrong.hidden = false
    self.audioController.playEffect(soundWrong)
    self.UpdateScoreNegative()
    self.vaultBoyWrongYConstraint.constant -= self.view.bounds.height
    UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
      self.view.layoutIfNeeded()
      }, completion: {_ in
        self.RemoveAlreadyUsedQuestion()
        userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
        userDefaults.synchronize()
        if self.questions.count == 0 {
          self.areBaseGraphicsHidden(true)
          if self.currentRoundScore == 0 {
            self.mainTileTargetView.removeFromSuperview()
            self.ZeroScoreVaultBoy()
          }else{
            self.mainTileTargetView.removeFromSuperview()
            self.CongratulationsVaultBoy()
          }
        } else{
          self.resetAlltimers()
        }
        self.vaultBoyWrongYConstraint.constant += self.view.bounds.height
        UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
          self.view.layoutIfNeeded()
          }, completion:{_ in
            self.buttons.hintBtn.enabled = true
            madVaultBoyRunning = false
        })
    })
  }
  
  
  func ThumbsUpVaultBoy () {
    self.buttons.hintBtn.enabled = false
    self.mainTileTargetView.hidden = true
    thumbsUpBoyRunning = true
    self.vaultboyToFront()
    self.stopAudioTimer()
    timer.pause()
    self.RemoveAlreadyUsedQuestion()
    self.audioController.playEffect(soundDing)
    UIView.transitionWithView(vaultBoyRight, duration: 0.7, options: [.TransitionFlipFromBottom], animations: {
      self.vaultBoyRight.hidden = false
      
      }, completion: {_ in
        self.UpdateScorePositive()
        userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
        userDefaults.synchronize()
        self.vaultBoyRightYConstraint.constant += self.view.bounds.height
        UIView.animateWithDuration(1.0, delay: 1.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
          self.view.layoutIfNeeded()
          self.delay(1, closure: {
            if self.questions.count == 0 {
              self.areBaseGraphicsHidden(true)
              self.CongratulationsVaultBoy()
              self.mainTileTargetView.removeFromSuperview()
            } else {
              self.vaultBoyRightYConstraint.constant -= self.view.bounds.height
              self.view.layoutIfNeeded()
              self.vaultBoyRight.hidden = true
              self.mainTileTargetView.hidden = false
              self.resetAlltimers()
            }
          })
          }, completion:{_ in
             thumbsUpBoyRunning = false
            self.buttons.hintBtn.enabled = true
        })
    })
  }
  
  func ZeroScoreVaultBoy () {
    self.audioController.playEffect(soundWrong)
    self.tryAgain.hidden = false
    self.view.bringSubviewToFront(self.tryAgain)
    self.youFailedThisRound.hidden = false
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
  
  func CongratulationsVaultBoy() {
    self.stopAudioTimer()
    self.vaultBoySuccess.hidden = false
    self.audioController.playEffect(soundWin)
    userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
    userDefaults.synchronize()
    UIView.transitionWithView(vaultBoySuccess, duration: 0.7, options: [.TransitionFlipFromTop], animations: {
      self.scoreBanner.hidden = false
      self.scoreLabel.hidden = false
      self.scoreLabel.text = "You scored \(totalScore) points!"
      }, completion:{_ in
        let explode = ExplodeView(frame:CGRectMake(self.vaultBoySuccess.center.x - 20, self.vaultBoySuccess.center.y - 60, 100,100))
        self.vaultBoySuccess.superview?.addSubview(explode)
        self.vaultBoySuccess.superview?.sendSubviewToBack(explode)
        self.delay(3.0, closure: {
          self.nextRound.hidden = false
          self.view.bringSubviewToFront(self.nextRound)
          self.vaultBoySuccess.hidden = true
          self.scoreBanner.hidden = true
          self.scoreLabel.hidden = true
          self.youEarrnedACoin.hidden = false
          self.audioController.playEffect(soundPerk)
          let Gif = UIImage.gifWithName("fallout2Resize")
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
  
  
  
  //MARK: timer
  
  func countdownEnded() -> Void {
    self.checkInitialtimer()
  }
  
  func timerShakeAndReset () {
    if madVaultBoyRunning == false && thumbsUpBoyRunning == false {
      self.UpdateScoreRunOutOfTime()
      self.timerShake()
      self.MadVaultBoy()
    }
  }
  
  func resetAlltimers () {
    timer.reset()
    timer.start()
    startAudioTimer()
  }
  
  func checkInitialtimer () {
    if self.questions.count == 0 {
    } else {
      self.timerShakeAndReset()
    }
  }
  
  //MARK: Tiles Other
  
  func removeTiles() {
    
    switch mainTileTargetView {
    case tileTargetView1:
      self.tileTargetView1.removeFromSuperview()
    case tileTargetView2:
      self.tileTargetView2.removeFromSuperview()
    case tileTargetView3:
      self.tileTargetView3.removeFromSuperview()
    case tileTargetView4:
      self.tileTargetView4.removeFromSuperview()
    case tileTargetView5:
      self.tileTargetView5.removeFromSuperview()
    default: print("")
    }
  }
  
  func newTile () {
    print("\(self.questions.count)")
    switch mainTileTargetView {
    case tileTargetView0:
      let tileView = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
      self.view.addSubview(tileView)
      self.tileTargetView1 = tileView
      self.mainTileTargetView = self.tileTargetView1
      self.view.addSubview(buttons.hintBtn)
    case tileTargetView1:
      self.tileTargetView1.removeFromSuperview()
      let tileView = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
      self.view.addSubview(tileView)
      self.tileTargetView2 = tileView
      self.view.addSubview(tileTargetView2)
      self.mainTileTargetView = self.tileTargetView2
      self.view.addSubview(buttons.hintBtn)
    case tileTargetView2:
      self.tileTargetView2.removeFromSuperview()
      let tileView = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
      self.view.addSubview(tileView)
      self.tileTargetView3 = tileView
      self.view.addSubview(tileTargetView3)
      self.mainTileTargetView = self.tileTargetView3
      self.view.addSubview(buttons.hintBtn)
    case tileTargetView3:
      self.tileTargetView3.removeFromSuperview()
      let tileView = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
      self.view.addSubview(tileView)
      self.tileTargetView4 = tileView
      self.view.addSubview(tileTargetView4)
      self.mainTileTargetView = self.tileTargetView4
      self.view.addSubview(buttons.hintBtn)
    case tileTargetView4:
      self.tileTargetView4.removeFromSuperview()
      let tileView = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
      self.view.addSubview(tileView)
      self.tileTargetView5 = tileView
      self.view.addSubview(tileTargetView5)
      self.mainTileTargetView = self.tileTargetView5
      self.view.addSubview(buttons.hintBtn)
    case tileTargetView5:
      self.tileTargetView5.removeFromSuperview()
    default: print("")
    }
    self.vaultboyToFront()
  }
  
  
  //MARK: Graphics
  
  func hideAllGraphics () {
    vaultBoyWrong.hidden = true
    vaultBoyRight.hidden = true
    vaultBoyFailed.hidden = true
    vaultBoySuccess.hidden = true
    tryAgain.hidden = true
    nextRound.hidden = true
    youFailedThisRound.hidden = true
    scoreBanner.hidden = true
    scoreLabel.hidden = true
    youEarrnedACoin.hidden = true
    coin.hidden = true
    wrongAnswerBanner.hidden = true
    wrongAnswerLabel.hidden = true
    rightAnswerBanner.hidden = true
    rightAnswerLabel.hidden = true
  }
  
  func labelSizeAdjustment () {
    QuestionLabel.adjustsFontSizeToFitWidth = true
    youEarrnedACoin.adjustsFontSizeToFitWidth = true
    scoreLabel.adjustsFontSizeToFitWidth = true
    youFailedThisRound.adjustsFontSizeToFitWidth = true
    rightAnswerLabel.adjustsFontSizeToFitWidth = true
    wrongAnswerLabel.adjustsFontSizeToFitWidth = true
    tryAgain.titleLabel?.adjustsFontSizeToFitWidth = true
    nextRound.titleLabel?.adjustsFontSizeToFitWidth = true
  }
  
  //MARK: Update Score
  
  func UpdateScoreNegative () {
    self.data.points -= pointsPerQuestion/2
    totalScore = self.data.points
    currentRoundScore = self.data.points
    self.PlayerScore.text = "Score: \(totalScore)"
  }
  
  func UpdateScorePositive () {
    self.data.points += pointsPerQuestion/2
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
  
  //MARK: Buttons Functions
  
  func ButtonActions () {
    buttons.hintBtn.addTarget(self, action: "giveHint:", forControlEvents: .TouchUpInside)
  }
  
//  //Next Round
  func switchToRoundThree () {
    UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: [.CurveEaseInOut, .AllowAnimatedContent], animations: {
      self.performSegueWithIdentifier("round2ToRound3Segue", sender: self)
      }, completion: nil)
  }
  
  //Restart viewController
  
  func restartViewController () ->() {
    self.vaultBoyFailedYConstraint.constant += self.view.bounds.height
    self.view.layoutIfNeeded()
    viewDidLoad()
    viewWillAppear(false)
    areBaseGraphicsHidden(false)
  }
  
  //Give Hint
  
  func giveHint (sender: UIButton) {
    audioController.playEffect(soundHintButtonPressed)
    self.buttons.hintBtn.enabled = false
    self.data.points -= pointsPerTile/2
    totalScore = self.data.points
    self.PlayerScore.text = "Score: \(totalScore)"
    
    //3 find the first unmatched target and matching tile
    var foundTarget:TargetView? = nil
    for target in targets {
      if !target.isMatched {
        foundTarget = target
        break
      }
    }
    //4 find the first tile matching the target
    var foundTile:TileView? = nil
    for tile in tiles {
      if !tile.isMatched && tile.letter == foundTarget?.letter {
        foundTile = tile
        break
      }
    }
    //ensure there is a matching tile and target
    if let target = foundTarget, tile = foundTile {
      //5 don't want the tile sliding under other tiles
      self.mainTileTargetView.bringSubviewToFront(tile)
      //6 show the animation to the user
      UIView.animateWithDuration(1.5,
                                 delay:0.0,
                                 options:UIViewAnimationOptions.CurveEaseOut,
                                 animations:{
                                  tile.center = target.center
        }, completion: {
          (value:Bool) in
          //7 adjust view on spot
          if madVaultBoyRunning == false {
            self.placeTile(tile, targetView: target)
            self.audioController.playEffect(soundTileCorrect)
            //8 re-enable the button
            self.buttons.hintButton.enabled = true
            //9 check for finished game
            self.checkForSuccess()
          } else {
            self.buttons.hintButton.enabled = false
          }
          
      })
    }
  }
  
  //MARK: Buttons
  
  @IBAction func nextRoundButton(sender: AnyObject) {
    self.switchToRoundThree()
    audioController.playEffect(soundButtonPressedCorrect)
  }
  
  @IBAction func tryRoundAgainButton(sender: AnyObject) {
    self.restartViewController()
    audioController.playEffect(soundButtonPressedCorrect)
  }
  
}

/*declares that the viewController conforms to TileDragDelegateProtocol, and also defines tileView(tileView:didDragToPoint:) which is the initial implementation of the delegate method.
 This code loops over all objects in the targets array and, for each of the target views, checks whether the given drag point is within the target’s frame. If a tile is found to be within a target, the matching target is saved to targetView.
 */


extension Round2_ViewController:TileDragDelegateProtocol {
  //a tile was dragged, check if matches a target
  func tileView(tileView: TileView, didDragToPoint point: CGPoint) {
    var targetView: TargetView?
    for tv in targets {
      if tv.frame.contains(point) && !tv.isMatched {
        targetView = tv
        break
      }
    }
    //1 check if target was found
    if let targetView = targetView {
      //2 check if letter matches
      if targetView.letter == tileView.letter {
        //3 called if tile is placed on right target
        placeTile(tileView, targetView: targetView)
        //4 sound tile was placed right target
        audioController.playEffect(soundTileCorrect)
        //give points
        data.points += pointsPerTile
        //check if word is completed
        totalScore = self.data.points
        self.PlayerScore.text = "Score: \(totalScore)"
        //check if word is completed
        self.checkForSuccess()
      } else {
        
        //4 called if tile is placed on wrong target
        UIView.animateWithDuration(0.35,
                                   delay:0.00,
                                   options:UIViewAnimationOptions.CurveEaseOut,
                                   animations: {
                                    tileView.center = CGPointMake(tileView.center.x + CGFloat(self.randomNumber(minX:0, maxX:40)-20),
                                      tileView.center.y + CGFloat(self.randomNumber(minX:20, maxX:30)))
          },
                                   completion: nil)
        //more stuff to do on failure here
        audioController.playEffect(soundWrong)
        //take out points
        data.points -= pointsPerTile/2
        totalScore = self.data.points
        self.PlayerScore.text = "Score: \(totalScore)"
      }
    }
  }
  
  //MARK: Set Tiles
  func setTiles () {
    
    //calculate the tile size
    let tileSide = ceil(screenWidth * 0.9 / CGFloat(max(lettersLength, answerLength))) - TileMargin
    //get the left margin for first tile
    var xOffset = (screenWidth - CGFloat(max(lettersLength, answerLength)) * (tileSide + TileMargin)) / 2.0
    //adjust for tile center (instead of the tile's origin)
    xOffset += tileSide / 2.0
    //initialize target list
    targets = []
    //create targets
    for (index, letter) in self.answer.characters.enumerate() {
      if letter != " " {
        let target = TargetView(letter: letter, sideLength: tileSide)
        target.center = CGPointMake(xOffset + CGFloat(index)*(tileSide + TileMargin), screenHeight/4*3)
        
        switch mainTileTargetView {
        case tileTargetView1:
          tileTargetView1.addSubview(target)
          targets.append(target)
        case tileTargetView2:
          tileTargetView2.addSubview(target)
          targets.append(target)
        case tileTargetView3:
          tileTargetView3.addSubview(target)
          targets.append(target)
        case tileTargetView4:
          tileTargetView4.addSubview(target)
          targets.append(target)
        case tileTargetView5:
          tileTargetView5.addSubview(target)
          targets.append(target)
        default: print("Target view not present")
        }
      }
    }
    //1 initialize tile list
    tiles = []
    //2 create tiles
    for (index, letter) in self.letters.characters.enumerate() {
      //3
      if letter != " " {
        let tile = TileView(letter: letter, sideLength: tileSide)
        tile.center = CGPointMake(xOffset + CGFloat(index)*(tileSide + TileMargin), screenHeight/7*6)
        tile.dragDelegate = self
        
        switch mainTileTargetView {
        case tileTargetView1:
          tileTargetView1.addSubview(tile)
          tiles.append(tile)
        case tileTargetView2:
          tileTargetView2.addSubview(tile)
          tiles.append(tile)
        case tileTargetView3:
          tileTargetView3.addSubview(tile)
          tiles.append(tile)
        case tileTargetView4:
          tileTargetView4.addSubview(tile)
          tiles.append(tile)
        case tileTargetView5:
          tileTargetView5.addSubview(tile)
          tiles.append(tile)
        default: print("Tile does not exist")
        }
      }
    }
  }
  
  //MARK: Place Tile - called when a tile a successfully placed - makes tile flush with target
  
  
  func placeTile(tileView: TileView, targetView: TargetView) {
    //1
    targetView.isMatched = true
    tileView.isMatched = true
    //2
    tileView.userInteractionEnabled = false
    //3
    UIView.animateWithDuration(0.35,
                               delay:0.00,
                               options:UIViewAnimationOptions.CurveEaseOut,
                               //4
      animations: {
        tileView.center = targetView.center
        tileView.transform = CGAffineTransformIdentity
      },
      //5
      completion: {
        (value:Bool) in
        targetView.hidden = true
    })
    //adds explosive view behind tile
    let explode = TileBackgroundExplode(frame:CGRectMake(tileView.center.x, tileView.center.y, 10,10))
    tileView.superview?.addSubview(explode)
    tileView.superview?.sendSubviewToBack(explode)
  }
  //MARK: Check For Success - check if player has completed the word
  
  func checkForSuccess() {
    
    for targetView in targets {
      //no success, bail out
      if !targetView.isMatched {
        return
      }
    }
    self.stopAudioTimer()
    timer.pause()
    audioController.playEffect(soundStarDust)
    
    //Points added to score
    self.data.points += pointsPerQuestion
    totalScore = self.data.points
    self.PlayerScore.text = "Score: \(totalScore)"
    
    // win animation
    let firstTarget = targets[0]
    let startX:CGFloat = 0
    let endX:CGFloat = screenWidth + 300
    let startY = firstTarget.center.y
    let stars = StardustView(frame: CGRectMake(startX, startY, 10, 10))
    self.view.addSubview(stars)
    self.view.sendSubviewToBack(stars)
    
    UIView.animateWithDuration(3.0,
                               delay:0.0,
                               options:UIViewAnimationOptions.CurveEaseOut,
                               animations:{
                                stars.center = CGPointMake(endX, startY)
      }, completion: {(value:Bool) in
        //game finished
        stars.removeFromSuperview()
    })
    delay(2, closure: {
      self.showRightAnswerBanner()
      self.ThumbsUpVaultBoy()
    })
  }
}