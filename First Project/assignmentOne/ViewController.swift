//
//  ViewController.swift
//  assignmentOne
//
//  Created by user237515 on 1/19/24.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var result = 0
    var step = 1
    
    @IBOutlet weak var counter: UILabel!
    
    
    
    @IBAction func increment(_ sender: UIButton) {
        
        counter.text =
        "\(result) + \(step) = \(result+step)"
        result+=step
    }
    
    
    @IBAction func decrement(_ sender: UIButton) {
        
        counter.text = "\(result) - \(step) = \(result-step)"
        result-=step
       
    }
    
    
    @IBAction func reset(_ sender: UIButton) {
        result=0
        step=1
        counter.text=String(result)
        currentStep.text=String(step)
    }
    
    
    @IBAction func stepToggle(_ sender: UIButton) {
        if step==1 {
            step=2
        }else{
            step=1
        }
        currentStep.text=String(step)
    }
    
    
    @IBOutlet weak var currentStep: UILabel!
    
}

