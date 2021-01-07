//
//  DataManager.swift
//  TestTask
//
//  Created by Mac on 06.01.2021.
//

import Foundation

class DataManager {
    static func getCurrencies(){
        APIManager.fetchCurrenciesRate(completion: {result in
            
            switch result {
            case .Success(let rateData):
                print("Success, just get data from API")

                if let _ = rateData[0]["cc"] {
                    print("Data from API is valid")
                    let data = DataManager.filter(arr: rateData)
                    CoreDataManager.clearData(forEntity: "CurrencyEntity")
                    CoreDataManager.saveInCoreDataCurrencyWith(array: data)
                    CoreDataManager.getCurrencies()
                    
                } else {
                    print("Data isn`t valid, get old rates from CoreData")
                    CoreDataManager.getCurrencies()
                }

            case .Error(let error):
                print("Can`t get data from API. APP load data from CoreData")
                CoreDataManager.getCurrencies()
                print(error)
            }
        })
    }
    
    static func filter(arr: [[String:AnyObject]]) -> [[String:AnyObject]]{
        var result = [[String:AnyObject]]()
        let uah = ["cc": "UAH", "rate": 1.00] as [String:AnyObject]
        result.append(uah)
        for item in arr {
            if item["cc"] as! String == "EUR" {
                result.append(item)
            } else if item["cc"] as! String == "USD" {
                result.append(item)
            }
        }
        
        return result
    }
}
