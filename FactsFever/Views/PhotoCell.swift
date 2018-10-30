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
 
    @IBOutlet weak var reportButtonOutlet: UIButton!
    
    @IBOutlet weak var likeButtonOutlet: UIButton!
    
    
    var facts: Facts!
    var currentUser = Auth.auth().currentUser?.uid
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeButtonOutlet.setImage(UIImage(named: "noLike"), for: .normal)
        likeButtonOutlet.setImage(UIImage(named: "like"), for: .selected)
        
    }
    func configureCell(fact: Facts){
        self.facts = fact
        self.imageView.layer.cornerRadius = 20
        self.imageView.clipsToBounds = true
        self.imageView.layer.shouldRasterize = true
        self.imageView.backgroundColor = UIColor.clear
        self.imageView.sd_setImage(with: URL(string: fact.factsLink))
        self.likeLableOutlet.text = String(fact.factsLikes.count)


        let factsRef = Database.database().reference().child("Facts").child(facts.factsId).child("likes")
        factsRef.observeSingleEvent(of: .value) { (snapshot) in
            if fact.factsLikes.contains(self.currentUser!){
                self.likeButtonOutlet.isSelected = true
            } else {
                self.likeButtonOutlet.isSelected = false
            }
            
            
        }

    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
    
    
        let factsRef = Database.database().reference().child("Facts").child(facts.factsId).child("likes")
        likeButtonOutlet.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 3.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.30),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.likeButtonOutlet.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        
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


}
