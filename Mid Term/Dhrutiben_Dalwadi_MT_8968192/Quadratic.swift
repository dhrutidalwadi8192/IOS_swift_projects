//
//  Quadratic.swift
//  Dhrutiben_Dalwadi_MT_8968192
//
//  Created by user237515 on 2/29/24.
//

import UIKit

class Quadratic: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // on load hide message and result view
        message.isHidden = true
        result.isHidden = true
       

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var a: UITextField!
    
   
    @IBOutlet weak var b: UITextField!
    
   
    @IBOutlet weak var c: UITextField!
    
    
    @IBOutlet weak var message: UILabel!
    
    
    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var reset: UIButton!
    
    
    // function to solve quadratic equations
    func solveQuadraticEquation(a:Double,b:Double,c:Double){
        // find discriminant
        let discriminant = b * b - 4 * a * c
        // hide message label
        message.isHidden = false
        // diplay value and message based on discriminant value
        if(discriminant<0){
        message.text = "There are no results since the discriminant is less than zero."
        }else if(discriminant == 0){
            let root = -b / (2 * a)
            message.text = "There is only one value for x"
            result.isHidden = false
            // display root value upto 2 decimal points
            result.text = "X = \(String(format: "%.2f", root))"
        }else{
            let root1 = (-b + sqrt(discriminant)) / (2 * a)
            let root2 = (-b - sqrt(discriminant)) / (2 * a)
            message.text = "There are two values of x"
            result.isHidden = false
            result.text = "1) X = \(String(format: "%.2f", root1)) \n2) X = \(String(format: "%.2f", root2)) "
        }
    }
    
    // function to check if value is valid real number
    func isRealNumber(_ input: String, valueFor:String ) -> Bool {
        // Attempt to convert the string to a Double
        if let _ = Double(input) {
            return true
        } else {
            // display alert dialog for invalid value
            showAlert(title: "Invalid Value", message: "The value you entered for \(valueFor) is invalid")
            return false
        }
    }
    
    // button click action to find value of x
    @IBAction func findValueOfX(_ sender: UIButton) {
        // reset message and result fields
        resetLabels()
        // dismiss keyboard
        view.endEditing(true)
        // assign text field values to variables
        let valueOfA = a.text ?? ""
        let valueofB = b.text ?? ""
        let valueOfC = c.text ?? ""
        
        // display alert message if user has not entered all three values
        if(valueOfA.isEmpty || valueofB.isEmpty || valueOfC.isEmpty){
            showAlert(title: "Missing Value", message: "Enter a value of A,B and C to Find X")
        }else{
            // if all entered values are valid then call function to solve equation
            if(isRealNumber(valueOfA, valueFor: "A") && isRealNumber(valueofB, valueFor: "B") && isRealNumber(valueOfC, valueFor: "C")){
                solveQuadraticEquation(a: Double(valueOfA) ?? 0, b: Double(valueofB) ?? 0, c: Double(valueOfC) ?? 0)

            }
        }
    }
    
    // function to reset fields
    @IBAction func resetFields(_ sender: UIButton) {
        a.text=""
        b.text=""
        c.text=""
        resetLabels()
        showAlert(title: "", message: "Enter a value of A,B and C to Find X")
    }
               // function to reset message and result views
    func resetLabels(){
        message.text = ""
        result.text = ""
        message.isHidden = true
        result.isHidden = true
    }
    
    // function to dismiss keyword
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
}
