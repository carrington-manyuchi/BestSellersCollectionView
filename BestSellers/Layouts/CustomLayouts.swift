//
//  CustomLayouts.swift
//  BestSellers
//
//  Created by DA MAC M1 157 on 2023/08/24.
//

import UIKit

//MARK: - Class customLayout will inherit the properties of UICollectionViewFlowLayout

class CustomLayout: UICollectionViewFlowLayout {
    
    var previousOffset: CGFloat = 0.0
    var currentPage = 0
    
    
    
    //MARK: - This method return CGPoint value when we stop scrolling in collectionView
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let cv = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let itemCount = cv.numberOfItems(inSection: 0)
        
        if previousOffset > cv.contentOffset.x && velocity.x < 0.0 {
            currentPage = max(currentPage - 1, 0)
        } else if  previousOffset < cv.contentOffset.x && velocity.x > 0.0 {
                currentPage = min(currentPage + 1,itemCount-1)
        }
        
        //print("currentPage: \(currentPage) ")

        let offset = updateOffset(cv)
        previousOffset = offset
        
        return CGPoint(x: offset, y: proposedContentOffset.y)
    }
    
    func updateOffset(_ cv: UICollectionView) -> CGFloat {
        let w = cv.frame.width
        let itemW = itemSize.width
        let sp = minimumLineSpacing
        let edge = (w - itemW - sp*2)/2
        let offset = (itemW + sp) * CGFloat(currentPage) - (edge + sp)
        return offset
    }
}
