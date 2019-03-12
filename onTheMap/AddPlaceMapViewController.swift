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
    
    var infoToSend = StudentInformationSend(uniqueKey: nil, firstName: nil, lastName: nil, mapString: nil, mediaURL: nil, latitude: nil, longitude: nil, createdAt: nil, updatedAt: nil)
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    func alertError(message: String) {
        
        print("Show error alert")
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishButton.isEnabled = false
        let userLocationString = StudentsInformationClass().getLocation()
        let userURL = StudentsInformationClass().getURL()

        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = userLocationString
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start {(response, error) in
            
            guard let mapKitError = error as? MKError else {
                
                guard (error as? URLError) != nil else {
                    
                    self.finishButton.isEnabled = true
                    
                    let latitude = response?.boundingRegion.center.latitude
                    
                    let longitude = response?.boundingRegion.center.longitude
                    
                    
                    
                    //Create annotation
                    let annotation = MKPointAnnotation()
                    annotation.title = userLocationString
                    annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                    self.mapView.addAnnotation(annotation)
                    
                    
                    //Zooming to the coordinate
                    let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    self.mapView.setRegion(region, animated: true)
                    
                    
                    //Create object to save
                    self.infoToSend = StudentInformationSend(uniqueKey: "alos", firstName: "Alfredo", lastName: "Gatti", mapString: userLocationString, mediaURL: userURL, latitude: latitude, longitude: longitude, createdAt: nil, updatedAt: nil)
                    
                    return
                    
                }
                
                    DispatchQueue.main.async {
                        self.alertError(message: error!.localizedDescription)
                        
                    }
                
                
                return
                
            }
            
            if(mapKitError.errorCode == 4){
                
                DispatchQueue.main.async {
                    self.alertError(message: "No location found")
                }
            }
            
            return
        }
    }
    
    func goBack() {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        
        
            //let MainNavigationController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainNavigationController")
            
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            
        }
        
        //self.present(MainNavigationController, animated: true, completion: nil)

        //self.navigationController?.popToViewController(MainNavigationController, animated: true)
        
        
    }
    
    
    
    @IBAction func onFinishClicked(_ sender: Any) {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = .black
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        NetworkRequests().sendMapInformation(infoToSend: infoToSend,
                           completionHandler: {self.goBack()},
                           errorHandler: {error in
                            
                            DispatchQueue.main.async {
                                
                                self.activityIndicator.stopAnimating()
                                self.alertError(message: error.localizedDescription)
                                
                                
                            }
                        
        })
        
        
    }
    

}
