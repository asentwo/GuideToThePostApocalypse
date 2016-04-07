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
let SoundDing = "ding.mp3"
let SoundWrong = "wrong.m4a"
let SoundWin = "win.mp3"
let SoundTimer = "17sec_time-running-out-buzzer.mp3"
let SoundTimer30 = "30sec_time-running-out-buzzer.mp3"
let SoundPerk = "jingle-win-01.wav"
let SoundTileCorrect = "jingle-win-synth-02.wav"
let SoundStarDust = "synth_win.wav"
let SoundExplosion = "explosion-01.wav"
let SoundButtonPressed = "ding.wav"
let SoundHintButtonPressed = "button-press2.wav"
let SoundButtonPressedCorrect = "ding2.wav"

let AudioEffectFiles = [SoundDing, SoundWrong, SoundWin, SoundTimer, SoundTimer30, SoundPerk, SoundTileCorrect, SoundStarDust, SoundExplosion, SoundButtonPressed, SoundHintButtonPressed, SoundButtonPressedCorrect]


// Font
let font = UIFont(name: "Overseer", size: 30)

let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height

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

var Survival = "Survival"

let userDefaults = NSUserDefaults.standardUserDefaults()
let storyboard : UIStoryboard = UIStoryboard(name: "Survial", bundle: nil)

