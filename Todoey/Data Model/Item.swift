//
//  Item.swift
//  Todoey
//
//  Created by Langxing Daniel Bai [STUDENT] on 2019/8/22.
//  Copyright © 2019 Daniel Bai. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
