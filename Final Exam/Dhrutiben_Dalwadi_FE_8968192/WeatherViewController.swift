//
//  WeatherViewController.swift
//  Dhrutiben_Dalwadi_FE_8968192
//
//  Created by user237515 on 4/11/24.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController,CLLocationManagerDelegate {
    
    // core data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // interaction source
    var source : String?
    
    // user's current city
    var fromCity : String?

    // location manager object
    let manager = CLLocationManager()
    
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
        
        // if currenct city received from home page then use it
        if let city = fromCity, !city.isEmpty{
            convertAddress(city)
        }else{
            // fetch location
            manager.startUpdatingLocation()
        }
        
    }
    
    // pass data to view controller for managing history
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WeatherToMapSegue" {
            let navigationViewController = segue.destination as? MapViewController
            // pass interaction type as Weather to Map View Controller
            navigationViewController?.source = Constants.InteractionType.WEATHER
            
        } else if(segue.identifier == "WeatherToNewsSegue"){
            let navigationViewController = segue.destination as? NewsTableViewController
            // pass interaction type as Weather to News Controller
            navigationViewController?.source = Constants.InteractionType.WEATHER
           
        }
    }
    
    // function to open modal when user clic on plus button
    @IBAction func changeLocation(_ sender: UIBarButtonItem) {
        // function call to open dialog
        OpenChangeCityDialg()
    }
    
    // navigate to home action
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        // display home page
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    // function to perform action when location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            //manager.startUpdatingLocation()
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
        
        print("api url \(apiUrl)")
        
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
        
        // function call to add history in core data
        addHistory(cityName.text!, temperature.text!, windSpeed.text!, humidity.text!)
        
    }
    
    // function to open Add New To Do Dialog
    func OpenChangeCityDialg(){
        let alertDialog = UIAlertController(title:"Change City",message:"",preferredStyle: .alert)
        // text field for city name
        alertDialog.addTextField{(textField) in
            textField.placeholder="Enter City Name"
        }
        
        // cancel button
        let cancelAction = UIAlertAction(title:"Cancel",style: .cancel,handler:nil)
        alertDialog.addAction(cancelAction)
        
        //Change City Button
        let insertAction = UIAlertAction(title:"Change",style: .destructive) { [self] action in
            // fetch city name from text box
            let cityName = alertDialog.textFields?.first?.text ?? ""
            
            // show error message if city name is empty
            if(cityName.isEmpty){
                // again show alert
                showAlert(title:"",message:"Please enter city name")
            }else{
                // function call to fetch lat long from city name
                convertAddress(cityName)
                
            }
            
        }
        // add text field in dialog
        alertDialog.addAction(insertAction)
        // display dialog
        present(alertDialog,animated: true,completion: nil)
    }
    
    // function to fetch location coordinates from city name usign geo coder
    func convertAddress(_ cityName : String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(cityName) { (placemarks, errors) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location
            else{
                self.showAlert(title:"",message:"Location not found, please try with another city")
                return
            }
            // make API call to fetch weather data for the location
            self.makeAPIRequest(location)
        }
        
    }
    
    // function to add new to do in list
    func addHistory(_ city : String, _ temperature : String, _ windSpeed : String, _ humidity : String){
        if let source = source, !source.isEmpty {
            // Navigation history context
            let history = NavigationHistory(context: context)
            
            // define date formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy" // Customize the format as needed
            
            // define time formatter
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            
            // interaction source
            history.source = source
            // interaction type
            history.interactionType = Constants.InteractionType.WEATHER
            // city
            history.city = city
            // weather date
            history.weatherDate=dateFormatter.string(from: Date())
            // weather time
            history.weatherTime=timeFormatter.string(from: Date())
            // temperature
            history.temperature=temperature
            // windspeed
            history.windSpeed=windSpeed
            // humidity
            history.humidity=humidity
            // current date
            history.createdAt = Date()
            
            do{
                // save history
                try context.save()
                
            }catch{
                print("Error while adding new To Do Item")
            }
            
        }
    }
}
