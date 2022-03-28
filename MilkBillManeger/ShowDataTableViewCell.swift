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
        self.contentView.layer.shadowColor = UIColor.gray.cgColor
        self.contentView.layer.shadowOpacity = 0.6
        self.contentView.layer.timeOffset = 0.0
        self.contentView.layer.shadowRadius = 4

        
       // randomColourChange()
        //cellDesignView.layer.borderColor = UIColor.black.cgColor
        //cellDesignView.layer.borderWidth = 1.0
       // self.dayLbl.tintColor = randomColourChange()
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
    
    
    func randomColourChange()-> UIColor{
//        let colors = [
//                    UIColor(red: 233/255, green: 203/255, blue: 198/255, alpha: 1),
//                    UIColor(red: 38/255, green: 188/255, blue: 192/255, alpha: 1),
//                    UIColor(red: 253/255, green: 221/255, blue: 164/255, alpha: 1),
//                    UIColor(red: 235/255, green: 154/255, blue: 171/255, alpha: 1),
//                    UIColor(red: 87/255, green: 141/255, blue: 155/255, alpha: 1)
//                ]
//                let randomColor = Int(arc4random_uniform(UInt32 (colors.count)))
//        dateLbl.tintColor = colors[randomColor]
        
        let a = CGFloat(arc4random_uniform(256))/255.0
        let b = CGFloat(arc4random_uniform(256))/255.0
        let c = CGFloat(arc4random_uniform(256))/255.0
        
        return UIColor(red: a, green: b, blue: c, alpha: 1.0)
    }
}
