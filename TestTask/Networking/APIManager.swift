//
//  APIManager.swift
//  TestTask
//
//  Created by Mac on 06.01.2021.
//

import Foundation
import Alamofire

class APIManager: NSObject {
    
    enum Result <T>{
    case Success(T)
    case Error(String)
    }
    
    static let URL = "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json"
    static let context = CoreDataStack.sharedInstance.persistentContainer.viewContext

    class func fetchCurrenciesRate(completion: @escaping (Result<[[String:AnyObject]]>) -> ()) {
        AF.request(URL, requestModifier: { $0.timeoutInterval = 3 })
            .validate()
            .responseJSON { response in
                switch (response.result) {
                case .success( _):
                    completion(.Success(response.value as! [[String:AnyObject]]))
                    
                case .failure(let error):
                    completion(.Error(error.localizedDescription))
                }
            }
    }
}

