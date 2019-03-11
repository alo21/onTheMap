//
//  NetworkRequests.swift
//  onTheMap
//
//  Created by Alessandro Losavio on 11/03/2019.
//  Copyright © 2019 Losavio. All rights reserved.
//

import Foundation
import UIKit


class NetworkRequests: UIViewController {
    
    var StudentsArray: [StudentInformation] = []
    var myInfo: StudentInformation!
    
    
    
    func alertError(message: String) {
        
        print("Show error alert")
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }

    func getStudentsData(completionHandler: @escaping ()-> Void, errorHandler: @escaping (Error)->Void){
        
        print("Getting Student data")
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                
                errorHandler(error!)
                
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
                
                
                print(StudentResponse)
                
                
                
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
                    
                    completionHandler()
                    return
                    
                }
                
                
                
                
            } catch {
                let myError = error as NSError
                print("Qualcosa non va")
                print(myError)
                
            }
            
        }
        task.resume()
        
        
    }
    
    
    
    
    
    
    
    
    func authenticate(user: LoginInfo, completionHandeler: @escaping()->Void, errorHandler: @escaping(Error)->Void, loginError: @escaping(Int) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        
        //request.httpBody = try! JSONEncoder().encode(user)
        
        let LoginData = LoginPost(udacity: PersonalInfo(username: user.username, password: user.password))
        
        
        guard let LoginRequestBody = try? JSONEncoder().encode(LoginData) else {
            
            print("Unable to encode LoginData")
            return
            
        }
        
        request.httpBody = LoginRequestBody
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil { // Handle error…
                
                errorHandler(error!)
        
                return
            }
            
            
            guard let data = data else {
                
                print("No data")
                return
            }
            
            do {
                
                
                
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                
                print(String(data: newData, encoding: .utf8)!)
                
                guard let ErrorLoginResponse = try? JSONDecoder().decode(LoginResult.self, from: newData) else  {
                    
                    let SuccessLoginResponse = try JSONDecoder().decode(SuccessLoginResult.self, from: newData)
                    
                    if SuccessLoginResponse.account.registered {
                        //print(newData)*/
                        print("Data fine")
                        completionHandeler()
                    }
                    
                    return
                    
                }
                
                   loginError(ErrorLoginResponse.status)
                
                    return
                
                
            } catch {
                
                
                print("Something went wrong")
                print(error)
                
            }
            
            
            
        }
        task.resume()
        
        
        
    }
    
    
    
    
    
}
