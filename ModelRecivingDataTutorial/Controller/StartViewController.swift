//
//  StartViewController.swift
//  ModelRecivingDataTutorial
//
//  Created by Alexander Danilyak on 02/04/16.
//  Copyright © 2016 Alexander Danilyak. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController:UIPageViewController!
    var dataForPages: NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Города для которых будем искать погоду
        dataForPages = [WeatherModel.init(_cityName: "Moscow"),
                        WeatherModel.init(_cityName: "San Francisco"),
                        WeatherModel.init(_cityName: "New York"),
                        WeatherModel.init(_cityName: "London"),
                        WeatherModel.init(_cityName: "Tokyo")]
        
        // Инициализируем контроллер из сторибора
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewControllerID") as! UIPageViewController
        
        // Говорим, что источником данных и делегатос для контроллера будет этот контроллер
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // Инициализируем первый контроллер
        let cityWeatherController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([cityWeatherController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        // Устанавливаем фрейм для Page View Controller
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    func viewControllerAtIndex(index: Int) -> CityWeatherViewController? {
        // Если индекс запрашиваемого контроллера вне границ массива данных, то такого контроллера нет
        if (dataForPages.count == 0) || (index >= dataForPages.count) {
            return nil
        }
        
        // Инициализируем контроллер из сториборда
        let storyBoard = UIStoryboard(name: "Main",
                                      bundle: NSBundle.mainBundle())
        let cityWeatherController = storyBoard.instantiateViewControllerWithIdentifier("CityWeatherControllerID") as! CityWeatherViewController
        
        // Задаем данные для конкретного города
        cityWeatherController.weatherModel = dataForPages[index] as! WeatherModel
        return cityWeatherController
    }
    
    func indexOfViewController(cityWeatherController: CityWeatherViewController) -> Int {
        if let dataObject: AnyObject = cityWeatherController.weatherModel {
            return dataForPages.indexOfObject(dataObject)
        } else {
            return NSNotFound
        }
    }
    
    
    // MARK: - Page View Controller Data Source Protocol
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController
            as! CityWeatherViewController)
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController
            as! CityWeatherViewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == dataForPages.count {
            return nil
        }
        return viewControllerAtIndex(index)
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return dataForPages.count
    }
    
    
}
