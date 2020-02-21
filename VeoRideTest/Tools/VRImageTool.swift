//
//  VRImageTool.swift
//  VeoRideTest
//
//  Created by 江传林 on 2020/2/20.
//  Copyright © 2020 ChuanLin Jiang. All rights reserved.
//

func UIImageWithColor(_ color: UIColor) -> UIImage {
    
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    
    let context = UIGraphicsGetCurrentContext()
    
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
}

