//
//  Lab2.swift
//  Dhrutiben_Dalwadi_MT_8968192
//
//  Created by user237515 on 2/29/24.
//

import UIKit

class Lab2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    var result = 0
    var step = 1
    @IBOutlet weak var counter: UILabel!
    
    
    @IBOutlet weak var nextStepValue: UIButton!
    
    @IBAction func increment(_ sender: UIButton) {
        
        counter.text = "\(result) + \(step) = \(result+step)"
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
        nextStepValue.setTitle("Step = 2", for: .normal)
    }
    
    
    @IBAction func stepToggle(_ sender: UIButton) {
        sender.setTitle("Step = \(step)", for: .normal)
        if step==1 {
            step=2
            
        }else{
            step=1
        }
        currentStep.text=String(step)
    }
    
    
    @IBOutlet weak var currentStep: UILabel!

}
