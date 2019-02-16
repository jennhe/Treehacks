//
//  FirstViewController.swift
//  Treehacks
//
//  Created by Katie Mishra on 2/15/19.
//  Copyright © 2019 Katie Mishra. All rights reserved.
//

import UIKit

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit



class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // reference to user defaults
    let defaults = UserDefaults.standard
    
    // savedID is the array to store a username and password
    var savedID = [String]()
    
    // variable to store display name
    var username = String()
    
    // creates a UITextField
    var activeTextField = UITextField()
    
    
    // outlet to check box, email and password field
    @IBOutlet weak var savePasswordButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        
        // asks user to enable notifications
        let settings = UIUserNotificationSettings(types: [.sound, .alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        
        // for first time launching app/reset app data
        // if defaults for saving password does not exist, sets to false
        if defaults.string(forKey: "savePassword") == nil {
            defaults.set("false", forKey: "savePassword")
        }
        
        // gets current usernames and passwords and stores them in savedID
        self.getKeychain()
        
        // calls check for save function, which then sets the text fields if remember me is checked
        self.checkforSave() { (save) -> Void in
            
            if save {
                self.loginPressed(self)
            }
            
        }
        
        super.viewDidLoad()
        
        
    }
    
    // function called when user touches outside textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // hides keyboard and stops editing
        self.activeTextField.resignFirstResponder()
    }
    
    // sets active text field to selected textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    
    
    // function to check if the user defaults has remember me checked previously
    fileprivate func checkforSave(completion: @escaping(Bool)->Void) {
        completion(false)
        // checks the value in savePassword key
        if let save = defaults.string(forKey: "savePassword") {
            
            // if true, sets the check box to checked and sets the text fields
            if save == "true" {
                self.savePasswordButton.isSelected = true
                // if savedID is not empty, should never be empty, sets the text fields
                if !savedID.isEmpty {
                    self.emailField.text = savedID[0]
                    self.passwordField.text = savedID[1]
                    completion(true)
                    
                    
                    
                }
                
                // if else, sets check box to empty
            } else {
                self.savePasswordButton.isSelected = false
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // when user taps checkbox, sets to opposite image (checked or unchecked) and sets the user defaults accordingly
    @IBAction func checkbox(_ sender: Any) {
        self.savePasswordButton.isSelected = !self.savePasswordButton.isSelected
        if self.savePasswordButton.isSelected {
            defaults.set("true", forKey: "savePassword")
        } else {
            defaults.set("false", forKey: "savePassword")
            
        }
    }
    
    // login button pressed
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        // if either field are empty
        if self.emailField.text == "" ||  self.passwordField.text == "" {
            
            // calls displayAlertMessage function in Alert class, creates an alert with title and msg
            Alert.displayAlertMessage(titleMessage: "Error", alertMsg: "Please enter an email and password.")
            
            // both fields are entered
        } else {
            
            // signin attempt with email and password in the text field
            Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) { (user, error) in
                
                // no error
                if error == nil {
                    
                    // if savedID is currently empty (which it should never be), or is not equal to the email entered
                    // the savedID will be replaced with the email and password in the text field
                    // will implement drop down menu in the future
                    
                    // if remember me is checked and savePassword key in user defaults is true
                    if self.defaults.string(forKey: "savePassword") == "true" {
                        
                        // empties savedID and sets it to the current credentials in the text fields and saves it to keychain
                        self.savedID.removeAll()
                        self.savedID.append(self.emailField.text!)
                        self.savedID.append(self.passwordField.text!)
                        self.setKeychain()
                    }
                    
                    // creates reference to currently signed in user
                    //let user = FIRAuth.auth()?.currentUser
                    /*
                     // if display of user is nil (should never be), dummy proofing
                     if user?.displayName == nil {
                     
                     // separates email to first and second part
                     let stringArray = (self.emailField.text!).components(separatedBy: "@")
                     
                     // creates setName to change profile display name
                     let setName = user?.profileChangeRequest()
                     setName?.displayName = stringArray[0].replacingOccurrences(of: ".", with: "")
                     
                     // commites the changes
                     setName?.commitChanges(completion: { (error) in
                     if let error = error {
                     print(error)
                     } else {
                     // if no error, continues
                     // sets username to display name and calls show home screen
                     self.username = (user?.displayName)!
                     self.showHomeScreen()
                     }
                     })
                     // else, sets username to display name and calls show home screen
                     } else {*/
                    //self.username = (user?.displayName)!
                    self.showHomeScreen()
                    //}
                    
                    // error
                } else {
                    
                    // calls displayAlertMessage function in Alert class, creates an alert with title and msg
                    Alert.displayAlertMessage(titleMessage: "Error", alertMsg: (error?.localizedDescription)!)
                    
                }
            }
        }
    }
    
    // function called when facebook login button is pressed
    @IBAction func facebookLogin (_ sender: AnyObject){
        
        // new facebook login manager
        let facebookLogin = FBSDKLoginManager()
        
        // calls facebook login function with permissions to get the email
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler:{(facebookResult, facebookError) -> Void in
            
            // if login is not successful
            if facebookError != nil {
                print("Facebook login failed. Error ")
                
                // if login is cancelled
            } else if (facebookResult?.isCancelled)! {
                print("Facebook login was cancelled.")
                
                // if login is successful
            } else {
                print("You’re in")
                
                // creates credential from the facebook access token
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                // signs into firebase with the facebook access token
                Auth.auth().signIn(with: credential) { (user, error) in
                    
                    // sign in successful
                    if error == nil {
                        
                        // creates reference to user and sets username to display name
                        //let user = FIRAuth.auth()?.currentUser
                        //self.username = (user?.displayName)!
                        
                        // shows the homescreen
                        self.showHomeScreen()
                        
                        // error
                    } else {
                        
                        // displays error with error message
                        Alert.displayAlertMessage(titleMessage: "Error", alertMsg: (error?.localizedDescription)!)
                        
                    }
                }
                
            }
        });
        
        
    }
    
    
    // function that is called when segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // if segue identifier is login to home screen
        if segue.identifier == "loginToHomescreen" {
            
            // creates destination as home screen controller and sets the destination username to self.username unless it it empty
            
            /*
             let destination = segue.destination.childViewControllers[0] as! HomescreenViewController
             
             if !self.username.isEmpty {
             destination.username = self.username
             } else {
             destination.username = "Katie"
             }*/
            
        }
        
    }
    
    // function to call the segue to homescreen
    fileprivate func showHomeScreen() {
        self.performSegue(withIdentifier: "loginToHomescreen", sender: nil)
    }
    
    // gets the data saved in keychain as a string in json format
    // saves and converts the string to savedID array
    fileprivate func getKeychain() {
        
        // do try catch to catch for errors
        do {
            
            // creates jsonString to be the keychain string in json format
            let jsonString = KeychainWrapper().myObject(forKey: kSecValueData) as! String
            //print(jsonString)
            
            // converts json string to an array and sets savedID equal to the array
            let jsonObject = try JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8)!, options: [])
            if jsonObject is NSArray {
                self.savedID = jsonObject as! [String];
            }
            
            // in case of error
        } catch {
            
        }
        
    }
    
    // stores the savedID array as a json formatted string in keychain
    fileprivate func setKeychain() {
        
        // do try catch to catch for errors
        do {
            
            // creates json data from savedID array
            let jsonData = try JSONSerialization.data(withJSONObject: self.savedID, options: [])
            
            // converts json data into string and writes it to the keychain
            let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8)!
            
            //print(jsonString)
            
            KeychainWrapper().mySetObject(jsonString, forKey:kSecValueData)
            KeychainWrapper().writeToKeychain()
            
            // in case of error
        } catch {
            
        }
    }
    
    // function that is called when unwinded to login view controller from another view controller
    @IBAction func unwindToLoginViewController(_ segue: UIStoryboardSegue) {
        
        print("unwinded")
        
        // gets the keychain and resets the text fields
        self.getKeychain()
        self.checkforSave() { (save) -> Void in
        }
    }
    
    
}

