//
//  Item.swift
//  Todoey
//
//  Created by Devesan G on 16/09/18.
//  Copyright © 2018 Devesan G. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
