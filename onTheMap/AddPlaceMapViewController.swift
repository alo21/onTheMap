//
//  AddPlaceMapViewController.swift
//  onTheMap
//
//  Created by Alessandro Losavio on 06/03/2019.
//  Copyright © 2019 Losavio. All rights reserved.
//

import UIKit
import MapKit

class AddPlaceMapViewController: UIViewController {
    
    var passedInfo: StudentInformation {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.infoToAdd
    }
    
    var infoToSend: StudentInformation {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.infoToSend
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = passedInfo.mapString
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start {(response, error) in
            
            if(response == nil) {
                print("No result")
            
            } else {
                
                let latitude = response?.boundingRegion.center.latitude
                
                let longitude = response?.boundingRegion.center.longitude
                
                
                
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.passedInfo.mapString
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                
                //Zooming to the coordinate
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                
                
                //Create object to save
                let infoToSave = StudentInformation(objectId: "nil", uniqueKey: "nil", firstName: nil, lastName: nil, mapString: self.passedInfo.mapString, mediaURL: self.passedInfo.mediaURL, latitude: latitude, longitude: longitude, createdAt: "nil", updatedAt: "nil")
                
                
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.infoToSend = infoToSave
                                
            }
            
        }
    }
    
    
    @IBAction func onFinishClicked(_ sender: Any) {
        
        print(infoToSend)
        
        
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
