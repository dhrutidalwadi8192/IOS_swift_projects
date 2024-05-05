//
//  CarData.swift
//  Dhrutiben_Dalwadi_MT_8968192
//
//  Created by user237515 on 3/1/24.
//

import UIKit

class CarData{
    static let shared = CarData()

    struct Car {
        var name: String
        var image: UIImage
    }

    // Create an array of Car structures
     var cars: [Car] = []
     init() {
        cars.append(Car(name: "BMW", image: UIImage(named: "BMW.jpeg")!))
        cars.append(Car(name: "Ford", image: UIImage(named: "Ford.jpeg")!))
        cars.append(Car(name: "GMC", image: UIImage(named: "GMC.jpeg")!))
        cars.append(Car(name: "Honda", image: UIImage(named: "Honda.jpeg")!))
        cars.append(Car(name: "Jeep", image: UIImage(named: "JEEP.jpeg")!))
        cars.append(Car(name: "Volvo", image: UIImage(named: "Volvo.jpeg")!))
    }
}
