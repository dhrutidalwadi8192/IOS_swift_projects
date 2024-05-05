//
//  ViewController.swift
//  Dhrutiben_Dalwadi_FE_8968192
//
//  Created by user237515 on 4/11/24.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController ,CLLocationManagerDelegate,MKMapViewDelegate{
    
    // core data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // location manager
    let manager = CLLocationManager()
    
    // user current city
    var currentCity : String = ""
    
    // map view
    @IBOutlet weak var map: MKMapView!
    
    // city temperature
    @IBOutlet weak var temperature: UILabel!
    
    // humidity
    @IBOutlet weak var humidity: UILabel!
    
    // wind speed
    @IBOutlet weak var windSpeed: UILabel!
    
    // weather icon
    @IBOutlet weak var weatherIcon: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set background image with 0.25 opacity
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha=0.25
        self.view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)
        
        
        manager.delegate = self
        // configure location accuracy to best
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // request location access from user
        manager.requestWhenInUseAuthorization()
        // start updating lcation
        manager.startUpdatingLocation()
        
        // function call to pre load history for the first time
        preloadHistoryData()
        
    }
    
    // function pass data while navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // check for segue idenifier and pass source and city
        if segue.identifier == "MapSegue" {
            let navigtionViewController = segue.destination as? MapViewController
            // pass interaction type to Main
            navigtionViewController?.source = Constants.InteractionType.MAIN
            // pass current city
            navigtionViewController?.fromCity = currentCity
            
        } else if(segue.identifier == "NewsSegue"){
            let navigtionViewController = segue.destination as? NewsTableViewController
            // pass interaction type to Main
            navigtionViewController?.source = Constants.InteractionType.MAIN
            // pass current city
            navigtionViewController?.fromCity = currentCity
        }else if(segue.identifier == "WeatherSegue"){
            let navigationViewController = segue.destination as? WeatherViewController
            // pass interaction type to main
            navigationViewController?.source = Constants.InteractionType.MAIN
            // pass current city
            navigationViewController?.fromCity = currentCity
        }
        
    }
    
    
    
    
    // function to perform action when location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            //manager.startUpdatingLocation()
            // function call to render location
            render(location)
            // function call to make weather API request
            makeAPIRequest(location)
            
        }else{
            return
        }
    }
    
    // function to render location on map
    func render(_ location:CLLocation){
        // get location coordinated
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        // set span
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        // set location to center
        let region = MKCoordinateRegion(center: coordinate, span: span)
        // set pin
        let pin = MKPointAnnotation()
        pin.coordinate=coordinate
        map.addAnnotation(pin)
        // view map
        map.setRegion(region, animated: true)
        
    }
    
    
    // function to make API call to get weather information
    func makeAPIRequest(_ location : CLLocation){
        // fetch lat and long
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // create url component
        var components = URLComponents(string: Constants.weatherBaseUrl)!
        
        // add query parameters to request
        components.queryItems=[
            URLQueryItem(name:"lat",value:String(latitude)),
            URLQueryItem(name:"lon",value:String(longitude)),
            // metric unit to get temperature in celcius
            URLQueryItem(name:"units",value:"metric"),
            URLQueryItem(name:"appId",value:Constants.weatherApiKey)
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
                        // update users current location in core data
                        self.updateUserCurrentLocation(Double(latitude),Double(longitude),weatherData.name)
                    }
                    
                }catch{
                    // catch error in decode
                    print("Error while parsing weather data : \(error)")
                    // display error message
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: "Error while fetching weather information")
                    }
                    
                }
            }
            // api call error
            if let error = error {
                print("Error while getting weather information: \(error)")
                // display error message
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
        var components = URLComponents(string: Constants.weatherIconUrl)!
        
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
        // update current city
        currentCity = weatherResponse.name
        
        // set temperature
        temperature.text = "\(weatherResponse.main.temp) \u{00B0}C"
        
        // set humidity
        humidity.text = "Humidity : \(weatherResponse.main.humidity) %"
        
        // convert speed to km/h and then display it upto two decimal
        windSpeed.text = "Wind Speed :" + String(format: "%.2f",weatherResponse.wind.speed * 3.6) + " km/h"
        
        // function call to get image and display in UI
        getImage(icon: icon)
        
    }
    
    // update user current location in core data
    func updateUserCurrentLocation(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees, _ city : String){
        do{
            // check if already data exist then update it else add new entry
            let userCurrentLocations = try context.fetch(UserCurrentLocation.fetchRequest())
            if let location = userCurrentLocations.first {
                location.cityName = city
                try context.save()
            } else {
                let newLocation = UserCurrentLocation(context: context)
                newLocation.cityName = city
                try context.save()
            }
        }catch{
            print("Error while updating user current location")
        }
        
    }
    
    // pre load History Data
    func preloadHistoryData(){
        if UserDefaults.standard.object(forKey: "History_Preloaded") != nil {
            // history is not loaded
            return
        } else {
            // store static data of five city
            let cityOneHistory = NavigationHistory(context: context)
            cityOneHistory.city = "Waterloo"
            cityOneHistory.from = "Waterloo"
            cityOneHistory.createdAt = Date()
            cityOneHistory.to = "Hamilton"
            cityOneHistory.source = "Main"
            cityOneHistory.interactionType = "Map"
            cityOneHistory.travelMode = "Car"
            cityOneHistory.totalDistance = "69.09 km"
            cityOneHistory.historyId = UUID()
            
            let cityTwoHistory = NavigationHistory(context: context)
            cityTwoHistory.source = "Main"
            cityTwoHistory.interactionType = "Weather"
            cityTwoHistory.city = "Toronto"
            cityTwoHistory.humidity = "99 %"
            cityTwoHistory.temperature = "4.2 \u{00B0}C"
            cityTwoHistory.weatherDate = "17/04/2024"
            cityTwoHistory.weatherTime = "8:26 AM"
            cityTwoHistory.windSpeed = "16.09 km/h"
            cityTwoHistory.historyId = UUID()
            
            let cityThreeoHistory = NavigationHistory(context: context)
            cityThreeoHistory.source = "Map"
            cityThreeoHistory.interactionType = "Weather"
            cityThreeoHistory.city = "Ottawa"
            cityThreeoHistory.humidity = "99 %"
            cityThreeoHistory.temperature = "4.2 \u{00B0}C"
            cityThreeoHistory.weatherDate = "17/04/2024"
            cityThreeoHistory.weatherTime = "8:20 AM"
            cityThreeoHistory.windSpeed = "16.09 km/h"
            cityThreeoHistory.historyId = UUID()
            
            let cityFouroHistory = NavigationHistory(context: context)
            cityFouroHistory.source = "News"
            cityFouroHistory.interactionType = "Weather"
            cityFouroHistory.city = "Kitchener"
            cityFouroHistory.humidity = "99 %"
            cityFouroHistory.temperature = "4.2 \u{00B0}C"
            cityFouroHistory.weatherDate = "17/04/2024"
            cityFouroHistory.weatherTime = "8:20 AM"
            cityFouroHistory.windSpeed = "16.09 km/h"
            cityFouroHistory.historyId = UUID()
            
            let cityFiveHistory = NavigationHistory(context: context)
            cityFiveHistory.city = "Burlington"
            cityFiveHistory.from = "Burlington"
            cityFiveHistory.createdAt = Date()
            cityFiveHistory.to = "Hamilton"
            cityFiveHistory.source = "Main"
            cityFiveHistory.interactionType = "Map"
            cityFiveHistory.travelMode = "Walk"
            cityFiveHistory.totalDistance = "16.09 km"
            cityFiveHistory.historyId = UUID()
            
            do{
                // save data
                try context.save()
                UserDefaults.standard.set(true,forKey: "History_Preloaded")
                
            }catch{
                print("Error while adding new To Do Item")
            }
            
            
            
            
        }
        
    }
    
}

