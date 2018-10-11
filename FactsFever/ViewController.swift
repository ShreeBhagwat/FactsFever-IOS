//
//  ViewController.swift
//  FactsFever
//
//  Created by Gauri Bhagwat on 09/10/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Outlets
    
    @IBOutlet weak var uploadButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Properties
    
    let images = [#imageLiteral(resourceName: "2"),#imageLiteral(resourceName: "10"),#imageLiteral(resourceName: "10"),#imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "6"), #imageLiteral(resourceName: "12"),#imageLiteral(resourceName: "11"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "10")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(refreshControl)
        

    }
    

    //MARK:- Upload Facts
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        selectPhoto()
    }
    // Pull To refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 1, green: 0.8508075984, blue: 0.02254329405, alpha: 1)
        
        return refreshControl
    }()
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    // Image Picker View
    func selectPhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = [kUTTypeImage] as [String]
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if let orginalImage = info["UIImagePickerControllerOriginalImage"]{
            print("Size \(orginalImage.size)")
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func handelImageSend(){
        var seletedImageFromPicker : UIImage?
        
    }
   
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //MARK: Data Source
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        let image = images[indexPath.item]
        cell.imageView.layer.cornerRadius = 20
        cell.imageView.layer.masksToBounds = true
        cell.imageView.layer.shouldRasterize = true
        cell.imageView.image = image
        
        return cell
    }

}

