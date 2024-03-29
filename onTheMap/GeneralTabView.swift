//
//  GeneralTabView.swift
//  onTheMap
//
//  Created by Alessandro Losavio on 27/02/2019.
//  Copyright © 2019 Losavio. All rights reserved.
//

import UIKit

class GeneralTabView: UITabBarController {

    
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        NetworkRequests().logOutUser(completionHandler: {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
                print("dismissed")
            }
            
        } ,errorHandler: {error in
            
            DispatchQueue.main.async {
                self.alertError(message: error.localizedDescription)
            }
            
        });
    
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        



    }
    
    
    func alertError(message: String) {
        
        print("Show error alert")
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func getStudentData(completionHandeler:@escaping() -> Void) {
        
        
        NetworkRequests().getStudentsData(completionHandler: {
            
            self.presentMapViewAfterRefresh()
            
        }, errorHandler: { error in
            
            self.alertError(message: error.localizedDescription)
            
            
        })
        
    }
    
    
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        
        print("Refresh button pressed")
        
        self.getStudentData(completionHandeler: {
            
            print("Reloaded")
            
        })
        
    }
    
    
    func presentMapViewAfterRefresh() {
        
        let secondViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainNavigationController")
        
        self.present(secondViewController, animated: true, completion: nil)
        
    }

}
