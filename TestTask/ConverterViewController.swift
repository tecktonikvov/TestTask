//
//  ConverterViewController.swift
//  TestTask
//
//  Created by Mac on 06.01.2021.
//

import UIKit

class ConverterViewController: UIViewController {
    
    var currencies = [CurrencyEntity]()

    var indexOfSelectedCurrency = 0
    var oldRate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDoneButtonOnKeyboard()
        firstCurrencyLabel.text = currencies[0].cc
        firstRateTF.tag = 0
        secondRateTF.tag = 1
        convert()
    }
    
    func convert(){
        let rateOfSelectedCurrency =  Double(currencies[indexOfSelectedCurrency].rate)
        let rateInUAHTF = Double(firstRateTF.text!) ?? 0.00
        var result: Double = rateOfSelectedCurrency * rateInUAHTF
        result = result.rounded(toPlaces: 2)
        
        secondRateTF.text = String(result)
    }
    
    func convertReverse(){
        let rateOfSelectedCurrency =  Double(currencies[indexOfSelectedCurrency].rate)
        let rateInUAHTF = Double(secondRateTF.text!) ?? 0.00
        var result: Double = rateInUAHTF / rateOfSelectedCurrency
        result = result.rounded(toPlaces: 2)

        firstRateTF.text = String(result)
    }
    
//MARK: - Done button setup
    func addDoneButtonOnKeyboard(){
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            secondRateTF.inputAccessoryView = doneToolbar
            firstRateTF.inputAccessoryView = doneToolbar
        }

        @objc func doneButtonAction(){
            secondRateTF.resignFirstResponder()
            firstRateTF.resignFirstResponder()
        }
    
//MARK: - Outlets & IBActions
    @IBOutlet weak var firstCurrencyLabel: UILabel!
    @IBOutlet weak var secondCurrencyLabel: UILabel!
    @IBOutlet weak var firstCurrencyPIcker: UIPickerView!
    @IBOutlet weak var firstRateTF: UITextField!
    @IBOutlet weak var secondRateTF: UITextField!
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}

//MARK: - Delegate & DataSource

extension ConverterViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].cc
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currencyName = currencies[row].cc
        
        firstCurrencyLabel.text = currencyName
        indexOfSelectedCurrency = row
        self.view.endEditing(true)
        
        convert()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 0 {
            convert()
        } else if textField.tag == 1 {
            convertReverse()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        oldRate = String(textField.text!)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = String(oldRate)
        }
        
        if textField.tag == 1 {
            convertReverse()
        } else {
            convert()
        }
    }
}
