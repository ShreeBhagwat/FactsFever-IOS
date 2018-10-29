//
//  PhotoCell.swift
//  FactsFever
//
//  Created by Gauri Bhagwat on 09/10/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeLableOutlet: UILabel!
    @IBOutlet weak var favButtonOutlet: UIButton!
 
    @IBOutlet weak var likeButtonOutlet: UIButton!
    
    var facts: Facts!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeButtonOutlet.setImage(UIImage(named: "noLike"), for: .normal)
        likeButtonOutlet.setImage(UIImage(named: "like"), for: .selected)
        
    }
    func configureCell(fact: Facts, indexPath: IndexPath){
        self.facts = fact
        
        self.imageView.sd_setImage(with: URL(string: fact.factsLink))
        self.likeLableOutlet.text = String(fact.factsLikes)

//
//        let factsRef = Database.database().reference().child("Facts").child(facts.factsId).child("likes")
//        factsRef.observeSingleEvent(of: .value) { (snapshot) in
//
//            if self.likeButtonOutlet.isSelected == true {
//                self.likeButtonOutlet.isSelected = false
//
//            } else {
//                self.likeButtonOutlet.isSelected = false
//
//            }
//
//            }

    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        let factsRef = Database.database().reference().child("Facts").child(facts.factsId).child("likes")
        
        factsRef.observeSingleEvent(of: .value) { (snapshot) in
            if self.likeButtonOutlet.isSelected == true {
                self.likeButtonOutlet.isSelected = false
                self.facts.addSubtractLike(addLike: false)
            } else {
                self.likeButtonOutlet.isSelected = true
                self.facts.addSubtractLike(addLike: true)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }


        
    
    
    
}
