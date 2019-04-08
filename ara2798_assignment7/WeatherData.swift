//
//  WeatherData.swift
//  ara2798_assignment7
//
//  Created by Argandona Vite, Angel R on 4/6/19.
//  Copyright © 2019 Argandona Vite, Angel R. All rights reserved.
//

//["Alaska" : "AK", "Alabama" : "AL", "Arkansas" : "AR", "American Samoa" : "AS", "Arizona" : "AZ", "California" : "CA", "Colorado" : "CO", "Connecticut" : "CT", "District of Columbia" : "DC", "Delaware" : "DE", "Florida" : "FL", "Georgia" : "GA", "Guam" : "GU", "Hawaii" : "HI", "Iowa" : "IA", "Idaho" : "ID", "Illinois" : "IL", "Indiana" : "IN", "Kansas" : "KS", "Kentucky" : "KY", "Louisiana" : "LA", "Massachusetts" : "MA", "Maryland" : "MD", "Maine" : "ME", "Michigan" : "MI", "Minnesota" : "MN", "Missouri" : "MO", "Mississippi" : "MS", "Montana" : "MT", "North Carolina" : "NC", "North Dakota" : "ND", "Nebraska" : "NE", "New Hampshire" : "NH", "New Jersey" : "NJ", "New Mexico" : "NM", "Nevada" : "NV", "New York" : "NY", "Ohio" : "OH", "Oklahoma" : "OK", "Oregon" : "OR", "Pennsylvania" : "PA", "Puerto Rico" : "PR", "Rhode Island" : "RI", "South Carolina" : "SC", "South Dakota" : "SD", "Tennessee" : "TN", "Texas" : "TX", "Utah" : "UT", "Virginia" : "VA", "Virgin Islands" : "VI", "Vermont" : "VT", "Washington" : "WA", "Wisconsin" : "WI", "West Virginia" : "WV", "Wyoming" : "WY"]

import UIKit

protocol WeatherDataProtocol {
    // MAY NEED TO CHANGE!!!
    func responseDataHandler(data:NSDictionary)
    func responseError(message:String)
}

class WeatherData {
    private let urlSession = URLSession.shared
    private let urlPathBase = "https://api.worldweatheronline.com/premium/v1/weather.ashx?key=3d50f7e7e0f94d458fd22305190704&format=json"
    
    private var dataTask:URLSessionDataTask? = nil
    
    var delegate:WeatherDataProtocol? = nil
    
    init() {}
    
    func getData(city:String, state:String){
        
        var urlPath = self.urlPathBase
        urlPath = urlPath + "&q=" + city + "," + state + "&num_of_days=1"
        
        let url:NSURL? = NSURL(string: urlPath)
        
        let dataTask = self.urlSession.dataTask(with: url! as URL) {
            (data, response, error) -> Void in
            if error != nil {
                //IMPLEMENT LABEL!!!
                self.delegate?.responseError(message: error as! String)
            } else {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    if jsonResult != nil {
                        //print(jsonResult!)
                        let data:NSDictionary? = jsonResult!["data"] as? NSDictionary
                        let climateAverages = data!["ClimateAverages"] as? NSArray
                        let current_condition = data!["current_condition"] as? NSArray
                        let weather = data!["weather"] as? NSArray
                        if climateAverages != nil && current_condition != nil && weather != nil {
                            //print(climateAverages!)
                            //print(current_condition!)
                            //print(weather!)
                            self.delegate?.responseDataHandler(data: data!)
                        } else {
                            self.delegate?.responseError(message:"Error caught in try statement")
                        }
                    }
                } catch {
                    // Handle the exception
                    self.delegate?.responseError(message:"Error caught in catch statement")
                }
            }
        }
        dataTask.resume()
    }
}
