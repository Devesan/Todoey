//
//  AppDelegate.swift
//  Todoey
//
//  Created by Devesan G on 30/08/18.
//  Copyright © 2018 Devesan G. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    
        do{
            _ = try Realm()
            
            }
        catch{
            print("Error initialising new realm \(error)")
        }
        
        return true
    }


}

