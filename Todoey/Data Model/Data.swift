//
//  Data.swift
//  Todoey
//
//  Created by Devesan G on 16/09/18.
//  Copyright © 2018 Devesan G. All rights reserved.
//

import Foundation
import RealmSwift

class Data : Object{
    
    @objc dynamic  var name : String = ""
    @objc dynamic  var age : Int = 0
}
