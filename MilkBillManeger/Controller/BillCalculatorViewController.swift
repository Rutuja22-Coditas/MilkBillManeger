//
//  BillCalculatorViewController.swift
//  MilkBillManeger
//
//  Created by Coditas on 24/03/22.
//

import UIKit
import RealmSwift

class BillCalculatorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var billTableView: UITableView!
    @IBOutlet weak var totalCalculatedValueLbl: UILabel!
    
    static let identifier = String(describing: BillCalculatorViewController.self)
    let realm = try! Realm()
    var cowMilkRate : Int?
    var cowMilkTotal : Float?
    var cowMilkTotalLiter : Float = 0.0
    
    var buffaloMilkRate : Int?
    var buffaloMilkTotal : Float?
    var buffaloMilkTotalLiter : Float = 0.0
    var totalAmount : Float = 0.0
    var dataToPrintInTable : dataToPrintInBillCalculator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        billTableView.register(UINib(nibName: HeaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HeaderTableViewCell.identifier)
        
        filterData()
        
        
    }
    func filterData(){
        let results = realm.objects(BillManeger.self)
        
        for i in results{
            if i.typeOfMilk == MilkType.cow.rawValue{
                cowMilkTotalLiter += i.liter
                cowMilkRate = i.rate
            }
            else if i.typeOfMilk == MilkType.buffalo.rawValue {
                buffaloMilkTotalLiter += i.liter
                buffaloMilkRate = i.rate
            }
            
        }
        cowMilkTotal = cowMilkTotalLiter * Float(cowMilkRate!)
        buffaloMilkTotal = buffaloMilkTotalLiter * Float(buffaloMilkRate!)
        //totalAmount =
       
       
        DispatchQueue.main.async {
            self.dataToPrintInTable = dataToPrintInBillCalculator(dataToPrint: [billData(milkType: "Cow", liter: self.cowMilkTotalLiter, rate: self.cowMilkRate!, total: self.cowMilkTotal!),
                billData(milkType: "Buffalo", liter: self.buffaloMilkTotalLiter, rate:self.buffaloMilkRate!, total: self.buffaloMilkTotal!)])
            print(self.dataToPrintInTable!.dataToPrint!)
            self.totalCalculatedValueLbl.text = "\(self.cowMilkTotal! + self.buffaloMilkTotal!)/-"
        }
        

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataToPrintInTable?.dataToPrint!.count)! + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = billTableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier, for: indexPath) as? HeaderTableViewCell
        if indexPath.row == 0 {
            cell?.rateLbl.text = "Rate"
            cell?.literLbl.text = "Liter"
            cell?.totalLbl.text = "Total"
            cell?.typeLbl.text = "Type"
        }
        else{
            cell?.setUpCell(oneCell: (dataToPrintInTable?.dataToPrint![indexPath.row - 1])!)
//            let common = dataToPrintInTable?.dataToPrint![indexPath.row]
//            cell?.rateLbl.text = String(describing: common!.rate)
//            cell?.literLbl.text = String(describing: common!.liter)
//            cell?.totalLbl.text = String(describing: common!.total)
//            cell?.typeLbl.text = common?.milkType
        }
            return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
   
    
}
