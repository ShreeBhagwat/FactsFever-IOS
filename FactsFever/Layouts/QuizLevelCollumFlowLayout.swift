//
//  QuizLevelCollumFlowLayout.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 18/02/19.
//  Copyright © 2019 Development. All rights reserved.
//

import Foundation
import UIKit

class QuizLevelColumnFlowlayout : UICollectionViewFlowLayout {
    
    let cellPerRow : Int
    
    init(cellPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellPerRow = cellPerRow
        super.init()
        
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        if #available(iOS 11.0, *) {
            let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellPerRow - 1)
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellPerRow - 1)
            let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellPerRow)).rounded(.down)
            itemSize = CGSize(width: itemWidth, height: itemWidth)
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

}
