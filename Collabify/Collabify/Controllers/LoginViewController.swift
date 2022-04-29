//
//  LoginViewController.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Eyoel Wendwosen on 4/22/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    let showPasswordButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpShowPasswordbutton()
        
        // tap to remove keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        print("Tapped")
        view.endEditing(true)
    }

    @IBAction func onCreateAccount(_ sender: Any) {
        if(PFUser.current() == nil){
            NotificationCenter.default.post(name: Notification.Name("create_account"), object: nil)
        }
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameTextfield.text!
        let password = passwordTextfield.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { success, error in
            if(success != nil) {
                NotificationCenter.default.post(name: NSNotification.Name("login"), object: nil)
            } else {
                print("Erorr logging in username or password is not correct")
            }
        }
    }
    
    func setUpShowPasswordbutton() {

        passwordTextfield.rightViewMode = .unlessEditing
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "eye.slash")
//        config.imagePadding = 4
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        showPasswordButton.configuration = config
        showPasswordButton.frame = CGRect(x: passwordTextfield.frame.size.width - 30,
                                          y: passwordTextfield.frame.size.height / 2,
                                          width: CGFloat(15),
                                          height: CGFloat(15))
        showPasswordButton.addTarget(self, action: #selector(self.showPasswordVisibilityChanged), for: .touchUpInside)
        passwordTextfield.rightView = showPasswordButton
        passwordTextfield.rightViewMode = .whileEditing
    }
    

    
    @objc func showPasswordVisibilityChanged(_ sender: Any) {
        let visibilityButton = sender as! UIButton
        visibilityButton.isSelected = !visibilityButton.isSelected
        
        if (visibilityButton.isSelected) {
            passwordTextfield.isSecureTextEntry = false
            showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            passwordTextfield.isSecureTextEntry = true
            showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
}
