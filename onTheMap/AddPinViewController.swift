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
    
    
    @IBAction func findLocation(_ sender: Any) {
        
        save()
        
    }
    
    
    func save() {
        
        let infoToSave = StudentInformation(objectId: "nil", uniqueKey: "nil", firstName: "nil", lastName: "nil", mapString: self.location_Input.text, mediaURL: self.website_Input.text, latitude: nil, longitude: nil, createdAt: "nil", updatedAt: "nil")
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.infoToAdd = infoToSave
        
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
