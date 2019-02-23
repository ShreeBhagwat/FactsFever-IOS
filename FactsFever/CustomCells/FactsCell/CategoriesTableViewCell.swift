//
//  CategoriesTableViewCell.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 21/02/19.
//  Copyright © 2019 Development. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {
  
    @IBOutlet weak var categoriesImageView: UIImageView!
    
    @IBOutlet weak var categoriesLabelOutlet: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLayout()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpLayout(){
//        categoriesImageView.layer.cornerRadius = categoriesImageView.frame.height / 2
        categoriesImageView.clipsToBounds = true
//        categoriesImageView.layer.borderWidth = 3
        categoriesImageView.layer.masksToBounds = true
//        categoriesImageView.layer.borderColor = UIColor.white.cgColor
        categoriesImageView.contentMode = .scaleAspectFill
        categoriesLabelOutlet.backgroundColor = #colorLiteral(red: 0.01084895124, green: 0.06884861029, blue: 0.1449754088, alpha: 1)
        categoriesLabelOutlet.textColor = #colorLiteral(red: 0.9334741235, green: 0.8684075475, blue: 0.2870253325, alpha: 1)
        categoriesLabelOutlet.layer.cornerRadius = categoriesLabelOutlet.frame.height / 2
        categoriesLabelOutlet.layer.masksToBounds = true
        categoriesLabelOutlet.layer.borderColor = UIColor.white.cgColor
        categoriesLabelOutlet.layer.borderWidth = 2
        
        contentView.bringSubviewToFront(categoriesLabelOutlet)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }

}
