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
    @IBOutlet weak var weatherImage: WeatherImageView!
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
        self.dataSession.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkConditionsButton(_ sender: UIButton) {
        var city:String? = cityTextField.text
        city = city?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        var state:String? = stateTextField.text
        state = state?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard let selectedCity = city, let selectedState = state, !selectedCity.isEmpty, !selectedState.isEmpty else {
            return
        }
        city = ""
        state = ""
        for chr in selectedCity {
            if chr != " " {
                city = city! + String(chr)
            } else {
                city = city! + "+"
            }
        }
        for chr in selectedState {
            if chr != " " {
                state = state! + String(chr)
            } else {
                state = state! + "+"
            }
        }
        print(city!)
        print(state!)
        self.dataSession.getData(city: city!, state: state!)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: WeatherDataProtocol
    func responseDataHandler(data: NSDictionary) {
        let current_condition = data["current_condition"] as? NSArray
        let current_dict = current_condition![0] as? NSDictionary
        let weather = data["weather"] as? NSArray
        let weather_dict = weather![0] as? NSDictionary
        
        let icon = current_dict!["weatherIconUrl"] as? NSArray
        let weatherIcon = icon![0] as? NSDictionary
        
        let cur_temp = (current_dict!["temp_C"] as! String) + "°C/" + (current_dict!["temp_F"] as! String) + "°F"
        let cur_cloudCover = "Cloud cover: " + (current_dict!["cloudcover"] as! String) + "%"
        let cur_humidity = "Humidity: " + (current_dict!["humidity"] as! String) + "%"
        let cur_pressure = "Pressure: " + (current_dict!["pressure"] as! String) + "mbar"
        let cur_precipitation = "Precipitation: " + (current_dict!["precipMM"] as! String) + "mm"
        let cur_wind = (current_dict!["windspeedKmph"] as! String) + "kmph/" + (current_dict!["windspeedMiles"] as! String) + "mph " + (current_dict!["winddir16Point"] as! String) + " (" + (current_dict!["winddirDegree"] as! String) + "°)"
        
        DispatchQueue.main.async(){
            self.weatherImage.downloaded(from: weatherIcon!["value"] as! String)
            self.temperatureLabel.text = cur_temp
            self.conditionsLabel.text = cur_cloudCover + "\n" + cur_humidity + "\n" + cur_pressure + "\n" + cur_precipitation + "\n" + cur_wind
            self.weatherImage.isHidden = false
            self.temperatureLabel.isHidden = false
            self.conditionsLabel.isHidden = false
            self.errorLabel.isHidden = true
        }
    }
    
    func responseError(message: String) {
        DispatchQueue.main.async() {
            self.errorLabel.text = "Current conditions not found"
            self.weatherImage.isHidden = true
            self.temperatureLabel.isHidden = true
            self.conditionsLabel.isHidden = true
            self.errorLabel.isHidden = false
            print(message)
        }
    }
}

