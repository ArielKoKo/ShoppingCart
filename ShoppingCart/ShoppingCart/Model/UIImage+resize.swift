//
//  UIImage+resize.swift
//  ShoppingCart
//
//  Created by Ariel Ko on 2021/6/30.
//

import UIKit

extension UIImage {
    func resize(maxEdge: CGFloat) -> UIImage? {
        
        // Check if it is necessarry to resize?
        if self.size.width <= maxEdge && self.size.height <= maxEdge {
            return self
        }
        
        // Caculate final size to aspect ratio.
        let ratio = self.size.width / self.size.height
        let finalSize: CGSize
        if self.size.width > self.size.height {
            let finalHeight = maxEdge / ratio
            finalSize = CGSize(width: maxEdge, height: finalHeight)
        } else {
            let finalWidth = maxEdge * ratio
            finalSize = CGSize(width: finalWidth, height: maxEdge)
        }
        UIGraphicsBeginImageContext(finalSize)
        let rect = CGRect(origin: CGPoint.zero, size: finalSize)
        self.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext() // Important!
        
        return result
    }
}
