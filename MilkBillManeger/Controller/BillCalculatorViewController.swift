//
//  BillCalculatorViewController.swift
//  MilkBillManeger
//
//  Created by Coditas on 24/03/22.
//

import UIKit
import RealmSwift

//protocol ValuePass {
//    func billValue(cowMilkTotal,cowMilkLtr,buffaloMilkTotal,buffaloMilkLtr,)
//}
class BillCalculatorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var billTableView: UITableView!
    @IBOutlet weak var totalCalculatedValueLbl: UILabel!
    
    static let identifier = String(describing: BillCalculatorViewController.self)
    
    var dataToPrintInTable : DataToPrintInBillCalculator?
    //var dataToPrintInTable : [BillManeger]?
    var viewModel = BillManegerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pdf", style: .plain, target: self, action: #selector(pdfButtonClicked))
        billTableView.register(UINib(nibName: BillTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BillTableViewCell.identifier)
        billTableView.register(UINib(nibName: BillCalculatorTableHeaderView.identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: BillCalculatorTableHeaderView.identifier)
        
        self.viewModel.fetchResultForBillCalculation { (arrayData, totalValue) in
                self.dataToPrintInTable = arrayData
                self.totalCalculatedValueLbl.text = "₹\(totalValue)/-"
            print("dataToPrintInTable",self.dataToPrintInTable!)

        }
    }
        
    @objc func pdfButtonClicked(){
        let newVC = storyboard?.instantiateViewController(identifier: PDFViewController.identifier) as? PDFViewController
        let pdfCreator = PDFCreator()
        newVC?.documentData = pdfCreator.createFlyer()
        self.navigationController?.pushViewController(newVC!, animated: true)
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
