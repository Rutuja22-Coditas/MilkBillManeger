//
//  ShowDataTableViewCell.swift
//  MilkBillManeger
//
//  Created by Coditas on 21/03/22.
//

import UIKit

class ShowDataTableViewCell: UITableViewCell {

    @IBOutlet weak var cellDesignView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var literLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    static let identifier = String(describing: ShowDataTableViewCell.self)
    let date = Date()
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellDesignView.layer.cornerRadius = 10.0
        //cellDesignView.layer.borderColor = UIColor.black.cgColor
        //cellDesignView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setValues(oneDayData: BillManeger){
        dateFormatter.dateFormat = "EEEE"
        let stringDay = dateFormatter.string(from: oneDayData.date!)
        dateFormatter.dateFormat = "dd"
        let stringDate = dateFormatter.string(from: oneDayData.date!)
        dateFormatter.dateFormat = "MMM"
        let stringMonth = dateFormatter.string(from: oneDayData.date!)
        dayLbl.text = "\(stringDay)"
        dateLbl.text = "\(stringDate)\n\(stringMonth)"
        if oneDayData.typeOfMilk == "cow"{
            literLbl.text = "Liter: \(oneDayData.liter) - 🐄"
        }
        else if oneDayData.typeOfMilk == "buffalo"{
            literLbl.text = "Liter: \(oneDayData.liter) - 🐃"

        }
        
        amountLbl.text = "₹\(oneDayData.rate)"
    }
    
    
}
