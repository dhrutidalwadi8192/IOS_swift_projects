//
//  Carlist.swift
//  Dhrutiben_Dalwadi_MT_8968192
//
//  Created by user237515 on 2/29/24.
//

import UIKit

class Carlist: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // car listing table
    @IBOutlet weak var carListing: UITableView!
    
    // car listing - here car data coming from Car Controller (used segue prepare(for:) method )
    var cars :[Car.Car] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carListing.delegate = self
        carListing.dataSource = self
    }
    
    // return number of section - here it is static 1
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    // display car data in cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Car",for: indexPath) as! CarCell
        // for even and odd rows display different cell background color
        if ((indexPath.row % 2) == 0){
            cell.backgroundColor = .systemCyan
        }else{
            cell.backgroundColor = .lightGray
        }
        cell.carName.text = self.cars[indexPath.row].name
        cell.carImage.image = self.cars[indexPath.row].image
        return cell
    }

}
