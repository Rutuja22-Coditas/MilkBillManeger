//
//  BillCalculatorTableHeaderView.swift
//  MilkBillManeger
//
//  Created by Coditas on 24/03/22.
//

import UIKit

class BillCalculatorTableHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = String(describing: BillCalculatorTableHeaderView.self)
    
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var litreLbl : UILabel!
    @IBOutlet weak var rateLbl : UILabel!
    @IBOutlet weak var totalLbl : UILabel!
    
}
