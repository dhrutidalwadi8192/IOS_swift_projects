//
//  Lab3.swift
//  Dhrutiben_Dalwadi_MT_8968192
//
//  Created by user237515 on 2/29/24.
//

import UIKit

class Lab3: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        message.isHidden = true
        userDetails.isHidden=true
        userDetails.layer.borderColor=getBlackColor()
        userDetails.layer.borderWidth = 3
        userDetails.layer.cornerRadius=5.0
        // set cursot at firstname
        //firstName.becomeFirstResponder()
        firstName.autocorrectionType = .no
        lastName.autocorrectionType = .no
        country.autocorrectionType = .no
        
        // Do any additional setup after loading the view.
    }

   
    // declare user as dictionary
    var user = ["userFirstName" :"","userLastName":"","userCountry":"","userAge": ""]
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!

    @IBOutlet weak var country: UITextField!
    
    @IBOutlet weak var age: UITextField!
    
    @IBOutlet weak var userDetails: UITextView!
    
    @IBOutlet weak var message: UILabel!
    
    
    // action when user click on view Details Button
    @IBAction func addDetails(_ sender: UIButton) {
        // function call to set value in view box
        userDetails.isHidden = false
        setControllerValues()
    }
    
    // action when user click on submit button
    @IBAction func submitDetails(_ sender: UIButton) {
        var isValid = true
        setControllerValues()
        userDetails.isHidden=false
        
        for (userKey,userValue) in user{
            if userValue.isEmpty{
                isValid=false
                switch(userKey){
                case "userFirstName":
                    firstName.layer.borderWidth=3
                    firstName.layer.borderColor = getRedColor()
                    break;
                case "userLastName":
                    lastName.layer.borderWidth=3
                    lastName.layer.borderColor = getRedColor()
                    break;
                case "userCountry":
                    country.layer.borderWidth=3
                    country.layer.borderColor = getRedColor()
                case "userAge":
                    age.layer.borderWidth=3
                    age.layer.borderColor = getRedColor()
                default:
                    break;
                }
                
            }
        }
        
        if !isValid {
         message.isHidden = false
         message.text = "Complete the missing info !"
         message.textColor = getRedUIColor()
        }else{
         resetTextFields()
         message.isHidden = false;
         resetControlsToValidState()
         message.textColor=getGreenUIColor()
         message.text = "Details Submitted Successfully!"
        }
          
    }
    
    // Reset function
    @IBAction func reset(_ sender: UIButton) {
        resetTextFields()
        userDetails.text = ""
        message.isHidden = true
        userDetails.isHidden = true
        message.text = ""
        //firstName.becomeFirstResponder()
    }
    
    func resetTextFields(){
        user = ["userFirstName" :"","userLastName":"","userCountry":"","userAge": ""]
        firstName.text = ""
        lastName.text = ""
        country.text = ""
        age.text = ""
        resetControlsToValidState()
    }
   
    func getBlackColor() -> CGColor{
        return  CGColor(red: 204.0/255.0, green: 204.0/255.0, blue:204.0/255.0, alpha: 1.0)
        
    }
    
    func getRedColor() -> CGColor{
        return  CGColor(red: 204.0/255.0, green: 0,blue: 0,alpha: 1.0)
        
    }
    
    func getRedUIColor() -> UIColor{
        return  UIColor(red:204.0/255.0,green: 0,blue: 0,alpha: 1.0)
    }
    
    
    func getGreenUIColor()-> UIColor{
        return  UIColor(red:0,green: 204.0/255.0,blue: 0,alpha: 1.0)
    }
    

               
    // Function to reset textfields border color
    func resetControlsToValidState(){
        firstName.layer.borderColor = getBlackColor()
        country.layer.borderColor = getBlackColor()
        lastName.layer.borderColor = getBlackColor()
        age.layer.borderColor = getBlackColor()
    }
    
    // Function to set user inputs into Textview and user dictionary
    func setControllerValues(){
        message.isHidden = true
        user["userFirstName"] = firstName.text ?? ""
        user["userLastName"] = lastName.text ?? ""
        user["userCountry"] = country.text ?? ""
        user["userAge"] = age.text ?? ""
    
       
        userDetails.text="Full Name : \(user["userFirstName"] ?? "") \(user["userLastName"] ?? "")"
        userDetails.text += "\nCountry : \(user["userCountry"] ?? "")"
        userDetails.text += "\nAge : \(user["userAge"] ?? "")"
    }
    
    // action when user start typing in firstname textfield
    @IBAction func handleFirstNameChange(_ sender: UITextField) {
        setControllerValues()
        if(firstName.layer.borderColor==getRedColor()){
            firstName.layer.borderColor=getBlackColor()
        }
    }
    
    // action when user start typing in lastname textfield
    @IBAction func handleLastNameChange(_ sender: UITextField) {
        setControllerValues()
        if(lastName.layer.borderColor==getRedColor()){
            lastName.layer.borderColor=getBlackColor()
        }
    }
    
    // action when user start typing in country textfield
    @IBAction func handleCountryChange(_ sender: UITextField) {
        setControllerValues()
        if(country.layer.borderColor==getRedColor()){
            country.layer.borderColor=getBlackColor()
        }
    }
    
    // action when user start typing in age textfield
    @IBAction func handleAgeChange(_ sender: UITextField) {
        setControllerValues()
        if(age.layer.borderColor==getRedColor()){
            age.layer.borderColor=getBlackColor()
        }
    }
    
    
    // dismiss keyword
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        //firstName.resignFirstResponder()
        view.endEditing(true)
    }

}
