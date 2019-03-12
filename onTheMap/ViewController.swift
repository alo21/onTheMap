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
    
    
    @IBOutlet weak var Email_Input: UITextField!
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
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    
    @IBAction func EditingChanged(_ sender: UITextField) {
        
        LoginButton.isEnabled = !Email_Input.text!.isEmpty && !Password_Input.text!.isEmpty
        
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
        activityIndicator.color = .white
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        NetworkRequests().authenticate(
            
            user: user,
                                       
            completionHandeler: {self.goToMapViewController()},
        
            errorHandler: {error in
                
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                    self.alertError(message: "Unable to comunicate with the server Try later")
                    
                }
            },
            
            loginError: {errorCode in
                
                if errorCode==403 {
                    
                    DispatchQueue.main.async {
                        
                        self.activityIndicator.stopAnimating()
                        self.alertError(message: "Check your internet connection please")
                        
                    }
                    
                } else if errorCode == 400 {
                    
                    DispatchQueue.main.async {
                        
                        self.activityIndicator.stopAnimating()
                        self.alertError(message: "Invalid credentials")
                        
                    }
                    
                }
    
            })
        
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
    
    
    
    @IBAction func EditingDidBegin(_ sender: Any) {
        
        print("Editing did begin")
        
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
        
        
        print("TextFieled - Keyborad: ")
        print(getTextFieldPosition(currentTappedTextField!) - getKeyboardHeight(notification))
        
        print("KeyBoard: ")
        print(getKeyboardHeight(notification))
        
        print("TextField: ")
        print(getTextFieldPosition(currentTappedTextField!))
        
        
        if (getTextFieldPosition(currentTappedTextField!) - getKeyboardHeight(notification)) <= 0 {
            
            print(getKeyboardHeight(notification) - getTextFieldPosition(currentTappedTextField!))
            
        }
        
    }
    
    
    func getTextFieldPosition(_ textField: UITextField)-> CGFloat{
        
        let frm: CGRect = textField.frame
        
        return frm.origin.y
        
    }
    
    
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
        
    }
}

