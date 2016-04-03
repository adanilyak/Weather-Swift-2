//
//  CityWeatherViewController.swift
//  ModelRecivingDataTutorial
//
//  Created by Alexander Danilyak on 02/04/16.
//  Copyright © 2016 Alexander Danilyak. All rights reserved.
//

import UIKit

class CityWeatherViewController: UIViewController, WeatherModelProtocol {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityTempLabel: UILabel!
    
    var weatherModel: WeatherModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityNameLabel.text = weatherModel.cityName
        self.resetTemp()
        self.activityIndicator.startAnimating()
        
        weatherModel.delegate = self
        self.updateWeatherModel(nil)
        
        let gestureTap = UITapGestureRecognizer.init(target: self, action: #selector(CityWeatherViewController.updateWeatherModel(_:)))
        self.cityTempLabel.addGestureRecognizer(gestureTap)
        self.cityTempLabel.userInteractionEnabled = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animateWithDuration(0.4) {
            self.cityNameLabel.alpha = 1.0
        }
        self.animateTemp(cityTempLabel.text!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animateWithDuration(0.4) {
            self.cityNameLabel.alpha = 0.0
        }
        self.resetTemp()
    }
    
    func kelvinToCelsius(tempK: Int!) -> Int {
        return tempK - 273
    }
    
    func resetTemp() {
        self.cityTempLabel.alpha = 0.0
        self.cityTempLabel.transform = CGAffineTransformMakeScale(0.0, 0.0)
        self.cityTempLabel.userInteractionEnabled = false
    }
    
    func animateTemp(temp: String) {
        UIView.animateWithDuration(0.4) {
            self.cityTempLabel.alpha = 1.0
            self.cityTempLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.cityTempLabel.text = temp
        }
        self.cityTempLabel.userInteractionEnabled = true
    }
    
    func updateWeatherLabel() {
        let main = (weatherModel.cityWeather! as Dictionary<String, AnyObject>)["main"] as! Dictionary<String, AnyObject>
        let tempK = main["temp"] as! Int
        let tempC = self.kelvinToCelsius(tempK)
        let tempString = String.init(format: "%li ℃", arguments: [tempC])
        self.animateTemp(tempString)
    }
    
    // MARK: - Weather Model Protocol
    
    func weatherDidLoaded() {
        self.activityIndicator.stopAnimating()
        self.updateWeatherLabel()
    }
    
    //
    
    func updateWeatherModel(sender: UITapGestureRecognizer?) {
        self.resetTemp()
        self.activityIndicator.startAnimating()
        weatherModel.updateWeather()
    }

}
