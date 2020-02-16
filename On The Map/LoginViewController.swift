//
//  LoginViewController.swift
//  On The Map
//
//  Created by Nils Riebeling on 01.11.19.
//  Copyright © 2019 Nils Riebeling. All rights reserved.
//

import UIKit
import Network
class LoginViewController: UIViewController {

    //MARK:VARs
    let userDefaults = UserDefaults.standard
    let networkConnection = NWPathMonitor()
    
    //MARK: IBMOutlets
    @IBOutlet weak var eMailTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTextFields: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func dismissKeyboard(_ sender: UITextField) {
        
        sender.resignFirstResponder()
    }
    
    //MARK: IBMActions
    @IBAction func loginButton(_ sender: UIButton) {
        
        
        if eMailTextField.hasText, passwordTextFields.hasText {
            
            handleActivityIndicator(activate: true, button: self.loginButton)
            handleLogin()
            
        } else {
            
            self.showLoginFailure(message: OTMError.noTextfieldInput(field: "Username / Password").localizedDescription)
        }
    }
    @IBAction func signUpButton(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: "https://www.udacity.com")!)
        
        
    }
    
    
    //MARK: Override
    override func viewDidLoad() {

        super.viewDidLoad()
        handleActivityIndicator(activate: false, button: nil)

    }


    //MARK: Helper functions
    
    //Handle the login including session and the request for user data
    func handleLogin() {
        UdacityAPI.getUserSesssion(username: self.eMailTextField.text ?? " ", password: self.passwordTextFields.text ?? " ") { (success, error) in
            
            if success {
                
                UdacityAPI.getPublicUserData { (success, error) in
                    if success {
                        
                        DispatchQueue.main.async {
                        self.handleActivityIndicator(activate: false, button: self.loginButton)
                        self.performSegue(withIdentifier: "completeLogin", sender: nil)
                        }
                        
                    }else {
                        
                        DispatchQueue.main.async {
                            self.handleActivityIndicator(activate: false, button: self.loginButton)
                            self.showLoginFailure(message: OTMError.dataUpdateFailed.localizedDescription)
                        }
                        
                    }
                    
                }
            
            }
            else {
                
                //When no internet connection
                if (error as! NSError).code  == -1009 {
            
                    DispatchQueue.main.async {
                        self.handleActivityIndicator(activate: false, button: self.loginButton)
                        self.showLoginFailure(message: OTMError.noInternetConnection.localizedDescription)
                    }
                    
                }else {
            
                DispatchQueue.main.async {
                self.handleActivityIndicator(activate: false, button: self.loginButton)
                self.showLoginFailure(message: OTMError.incorrectUserCredentials.localizedDescription)
                }
            }
        }
    }
        
    }
    
    //Function to show an alert message, if something went wrong during the login process.
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    
    
//    //Handle the login button based on the indicator to avoid concurent requests
//    func prepareLoginButton(enabled: Bool) {
//
//        loginButton.isEnabled = enabled
//
//        if enabled {
//            loginButton.backgroundColor = UIColor(displayP3Red: -0.316305, green: 0.710685, blue: 0.914563, alpha: 1)
//        }else {
//          loginButton.backgroundColor = .gray
//        }
//    }
    
    
    //Handle activity indicator and change colour of the button
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
}
