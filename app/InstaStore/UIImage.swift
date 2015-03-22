//
//  UIImage.swift
//  InstaStore
//
//  Created by Neo on 3/21/15.
//  Copyright (c) 2015 instastore. All rights reserved.
//

import UIKit

extension UIImage {
    public func resize(size:CGSize, completionHandler:(resizedImage:UIImage, data:NSData)->()) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            var newSize:CGSize = size
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.drawInRect(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageData = UIImageJPEGRepresentation(newImage, 0.5)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(resizedImage: newImage, data:imageData)
            })
        })
    }
    
    public func convertImageToBase64(image: UIImage) -> String {
        
        var imageData = UIImagePNGRepresentation(image)
        let base64String = imageData.base64EncodedStringWithOptions(.allZeros)
        
        return base64String
        
    }
}