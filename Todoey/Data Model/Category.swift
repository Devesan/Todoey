//
//  Category.swift
//  Todoey
//
//  Created by Devesan G on 16/09/18.
//  Copyright © 2018 Devesan G. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
