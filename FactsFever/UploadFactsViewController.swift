//
//  UploadFactsViewController.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 01/12/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import AVKit
import Foundation
import MobileCoreServices
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SDWebImage
import ProgressHUD
import IDMPhotoBrowser
import ChameleonFramework
import PCLBlurEffectAlert
import SkeletonView

class UploadFactsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var captionViewOutlet: UITextView!
    @IBOutlet weak var selectImageButtonOutlet: UIButton!
    @IBOutlet weak var uploadFactButtonOutlet: UIButton!
    
    var currentUserUId = Auth.auth().currentUser?.uid
    var likeUsers:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadFactButtonOutlet.isEnabled = true
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uploadFactButtonOutlet.isEnabled = true
    }
    
    @IBAction func selectImageButtonPressed(_ sender: Any) {
        uploadFactButtonOutlet.isHidden = false
        uploadFactButtonOutlet.isEnabled = true
        selectPhoto()
    }
    
    @IBAction func uploadFactsButtonPressed(_ sender: Any) {
        uploadFactButtonOutlet.isEnabled = false
        uploadFactButtonOutlet.isHidden = true
        if imageViewOutlet.image != nil {
            ProgressHUD.show()
            let imageToUpload = imageViewOutlet.image
            uploadImageToFirebaseStorage(image: imageToUpload!) { (imageUrl) in
                if self.captionViewOutlet.text == nil || self.captionViewOutlet.text == ""{
                    self.captionViewOutlet.text = "FactsFever"
                    self.addToDatabase(imageUrl: imageUrl, caption: self.captionViewOutlet.text, image: imageToUpload!)
                    ProgressHUD.dismiss()
                    self.uploadFactButtonOutlet.isEnabled = false
                }else {
                    self.addToDatabase(imageUrl: imageUrl, caption: self.captionViewOutlet.text, image: imageToUpload!)
                    ProgressHUD.dismiss()
                    self.uploadFactButtonOutlet.isEnabled = false
                }
            }
        }else {
        uploadFactButtonOutlet.isEnabled = true
        uploadFactButtonOutlet.isHidden = false
        }
      
    }
    
    func selectPhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.mediaTypes = [kUTTypeImage] as [String]
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker : UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        }
        else if let orginalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = orginalImage
            
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.imageViewOutlet.image = selectedImage
//            uploadImageToFirebaseStorage(image: selectedImage) { (imageUrl) in
//            }
            
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (_ imageUrl: String) -> ()){
        let imageName = NSUUID().uuidString + ".jpg"
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = image.jpegData(compressionQuality: 0.2){
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(" Failed to upload Image", error)
                }
                ref.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print("Unable to upload image into storage due to \(err)")
                    }
                    let messageImageURL = url?.absoluteString
                    completion(messageImageURL!)
                    
                })
                
            })
        }
    }
    
    func addToDatabase(imageUrl:String, caption: String, image: UIImage){
        let Id = NSUUID().uuidString
        likeUsers.append(currentUserUId!)
        let timeStamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let factsDB = Database.database().reference().child("Facts")
        let factsDictionary = ["factsLink": imageUrl, "likes": likeUsers, "factsId": Id, "timeStamp": timeStamp, "captionText": caption, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
        factsDB.child(Id).setValue(factsDictionary){
            (error, reference) in
            
            if error != nil {
                print(error)
                ProgressHUD.showError("Image Upload Failed")
               
                return
                
            } else{
                print("Message Saved In DB")
                ProgressHUD.showSuccess("image Uploded Successfully")
             
                

            }
        }
    }
    

    
}
