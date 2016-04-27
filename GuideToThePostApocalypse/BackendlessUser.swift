//
//  BackendlessUser.swift
//  Test
//
//  Created by Justin Doo on 4/21/16.
//  Copyright © 2016 Justin Doo. All rights reserved.
//

import Foundation

class BackendlessUserFunctions {
  
  static let sharedInstance = BackendlessUserFunctions()
  
  var randomID = 0//Used to represent question being displayed
  var randomQuestion = 0
  
  var questions:[BackendlessUserFunctions.Questions]!
  
  var question: String!
  var answers: [String]!
  var answer: String!
  
  
  private init() {
  
    let backendless = Backendless.sharedInstance()
    backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
    // This asks that the user should stay logged in by storing or caching the user's login
    // information so future logins can be skipped next time the user launches the app.
    backendless.userService.setStayLoggedIn(true)
  
  } //This prevents others from using the default '()' initializer for this class.
  
  let VERSION_NUM = "v1"
  let APP_ID = "8D2FD354-3D1D-CE63-FF2C-2188F2712800"
  let SECRET_KEY = "FECE275E-BC7E-9618-FFC0-21A4EDC16F00"
  var USER_NAME: String?
  var PASSWORD: String?
  let backendless = Backendless.sharedInstance()


//example custom class
class  Questions: NSObject {
  
  var round: String?
  var question: String?
  var answer: String?
  var answers: String?
  var letters: String?
  var image: String?
}
  
  func getDataFromBackendless (roundNumber: Int, rep: ((BackendlessCollection!) -> Void), err: ((Fault!) -> Void) ) {
    
    let backendless = Backendless.sharedInstance()
    let dataStore = backendless.data.of(Questions.ofClass())
    
    let dataQuery = BackendlessDataQuery()
    dataQuery.whereClause = "round = \(roundNumber)"
    
    dataStore.find( dataQuery, response: rep,  error: err)
    
  }
}

      
//      response: { ( questions : BackendlessCollection!) -> () in
//      print("Comments have been fetched:")
//      
//     self.questions = []
//      
//      for question in questions.data {
//        
//        let currentQuestion = question as! Questions
//        
//        self.questions.append(currentQuestion)
//      }
//      
//      dispatch_async(dispatch_get_main_queue()) {
//        
//      //self.populateViewWithData()
//      }
//      }

      
                    
      
//      error: { ( fault : Fault!) -> () in
//        print("Questions were not fetched: \(fault)")
//      }


