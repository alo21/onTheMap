//
//  GeneralTabView.swift
//  onTheMap
//
//  Created by Alessandro Losavio on 27/02/2019.
//  Copyright © 2019 Losavio. All rights reserved.
//

import UIKit

class GeneralTabView: UITabBarController {
    
    var StudentsArray: [StudentInformation] = []
    var myInfo: StudentInformation!

    
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true) {
            print("dismissed")
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    func getStudentData(completionHandeler:@escaping()->Void) {
        
        print("Getting Student data")
    
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            guard let data = data else {
                
                print("No data")
                return
            }
            
            do {
                                
                //var myData = String(data: data, encoding: .utf8)!
                let StudentResponse = try JSONDecoder().decode(StudentsInfoResults.self, from: data)
                self.StudentsArray = StudentResponse.results.map({$0})
                
                
                DispatchQueue.main.async {
                    
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                
                //Loop thrhough to save in shared
                    for student in self.StudentsArray {
                        
                    if(student.latitude != nil || student.longitude != nil){
                    
                        appDelegate.Students.append(student)
                        
                        }
                    }
                    
                    print("Done getting data")
                    
                    completionHandeler()
                    
                }
                
                
                
                
            } catch {
                let myError = error as NSError
                print("Qualcosa non va")
                print(error)
                
            }
            
        }
        task.resume()
        
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
