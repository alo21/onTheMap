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
    
    
    func alertError(message: String) {
        
        print("Show error alert")
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        NetworkRequests().getStudentsData(
            
            completionHandler: {
                self.createAnnotations()
                
        }, errorHandler: {error in
                
                self.alertError(message: error.localizedDescription)
                
            }
        )
        

        
    }
    
    func reloadMap (){
        
        print("ReloadMap")
        
        print(mapView)
        
        /*NetworkRequests().getStudentsData {
            self.createAnnotations()
            
        }*/
        
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
