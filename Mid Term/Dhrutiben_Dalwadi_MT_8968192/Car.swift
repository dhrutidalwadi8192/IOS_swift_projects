//
//  Car.swift
//  Dhrutiben_Dalwadi_MT_8968192
//
//  Created by user237515 on 3/1/24.
//

import UIKit


class Car: UIViewController,UITextFieldDelegate {
    
    // declare car structure
    struct Car {
        var name: String
        var image: UIImage
    }
    
    // Create an array of Car structures
    var cars: [Car] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carNameToSearch.delegate = self
        

        
        //Insert car structures into the array
        cars.append(Car(name: "BMW", image: UIImage(named: "BMW.jpeg")!))
        cars.append(Car(name: "Ford", image: UIImage(named: "Ford.jpeg")!))
        cars.append(Car(name: "GMC", image: UIImage(named: "GMC.jpeg")!))
        cars.append(Car(name: "Honda", image: UIImage(named: "Honda.jpeg")!))
        cars.append(Car(name: "Jeep", image: UIImage(named: "JEEP.jpeg")!))
        cars.append(Car(name: "Volvo", image: UIImage(named: "Volvo.jpeg")!))
        
    }
    

    
    // function to pass car list data to carlist controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigtionViewController = segue.destination as? Carlist
        // pass car list
        navigtionViewController?.cars = cars;
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBOutlet weak var carName: UILabel!
    
    @IBOutlet weak var carImage: UIImageView!
    
    // search box
    @IBOutlet weak var carNameToSearch: UITextField!
    
    @IBAction func searchCar(_ sender: UIButton) {
        // call find user car function
        findUserCar()
    }
        
        // function to find Car from list based on user input
        func findUserCar(){
            let searchValue = carNameToSearch.text ?? ""
            var isFound = false;
            // fund user car from car list
            if !searchValue.isEmpty {
                for car in cars{
                    if(car.name.lowercased()==searchValue.lowercased()){
                        // set car name and image to view
                        carName.text=car.name
                        carImage.image=car.image
                        isFound = true
                        resetSearchBox()
                        break
                    }
                }
                if(!isFound){
                    // display alert dialog if car not found (Created extension to Showing Alert box throughout app (AlertController))
                    showAlert(title: "Not Found", message: "Car Not Found With Given Name")
                }
                
            } else {
                // display alert dialog if user hit search button without entering car name
                showAlert(title: "Enter Car Name", message: "Please Enter Car Name To Search")
                
            }
        }
        
        // function to reset search box
        func resetSearchBox(){
            carNameToSearch.text=""
        }
        
        // dismiss keyboard
        @IBAction func dismissKeyboard(_ sender: Any) {
            carNameToSearch.resignFirstResponder()
        }
        
       // search car when user press on Search from keypad
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            carNameToSearch.resignFirstResponder()
            // call find user car function
            findUserCar()
            return false
        }
        
    }

