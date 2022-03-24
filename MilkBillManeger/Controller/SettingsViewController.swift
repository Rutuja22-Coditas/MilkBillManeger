//
//  SettingsViewController.swift
//  MilkBillManeger
//
//  Created by Coditas on 24/03/22.
//

import UIKit


class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var cowLbl: UILabel!
    @IBOutlet weak var cowMilkRateTxtFld : UITextField!
    @IBOutlet weak var cowMilkRateLbl : UILabel!

    @IBOutlet weak var buffaloLbl : UILabel!
    @IBOutlet weak var buffaloMilkRateTxtFld : UITextField!
    @IBOutlet weak var  buffaloMilkRateLbl : UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    static let identifier = String(describing:SettingsViewController.self)
    var milkRate : Rate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButton.addTarget(self, action: #selector(changeButtonClicked), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(donebuttonClicked), for: .touchUpInside)
        
    }
   
    @objc func changeButtonClicked(sender: UIButton){
        cowMilkRateLbl.isHidden = true
        buffaloMilkRateLbl.isHidden = true
        
        cowMilkRateTxtFld.isHidden = false
        buffaloMilkRateTxtFld.isHidden = false
        
        cowMilkRateTxtFld.text = cowMilkRateLbl.text
        buffaloMilkRateTxtFld.text = buffaloMilkRateLbl.text
    }
    
    @objc func donebuttonClicked(sender: UIButton){
        cowMilkRateTxtFld.isHidden = true
        buffaloMilkRateTxtFld.isHidden = true
        
        cowMilkRateLbl.isHidden = false
        buffaloMilkRateLbl.isHidden = false
        
        cowMilkRateLbl.text = cowMilkRateTxtFld.text
        buffaloMilkRateLbl.text =  buffaloMilkRateTxtFld.text
        
        
        self.dismiss(animated: true, completion: nil)
    }
}
