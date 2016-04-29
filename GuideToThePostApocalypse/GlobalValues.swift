//
//  Round3_Config.swift
//  Wastland_Survival_Guide
//
//  Created by Justin Doo on 1/11/16.
//  Copyright © 2016 Justin Doo. All rights reserved.
//

import Foundation
import UIKit


// Sound effects
let soundDing = "ding.mp3"
let soundWrong = "wrong.m4a"
let soundWin = "win.mp3"
let soundTimer = "17sec_time-running-out-buzzer.mp3"
let soundTimer30 = "30sec_time-running-out-buzzer.mp3"
let soundPerk = "jingle-win-01.wav"
let soundTileCorrect = "jingle-win-synth-02.wav"
let soundStarDust = "synth_win.wav"
let soundExplosion = "explosion-01.wav"
let soundButtonPressed = "ding.wav"
let soundHintButtonPressed = "button-press2.wav"
let soundButtonPressedCorrect = "ding2.wav"

let audioEffectFiles = [soundDing, soundWrong, soundWin, soundTimer, soundTimer30, soundPerk, soundTileCorrect, soundStarDust, soundExplosion, soundButtonPressed, soundHintButtonPressed, soundButtonPressedCorrect]


// Font
let font = UIFont(name: "Overseer", size: 30)

let screenWidth = UIScreen.mainScreen().bounds.size.width
let screenHeight = UIScreen.mainScreen().bounds.size.height

var currentScore = 0
var totalScore = 0
let TOTAL_SCORE_SAVED_KEY = "TOTAL_SCORE_SAVED_KEY"
let CURRENT_ROUND_KEY = "CURRENT_ROUND_KEY"

let pointsPerTile = 10
let pointsPerQuestion = 100
let pointsPerCompletedTile = 100
let pointsPerMultiHint = 20
let pointsPerWrongAnswer = 50
let pointsTimeRunsOut = 50

var timer: CountdownTimer!

var madVaultBoyRunning = false
var thumbsUpBoyRunning = false

var SURVIVAL_KEY = "Survival"

let userDefaults = NSUserDefaults.standardUserDefaults()
let storyboard : UIStoryboard = UIStoryboard(name: "Survial", bundle: nil)

//////////Backendless///////////////

//var randomID: Int?
////var objectIDArray: [Questions]?
//
//func GetRandomObjectID () {
//  randomID = Int(arc4random_uniform(UInt32(objectIDArray!.count)))
//  //creating random 32 bit interger from the objectIDs
//}
