//
//  ViewController.swift
//  MilkBillManeger
//
//  Created by Coditas on 17/03/22.
//

import UIKit
import Floaty
import RealmSwift

class ViewController: UIViewController{
    
    @IBOutlet weak var filterButtonView: FilterView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var floatingButton: Floaty!
    @IBOutlet weak var noResultsFoundLbl: UILabel!
    var billViewModel = BillManegerViewModel()
    var allDataInResult = [BillManeger]()
    var filterDataCase : FilterData?
    var addDataViewController = AddDataViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterButtonView.isHidden = true
        floatingButton.isHidden = false
        addItemToFloatingButton()
        tableView.register(UINib(nibName: ShowDataTableViewCell.identifier , bundle: nil), forCellReuseIdentifier: ShowDataTableViewCell.identifier)
            self.loadAllData()
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("NotificationIdentifier"), object: nil)
        print("realm", Realm.Configuration.defaultConfiguration.fileURL!)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), style: .plain, target: self, action: #selector(filterButtonClicked))
        filterButtonView.isOpaque = false
        filterButtonView.backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(findTheCondition), name:Notification.Name("NotificationCenter"), object: nil)

    }
    
    func filterData(){
        switch filterDataCase{
        case .all:
            loadAllData()
        case .byDate:
            loadByDateFilteredData()
        case .byMilkType:
            loadByMilkTypeFilteredData()
        case .byDateAndMilkType:
            print("ok")
            loadByDateAndMilkTypeFilteredData()
        case .none:
            loadAllData()
        }
    }
    
    func loadAllData(){
        billViewModel.fetchAllResult { (data) in
            self.allDataInResult.removeAll()
            self.allDataInResult = data
            print("ALL DATAA",self.allDataInResult)
            self.tableView.reloadData()
        }
    }
    func loadByDateFilteredData(){
        billViewModel.fetchResultSortedByDate(startDate: filterButtonView.startDate!, endDate: filterButtonView.endDate!) { (data) in
            self.allDataInResult.removeAll()
            self.allDataInResult = data
            print("fetchResultSortedByDate",self.allDataInResult)

            self.tableView.reloadData()
        }
    }
    func loadByMilkTypeFilteredData(){
        billViewModel.fetchResultSortedByTypeOfMilk(milkType: filterButtonView.milkTypeSelected) { (data) in
            self.allDataInResult.removeAll()
            self.allDataInResult = data
            print("fetchResultSortedByTypeOfMilk",self.allDataInResult)

            self.tableView.reloadData()
        }
    }
    func loadByDateAndMilkTypeFilteredData(){
        billViewModel.fetchResultSortedByDateAndMilkType(startDate: filterButtonView.startDate!, endDate: filterButtonView.endDate!, milkType: filterButtonView.milkTypeSelected) { (data) in
            self.allDataInResult.removeAll()
            self.allDataInResult = data
            print("fetchResultSortedByDateAndMilkType",self.allDataInResult)

            self.tableView.reloadData()
        }
    }
    
    @objc func findTheCondition(){
        filterButtonView.isHidden = true
        floatingButton.isHidden = false
        if filterButtonView.allButton.isSelected{
            print("all Data")
            filterDataCase = .all
            filterData()
            floatingButton.isHidden = false

        }
        else if filterButtonView.sortByDateButton.isSelected && !filterButtonView.sortByMilkTypeButtn.isSelected{
            filterDataCase = .byDate
            filterData()
            floatingButton.isHidden = false

        }
        else if filterButtonView.sortByMilkTypeButtn.isSelected && !filterButtonView.sortByDateButton.isSelected{
            filterDataCase = .byMilkType
            filterData()
            floatingButton.isHidden = false

        }
        else if filterButtonView.sortByMilkTypeButtn.isSelected && filterButtonView.sortByDateButton.isSelected{
            filterDataCase = .byDateAndMilkType
            filterData()
            floatingButton.isHidden = false

        }
        resetAllData()

    }
    func resetAllData(){
        filterButtonView.segmentControlForMilkType.selectedSegmentIndex = 0
        filterButtonView.allButton.isSelected = true
        filterButtonView.sortByDateButton.isSelected = false
        filterButtonView.sortByMilkTypeButtn.isSelected = false
        
        filterButtonView.viewForDateSorting.isHidden = true
        filterButtonView.sortByMilkTypeView.isHidden = true
        filterButtonView.datePicker.isHidden = true
        filterButtonView.datePickerButtnsView.isHidden = true
        
        filterButtonView.heightOfDateSortingView.constant = 0
        filterButtonView.htOfSortByMilkType.constant = 0
    }
    @objc func filterButtonClicked(){
        if filterButtonView.isHidden {
            floatingButton.isHidden = true
            filterButtonView.isHidden = false
        }
        else{
            filterButtonView.isHidden = true
            floatingButton.isHidden = false
        }
        //filterButtonView.isHidden = false
    }
    @objc func reloadTableView(notification: NSNotification){
        print(allDataInResult)
//        if let caseToWorkOn =  notification.userInfo?["caseToWorkOn"]{
//            print(caseToWorkOn)
//
//            if caseToWorkOn as! String == "save"{
//
//            }
//        }
        loadAllData()
        self.tableView.reloadData()
    }
  
    func addItemToFloatingButton(){
        
        floatingButton.addItem("Add data", icon: UIImage(systemName: "plus")) { (addButton) in
            let vc = self.storyboard?.instantiateViewController(identifier: AddDataViewController.identifier) as? AddDataViewController
            
            vc?.modalPresentationStyle = .overCurrentContext
            vc?.caseToWorkOn = .add
            self.present(vc!, animated: true, completion: nil)
        }
        
        floatingButton.addItem("Settings", icon: UIImage(systemName: "gearshape")) { (settingButton) in
            let settingsVc = self.storyboard?.instantiateViewController(identifier:SettingsViewController.identifier)as? SettingsViewController
            settingsVc?.modalPresentationStyle = .overCurrentContext
            self.navigationController?.pushViewController(settingsVc!, animated: true)
            //self.present(settingsVc!, animated: true, completion: nil)
        }
        floatingButton.addItem("Bill", icon: UIImage(systemName: "dollarsign.circle")) { (billButton) in
            let billCalculatorVc = self.storyboard?.instantiateViewController(identifier: BillCalculatorViewController.identifier) as? BillCalculatorViewController
            billCalculatorVc?.modalPresentationStyle = .overCurrentContext
           // self.present(billCalculatorVc!, animated: true, completion: nil)
            self.navigationController?.pushViewController(billCalculatorVc!, animated: true)
        }
        
        self.view.addSubview(floatingButton)
}

}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allDataInResult.count == 0{
            addDataViewController.showAlert(message: "Please Apply valid filter options", titleForAlert: "Invalid Selection")
            let label = UILabel()
            //let x = label.center.x

            label.frame = CGRect(x: 50, y: view.center.y, width: 300, height: 100)
            label.textAlignment = .center
            label.text = "No Result Found!"
            label.font = UIFont(name: "Halvetica", size: 90)
            label.textColor = .black
            view.addSubview(label)
            tableView.backgroundView = label

           // noResultsFoundLbl.isHidden = false
           // tableView.isHidden = true
        }
        noResultsFoundLbl.isHidden = true
        return allDataInResult.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShowDataTableViewCell.identifier, for: indexPath)as? ShowDataTableViewCell
        cell?.backgroundColor = tableView.backgroundColor
        cell?.setValues(oneDayData: allDataInResult[indexPath.row])
        //cell?.literLbl.text = "\(allDataInResult[indexPath.row].liter)"
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            print("edit")
            let editVc  = self.storyboard?.instantiateViewController(withIdentifier: AddDataViewController.identifier) as? AddDataViewController
            editVc?.caseToWorkOn = .edit
            editVc?.milkDataToEdit = self.allDataInResult[indexPath.row]
            editVc?.modalPresentationStyle = .overCurrentContext
            self.present(editVc!, animated: true, completion: nil)
            
        }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            print("delete")
            let deleteFromRealm = self.billViewModel.objectOfResult[indexPath.row]
            self.billViewModel.deleteData(object: deleteFromRealm)
            self.allDataInResult.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete,edit])
        return swipeConfiguration
    }
}
