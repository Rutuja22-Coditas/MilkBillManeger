//
//  FilterView.swift
//  MilkBillManeger
//
//  Created by Coditas on 22/03/22.
//

import UIKit



class FilterView: UIView {
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var sideFilterView: UIView!
    @IBOutlet weak var filtersLbl: UILabel!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var sortByDateButton: UIButton!
    
    @IBOutlet weak var viewForDateSorting: UIView!
    @IBOutlet weak var heightOfDateSortingView: NSLayoutConstraint!
    @IBOutlet weak var startDateTxtFld: UITextField!
    @IBOutlet weak var lastDateTxtFld: UITextField!
    
    @IBOutlet weak var sortByMilkTypeButtn: UIButton!
    @IBOutlet weak var sortByMilkTypeView: UIView!
    @IBOutlet weak var htOfSortByMilkType: NSLayoutConstraint!
    
    @IBOutlet weak var segmentControlForMilkType: UISegmentedControl!
    @IBAction func milkTypeSelected(_ sender: UISegmentedControl) {
        //segmentControlForMilkType.isSelected = true
        //milkTypeSelected = "cow"
        if segmentControlForMilkType.selectedSegmentIndex == 0 {
            milkTypeSelected = .cow
        }
        else if segmentControlForMilkType.selectedSegmentIndex == 1{
            milkTypeSelected = .buffalo
        }
        print(milkTypeSelected)
    }
    
    @IBAction func applyButtonClicked(_ sender: UIButton) {
//        if allButton.isSelected{
//            print("allButtonSelected")
//        }
//        if sortByDateButton.isSelected || sortByMilkTypeButtn.isSelected{
//            print("sort by date selected")
//            print("startDate",startDate!)
//            print("endDate",endDate!)
//            print("milkType", milkTypeSelected)
//        }
        
        NotificationCenter.default.post(name: Notification.Name("NotificationCenter"), object: nil, userInfo: nil)
        
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerButtnsView: UIView!
    @IBAction func datePickerDoneButtn(_ sender: UIButton) {
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        selectedTextField!.text = date
        //alertLblOfDateTxtFld.isHidden = true
        datePicker.isHidden = true
        datePickerButtnsView.isHidden = true
        
//        if selectedTextField == startDateTxtFld{
//            startDate = datePicker.date
//        }
//        else if selectedTextField == lastDateTxtFld{
//            endDate = datePicker.date
//        }
        if selectedTextField == startDateTxtFld{
            startDate = date
        }
        else if selectedTextField == lastDateTxtFld{
            endDate = date
        }
    }
    
    @IBAction func datePickerCancelButtn(_ sender: UIButton) {
        containerView.endEditing(true)
        datePicker.isHidden = true
        datePickerButtnsView.isHidden = true
    }
    @IBAction func buttonAction(_ sender: UIButton) {
        if sender.tag == 1{
            allButton.isSelected = true
            sortByDateButton.isSelected = false
            sortByMilkTypeButtn.isSelected = false
            
            datePicker.isHidden = true
            heightOfDateSortingView.constant = 0
            datePickerButtnsView.isHidden = true
            viewForDateSorting.isHidden = true
            
            sortByMilkTypeView.isHidden = true
            htOfSortByMilkType.constant = 0
            containerView.endEditing(true)
        }
        else if sender.tag == 2{
            startDateTxtFld.text = nil
            lastDateTxtFld.text = nil
            allButton.isSelected = false
            sortByDateButton.isSelected = !sortByDateButton.isSelected
            if sortByDateButton.isSelected{
                viewForDateSorting.isHidden = false
                heightOfDateSortingView.constant = 153
            }
            else{
                containerView.endEditing(true)
                viewForDateSorting.isHidden = true
                datePicker.isHidden = true
                datePickerButtnsView.isHidden = true
                heightOfDateSortingView.constant = 0
            }
          
        }
        else if sender.tag == 3{
            containerView.endEditing(true)
            datePicker.isHidden = true
            datePickerButtnsView.isHidden = true
            milkTypeSelected = .cow
            allButton.isSelected = false
            sortByMilkTypeButtn.isSelected = !sortByMilkTypeButtn.isSelected
            if sortByMilkTypeButtn.isSelected{
                sortByMilkTypeView.isHidden = false
                htOfSortByMilkType.constant = 41
            }
            else{
                sortByMilkTypeView.isHidden = true
                htOfSortByMilkType.constant = 0
            }
        }
    }
    
    var nibName = String(describing: FilterView.self)
    var selectedTextField : UITextField?
    let dateFormatter = DateFormatter()
    var milkTypeSelected : MilkType = .cow
    var startDate : String?
    var endDate : String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        sideFilterView.backgroundColor =  UIColor(red: 244/255.0, green: 240/255.0, blue: 237/255.0, alpha: 2.5)
        
        //containerView.isOpaque = false
        //containerView.backgroundColor = .clear
        addSubview(containerView)
        startDateTxtFld.delegate = self
        lastDateTxtFld.delegate = self
        sideFilterView.layer.cornerRadius = 10.0
        setUpInitialView()
        setDatePicker()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
            containerView.addGestureRecognizer(tapGesture)
        allButton.isSelected = true
        sortByDateButton.isSelected = false
        sortByMilkTypeButtn.isSelected = false
        containerView.backgroundColor = UIColor(white: 40/255.0, alpha: 0.5)
        //sideFilterView.setViewLayout(self)
    }
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        containerView.endEditing(true)
        //priorityTxtFld.resignFirstResponder()
    }
    func setUpInitialView(){
        heightOfDateSortingView.constant = 0
        viewForDateSorting.isHidden = true
        
        htOfSortByMilkType.constant = 0
        sortByMilkTypeView.isHidden = true
        
    }
    
    func setDatePicker(){
        //startDateTxtFld.inputView = datePicker
        //lastDateTxtFld.inputView = datePicker
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = Date()
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 10
        datePickerButtnsView.backgroundColor = UIColor.lightGray
        datePickerButtnsView.layer.cornerRadius = 5.0
    }
  
}

extension FilterView : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == startDateTxtFld{
            selectedTextField = startDateTxtFld
        }
        else if textField == lastDateTxtFld{
            selectedTextField = lastDateTxtFld
        }
        if textField == startDateTxtFld || textField == lastDateTxtFld{
            containerView.endEditing(true)
            datePicker.isHidden = false
            datePickerButtnsView.isHidden = false
        }
        else{
            //textField.resignFirstResponder()
            //textField.endEditing(true)
            datePicker.isHidden = true
            datePickerButtnsView.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == startDateTxtFld || textField == lastDateTxtFld{
            datePicker.isHidden = true
            datePickerButtnsView.isHidden = true
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
      }
}

