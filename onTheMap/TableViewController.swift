//
//  TableViewController.swift
//  onTheMap
//
//  Created by Alessandro Losavio on 27/02/2019.
//  Copyright © 2019 Losavio. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var students: [StudentInformation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.Students
    }

        
    

    override func viewDidLoad() {
        super.viewDidLoad()
    

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.students.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentCell
        let student = self.students[(indexPath as NSIndexPath).row]
        
        if(student.firstName != nil && student.lastName != nil) {
        
        cell.fullnameLabel.text = student.firstName! + " " + student.lastName!
        cell.LinkText.text = student.mediaURL!
        
        }
        
        return cell
            
        

    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let app = UIApplication.shared
        if let toOpen = self.students[(indexPath as NSIndexPath).row].mediaURL {
            app.open(URL(string: toOpen)!)
        }
        
    }




}
