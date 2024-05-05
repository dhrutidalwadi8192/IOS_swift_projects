//
//  MapViewController.swift
//  Dhrutiben_Dalwadi_FE_8968192
//
//  Created by user237515 on 4/11/24.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    // core data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // location manager
    let manager = CLLocationManager()
    
    // interaction source coming from navigation
    var source : String?
    
    // start location
    var fromCity : String?
    // end location
    var toCity : String?
    
    // travel mode
    var travelMode : String?
    
    // source coordinate
    var sourceCoordinate : CLLocationCoordinate2D?
    // destination coordinate
    var destinationCoordinate : CLLocationCoordinate2D?
    
    var zoomCounter = 0.01
    
    
    // zoom in zoom out slider
    @IBOutlet weak var toggleMapZooming: UISlider!
    
    // map view
    @IBOutlet weak var map: MKMapView!
    
    // total distance to travel
    @IBOutlet weak var totalDistance: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // open dialogue to ask user travel location
        OpenChangeCityDialg()
        manager.delegate=self
        // set accuracy
        manager.desiredAccuracy=kCLLocationAccuracyBest
        // ask user for location access permission
        manager.requestWhenInUseAuthorization()
        map.delegate=self
        // set total distance text empty initially
        totalDistance.text = ""
       
    }
    
    // navigate to home
    @IBAction func navigateToHome(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // navigate to news
    @IBAction func navigateToNews(_ sender: UIButton) {
        // instantiate news controller
        let navController = storyboard?.instantiateViewController(withIdentifier: "News") as! NewsTableViewController
        // set soure as Map
        navController.source = Constants.InteractionType.MAP
        // display News controller
        navigationController?.pushViewController(navController, animated: true)
        
    }
    
    // navigate to weather
    @IBAction func navigateToWeather(_ sender: UIButton) {
        // instantiate weather controller
        let navController = storyboard?.instantiateViewController(withIdentifier: "Weather") as! WeatherViewController
        // set source as Map
        navController.source = Constants.InteractionType.MAP
        // display Weather controller
        navigationController?.pushViewController(navController, animated: true)
    }
    
   // function to change location
    @IBAction func changeLocation(_ sender: UIBarButtonItem) {
        // function call to open dialog which taes start and end location
        OpenChangeCityDialg()
    }
    
    
    // function to check zooming level
    @IBAction func changeMapZoomingValue(_ sender: UISlider) {
        // get slider vlet alue
        var zoomLevel = Double(sender.value)
        // set delta level
        if(zoomLevel > 0.0){
            // 0.07 is current value, so when slider values increases, decrease value of zoom level
            zoomLevel = 0.07 / (zoomLevel * 2)
        }
        //var zoomLevel = CLLocationDegrees(sender.value)
        // set new delta for span
        let span = MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel)
        // get center region
        let center = map.region.center
        // open the map on center with given span
        let region = MKCoordinateRegion(center: center, span: span)
        // display map
        map.setRegion(region, animated: true)
    }
    
    // function to update travel mode to car
    @IBAction func setTravelModeToCar(_ sender: UIButton) {
        travelMode = "car"
        // function call to display travel route
        self.mapThis(sourceCoordinate: self.sourceCoordinate! , destinationCoordinate: self.destinationCoordinate!)
    }
    
    // function to update travel mode to walk
    @IBAction func setTravelModeToWalk(_ sender: UIButton) {
        travelMode = "walk"
        // function call to display travel route
        self.mapThis(sourceCoordinate: self.sourceCoordinate! , destinationCoordinate: self.destinationCoordinate!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // function to open Add New To Do Dialog
    func OpenChangeCityDialg(){
        totalDistance.text = ""
        // ask user to enter destination
        let alertDialog = UIAlertController(title:"Where would you like to go?",message:"Enter Destination",preferredStyle: .alert)
        // text field for start location
        alertDialog.addTextField{(textField) in
            textField.placeholder="Start Location"
            if let city = self.fromCity, !city.isEmpty {
                textField.text = city
            }
        }
        // text field for end location
        alertDialog.addTextField{(textField) in
            textField.placeholder="End Location"
            if let city = self.toCity, !city.isEmpty {
                textField.text = city
            }
        }
        // cancel button
        let cancelAction = UIAlertAction(title:"Cancel",style: .cancel,handler:nil)
        alertDialog.addAction(cancelAction)
        
        // start and end location text fields
        let insertAction = UIAlertAction(title:"Direction",style: .destructive) { [self] action in
            let fromLocation = alertDialog.textFields?.first?.text ?? ""
            let toLocation = alertDialog.textFields?[1].text ?? ""
            if(fromLocation.isEmpty){
                // if start location is not added then show alert
                showAlert(title:"",message:"Please enter start location")
            }else if(toLocation.isEmpty){
                // if end location is not added then show alert
                showAlert(title:"",message:"Please enter end location")
            }else{
                // fetch location coordinates from city name for start location
                self.convertAddress(fromLocation) { location in
                    if let sourceCor = location {
                        // display start location on map
                        self.render(sourceCor)
                        // getch location coordinates from to city for end location
                        self.convertAddress(toLocation) { location in
                            // if both location found then
                            if let destinationCor = location {
                                // store values in variables
                                self.fromCity = fromLocation
                                self.toCity = toLocation
                                self.sourceCoordinate = sourceCor.coordinate
                                self.destinationCoordinate = destinationCor.coordinate
                                // function call to display route path on the map
                                self.mapThis(sourceCoordinate: self.sourceCoordinate! , destinationCoordinate: self.destinationCoordinate!)
                            } else {
                                // Handle the case where no location is found
                                self.showAlert(title: "Location Not Found", message: "End location not found, please try with another location")
                            }
                        }
                    } else {
                        // Handle the case where no location is found
                        self.showAlert(title: "Location Not Found", message: "Start location not found, please try with another location")
                    }
                }
                
              
                
                
            }
            
        }
        // add textfields in dialog
        alertDialog.addAction(insertAction)
        // open dialog
        present(alertDialog,animated: true,completion: nil)
    }
    
    // function to fetch coordinates from city name using go coder
    func convertAddress(_ cityName: String, completion: @escaping (CLLocation?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(cityName) { (placemarks, error) in
            if error != nil {
                completion(nil)
                self.showAlert(title: "Error", message: "Error while fetching location coordinates")
                return
            }
            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                completion(nil)
                return
            }
            // return coordinates
            completion(location)
        }
    }

    
  
    // function to display map with route
    func mapThis(sourceCoordinate:CLLocationCoordinate2D,destinationCoordinate:CLLocationCoordinate2D){
        // remove any previous overlays
        self.map.removeOverlays(map.overlays)
        // source
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        // dstination
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let destinationRequest = MKDirections.Request()
        
        //start and end
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem
        
        // set travel mode
        if let mode = travelMode, mode.isEmpty || mode == "car"{
            destinationRequest.transportType = .automobile
        }else if(travelMode == "walk"){
            destinationRequest.transportType = .walking
        }
       
        // multiple routes false
        destinationRequest.requestsAlternateRoutes = false
        
        // submit request to calculate directions
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            // if there is a response make it the response else make error
            guard let response = response else {
                if error != nil {
                    print("something went wrong")
                }
                return
            }
            
            //first rsponse
            let route = response.routes[0]
            // distance
            let distance = route.distance
            
            // display total distance on view
            self.totalDistance.text = "Distance : " + String(format: "%.2f", distance/1000) + " km"
            
            // adding overlay to routes
            self.map.addOverlay(route.polyline)
            self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            // setting endpoint pin
            let pin = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D (latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude )
            pin.coordinate = coordinate
            pin.title = "END POINT"
            self.map.addAnnotation(pin)
            // function call to add history to core data
            self.addHistory(distance,self.travelMode ?? "Car")
        }
    }
    
    // render overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let routeLine = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        routeLine.strokeColor = .purple
        return routeLine
    }
    
    // render location on map
    func render(_ location:CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        // set span
        let span = MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        // set pin
        let pin = MKPointAnnotation()
        pin.coordinate=coordinate
        map.addAnnotation(pin)
        // display region with pin
        map.setRegion(region, animated: true)
        
    }
    
    // function to add history
    func addHistory(_ distance : Double, _ travelMode : String){
        if let source = source, !source.isEmpty {
            // history context
            let history = NavigationHistory(context: context)
            // intercation source
            history.source = source
            // intercation type set to Map
            history.interactionType = Constants.InteractionType.MAP
            //  city
            history.city = fromCity
            // start location
            history.from = fromCity
            // end location
            history.to = toCity
            // total distance
            history.totalDistance = String(format: "%.2f", distance/1000) + " km"
            // travel mode
            history.travelMode = travelMode
            // current date time
            history.createdAt = Date()
            
            do{
                // save history
                try context.save()
                
            }catch{
                print("Error while adding new To Do Item")
            }
        }
    }
    // dismiss keyboard
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
}
