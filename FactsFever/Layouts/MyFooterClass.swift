//
//  MyFooterClass.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 22/03/19.
//  Copyright © 2019 Development. All rights reserved.
//

import Foundation
import UIKit

class MyFooterClass : UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.purple
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
