//
//  FactsFeverActivityIndicator.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 29/11/18.
//  Copyright © 2018 Development. All rights reserved.
//
import UIKit
import Foundation

class FactsFeverCustomLoader: UIView {
    
    static let instance = FactsFeverCustomLoader()
    
    
    lazy var transparentView : UIView = {
       let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.yellow.withAlphaComponent(0.8)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var gifImage: UIImageView = {
        let gifimage = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
        gifimage.contentMode = .scaleAspectFit
        gifimage.center = transparentView.center
        gifimage.isUserInteractionEnabled = false
        gifimage.loadGif(name: "loadingimage")
        return gifimage
    }()
    
    func showLoader(){
        self.addSubview(transparentView)
        transparentView.addSubview(gifImage)
        transparentView.bringSubviewToFront(gifImage)
        UIApplication.shared.keyWindow?.addSubview(transparentView)
        
    }
    
    func hideLoader(){
        self.transparentView.removeFromSuperview()
    }
    
}




