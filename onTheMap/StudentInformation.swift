//
//  Student.swift
//  onTheMap
//
//  Created by Alessandro Losavio on 03/03/2019.
//  Copyright © 2019 Losavio. All rights reserved.
//

import Foundation


struct StudentInformation: Codable {
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    var mapString: String?
    var mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String?
    let updatedAt: String?
}

var studentsArrayGloabl: [StudentInformation] = []
var infoToSave = StudentInformation(objectId: "nil", uniqueKey: "nil", firstName: "nil", lastName: "nil", mapString: "nil", mediaURL: "nil", latitude: nil, longitude: nil, createdAt: nil, updatedAt: nil)


class StudentsInformationClass {

    
    
    

    func getStudentsInformationArray() -> [StudentInformation] {
        
        print(studentsArrayGloabl)
        return studentsArrayGloabl
    }
    
    func getLocation()->String{
        
        return infoToSave.mapString!
        
    }
    
    func getURL()->String{
        
        return infoToSave.mediaURL!
        
    }
    
    
    func saveStudentsInformationArray(studentsArray: [StudentInformation]) {
        
        studentsArrayGloabl = studentsArray
        
    }
    
    func saveLocationaAndUrl(mapString: String, mediaURL: String)  {
        
        infoToSave.mediaURL = mediaURL
        infoToSave.mapString = mapString
    }
    
    

}
