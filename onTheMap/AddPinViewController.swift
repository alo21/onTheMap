//
//  AddPinViewController.swift
//  onTheMap
//
//  Created by Alessandro Losavio on 06/03/2019.
//  Copyright © 2019 Losavio. All rights reserved.
//

import UIKit

class AddPinViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var location_Input: UITextField!
    @IBOutlet weak var website_Input: UITextField!
    var currentTappedTextField : UITextField?
    @IBOutlet weak var findPlaceButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.location_Input.delegate = self
        self.website_Input.delegate = self

        // Do any additional setup after loading the view.
    }
   
    //Hide keyboard when hit return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    
    @IBAction func onFindLocationPressed(_ sender: UIButton) {
        
        
        
    }
    
    
    
    //Setting current TextField selected
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTappedTextField = textField
                
        return true
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func getWebsiteFieldPositions() -> CGFloat {
        
        let frm: CGRect = website_Input.frame
        
        return frm.origin.y
        
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        
       /* print(getKeyboardHeight(notification) - getWebsiteFieldPositions())
        
        if (currentTappedTextField == website_Input && (getKeyboardHeight(notification) - getWebsiteFieldPositions()) <= 0) {
            
            view.frame.origin.y = -getKeyboardHeight(notification) + 25
        
        } else if (currentTappedTextField == location_Input && (getKeyboardHeight(notification) - getWebsiteFieldPositions()) <= 0) {
            
            view.frame.origin.y = -getKeyboardHeight(notification) + 50
        }*/
        
    }
    
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func findLocation(_ sender: Any) {
        
        save()
        
    }
    
    
    func save() {
        
        let infoToSave = StudentInformation(objectId: "nil", uniqueKey: "nil", firstName: "nil", lastName: "nil", mapString: self.location_Input.text, mediaURL: self.website_Input.text, latitude: nil, longitude: nil, createdAt: nil, updatedAt: nil)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.infoToAdd = infoToSave
        
    }

}
