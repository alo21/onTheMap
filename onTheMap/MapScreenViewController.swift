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
    

    
    /*var StudentsArray: [StudentInformation] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.Students
    }*/
 

    @IBOutlet var mapView: MKMapView!
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
    
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = .black
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        NetworkRequests().getStudentsData(
            
            completionHandler: {
                self.createAnnotations()
                
        }, errorHandler: {error in
            
            self.alertError(message: error.localizedDescription)
            
        })
        
        
        
    }
    
    
    func alertError(message: String) {
        
        print("Show error alert")
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

        
        

        }
    
    func reloadMap (){
        
        print("ReloadMap")
        
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
                
                guard let url = URL(string: toOpen) else {
                    
                    DispatchQueue.main.async {
                        self.alertError(message: "The link you have privoded doesn't have a valid format")
                    }
                    
                    return;
                    
                }

                app.open(url)
            }
        }
    }
    
    func createAnnotations() {
    
        let students = StudentsInformationClass().getStudentsInformationArray()
        
        
        print(students)
        
        for student in students {
            
            if(student.latitude == nil || student.longitude == nil || student.mapString == nil || student.mediaURL == nil){
                continue
            }
            
            let annotations = MKPointAnnotation()
            annotations.title = student.mapString
            annotations.subtitle = student.mediaURL
            annotations.coordinate = CLLocationCoordinate2D(latitude: student.latitude!, longitude: student.longitude!)
            
            
            mapView.addAnnotation(annotations)
            
        }
        
        activityIndicator.stopAnimating()
        
        
    }

}
