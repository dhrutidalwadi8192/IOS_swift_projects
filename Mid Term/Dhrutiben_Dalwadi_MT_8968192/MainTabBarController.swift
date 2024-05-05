//
//  MainTabBarController.swift
//  Dhrutiben_Dalwadi_MT_8968192
//
//  Created by user237515 on 3/8/24.
//

import UIKit

class MainTabBarController: UITabBarController , UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // set navigation title for Car screen , as first view is car scene
        navigationController?.navigationBar.topItem?.title = "Cars"

        // Do any additional setup after loading the view.
    }
    
    // function to change navigation bar title based on selected view
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        var title = "Cars"
        if viewController is Car{
            title = "Cars"
        }else if viewController is Calculator{
            title = "Quadratic Formula"
        }else if viewController is MyWork{
            title="My Work"
        }
        viewController.navigationController?.navigationBar.topItem?.title = title
            
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
