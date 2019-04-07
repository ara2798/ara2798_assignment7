//
//  ViewController.swift
//  ara2798_assignment7
//
//  Created by Argandona Vite, Angel R on 4/6/19.
//  Copyright © 2019 Argandona Vite, Angel R. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, WeatherDataProtocol {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    var dataSession = WeatherData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTextField.delegate = self
        stateTextField.delegate = self
        temperatureLabel.isHidden = true
        conditionsLabel.isHidden = true
        errorLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkConditionsButton(_ sender: UIButton) {
        let selectedCity:String = cityTextField.text!
        let selectedState:String = stateTextField.text!
        self.dataSession.getData(city: selectedCity, state: selectedState)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: WeatherDataProtocol
    func responseDataHandler(data: NSDictionary) {
        print("HI")
    }
    
    func responseError(message: String) {
        print("BYE")
    }

}

