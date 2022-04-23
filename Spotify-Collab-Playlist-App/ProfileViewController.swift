//
//  ProfileViewController.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Eyoel Wendwosen on 4/8/22.
//

import UIKit
import AlamofireImage
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    
    var profile = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width/2
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "User")
        query.whereKey(<#T##key: String##String#>, equalTo: <#T##Any#>)
    }
    
    @IBAction func onAddImageButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 160, height: 160)
        let scaledImage = image.af.imageScaled(to: size)
        
        profileImage.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
