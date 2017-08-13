//
//  AppDelegate.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import CoreSpotlight
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if !TatoebaUserDefaults.bool(forKey: .defaultsConfigured) {
            TatoebaUserDefaults.setDefaultValues()
        }
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if #available(iOS 9.0, *) {
            guard userActivity.activityType == CSSearchableItemActionType, let activityId = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String, let sentenceIdString = activityId.components(separatedBy: ".").last, let sentenceId = Int(sentenceIdString) else {
                return false
            }
            
            SentenceRequest(id: sentenceId).start { sentence in
                guard let sentence = sentence, let sentenceController = UIStoryboard.main.instantiateViewController(withIdentifier: .sentenceController) as? SentenceViewController else {
                    return
                }
                
                sentenceController.sentence = sentence
                
                guard let topController = (self.window?.rootViewController as? UINavigationController)?.viewControllers.last else {
                    return
                }
                
                topController.present(sentenceController, animated: true, completion: nil)
            }
            
            return true
        } else {
            return false
        }
    }
}

