//
//  ViewController.swift
//  Dhrutiben_Dalwadi_Lab8_8968192
//
//  Created by user237515 on 4/1/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // location manager object
    let manager = CLLocationManager()
    
    // declare api urls & credentials
    let apiKey = "e68ee396fa496b330c4e8158ab739ead"
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    let weatherIconUrl = "https://openweathermap.org/img/wn/"
    
    // city label
    @IBOutlet weak var cityName: UILabel!
    
    // weather label
    @IBOutlet weak var weather: UILabel!
    
    // weather UI Image
    @IBOutlet weak var weatherIcon: UIImageView!
    
    // temperature label
    @IBOutlet weak var temperature: UILabel!
    
    // humidity
    @IBOutlet weak var humidity: UILabel!
    
    // wind speed
    @IBOutlet weak var windSpeed: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manager.delegate = self
        // configure location accuracy to best
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // request location access from user
        manager.requestWhenInUseAuthorization()
        // start updating lcation
        manager.startUpdatingLocation()
        
    }
    
    
    // function to perform action when location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            manager.startUpdatingLocation()
            // function call to make weather API request
            makeAPIRequest(location)
        }else{
            return
        }
    }
    
    // function to make API call to get weather information
    func makeAPIRequest(_ location : CLLocation){
        // fetch lat and long
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // create url component
        var components = URLComponents(string: baseUrl)!
        
        // add query parameters to request
        components.queryItems=[
            URLQueryItem(name:"lat",value:String(latitude)),
            URLQueryItem(name:"lon",value:String(longitude)),
            // metric unit to get temperature in celcius
            URLQueryItem(name:"units",value:"metric"),
            URLQueryItem(name:"appId",value:apiKey)
        ]
        
        // prepare url based on url component
        guard let apiUrl = components.url else {return}
        
        // create data task with shred session
        let dataTask = URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            if let data = data{
                do{
                    // decode json to cityWeather structure
                    let weatherData = try JSONDecoder().decode(CityWeather.self,from:data)
                    // perform UI updates on main thread
                    DispatchQueue.main.async {
                        // function call to set weather infromation on view
                        self.setWeatherInformation(weatherResponse : weatherData)
                     }
                    
                    
                }catch{
                    // catch error in decode
                    print("Error while parsing weather data : \(error)")
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: "Error while fetching weather information")
                    }
                    
                }
            }
            // api call error
            if let error = error {
                print("Error while getting weather information: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Error while fetching weather information")
                }
                return
            }
        }
        // begin data task
        dataTask.resume()
        
    }
    
    // function to get image from openweather API
    func getImage(icon : String){
        // create url cmponent
        var components = URLComponents(string: weatherIconUrl)!
        
        // append icon name in url
        components.path = components.path + "\(icon)@2x.png"
        
        // prepare request url
        guard let apiUrl = components.url else {return}
        
        // create data task with shared session
        let dataTask = URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            if let data = data{
                // perform ui image updated on main thread
                DispatchQueue.main.async {
                    // set icon to image view
                    self.weatherIcon.image = UIImage(data:data)
                }
            }
            // api request error
            if let error = error {
                print("Error while getting weather icon: \(error)")
                return
            }
        }
        // begin data task
        dataTask.resume()
    }
    
    // function to set weather information on ui controls
    func setWeatherInformation(weatherResponse : CityWeather){
        // fetch icon to get image
        let icon = weatherResponse.weather[0].icon
        
        // set city name
        cityName.text = weatherResponse.name
        
        // set weather
        weather.text = weatherResponse.weather[0].main
        
        // set temperature
        temperature.text = "\(weatherResponse.main.temp) \u{00B0}C"
        
        // set humidity
        humidity.text = "\(weatherResponse.main.humidity) %"
        
        // convert speed to km/h and then display it upto two decimal
        windSpeed.text = String(format: "%.2f",weatherResponse.wind.speed * 3.6) + " km/h"
        
        // function call to get image and display in UI
        getImage(icon: icon)
        
    }
    
    
    
}

