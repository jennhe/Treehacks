import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var parentsNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //Sign Up Action for email
    @IBAction func creatAccountAction(_ sender: Any) {
        if emailTextField.text == "" || firstNameTextField.text == "" || lastNameTextField.text == "" || parentsNumberTextField.text == "" || passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    let ref: DatabaseReference! = Database.database().reference().child("users").child(user?.user.uid ?? "test");
                    
                    ref.child("firstName").setValue(self.firstNameTextField.text ?? "No First Name");
                    ref.child("lastName").setValue(self.lastNameTextField.text ?? "No Last Name");
                    ref.child("parentsNumber").setValue(self.parentsNumberTextField.text ?? "No Number");
                    ref.child("email").setValue(self.emailTextField.text ?? "No Email");
                    ref.child("numCoins").setValue(0);
                    ref.child("Level").setValue(1);
                    ref.child("Hospital").setValue("Stanford Hospital");
                    
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
}

