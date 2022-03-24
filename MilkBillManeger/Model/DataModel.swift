//
//  DataModel.swift
//  MilkBillManeger
//
//  Created by Coditas on 21/03/22.
//

import Foundation

enum Conditions{
    case edit, add
}

enum MilkType: String{
    case cow, buffalo
}

enum FilterData{
    case all
    case byDate
    case byMilkType
    case byDateAndMilkType
}

enum Rate : Int{
    case cowMilkRate
    case buffaloMilkRate
}

class dataToPrintInBillCalculator{
    var dataToPrint : [billData]?
    
    init(dataToPrint : [billData]) {
        self.dataToPrint = dataToPrint
    }
}
struct billData{
    var milkType : String
    var liter : Float
    var rate : Int
    var total : Float
}
