//
//  WeatherImageView.swift
//  ara2798_assignment7
//
//  Created by Argandona Vite, Angel R on 4/7/19.
//  Copyright © 2019 Argandona Vite, Angel R. All rights reserved.
//

import UIKit

class WeatherImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension UIImageView {
    func downloaded(from url: URL) {
        let urlSession = URLSession.shared
        let url:URL = url
        
        let dataTask = urlSession.dataTask(with: url) {
            (data, response, error) -> Void in
            if error != nil {
                print(error!)
            } else {
                guard
                    let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode),
                    let mime = response.mimeType, mime.hasPrefix("image"),
                    let data = data,
                    let image = UIImage(data: data)
                    else {return}
                DispatchQueue.main.async() {
                    self.image = image
                }
            }
        }
        dataTask.resume()
    }
    
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url)
    }
}
