//
//  WeatherModel.swift
//  
//
//  Created by Alexander Danilyak on 02/04/16.
//
//

import UIKit
import AFNetworking

protocol WeatherModelProtocol {
    func weatherDidLoaded()
}

class WeatherModel: NSObject {
    // Open Weather Map API
    // Используется для примера, вам скорее всего не понадобится такой ключ для вашего API
    let apiKey: String!
    let apiURL: String!
    let cityParameterName: String!
    let apiKeyParameterName: String!
    
    // Хранение данных
    var cityName: String!
    var cityWeather: Dictionary<String, AnyObject>?
    
    // Менеджер загрузки
    var sessionManager: AFHTTPSessionManager!
    
    // Делегат
    var delegate: WeatherModelProtocol?
    
    override init() {
        apiKey = "edc334562e02d9f7b03c026a7b8d629a"
        apiURL = "http://api.openweathermap.org/data/2.5/weather"
        cityParameterName = "q"
        apiKeyParameterName = "APPID"
        sessionManager = AFHTTPSessionManager()
        super.init()
    }
    
    // Немножко Swift 2.2 вам в код
    convenience init(_cityName: String) {
        self.init()
        cityName = _cityName
    }
    
    func updateWeather() {
        sessionManager.GET(apiURL, parameters: [cityParameterName : cityName, apiKeyParameterName : apiKey], progress: nil, success: { (sessionDataTask, response) in
                print(response)
                self.cityWeather = response as? Dictionary
                self.delegate?.weatherDidLoaded()
            }, failure: { (sessionDataTask, error) in
                print("error")
            })
    }
}
