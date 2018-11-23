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
import ChameleonFramework


class PhotoCell: UICollectionViewCell {
    var facts: Facts!
    var currentUser = Auth.auth().currentUser?.uid
    let allView: UIView = {
        let view = UIView()
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints =  false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.white
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    let buttonView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    let captionTextView : UITextView = {
        let captionTextView = UITextView()
        captionTextView.textColor = UIColor.gray
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        captionTextView.backgroundColor = UIColor.white
        captionTextView.isEditable = false
        captionTextView.isSelectable = false
        captionTextView.isScrollEnabled = false
        return captionTextView
    }()
    
    lazy var likeButton : UIButton = {
        let likeButton = UIButton()
        likeButton.setImage(UIImage(named: "noLike"), for: .normal)
        likeButton.setImage(UIImage(named: "like"), for: .selected)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        return likeButton
    }()
    
    lazy var infoButton: UIButton = {
        let infoButton = UIButton()
        infoButton.setImage(UIImage(named: "info"), for: .normal)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)
        return infoButton
        }()
    
    let likeLable: UILabel = {
        let likeLable = UILabel()
        likeLable.textColor = UIColor.gray
        likeLable.translatesAutoresizingMaskIntoConstraints = false
        likeLable.numberOfLines = 1
        likeLable.text = "1000"
        likeLable.backgroundColor = UIColor.white
        likeLable.textColor = UIColor.gray
        
        return likeLable
    }()
    
        func roundCorners(view :UIView, corners: UIRectCorner, radius: CGFloat){
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }

    
    var imageViewHeightConstraint: NSLayoutConstraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addSubview(allView)
//        allView.addSubview(imageView)
//        allView.addSubview(captionTextView)
//        allView.addSubview(buttonView)
    
        addSubview(imageView)
        addSubview(captionTextView)
        addSubview(buttonView)
        buttonView.addSubview(likeLable)
        buttonView.addSubview(infoButton)
        buttonView.addSubview(likeButton)
        

        
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: captionTextView.topAnchor).isActive = true
        imageViewHeightConstraint =  imageView.heightAnchor.constraint(equalToConstant: 200)
        imageViewHeightConstraint.isActive = true
        
        captionTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        captionTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        captionTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        captionTextView.bottomAnchor.constraint(equalTo: buttonView.topAnchor).isActive = true

        buttonView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        buttonView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        buttonView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        buttonView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        likeButton.leftAnchor.constraint(equalTo: buttonView.leftAnchor, constant: 10).isActive = true
//        likeButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: 10).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        likeButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor).isActive = true

        likeLable.leftAnchor.constraint(equalTo: likeButton.rightAnchor, constant: 10).isActive = true
        likeLable.widthAnchor.constraint(equalToConstant: 50).isActive = true
        likeLable.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likeLable.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true

        infoButton.rightAnchor.constraint(equalTo: buttonView.rightAnchor, constant: -10).isActive = true
        infoButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        infoButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor).isActive = true
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? FactsFeverLayoutAttributes {
        imageViewHeightConstraint.constant =  attributes.photoHeight
        }
    }
    
    func configureCell(fact: Facts){
        self.facts = fact

        self.imageView.sd_setImage(with: URL(string: fact.factsLink))
        //////////////////
        likeLable.text = String(fact.factsLikes.count)
        /////////////////
        self.captionTextView.text = fact.captionText
        let factsRef = Database.database().reference().child("Facts").child(facts.factsId).child("likes")
        factsRef.observeSingleEvent(of: .value) { (snapshot) in
            if fact.factsLikes.contains(self.currentUser!){
                self.likeButton.isSelected = true
            } else {
                self.likeButton.isSelected = false
            }


        }

    }

    @objc func likeButtonPressed(){
        print("Like Button Pressed")
        
        let factsRef = Database.database().reference().child("Facts").child(facts.factsId).child("likes")
            likeButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    
            UIView.animate(withDuration: 3.0,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.30),
                           initialSpringVelocity: CGFloat(5.0),
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: {
                            self.likeButton.transform = CGAffineTransform.identity
            },
                           completion: { Void in()  }
            )
    
    
            factsRef.observeSingleEvent(of: .value) { (snapshot) in
                if self.likeButton.isSelected == true {
                    self.likeButton.isSelected = false
                    self.facts.addSubtractLike(addLike: false)
                } else {
                    self.likeButton.isSelected = true
                    self.facts.addSubtractLike(addLike: true)
    
                }
            }
        }
    
    
    @objc func infoButtonPressed(){
        print("Info Button Pressed")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
