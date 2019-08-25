//
//  Category.swift
//  Todoey
//
//  Created by Langxing Daniel Bai [STUDENT] on 2019/8/22.
//  Copyright © 2019 Daniel Bai. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    var items = List<Item>()
}
