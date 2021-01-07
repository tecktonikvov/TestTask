//
//  CoreDataManager.swift
//  TestTask
//
//  Created by Mac on 06.01.2021.
//

import Foundation
import CoreData

class CoreDataManager {
    static var mainVC: MainController!
    static let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
    
    static func createCurrencyEntityFrom(dictionary: [String:AnyObject]) -> NSManagedObject? {
        if let currencyEntity = NSEntityDescription.insertNewObject(forEntityName: "CurrencyEntity", into: CoreDataManager.context) as? CurrencyEntity {
            currencyEntity.cc = dictionary["cc"] as? String
            currencyEntity.rate = dictionary["rate"] as? Double ?? 00.000
            return currencyEntity
        }
        return nil
    }
    
    static func saveInCoreDataCurrencyWith(array: [[String: AnyObject]]) {
            _ = array.map{CoreDataManager.createCurrencyEntityFrom(dictionary: $0)}
            do {
                try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
                print("Currency entity saved in Core Data")
            } catch let error {
                print(error.localizedDescription)
            }
        }
    
    static func clearData(forEntity: String) {
            do {
                let context = CoreDataManager.context
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: forEntity)
                do {
                    let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                    _ = objects.map{$0.map{context.delete($0)}}
                    CoreDataStack.sharedInstance.saveContext()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    
    static func getCurrencies(){
        let fetchRequest: NSFetchRequest<CurrencyEntity> = CurrencyEntity.fetchRequest()
        
        do {
            let result = try CoreDataManager.context.fetch(fetchRequest)
            if result.isEmpty {
                print("Error! Count of etities from CoreData = 0")
            }
            CoreDataManager.mainVC.currencies = result
            
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
}
