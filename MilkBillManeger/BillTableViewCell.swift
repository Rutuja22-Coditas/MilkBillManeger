//
//  HeaderTableViewCell.swift
//  MilkBillManeger
//
//  Created by Coditas on 24/03/22.
//

import UIKit

class BillTableViewCell: UITableViewCell {

    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var literLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    static let identifier = String(describing: BillTableViewCell.self)
    var arrayOfLbls = [UILabel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setUpCell(oneCell: billData){
        typeLbl.text = oneCell.milkType
        literLbl.text = "\(oneCell.liter)"
        rateLbl.text = "\(oneCell.rate)"
        totalLbl.text = "\(oneCell.total)"
    }
    
}
