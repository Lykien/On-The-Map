//
//  StudentTableViewController.swift
//  On The Map
//
//  Created by Nils Riebeling on 06.11.19.
//  Copyright © 2019 Nils Riebeling. All rights reserved.
//

import UIKit

class StudentTableViewController: UIViewController {

    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshStudentLocationsButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    
    
    //MARK:IBActions
    
    //IBAction to check if the user already set a location
    @IBAction func userLocationButton(_ sender: Any) {
        
        UdacityAPI.getStudentLocationById { (studentLocation, error) in
            if !studentLocation.isEmpty {
                self.showLocationMessage(message: OTMError.locationAlreadySet(location: studentLocation.first?.mapString ?? "").localizedDescription)
            }else {
                
                self.performSegue(withIdentifier: "setUserLocation", sender: nil)
            }
        }
    }
    var studentsLocations = [StudentLocation]()
    
    
    //IBAction to refresh the locations
    @IBAction func refreshStudentLocations(_ sender: Any) {
        handleActivityIndicator(activate: true, button: self.refreshStudentLocationsButton)
        handleMapUpdate()
    }
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        self.handleActivityIndicator(activate: true, button: self.logoutButton)
        handleLogout()
    }
    
    
    //MARK:Override
    override func viewDidLoad() {
        super.viewDidLoad()
       
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleActivityIndicator(activate: true, button: self.refreshStudentLocationsButton)
        handleMapUpdate()
        
    }
    
    //Request new location data from interface
    func handleMapUpdate(){
        
        _ = UdacityAPI.getAllStudentLocations(limit: "100", skip: "0", orderBy: "-updatedAt") { (studentsLocations, error) in
            
            if error == nil {
                self.studentsLocations = studentsLocations
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.handleActivityIndicator(activate: false, button: self.refreshStudentLocationsButton)
                }

            }else {
                
                DispatchQueue.main.async {
                    self.handleActivityIndicator(activate: false, button: self.refreshStudentLocationsButton)
                self.showLocationMessage(message: OTMError.dataUpdateFailed.localizedDescription)
                }
            }
                     
              }
        
    }
    
    //Shows an aleart if the user has already set a location
    func showLocationMessage(message: String) {
        let alertVC = UIAlertController(title: "Location Information", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Override", style: .default) { (action) in
            self.performSegue(withIdentifier: "setUserLocation", sender: nil)
        }


        let cancelAction = UIAlertAction(title: "Cancel",
                             style: .cancel) { (action) in
         
        }
        
        
        alertVC.addAction(defaultAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //Handle activity indicator
    func handleActivityIndicator(activate: Bool, button: UIBarButtonItem?){
        
        self.activityIndicator.isHidden = !activate
        
        if button != nil {
            button!.isEnabled = !activate
        }
        
        if activate {
        self.activityIndicator.startAnimating()
        }else {
            
        self.activityIndicator.stopAnimating()
            
        }
        
    }
    
    //Handle logout by deactivation of session and forwarding to login page
    func handleLogout() {
        UdacityAPI.deleteSession { (success, error) in
            if success {
                
                DispatchQueue.main.async {
                    self.handleActivityIndicator(activate: false, button: self.logoutButton)
                    self.performSegue(withIdentifier: "logout", sender: nil)
                }
                
            } else {
                self.handleActivityIndicator(activate: false, button: self.logoutButton)
                self.showLocationMessage(message: OTMError.logoutFailed.localizedDescription)
                
            }
        }
    }
    
        
}

//MARK: Extention UITableViewDataSource, UITableViewDelegate
//Extends the StudentTableViewController to create the table for the locations
extension StudentTableViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.studentsLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentsTableViewCell")!
        
        cell.textLabel?.text = studentsLocations[indexPath.row].firstName +  " " + studentsLocations[indexPath.row].lastName
        cell.detailTextLabel?.text = studentsLocations[indexPath.row].mediaURL 
    

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = URL(string: studentsLocations[indexPath.row].mediaURL) {
            UIApplication.shared.open(url)
        }
    }
    
    
    

    

}

