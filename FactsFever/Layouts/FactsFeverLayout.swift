//
//  FactsFeverLayout.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 21/11/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
protocol FactsFeverLayoutDelegate: class {
    func collectionView(CollectionView: UICollectionView, heightForThePhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    
    func collectionView(CollectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
}



class FactsFeverLayout: UICollectionViewLayout {
    
    var cellPadding : CGFloat = 5.0
    var delegate: FactsFeverLayoutDelegate?
    
    private var contentHeight : CGFloat = 0.0
    private var contentWidth : CGFloat {
        let insets = collectionView!.contentInset
        return (collectionView!.bounds.width - insets.left + insets.right)
    }
  private var attributeCache = [FactsFeverLayoutAttributes]()
   override func prepare() {
    attributeCache.removeAll()
    if attributeCache.isEmpty {
        let containerWidth = contentWidth
        var xOffset : CGFloat = 0
        var yOffset : CGFloat = 0
        
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let width = containerWidth - cellPadding * 2
            let photoHeight:CGFloat = (delegate?.collectionView(CollectionView: collectionView!, heightForThePhotoAt: indexPath, with: width))!
            let captionHeight: CGFloat = (delegate?.collectionView(CollectionView: collectionView!, heightForCaptionAt: indexPath, with: width))!
            
            
            let height: CGFloat = cellPadding + photoHeight + captionHeight + cellPadding
            
            let frame = CGRect(x: xOffset, y: yOffset, width: containerWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // Create CEll Layout Atributes
            let attributes = FactsFeverLayoutAttributes(forCellWith: indexPath)
            attributes.photoHeight = photoHeight
            attributes.frame = insetFrame
            attributeCache.append(attributes)
            // Update The Colunm any Y axis
            contentHeight = max(contentHeight, frame.maxY)
            yOffset = yOffset + height
            
            
        }
    
        
    }
    }
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in attributeCache {
            if attributes.frame.intersects(rect){
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    

}
// UICollectionView FlowLayout
// Abstract
class FactsFeverLayoutAttributes: UICollectionViewLayoutAttributes {
    var photoHeight : CGFloat = 0.0
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! FactsFeverLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? FactsFeverLayoutAttributes {
            if attributes.photoHeight == photoHeight {
                super.isEqual(object)

            }
        }
        return false
    }
}
