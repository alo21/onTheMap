//
//  ViewController.swift
//  onTheMap
//
//  Created by Alessandro Losavio on 26/02/2019.
//  Copyright © 2019 Losavio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    struct LoginInfo: Codable {
        let username: String
        let password: String
    }
    
    
    @IBOutlet var Email_Input: UITextField!
    @IBOutlet weak var Password_Input: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Email_Input.delegate = self
        self.Password_Input.delegate = self
        
        LoginButton.isEnabled = false
        
        
    }
    

    func alertError() {
        
        print("Show error alert")
        
            let alert = UIAlertController(title: "Alert", message: "Check your internet connection", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        
    }
    
    
    
    @IBAction func EditingDidEnd(_ sender: UITextField) {
    
        LoginButton.isEnabled = !Email_Input.text!.isEmpty && !Password_Input.text!.isEmpty
        
    }
    
    
    @IBAction func EditingDidBegin(_ sender: UITextField) {
        
        LoginButton.isEnabled = !Email_Input.text!.isEmpty && !Password_Input.text!.isEmpty
        
        
    }
    
    @IBAction func onLoginPressed(_ sender: UIButton) {
        
        let user = LoginInfo(username: Email_Input.text!, password: Password_Input.text!)
        
        authenticate(user: user)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                
        textField.resignFirstResponder()
        return true
    }
    
    func authenticate(user: LoginInfo) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        
        //request.httpBody = try! JSONEncoder().encode(user)
        
        let baseString = "{\"udacity\": {\"username\": \"" + user.username + "\", \"password\": \""
            + user.password + "\"}}"

        
        request.httpBody = baseString.data(using: .utf8)

        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil { // Handle error…
                
                print("Eerrore")
                
                DispatchQueue.main.async {
                    
                    self.alertError()
                    
                
                }
                
                
                print("Fine errore")
                return
            }
            
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            print("Data inizio")
            print(String(data: newData!, encoding: .utf8)!)
            print("Data fine")
        }
        task.resume()
    }
    

}

