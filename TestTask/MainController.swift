//
//  ViewController.swift
//  TestTask
//
//  Created by Mac on 06.01.2021.
//

import UIKit

class MainController: UIViewController {
    
    var currencies = [CurrencyEntity]() {
        didSet {
            currenciesToConwer = currencies
            
            let indexOfUah = currencies.firstIndex{$0.cc == "UAH"}
            currencies.remove(at: indexOfUah!)
            tableView.reloadData()
        }
    }
    
    var currenciesToConwer = [CurrencyEntity]() // This property is needed in order to select "UAH" in the picker
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataManager.mainVC = self
        DataManager.getCurrencies()
        
        tableView.rowHeight = 44
        tableView.tableFooterView = UIView()
        //CoreDataStack.sharedInstance.applicationDocumentsDirectory()
    }
    
//MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "converter" {
            if let destinationVC = segue.destination as? ConverterViewController{
                destinationVC.currencies = currenciesToConwer
            }
        }
    }
    
//MARK: - Outlets & IBActions
    @IBOutlet weak var tableView: UITableView!
}

//MARK: - Extension, delegate, dataSource
extension MainController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tablw: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rateCell") as! RateCell
        
        cell.currencyNameLabel.text = currencies[indexPath.row].cc
        var rate = currencies[indexPath.row].rate
        rate = rate.rounded(toPlaces: 2)
        let strRate = String(rate)
        cell.rateLabel.text = strRate
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

