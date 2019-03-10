//
//  ViewController.swift
//  onTheMap
//
//  Created by Alessandro Losavio on 26/02/2019.
//  Copyright © 2019 Losavio. All rights reserved.
//

import UIKit
import LocalAuthentication


class ViewController: UIViewController, UITextFieldDelegate{
    
    struct LoginInfo: Codable {
        let username: String
        let password: String
    }
    
    
    @IBOutlet var Email_Input: UITextField!
    @IBOutlet weak var Password_Input: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    var currentTappedTextField : UITextField?
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var NoAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Email_Input.delegate = self
        self.Password_Input.delegate = self
        
        LoginButton.isEnabled = false
        
        
    }
    

    func alertError(message: String) {
        
        print("Show error alert")
        
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    
    @IBAction func EditingDidEnd(_ sender: UITextField) {
    
        LoginButton.isEnabled = !Email_Input.text!.isEmpty && !Password_Input.text!.isEmpty
        
    }
    
    
    @IBAction func EditingDidBegin(_ sender: UITextField) {
        
        LoginButton.isEnabled = !Email_Input.text!.isEmpty && !Password_Input.text!.isEmpty
        
        
    }
    
    @IBAction func noAccountPressed(_ sender: UIButton) {
        let app = UIApplication.shared
        app.open(URL(string: "http://udacity.com")!)
        
    }
    
    
    @IBAction func onLoginPressed(_ sender: UIButton) {
        
        let user = LoginInfo(username: Email_Input.text!, password: Password_Input.text!)
        
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = .black
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        authenticate(user: user, completionHandeler: {self.goToMapViewController()})
        
    }
    
    
    
    
    
    func goToMapViewController() {
    
        
       DispatchQueue.main.async {
        
        self.activityIndicator.stopAnimating()
        
            let secondViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainNavigationController")

            self.present(secondViewController, animated: true, completion: nil)
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                
        textField.resignFirstResponder()
        return true
    }
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    //Setting current TextField selected
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTappedTextField = textField
        return true
    }
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if (currentTappedTextField == Password_Input) {
            
            view.frame.origin.y -= getKeyboardHeight(notification)/2
        }
        
    }
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
        
    }
    
    func authenticate(user: LoginInfo, completionHandeler: @escaping()->Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        
        //request.httpBody = try! JSONEncoder().encode(user)
        
        let LoginData = LoginPost(udacity: PersonalInfo(username: user.username, password: user.password))
        
        
        guard let LoginRequestBody = try? JSONEncoder().encode(LoginData) else {
            
            print("Unable to encode LoginData")
            return
            
        }
        
        request.httpBody = LoginRequestBody
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil { // Handle error…
                
                print("Eerrore")
                
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                    self.alertError(message: "Unable to comunicate with the server Try later")
                    
                }
                
                
                print("Fine errore")
                return
            }
            
            
            guard let data = data else {
                
                print("No data")
                return
            }
            
            do {
                
                
                
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                
                print(String(data: newData, encoding: .utf8)!)
                
                guard let ErrorLoginResponse = try? JSONDecoder().decode(LoginResult.self, from: newData) else  {
                    
                    let SuccessLoginResponse = try JSONDecoder().decode(SuccessLoginResult.self, from: newData)
                
                    if SuccessLoginResponse.account.registered {
                        //print(newData)*/
                        print("Data fine")
                        completionHandeler()
                    }
                    
                    return
                    
                }
                    
                if ErrorLoginResponse.status == 403 {
                    
                    DispatchQueue.main.async {
                        self.alertError(message: "Invalid credentials")
                        self.activityIndicator.stopAnimating()
                    }

                        
                    return
                        
                    }
                
            } catch {
                
                
                print("Something went wrong")
                print(error)
                
            }
            
            
            
        }
        task.resume()
        
        
        
    }
    

}

