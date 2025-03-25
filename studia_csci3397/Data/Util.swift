//
//  Util.swift
//  studia_csci3397
//
//  Created by Aiden Seibel on 3/25/25.
//

import Foundation
import UIKit

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    // Determine what ratio to use to ensure the image is scaled properly
    let ratio = min(widthRatio, heightRatio)

    // Calculate the new size
    let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)

    // Resize the image
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.draw(in: CGRect(origin: .zero, size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}
