//
//  Round6_ViewController.swift
//  Wastland_Survival_Guide
//
//  Created by Justin Doo on 1/16/16.
//  Copyright © 2016 Justin Doo. All rights reserved.
//

import UIKit
import Parse

class Round6_ViewController: DragTileVC, CountdownTimerDelegate {
  
  
  //MARK:Constants
  
  var round6_objectIDArray = [String]()
  
  //tiles and targets
  var mainTileTargetView: UIView!
  var tileTargetView1: UIView!
  var tileTargetView2: UIView!
  var tileTargetView3: UIView!
  var tileTargetView4: UIView!
  var tileTargetView5: UIView!
  
  let messages = Messages(next: "Final", restart: "")
  
  
  
  //MARK: IBOutlets
  @IBOutlet var FalloutImage: UIImageView!
  @IBOutlet var QuestionLabel: UILabel!
  @IBOutlet var PlayerScore: UILabel!
  @IBOutlet var CountDownLabel: UILabel!
  @IBOutlet var hintLabel: UIButton!
  
  //VaultBoys
  @IBOutlet weak var vaultBoyWrong: UIImageView!
  @IBOutlet weak var vaultBoyRight: UIImageView!
  @IBOutlet weak var vaultBoyFailed: UIImageView!
  @IBOutlet weak var vaultBoySuccess: UIImageView!
  
  //buttons
  @IBOutlet weak var playAgainButton: UIButton!
  @IBOutlet weak var tryAgainButton: UIButton!
  
  //labels
  @IBOutlet weak var youFailedThisRoundLabel: UILabel!
  @IBOutlet weak var scoreBanner: UIImageView!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var youEarnedACoinLabel: UILabel!
  
  //gif
  @IBOutlet weak var coin: UIImageView!
  
  //constraints
  @IBOutlet weak var vaultBoyWrongYConstraint: NSLayoutConstraint!
  @IBOutlet weak var vaultBoyRightYConstraint: NSLayoutConstraint!
  @IBOutlet weak var vaultBoyFailedYConstraint: NSLayoutConstraint!
  @IBOutlet weak var vaultBoySuccessYConstraint: NSLayoutConstraint!
  @IBOutlet weak var coinYConstraint: NSLayoutConstraint!
  
  //MARK: ViewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    AddAllGraphics()
    ButtonActions()
    StoreParseDataLocally_Round6()
    
    let currentTotalScore = userDefaults.integerForKey(TOTAL_SCORE_SAVED_KEY)
    print(currentTotalScore)
    totalScore = currentTotalScore
    PlayerScore.text = "Score: \(totalScore)"
    
    //add tile view
    let tileView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
    self.view.addSubview(tileView)
    self.tileTargetView1 = tileView
    self.mainTileTargetView = self.tileTargetView1
    self.view.addSubview(buttons.hintBtn)
    timer = CountdownTimer(timerLabel: self.CountDownLabel, startingMin: 0, startingSec: 3)
    timer.delegate = self
    finalAnimation = true
    userDefaults.setObject("Round_6", forKey: CURRENT_ROUND_KEY)
  }
  
  //MARK: Parse
  
  //Random Object
  
  func GetRandomObjectID_Round6 () {
    randomID = Int(arc4random_uniform(UInt32(round6_objectIDArray.count)))
    //creating random 32 bit interger from the objectIDs
  }
  
  
  //Call Parse
  
  func CallData_Round6 () {
    GetRandomObjectID_Round6 ()
    
    if (round6_objectIDArray.count > 0) {
      
      let query: PFQuery = PFQuery(className: "Round_6")
      query.getObjectInBackgroundWithId(round6_objectIDArray[randomID], block:{
        
        (objectHolder : PFObject?, error : NSError?) -> Void in
        //holds all the objects (ie. questions & answers) created in parse.com
        
        if (error == nil) {
          self.image = objectHolder!["Image"] as! String!
          self.question = objectHolder!["Question"] as! String!
          self.letters = objectHolder!["Letters"] as! String!
          self.answer = objectHolder!["Answer"] as! String!
          
          self.lettersLength = self.letters.characters.count
          self.answerLength = self.answer.characters.count
          
          self.FalloutImage.image = UIImage(named: self.image)
          self.QuestionLabel.text = self.question
          
          self.setTiles()
          self.buttons.hintBtn.enabled = true
          
          timer.start()
          self.startAudioTimer()
        } else {
          
          NSLog("There is an error")
        }
      })
    }
  }
  
  
  //Store Parse Data Locally
  
  
  func StoreParseDataLocally_Round6 () {
    
    let objectIDQuery = PFQuery(className: "Round_6")
    
    objectIDQuery.findObjectsInBackgroundWithBlock({
      (objectsArray : [PFObject]?, error : NSError?) -> Void in
      
      if error == nil {
        var objectIDs = objectsArray
        for i in 0..<objectIDs!.count{
          self.round6_objectIDArray.append(objectIDs![i].objectId!)
          //appending objects downloaded from Parse.com to local array (objectIDPublicArray) - .objectId refers to id number given in parse.com (ex."QF0lrQKW8j")
        }
      } else {
        
        print("Error: \(error) \(error!.userInfo)")
      }
      dispatch_async(dispatch_get_main_queue()){
        objectIDQuery.cachePolicy = PFCachePolicy.NetworkElseCache
      }
      self.CallData_Round6()
    })
  }
  
  //MARK: Remove Used Questions
  
  func RemoveAlreadyUsedQuestion() {
    //adds 1 to the score
    if (round6_objectIDArray.count > 0){
      round6_objectIDArray.removeAtIndex(randomID)
      //randomID = currently asked question
      CallData_Round6()
    }
  }
  
  //MARK: Dismiss Q&A
  
  func DismissQandA () {
    UIView.animateWithDuration(0.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [.CurveEaseOut], animations: {
      self.bannersAndVaultBoys.rightAnswerBanner.hidden = true
      self.bannersAndVaultBoys.rightAnswerLabel.hidden = true
      self.buttons.hintButton.hidden = true
      self.FalloutImage.hidden = true
      self.QuestionLabel.hidden = true
      self.PlayerScore.hidden = true
      self.CountDownLabel.hidden = true
      }, completion: nil)
  }
  
  //MARK: Buttons
  
  func ButtonActions () {
    tryAgainButton.addTarget(self, action: "restartViewController", forControlEvents: .TouchUpInside)
//    buttons.btn.addTarget(self, action: "switchToRoundSix:", forControlEvents: .TouchUpInside)
    buttons.restartBtn.addTarget(self, action: "restartGame", forControlEvents: .TouchUpInside)
    buttons.hintBtn.addTarget(self, action: "giveHint:", forControlEvents: .TouchUpInside)
    
  }
  
  //Give Hint
  
  func giveHint (sender: UIButton) {
    
    self.buttons.hintBtn.enabled = false
    self.data.points -= pointsPerTile/2
    self.currentRoundScore = self.data.points
    self.PlayerScore.text = "Score: \(self.currentRoundScore)"
    
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
          self.placeTile(tile, targetView: target)
          self.audioController.playEffect(SoundTileCorrect)
          //8 re-enable the button
          self.buttons.hintButton.enabled = true
          //9 check for finished game
          self.checkForSuccess()
          
      })
    }
  }
  
  //Refresh viewController
  
  func restartViewController () ->() {
    self.dismissViewControllerAnimated(true, completion: nil)
    let storyboard = UIStoryboard(name: "Survial", bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier("Round_6")
    self.presentViewController(vc, animated: true, completion: nil)
    self.bannersAndVaultBoys.zeroScoreVaultBoyImage.center.y -= self.view.bounds.height
  }
  
  //Restart Game
  
  func restartGame () ->() {
    self.dismissViewControllerAnimated(true, completion: nil)
    let storyboard = UIStoryboard(name: "Survial", bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier("Round_1")
    self.presentViewController(vc, animated: true, completion: nil)
    self.bannersAndVaultBoys.zeroScoreVaultBoyImage.center.y -= self.view.bounds.height
  }
  
  
  
  //MARK: VaultBoy Animation
  
  func vaultboyToFront () {
    if madVaultBoyRunning == true {
    //  self.view.bringSubviewToFront(vaultBoyWrong)
    } else {
    //  self.view.bringSubviewToFront(vaultBoyRight)
    }
  }
  
  func MadVaultBoy() {
    madVaultBoyRunning = true
    timer.pause()
    self.vaultboyToFront()
//    self.bannersAndVaultBoys.madVaultBoyImage.hidden = false
//    self.bannersAndVaultBoys.madVaultBoyImage.center.y -= self.view.bounds.height
    self.audioController.playEffect(SoundWrong)
    self.UpdateScoreNegative()
    UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
      self.view.layoutIfNeeded()
      }, completion: {_ in
        UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
        //  self.bannersAndVaultBoys.madVaultBoyImage.center.y += self.view.bounds.height
          self.view.layoutIfNeeded()
          self.RemoveAlreadyUsedQuestion()
          self.newTile()
          self.stopAudioTimer()
          currentScore = totalScore + self.currentRoundScore
          totalScore = currentScore
          userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
          userDefaults.synchronize()
          self.delay(1, closure: {
            
            if self.round6_objectIDArray.count == 0 {
              self.DismissQandA()
              if self.currentRoundScore == 0 {
                self.mainTileTargetView.removeFromSuperview()
                self.stopAudioTimer()
               // self.ZeroScoreVaultBoy()
              }else{
                self.mainTileTargetView.removeFromSuperview()
                self.stopAudioTimer()
               // self.CongratulationsVaultBoy("madMax2Resize")
                self.ShowCongratulationsBanner(self.bannersAndVaultBoys.congratulationsBanner, label: self.bannersAndVaultBoys.congratulationsLabel)              }
            } else{
              self.resetAllTimers()
            }
          })
          }, completion:{_ in
            madVaultBoyRunning = false})
    })
  }

  func ThumbsUpVaultBoy () {
    
    UIView.transitionWithView(self.bannersAndVaultBoys.thumbsUpVaultBoyImage, duration: 0.7, options: [.TransitionFlipFromBottom], animations: {
      self.showThumbsUpVaultBoyTiles()
      }, completion: {_ in
        
        UIView.animateWithDuration(1.0, delay: 1.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: [], animations: {
          self.RemoveAlreadyUsedQuestion()
          self.mainTileTargetView.hidden = true
          self.bannersAndVaultBoys.thumbsUpVaultBoyImage.center.y += self.view.bounds.height
          currentScore = totalScore + self.currentRoundScore
          totalScore = currentScore
          userDefaults.setValue(totalScore, forKey: TOTAL_SCORE_SAVED_KEY)
          userDefaults.synchronize()
          self.delay(1, closure: {
            
            if self.round6_objectIDArray.count == 0 {
              self.stopAudioTimer()
              self.DismissQandA()
            //  self.CongratulationsVaultBoy("madMax2Resize")
              self.ShowCongratulationsBanner(self.bannersAndVaultBoys.congratulationsBanner, label: self.bannersAndVaultBoys.congratulationsLabel)
              self.mainTileTargetView.removeFromSuperview()
            } else {
              
              self.bannersAndVaultBoys.thumbsUpVaultBoyImage.center.y -= self.view.bounds.height
              self.bannersAndVaultBoys.thumbsUpVaultBoyImage.hidden = true
              self.mainTileTargetView.hidden = false
              self.resetAllTimers()
            }
          })
          }, completion:nil)
    })
  }
  
  func showThumbsUpVaultBoyTiles () {
    self.vaultboyToFront()
    self.stopAudioTimer()
    timer.pause()
    self.audioController.playEffect(SoundDing)
    self.bannersAndVaultBoys.thumbsUpVaultBoyImage.hidden = false
    self.UpdateScorePositive()
    self.newTile()
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
  

  
  //MARK: Timer
  
  
  func checkInitialTimer (round:[String]) {
    if round.count == 0 {
    } else {
      self.timerShakeAndReset()
    }
  }
  
  func countdownEnded() -> Void {
    self.checkInitialTimer()
  }
  
  
  func timerShakeAndReset () {
    self.UpdateScoreRunOutOfTime()
    self.TimerShake()
    
    if madVaultBoyRunning == false {
      MadVaultBoy()
    }
  }
  
  func resetAllTimers () {
    
    timer.reset()
    timer.start()
    startAudioTimer()
  }
  
  func checkInitialTimer () {
    if self.round6_objectIDArray.count == 0 {
    } else {
      self.timerShakeAndReset()
    }
    
  }
  
  //MARK: New Tile
  
  func newTile () {
    switch mainTileTargetView {
    case tileTargetView1:
      self.tileTargetView1.removeFromSuperview()
      let tileView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
      self.view.addSubview(tileView)
      self.tileTargetView2 = tileView
      self.view.addSubview(tileTargetView2)
      self.mainTileTargetView = self.tileTargetView2
      self.view.addSubview(buttons.hintBtn)
    case tileTargetView2:
      self.tileTargetView2.removeFromSuperview()
      let tileView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
      self.view.addSubview(tileView)
      self.tileTargetView3 = tileView
      self.view.addSubview(tileTargetView3)
      self.mainTileTargetView = self.tileTargetView3
      self.view.addSubview(buttons.hintBtn)
    case tileTargetView3:
      self.tileTargetView3.removeFromSuperview()
      let tileView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
      self.view.addSubview(tileView)
      self.tileTargetView4 = tileView
      self.view.addSubview(tileTargetView4)
      self.mainTileTargetView = self.tileTargetView4
      self.view.addSubview(buttons.hintBtn)
    case tileTargetView4:
      self.tileTargetView4.removeFromSuperview()
      let tileView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
      self.view.addSubview(tileView)
      self.tileTargetView5 = tileView
      self.view.addSubview(tileTargetView5)
      self.mainTileTargetView = self.tileTargetView5
      self.view.addSubview(buttons.hintBtn)
    default: print("")
    }
    self.vaultboyToFront()
  }
  
  
  //MARK: Add All Graphics
  
  func AddAllGraphics() {
    self.view.addSubview(bannersAndVaultBoys.wrongAnswerBanner)
    bannersAndVaultBoys.wrongAnswerBanner.addSubview(bannersAndVaultBoys.wrongAnswerLabel)
  //  bannersAndVaultBoys.madVaultBoyImage = UIImageView(image: UIImage(named: "vault boy (madmax)_mad"))
  //  bannersAndVaultBoys.madVaultBoyImage.center = CGPoint(x: 180, y: 455)
   // self.view.addSubview(bannersAndVaultBoys.madVaultBoyImage)
    self.view.addSubview(bannersAndVaultBoys.rightAnswerBanner)
    bannersAndVaultBoys.rightAnswerBanner.addSubview(bannersAndVaultBoys.rightAnswerLabel)
    bannersAndVaultBoys.thumbsUpVaultBoyImage = UIImageView(image: UIImage(named: "vault boy (madmax)"))
    bannersAndVaultBoys.thumbsUpVaultBoyImage.hidden = true
    //bannersAndVaultBoys.thumbsUpVaultBoyImage.frame = CGRect(x: 3, y: 300, width: 360, height: 360)
    view.addSubview(bannersAndVaultBoys.thumbsUpVaultBoyImage)
    self.view.addSubview(bannersAndVaultBoys.congratulationsBanner)
    bannersAndVaultBoys.congratulationsBanner.addSubview(bannersAndVaultBoys.congratulationsLabel)
    self.view.addSubview(bannersAndVaultBoys.fireworks_2_gold)
    bannersAndVaultBoys.congratulationsVaultBoyImage = UIImageView(image: UIImage(named: "vault boy (madmax)_success"))
    bannersAndVaultBoys.congratulationsVaultBoyImage.center = CGPoint(x: 190, y: 345)
    bannersAndVaultBoys.congratulationsVaultBoyImage.hidden = true
    self.view.addSubview(bannersAndVaultBoys.congratulationsVaultBoyImage)
   // bannersAndVaultBoys.zeroScoreVaultBoyImage = UIImageView(image: UIImage(named: "vault boy (madmax)_gameover"))
    //self.view.addSubview(bannersAndVaultBoys.zeroScoreVaultBoyImage)
    self.view.addSubview(bannersAndVaultBoys.earnedPerkLabel)
    self.view.addSubview(bannersAndVaultBoys.perkLabel)
    bannersAndVaultBoys.perkLabel.frame = CGRect(x: 110, y: 380, width: 200, height: 200)
    self.view.addSubview(bannersAndVaultBoys.failedLabel)
    self.view.addSubview(buttons.tryBtn)
    self.view.addSubview(buttons.btn)
    buttons.btn.setTitle("\(messages.nextRoundMessage)", forState: UIControlState.Normal)
    self.view.addSubview(bannersAndVaultBoys.yellowBurst)
    self.view.sendSubviewToBack(bannersAndVaultBoys.yellowBurst)
    self.view.addSubview(bannersAndVaultBoys.survivedLabel)
    self.view.addSubview(buttons.restartBtn)
    buttons.restartBtn.setTitle("\(messages.playAgaintMessage)", forState: UIControlState.Normal)
    self.view.addSubview(bannersAndVaultBoys.totalScoreLabel)
    bannersAndVaultBoys.totalScoreLabel.frame = CGRect(x: 100, y: 465, width: 200, height: 50)
  }
  
  //MARK: Update Score
  
  func UpdateScoreNegative () {
    self.data.points -= pointsPerQuestion/2
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
  
}

/*declares that the viewController conforms to TileDragDelegateProtocol, and also defines tileView(tileView:didDragToPoint:) which is the initial implementation of the delegate method.
 This code loops over all objects in the targets array and, for each of the target views, checks whether the given drag point is within the target’s frame. If a tile is found to be within a target, the matching target is saved to targetView.
 */


extension Round6_ViewController:TileDragDelegateProtocol {
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
        audioController.playEffect(SoundTileCorrect)
        //give points
        data.points += pointsPerTile
        //check if word is completed
        self.currentRoundScore = self.data.points
        self.PlayerScore.text = "Score: \(totalScore + self.currentRoundScore)"
        //check if word is completed
        checkForSuccess()
        
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
        audioController.playEffect(SoundWrong)
        //take out points
        data.points -= pointsPerTile/2
        self.currentRoundScore = self.data.points
        self.PlayerScore.text = "Score: \(totalScore + self.currentRoundScore)"
      }
    }
  }
  
  //MARK: Set Tiles
  func setTiles () {
    
    //calculate the tile size
    let tileSide = ceil(ScreenWidth * 0.9 / CGFloat(max(lettersLength, answerLength))) - TileMargin
    //get the left margin for first tile
    var xOffset = (ScreenWidth - CGFloat(max(lettersLength, answerLength)) * (tileSide + TileMargin)) / 2.0
    //adjust for tile center (instead of the tile's origin)
    xOffset += tileSide / 2.0
    //initialize target list
    targets = []
    //create targets
    for (index, letter) in answer.characters.enumerate() {
      if letter != " " {
        let target = TargetView(letter: letter, sideLength: tileSide)
        target.center = CGPointMake(xOffset + CGFloat(index)*(tileSide + TileMargin), ScreenHeight/4*3)
        
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
    for (index, letter) in letters.characters.enumerate() {
      //3
      if letter != " " {
        let tile = TileView(letter: letter, sideLength: tileSide)
        tile.center = CGPointMake(xOffset + CGFloat(index)*(tileSide + TileMargin), ScreenHeight/7*6)
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
    audioController.playEffect(SoundStarDust)
    
    //Points added to score
    self.data.points += pointsPerQuestion
    self.currentRoundScore = self.data.points
    self.PlayerScore.text = "Score: \(totalScore + self.currentRoundScore)"
    
    // win animation
    let firstTarget = targets[0]
    let startX:CGFloat = 0
    let endX:CGFloat = ScreenWidth + 300
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
      self.ShowRightAnswerBanner(self.bannersAndVaultBoys.rightAnswerBanner, label: self.bannersAndVaultBoys.rightAnswerLabel, message: self.messages.rightAnswerMessage)
      self.ThumbsUpVaultBoy()
    })
    
  }
  
}