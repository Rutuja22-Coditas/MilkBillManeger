//
//  BillManegerRealm.swift
//  MilkBillManeger
//
//  Created by Coditas on 17/03/22.
//

import Foundation
import RealmSwift

class BillManeger : Object{
    @objc dynamic var taskId : String?
    @objc dynamic var liter : Float = 0.0
    @objc dynamic var date : Date?
    @objc dynamic var rate : Int = 60
    @objc dynamic var typeOfMilk : String?
    @objc dynamic var comment : String?
 
    override class func primaryKey() -> String? {
        return "taskId"
    }
}

