//
//  BillManegerViewModel.swift
//  MilkBillManeger
//
//  Created by Coditas on 18/03/22.
//

import Foundation
import RealmSwift

class BillManegerViewModel {
    let realm = try! Realm()
    var objectOfResult : Results<BillManeger>!
    var objectOfResultForSorted : Results<BillManeger>!
    let dateFormatter = DateFormatter()
    var arrayOfResultInViewModel  = [BillManeger]()
    
    var test = [BillManeger]()
    var cowMilkRate : Int?
    var buffaloMilkRate : Int?
    var milkType : MilkType?
    
//MARK: - SAVE DATA
    func saveData(object: BillManeger){
        
        try! realm.write{
            realm.add(object)
        }
    }
//MARK: - DELETE DATA
    func deleteData(object: BillManeger){
        try! realm.write{
            realm.delete(object)
        }
    }
//MARK: - UPDATE DATA
    func updateData(object : BillManeger){
        try! realm.write{
            realm.add(object, update: .all)
        }
    }
    
    func fetchAllResult(completion: @escaping([BillManeger])->()){
        objectOfResult = realm.objects(BillManeger.self).sorted(byKeyPath: "date", ascending: true)
        arrayOfResultInViewModel.removeAll()
        for i in objectOfResult{
            arrayOfResultInViewModel.append(i)
        }
        print("arrayOfresult",arrayOfResultInViewModel)
        completion(arrayOfResultInViewModel)
    }
    
    func fetchResultSortedByDate(startDate: String,endDate: String,completion: @escaping([BillManeger])->()){
        print("startDate",startDate)
        print("endDate",endDate)
        
        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
        
        dateFormatter.locale = .current
        let editedStartDate = dateFormatter.date(from: startDate)
        let editedEndDate = dateFormatter.date(from: endDate)
        
        objectOfResult = realm.objects(BillManeger.self).filter("date BETWEEN %@",[editedStartDate,editedEndDate])
        arrayOfResultInViewModel.removeAll()
        for i in objectOfResult{
            arrayOfResultInViewModel.append(i)
        }
      completion(arrayOfResultInViewModel)
    }
    
    func fetchResultSortedByTypeOfMilk(milkType: MilkType, completion: @escaping([BillManeger])->()){
        objectOfResult = realm.objects(BillManeger.self).filter("typeOfMilk == '\(milkType.rawValue)'").sorted(byKeyPath: "date", ascending: true)
        arrayOfResultInViewModel.removeAll()
        for i in objectOfResult{
            arrayOfResultInViewModel.append(i)
        }
        completion(arrayOfResultInViewModel)
    }
    
    func fetchResultSortedByDateAndMilkType(startDate: String,endDate: String, milkType: MilkType, completion: @escaping([BillManeger])->()){
        dateFormatter.dateFormat = "EEEE, dd MM yyyy"
        dateFormatter.locale = .current
        let editedStartDate = dateFormatter.date(from: startDate)
        let editedEndDate = dateFormatter.date(from: endDate)
        objectOfResult = realm.objects(BillManeger.self)
            .filter("(date BETWEEN %@) AND (typeOfMilk == '\(milkType.rawValue)')",[editedStartDate,editedEndDate]).sorted(byKeyPath: "date", ascending: true)
        arrayOfResultInViewModel.removeAll()
        for i in objectOfResult{
            arrayOfResultInViewModel.append(i)
        }
        completion(arrayOfResultInViewModel)
    }
}
