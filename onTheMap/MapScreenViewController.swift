//
//  MapScreenViewController.swift
//  onTheMap
//
//  Created by Alessandro Losavio on 03/03/2019.
//  Copyright © 2019 Losavio. All rights reserved.
//

import UIKit
import MapKit

class MapScreenViewController: UIViewController, MKMapViewDelegate {
    
    
    var StudentsArray: [StudentInformation] = []
    var myInfo: StudentInformation!

    
    
    @IBOutlet var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getStudentData()
    }
    
    
    
    func getStudentData() {
        
        
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
                        
                        appDelegate.Students.append(student)
                        
                    }
                    
                }
                
                
                
                
                
            } catch {
                let myError = error as NSError
                print("Qualcosa non va")
                print(error)
                
            }
            
        }
        task.resume()
        
    }
    

    func createAnnotations() {
        
        print(StudentsArray)
        
        for student in StudentsArray {
            
            print(student)
            
            if(student.latitude == nil || student.longitude == nil){
                continue
            }
            
            let annotations = MKPointAnnotation()
            annotations.title = student.mapString
            annotations.coordinate = CLLocationCoordinate2D(latitude: student.latitude!, longitude: student.longitude!)
            
            mapView.addAnnotation(annotations)
            
        }
        
        
    }

}
