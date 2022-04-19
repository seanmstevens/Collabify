//
//  CreatePlaylistViewController.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Xiqi on 4/15/22.
//

import UIKit
import AlamofireImage
import Parse

class CreatePlaylistViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var playlistImageView: UIImageView!
    
    @IBOutlet weak var playlistNameField: UITextField!
    
    @IBOutlet weak var playlistDescriptionView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCreateButton(_ sender: Any) {
        let playlist = Playlist()
        
        let imageData = playlistImageView.image!.pngData()
        let file = PFFileObject(name:"image.png", data: imageData!)
        playlist.image = file
        playlist.title = playlistNameField.text!
        playlist.desc = playlistDescriptionView.text!
//        playlist["author"] = PFUser.current()!
        
        playlist.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("error!")
            }
        }
        
    }
    
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
            
        present(picker,animated: true,completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        
        playlistImageView.image = scaledImage
        
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
