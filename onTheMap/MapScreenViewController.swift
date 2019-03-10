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
    
    
    var myInfo: StudentInformation!
    //var StudentsArray: [StudentInformation] = []

    
    
    var StudentsArray: [StudentInformation] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.Students
    }
 

    @IBOutlet var mapView: MKMapView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*GeneralTabView().getStudentData() {
            
            self.createAnnotations()
            
            
        }*/
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        GeneralTabView().getStudentData() {
            
            self.createAnnotations()
            
            
        }

        
    }
    
    func reloadMap (){
        
        print("ReloadMap")
        
        print(mapView)
        
        GeneralTabView().getStudentData() {
            self.createAnnotations()
            
        }
        
    }
    
    
    //MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    //Method implemented to respond to taps
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {

                app.open(URL(string: toOpen)!)
            }
        }
    }
    
    
    
    
    
  
    /* func getStudentData() {
        
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
                        
                        appDelegate.Students.append(student)
                        
                    }
                    
                    print("Done getting data")
                    
                    
                }
                
                
                
                
            } catch {
                let myError = error as NSError
                print("Qualcosa non va")
                print(error)
                
            }
            
        }
        task.resume()
                
    } */
    
    

    func createAnnotations() {
        
        print("Lol")
        
        for student in StudentsArray {
            
            if(student.latitude == nil || student.longitude == nil || student.mapString == nil || student.mediaURL == nil){
                continue
            }
            
            let annotations = MKPointAnnotation()
            annotations.title = student.mapString
            annotations.subtitle = student.mediaURL
            annotations.coordinate = CLLocationCoordinate2D(latitude: student.latitude!, longitude: student.longitude!)
            
            
            mapView.addAnnotation(annotations)
            
        }
        
        
    }

}
