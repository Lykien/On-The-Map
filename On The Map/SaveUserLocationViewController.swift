//
//  SaveUserLocationViewController.swift
//  On The Map
//
//  Created by Nils Riebeling on 17.11.19.
//  Copyright © 2019 Nils Riebeling. All rights reserved.
//

import UIKit
import MapKit

class SaveUserLocationViewController: UIViewController {
    
    //MARK: VARs
    //Define default user location
    var userLocation = MapPin(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(39.92888890), longitude: CLLocationDegrees(116.38833330)), title: "Berlin")
    
    //MARK: IBOutlet
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addLink: UITextField!
    @IBOutlet weak var saveStudentButton: UIButton!
    @IBOutlet weak var studentLocation: MKMapView!
    
    
    //MARK: IBAction
    @IBAction func dismissKeyboard(_ sender: UITextField) {
        
        sender.resignFirstResponder()
    }
    
    @IBAction func saveStudentLocation(_ sender: UIButton) {
        self.handleActivityIndicator(activate: true, button: self.saveStudentButton)
        handleLocationUpdate(location: userLocation)
    }
    
    
    //MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        handleActivityIndicator(activate: false, button: nil)
        self.studentLocation.addAnnotation(self.userLocation)
        self.studentLocation.setCenter(self.userLocation.coordinate, animated: true)
        
    }
    
    //MARK: Helper
    //Helper to check if the location is already set. Based on the result it will make an update or creates a new user location
    func handleLocationUpdate(location: MKAnnotation){
        
        UdacityAPI.getStudentLocationById { (studentLocationResults, error) in
            
            if var studentLocation = studentLocationResults.first {
                studentLocation.latitude = location.coordinate.latitude
                studentLocation.longitude = location.coordinate.longitude
                studentLocation.mapString = location.title as! String
                studentLocation.mediaURL = self.addLink.text ?? ""
                
                UdacityAPI.updateStudentLocation(studentLocation: studentLocation) { (success, error) in
                    
                    if success {
                        DispatchQueue.main.async {
                            self.handleActivityIndicator(activate: false, button: self.saveStudentButton)
                        }
                        
                        self.dismiss(animated: true, completion: nil)
                    }else {
                        
                        DispatchQueue.main.async {
                            self.handleActivityIndicator(activate: false, button: self.saveStudentButton)
                            self.showFailure(message: OTMError.dataUpdateFailed.localizedDescription)
                        }
                    }
                    
                }
                
            } else {
                let studentLocation = StudentLocation(objectId: "", uniqueKey: UdacityAPI.Auth.accountId, firstName: UdacityAPI.Auth.user?.firstName ?? "", lastName: UdacityAPI.Auth.user?.lastName ?? "", mapString: location.title!!, mediaURL: self.addLink.text ?? "", latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, createdAt: nil, updatedAt: nil)
                
                UdacityAPI.addStudentLocation(studentLocation: studentLocation) { (success, error) in
                    
                    if success {
                        
                        DispatchQueue.main.async {
                            self.handleActivityIndicator(activate: false, button: self.saveStudentButton)
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            self.handleActivityIndicator(activate: false, button: self.saveStudentButton)
                            self.showFailure(message: OTMError.dataUpdateFailed.localizedDescription)
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    func handleActivityIndicator(activate: Bool, button: UIButton?){
        
        self.activityIndicator.isHidden = !activate
        
        if button != nil {
            button!.isEnabled = !activate
            
            if activate {
                button!.backgroundColor = .gray
            }else {
                button!.backgroundColor = UIColor(displayP3Red: -0.316305, green: 0.710685, blue: 0.914563, alpha: 1)
            }
        }
        
        if activate {
            self.activityIndicator.startAnimating()
        }else {
            
            self.activityIndicator.stopAnimating()
            
        }
        
    }
    
    //Func to show an alert
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Save Location", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

