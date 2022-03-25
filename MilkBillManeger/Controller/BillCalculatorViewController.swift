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
    var dataToPrintInTable : DataToPrintInBillCalculator?
    var viewModel = BillManegerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billTableView.register(UINib(nibName: BillTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BillTableViewCell.identifier)
        billTableView.register(UINib(nibName: BillCalculatorTableHeaderView.identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: BillCalculatorTableHeaderView.identifier)
        
      //  DispatchQueue.main.async {
            self.viewModel.fetchResultForBillCalculation { (arrayData, totalValue) in
                self.dataToPrintInTable = arrayData
                //self.totalAmount = totalValue
            //}
                self.totalCalculatedValueLbl.text = "₹\(totalValue)/-"
            print("dataToPrintInTable",self.dataToPrintInTable!)

        }
       
        //filterData()
        
//         DispatchQueue.main.async {
//             self.dataToPrintInTable = DataToPrintInBillCalculator(dataToPrint: [billData(milkType: "Cow", liter: self.cowMilkTotalLiter, rate: self.cowMilkRate!, total: self.cowMilkTotal!),
//                 billData(milkType: "Buffalo", liter: self.buffaloMilkTotalLiter, rate:self.buffaloMilkRate!, total: self.buffaloMilkTotal!)])
//             print(self.dataToPrintInTable!.dataToPrint!)
//             self.totalCalculatedValueLbl.text = "\(self.cowMilkTotal! + self.buffaloMilkTotal!)/-"
//         }
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
       
   
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = billTableView.dequeueReusableHeaderFooterView(withIdentifier: BillCalculatorTableHeaderView.identifier) as? BillCalculatorTableHeaderView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataToPrintInTable?.dataToPrint?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = billTableView.dequeueReusableCell(withIdentifier: BillTableViewCell.identifier, for: indexPath) as? BillTableViewCell
        cell?.setUpCell(oneCell: dataToPrintInTable!.dataToPrint![indexPath.row])
            return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
