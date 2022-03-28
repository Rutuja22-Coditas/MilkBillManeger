//
//  AddDataViewController.swift
//  MilkBillManeger
//
//  Created by Coditas on 17/03/22.
//

import UIKit
import SwiftMessages
import RealmSwift

class AddDataViewController: UIViewController {

    @IBOutlet weak var addDataView: UIView!
    @IBOutlet weak var litreTxtFld: UITextField!
    @IBOutlet weak var litreStepper: UIStepper!
    @IBOutlet weak var dateTxtFld: UITextField!
    @IBOutlet weak var commentTxtFld: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var milkTypeSegmentControl: UISegmentedControl!
    //@IBOutlet weak var milkTypeCowRadioButtn: UIButton!
    //@IBOutlet weak var milkTypeBuffeloRadioButtn: UIButton!
    
    @IBOutlet weak var addDataViewTopConstraint: NSLayoutConstraint! //204
    @IBOutlet weak var constraintBetweenViewAndDatePicker: NSLayoutConstraint! //15
    @IBOutlet weak var addDataViewBottomConstraint: NSLayoutConstraint!//244
    
    @IBOutlet weak var datePickerDoneButtn: UIButton!
    @IBOutlet weak var datePickerCancelButton: UIButton!
    @IBOutlet weak var datePickerButtonsView: UIView!

    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ltrStepperClicked(_ sender: UIStepper) {
        litreTxtFld.text = Float(sender.value).description
    }
    
    @IBAction func milkTypeValueChanged(_ sender: UISegmentedControl) {
        if milkTypeSegmentControl.selectedSegmentIndex == 0{
            milkTypeSelected = .cow
        }
        else if milkTypeSegmentControl.selectedSegmentIndex == 1{
            milkTypeSelected = .buffalo
        }
    }
    
    static let identifier = String(describing: AddDataViewController.self)
    let realm = try! Realm()

    let dateFormatter = DateFormatter()
    let milkDataObject = BillManeger()
    let viewModel = BillManegerViewModel()
    var caseToWorkOn : Conditions?
    var milkDataToEdit : BillManeger?
    var liter1 = ""
    var milkType1 = ""
    var date1 = ""
    var comment1 = ""
    var milkTypeSelected : MilkType = .cow
    var dictToPassData:[String:String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        //blurEffect()
        datePickerDoneButtn.addTarget(self, action: #selector(DateSelected), for: .touchUpInside)
        datePickerCancelButton.addTarget(self, action: #selector(cancelButtnClikedOnDatePicker), for: .touchUpInside)
        
        doneButton.addTarget(self, action: #selector(DoneButtonToSaveData), for: .touchUpInside)
        litreTxtFld.delegate = self
        dateTxtFld.delegate = self
        commentTxtFld.delegate = self
        
       // view.isOpaque = false
       // view.backgroundColor = UIColor.clear
        setUpUI()
        setDatePicker()
        view.backgroundColor = UIColor(white: 30/255.0, alpha: 0.6)
        //addDataView.backgroundColor = UIColor(white: 20/255.0, alpha: 0.9)
        //view.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 150/255.0, alpha: 1)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
            view.addGestureRecognizer(tapGesture)
        
        switch caseToWorkOn {
        case .edit:
            print("edit data")
            editData(data: milkDataToEdit!)
        case .add:
            print("add data")

        case .none:
            print("No changes")
        }

    }
    
    func blurEffect(){
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func editData(data: BillManeger){
        litreStepper.minimumValue = Double(data.liter)
        litreTxtFld.text = "\(data.liter)"
        liter1 = litreTxtFld.text!
        if data.typeOfMilk == "cow"{
            milkType1 = "cow"
            milkTypeSegmentControl.selectedSegmentIndex = 0
        }
        else if data.typeOfMilk == "buffalo"{
            milkType1 = "buffalo"
            milkTypeSegmentControl.selectedSegmentIndex = 1

        }
//        if data.typeOfMilk == "cow"{
//            milkTypeCowRadioButtn.isSelected = true
//            milkTypeBuffeloRadioButtn.isSelected = false
//            milkType1 = "cow"
//        }
//        else if data.typeOfMilk == "buffalo"{
//            milkTypeBuffeloRadioButtn.isSelected = true
//            milkTypeBuffeloRadioButtn.isSelected = false
//            milkType1 = "buffalo"
//        }
        dateTxtFld.text = dateFormatter.string(from: data.date!)
        date1 = dateTxtFld.text!
        if commentTxtFld.text != nil{
            commentTxtFld.text = data.comment
            comment1 = commentTxtFld.text!
        }
    }
    
    @objc func DoneButtonToSaveData(){

//        if let convertedValue = Float(litreTxtFld.text!){
//            milkDataObject.liter = convertedValue
//        }
//        dateFormatter.dateStyle = .medium
//        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
//        let dateInString = dateFormatter.date(from: dateTxtFld.text!)!
//        milkDataObject.date = dateInString
//
//        milkDataObject.typeOfMilk = milkTypeSelected.rawValue
////        if milkTypeCowRadioButtn.isSelected {
////            milkDataObject.typeOfMilk = MilkType.cow.rawValue
////        }
////        else if milkTypeBuffeloRadioButtn.isSelected {
////            milkDataObject.typeOfMilk = MilkType.buffalo.rawValue
////        }
//        milkDataObject.comment = commentTxtFld.text
        
        if litreTxtFld.text == "0.00"{
            showAlert(message: "Enter the amount of litre you want", titleForAlert: "Invalid Litre Count")
        }
        else if dateTxtFld.text == nil{
            showAlert(message: "Enter valid date", titleForAlert: "Invalid date")
        }
        else{
            switch caseToWorkOn{
            case .edit:
                dictToPassData = ["caseToWorkOn":"edit"]
                var milkTypeInEditingMode : MilkType = .cow
                if milkTypeSegmentControl.selectedSegmentIndex == 1{
                    milkTypeInEditingMode = .buffalo
                }
                else if milkTypeSegmentControl.selectedSegmentIndex == 0{
                    milkTypeInEditingMode = .cow
                }
                if litreTxtFld.text != liter1 || dateTxtFld.text != date1 || commentTxtFld.text != comment1 || milkTypeInEditingMode.rawValue != milkType1{
                    
                    let copy = realm.objects(BillManeger.self).detached.first?.detached()
                    //print("copy",copy.first?.detached() as Any)
                    if let convertedValue = Float(litreTxtFld.text!){
                        copy!.liter = convertedValue
                    }
                    dateFormatter.dateStyle = .medium
                    dateFormatter.dateFormat = "EEEE, dd MM yyyy"
                    let dateInString = dateFormatter.date(from: dateTxtFld.text!)!
                    copy!.date = dateInString
                    copy!.typeOfMilk = milkTypeInEditingMode.rawValue
                    copy?.comment = commentTxtFld.text
                    
                    print("copy",copy!)
                    viewModel.updateData(object: copy!)
                }
                
            case .add:
                if let convertedValue = Float(litreTxtFld.text!){
                    milkDataObject.liter = convertedValue
                }
                dateFormatter.dateStyle = .medium
                dateFormatter.dateFormat = "EEEE, dd MM yyyy"
                let dateInString = dateFormatter.date(from: dateTxtFld.text!)!
                milkDataObject.date = dateInString
                
                milkDataObject.typeOfMilk = milkTypeSelected.rawValue
        //        if milkTypeCowRadioButtn.isSelected {
        //            milkDataObject.typeOfMilk = MilkType.cow.rawValue
        //        }
        //        else if milkTypeBuffeloRadioButtn.isSelected {
        //            milkDataObject.typeOfMilk = MilkType.buffalo.rawValue
        //        }
                milkDataObject.comment = commentTxtFld.text
                dictToPassData = ["caseToWorkOn":"save"]

                print("add")
                milkDataObject.taskId = UUID().uuidString
                viewModel.saveData(object: milkDataObject)

            case .none:
                print("none")
            }
            
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: dictToPassData)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    func checkPrimartyKey(taskId: String)-> Bool{
        return (realm.object(ofType: BillManeger.self, forPrimaryKey: taskId) != nil)
    }
    @objc func DateSelected(){
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        dateTxtFld.text = date
        //alertLblOfDateTxtFld.isHidden = true
        datePicker.isHidden = true
        datePickerButtonsView.isHidden = true
    }
    
    @objc func cancelButtnClikedOnDatePicker(){
        datePickerButtonsView.isHidden = true
        datePicker.isHidden = true
    }
    
    func setUpUI(){
        litreStepper.layer.cornerRadius = 2.0
        addDataView.layer.cornerRadius = 10.0
       // doneButton.layer.cornerRadius = 5.0
        //doneButton.layer.borderColor = UIColor.black.cgColor
        //doneButton.layer.borderWidth = 1.0
        
        
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
        
        //addDataView.backgroundColor = UIColor(red: 42/255.0, green: 45/255.0, blue: 58/255.0, alpha: 1.5)
    }
    
    func setDatePicker(){
        dateTxtFld.inputView = datePicker
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = Date()
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 10
        datePickerButtonsView.backgroundColor = .lightGray
        datePickerButtonsView.layer.cornerRadius = 5.0
        
    }
    
    func showAlert(message:String, titleForAlert:String){
        
            let error = MessageView.viewFromNib(layout: .cardView)
            error.configureTheme(.error)
            error.configureDropShadow()
            error.configureContent(title: titleForAlert, body: message)
            error.button?.isHidden = true
            error.configureBackgroundView(width: UIScreen.main.bounds.width * 0.6)
            error.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            error.bodyLabel?.font = UIFont.systemFont(ofSize: 12)
        error.configureIcon(withSize: CGSize(width: 30, height: 30),contentMode: .scaleAspectFill)
            error.backgroundHeight = 90
            
            var errorConfig = SwiftMessages.defaultConfig
            errorConfig.presentationStyle = .top
            errorConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            
                SwiftMessages.show(config: errorConfig, view: error)
            
    }
}

extension AddDataViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == litreTxtFld || textField == commentTxtFld{
            //204-244
            addDataViewTopConstraint.constant = 100
            addDataViewBottomConstraint.constant = 350
        }
        else{
            addDataViewTopConstraint.constant = 204
            addDataViewBottomConstraint.constant = 244
        }
       
        if textField == dateTxtFld{
            self.view.endEditing(true)
            //textField.resignFirstResponder()
            datePicker.isHidden = false
            datePickerButtonsView.isHidden = false
        }
        else{
            datePicker.isHidden = true
            datePickerButtonsView.isHidden = true
        }
        if textField == commentTxtFld{
            
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == litreTxtFld{
            // Allow to remove character (Backspace)
                if string == "" {
                    return true
                }

               // Block multiple dot
                if (textField.text?.contains("."))! && string == "." {
                    return false
                }

                // Check decimal places
                if (textField.text?.contains("."))! {
                    let limitDecimalPlace = 2
                    let decimalPlace = textField.text?.components(separatedBy: ".").last
                    //let a = textField.text?.components(separatedBy: ".").first

                    if (decimalPlace?.count)! < limitDecimalPlace{
                        return true
                    }
                    else {
                        return false
                    }
                
                }
            let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
                     return string.rangeOfCharacter(from: invalidCharacters) == nil
        }
        return true
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dateTxtFld.inputView = datePicker
        dateTxtFld.resignFirstResponder()
        
    }
    
}
protocol RealmListDetachable {

 func detached() -> Self
}

extension List: RealmListDetachable where Element: Object {

 func detached() -> List<Element> {
     let detached = self.detached
    let result = List<Element>()
     result.append(objectsIn: detached)
     return result
 }
}

@objc extension Object {
  public func detached() -> Self {
    let detached = type(of: self).init()
    for property in objectSchema.properties {
      guard let value = value(forKey: property.name) else { continue }
      if let detachable = value as? Object {
        detached.setValue(detachable.detached(), forKey: property.name)
      } else if let list = value as? RealmListDetachable {
        detached.setValue(list.detached(), forKey: property.name)
      } else {
        detached.setValue(value, forKey: property.name)
      }
    }
    return detached
  }
}
extension Sequence where Iterator.Element: Object {

    public var detached: [Element] {
        return self.map({ $0.detached() })
    }

}

