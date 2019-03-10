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
    
    var infoToSend: StudentInformationSend {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.infoToSend
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
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
                let infoToSave = StudentInformationSend(uniqueKey: "alos", firstName: "Alfredo", lastName: "Gatti", mapString: self.passedInfo.mapString, mediaURL: self.passedInfo.mediaURL, latitude: latitude, longitude: longitude, createdAt: nil, updatedAt: nil)
                
                
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.infoToSend = infoToSave
                                
            }
            
        }
    }
    
    
    func alertError(message: String) {
        
        print("Show error alert")
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func sendMapInformation(completionHandler: @escaping()->Void){
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(infoToSend)
        
        
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                
                print("Something didn't work")
                
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                    self.alertError(message: "Unable to comunicate with the server Try later")
                    
                    
                }
                
                return
                
            }
            
            print(String(data: data!, encoding: .utf8)!)
            completionHandler()
        }
        task.resume()
        
        
        
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
        
        sendMapInformation(completionHandler: {self.goBack()})
        
        
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
