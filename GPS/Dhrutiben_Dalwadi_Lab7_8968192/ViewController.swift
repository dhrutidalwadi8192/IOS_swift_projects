//
//  ViewController.swift
//  Dhrutiben_Dalwadi_Lab7_8968192
//
//  Created by user237515 on 3/19/24.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    // set location manager
    let manager = CLLocationManager()
    
    // declare variables
    var currentSpeed : CLLocationSpeed = 0
    var maximumSpeed : CLLocationSpeed  = 0
    var averageSpeed : CLLocationSpeed = 0
    var maxAcceleration: CLLocationSpeed = 0
    var lastLocation : CLLocation?
    var totalDistance: CLLocationDistance = 0
    // variables for getting average speed
    var numberOfSpeed : Double = 0
    var totalSpeed : CLLocationSpeed = 0
    
    
    
    // current speed level
    @IBOutlet weak var speedValue: UILabel!
    
    // maximum speed label
    @IBOutlet weak var maxSpeedValue: UILabel!
    
    // average speed label
    @IBOutlet weak var averageSpeedValue: UILabel!
    
    // total distance label
    @IBOutlet weak var distanceValue: UILabel!
    
    // acceleration value label
    @IBOutlet weak var maxAccelerationValue: UILabel!
    
    // speed indicator
    @IBOutlet weak var highSpeedIndicator: UIView!
    
    // bottom bar trip indicator
    @IBOutlet weak var tripIndicator: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // function call to set default values
        setDefaultValues()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // location  configuration
        manager.delegate=self
        // set accuracy
        manager.desiredAccuracy=kCLLocationAccuracyBest
        // request location access from user
        manager.requestWhenInUseAuthorization()
        mapView.delegate=self
        
    }
    
    

    // start trip button action
    @IBAction func startTrip(_ sender: UIButton) {
        setDefaultValues()
        manager.startUpdatingLocation()
        // show location on map
        mapView.showsUserLocation = true
        tripIndicator.backgroundColor = UIColor.green
        
    }
    
    // function to end trip
    @IBAction func endTrip(_ sender: UIButton) {
        mapView.showsUserLocation = false;
        // stop updating location
        manager.stopUpdatingLocation();
        tripIndicator.backgroundColor = UIColor.lightGray
    }
    
    // function to get locations and update calculation when location get updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // take last location as new location as last location is the most recent one
        guard let newLocation = locations.last else { return }
                
                // if we have both last and new location then update calculations
                if let lastLocation = lastLocation {
                    // current speed
                    currentSpeed = newLocation.speed
                    // function call to get distance
                    let distance = calculateDistance(from: lastLocation, to: newLocation)
                    // get time to reach from last location to new location
                    
                  
                    let timeDifference = newLocation.timestamp.timeIntervalSince(lastLocation.timestamp)
                    
                    // function call to update max speed and speed indicator
                    updateMaxSpeed(speed: currentSpeed)
                    
                    // calculate average speed
                    totalSpeed += currentSpeed
                    numberOfSpeed += 1
                    averageSpeed = totalSpeed / numberOfSpeed
                    
                    // do sum of distance
                    totalDistance += distance
                    
                    // function call to calculate acceleration
                    let acceleration = calculateAcceleration(currentSpeed: newLocation.speed, previousSpeed: lastLocation.speed, timeDifference: timeDifference)
                    // function call to update acceleration
                    updateMaxAcceleration(acceleration: acceleration)
                    // function call to display calculated values on labels
                    displayCalculatedValues()
                }
                // function call to display location on map
                render(newLocation)
                // initially set last location as latest location
                lastLocation = newLocation
    }
    
    
     // function to render location on mapview
     func render(_ location:CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude:location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
      // Calculate distance between two locations
       func calculateDistance(from: CLLocation, to: CLLocation) -> CLLocationDistance {
           return from.distance(from: to)
       }
       
       
       // Update maximum speed if necessary
       func updateMaxSpeed(speed: CLLocationSpeed) {
           // update speed indiator view color
           if(speed >= 31.9){
               highSpeedIndicator.backgroundColor = UIColor.red
           }else{
               if(highSpeedIndicator.backgroundColor == UIColor.red){
                   highSpeedIndicator.backgroundColor = UIColor.lightGray
               }
           }
           // set maximum speed
           if speed > maximumSpeed {
               maximumSpeed = speed
           }
       }
       
       // Calculate acceleration
       func calculateAcceleration(currentSpeed: CLLocationSpeed, previousSpeed: CLLocationSpeed, timeDifference: TimeInterval) -> CLLocationSpeed {
           // speed diffirence / time
           return (currentSpeed - previousSpeed) / timeDifference
       }
       
      // function to update max accelration value
       func updateMaxAcceleration(acceleration: CLLocationSpeed) {
           if acceleration > maxAcceleration {
               maxAcceleration = acceleration
           }
       }
  
   // function to format and display calculated values
    func displayCalculatedValues(){
        speedValue.text = String(format: "%.2f km/h", currentSpeed * 3600/1000)
        maxSpeedValue.text = String(format: "%.2f km/h", maximumSpeed * 3600/1000)
        averageSpeedValue.text = String(format: "%.2f km/h", averageSpeed * 3600/1000)
        distanceValue.text = String(format: "%.2f km", totalDistance / 1000)
        maxAccelerationValue.text = String(format: "%.2f m^s2",maxAcceleration)
        
    }
    
    // function to set default values for labels and variables
    func setDefaultValues(){
        // reset variables
        currentSpeed = 0
        maximumSpeed = 0
        totalDistance = 0
        averageSpeed = 0
        maxAcceleration = 0
        numberOfSpeed = 0
        totalSpeed = 0
        
        // set label value to zero
        speedValue.text = String(format: "%.2f km/h", currentSpeed)
        maxSpeedValue.text = String(format: "%.2f km/h", maximumSpeed )
        averageSpeedValue.text = String(format: "%.2f km/h", averageSpeed )
        distanceValue.text = String(format: "%.2f km", totalDistance )
        maxAccelerationValue.text = String(format: "%.2f m^s2",maxAcceleration)
        
        // reste view colours
        highSpeedIndicator.backgroundColor = UIColor.lightGray
        
        
        // stop updating location
        manager.stopUpdatingLocation()
    }
    
}

