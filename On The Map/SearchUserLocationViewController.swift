//
//  UserLocationViewController.swift
//  On The Map
//
//  Created by Nils Riebeling on 11.11.19.
//  Copyright © 2019 Nils Riebeling. All rights reserved.
//

import UIKit
import MapKit

class SearchUserLocationViewController: UIViewController {


    //MARK: VARs
    //Define default user location
    var userLocation = MapPin(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(39.92888890), longitude: CLLocationDegrees(116.38833330)), title: "")
        
    //MARK:IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    
    //MARK: IBActions
    @IBAction func dismissKeyboard(_ sender: UITextField) {
        
        sender.resignFirstResponder()
    }
    //Button to cancel by dismissing the view
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //Button to start the search of the location
    @IBAction func searchLocationButton(_ sender: UIButton) {
        sender.resignFirstResponder()
        if let location = enterLocationTextField.text{
            handleActivityIndicator(activate: true, button: self.findLocationButton)
            handleGeoSearch(adressString: location)
        }
    }

    //MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        handleActivityIndicator(activate: false, button: nil)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Subscribe the Notification for the Keyboard
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           
           //Unsubscribe the Notification for the Keyboard
           unsubscribeFromKeyboardNotifications()
       }
    
    
    //MARK:Helper
    //Helper to search the user location
    func handleGeoSearch(adressString: String){
        
        if enterLocationTextField.hasText{
        let geocoder = CLGeocoder()
              geocoder.geocodeAddressString(adressString) { (placemark, error) in
                  if let placemarks = placemark{
                      
                      //Annotation will be set to default. In case of empty placemark, we will store the default location.

                      if !placemark!.isEmpty {
                        self.userLocation = MapPin(coordinate: placemarks.first!.location!.coordinate , title: placemarks.first!.name ?? "")
                        
                        DispatchQueue.main.async {
                            self.handleActivityIndicator(activate: false, button: self.findLocationButton)
                            self.performSegue(withIdentifier: "addLocationInformation", sender: nil)
                        }
                        
                         
                      }else{
                        DispatchQueue.main.async {
                            self.handleActivityIndicator(activate: false, button: self.findLocationButton)
                            self.showFailure(message: OTMError.locationNotFound(location: adressString).localizedDescription)
                        }
                        
                    }
   
                  }else{
                    
                    DispatchQueue.main.async {
                        self.handleActivityIndicator(activate: false, button: self.findLocationButton)
                        self.showFailure(message: OTMError.geoCodingFailed.localizedDescription)
                    }
                    
                }
              }
            
        }
        
        else {
            self.handleActivityIndicator(activate: false, button: self.findLocationButton)
            showFailure(message: OTMError.noTextfieldInput(field: "Location ").localizedDescription)
        }
    }
    
    //Function to transfer userLocation to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let saveUserLocationViewController = segue.destination as? SaveUserLocationViewController {
            saveUserLocationViewController.userLocation = userLocation
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
        let alertVC = UIAlertController(title: "Location", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    //MARK: Keyboard helper to shift view
    func subscribeToKeyboardNotifications(){
           
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

       }
       func unsubscribeFromKeyboardNotifications() {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
       @objc func keyboardWillShow(_ notification:Notification) {
           
           //Just when the bottom text will be changed then the keyboard sould move up the frame
           if enterLocationTextField.isFirstResponder {
           view.frame.origin.y = -getKeyboardHeight(notification)
           }
           
       }
       
       @objc func keyboardWillHide(_ notification:Notification){
           self.view.frame.origin.y = 0
       }
       
       func getKeyboardHeight(_ notification:Notification) -> CGFloat {
           let userInfo = notification.userInfo
           let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
           return keyboardSize.cgRectValue.height
       }
    
    
    
    
    
}


//MARK: Keyboard extention
extension SearchUserLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
}
