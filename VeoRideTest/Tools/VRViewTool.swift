//
//  VRViewTool.swift
//  VeoRideTest
//
//  Created by 江传林 on 2020/2/20.
//  Copyright © 2020 ChuanLin Jiang. All rights reserved.
//

import UIKit

class VRViewTool: NSObject {
    
    

    static func showAlertView(title: String?, message: String?, currentVC: UIViewController, cancelHandler:((UIAlertAction) -> Void)?, otherBtns:Array<String>?, otherHandler:((Int) -> ())?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler:{ (action) -> Void in
            cancelHandler?(action)
        })
        alertController.addAction(cancelAction)

        if otherBtns != nil {
            for (index, value) in (otherBtns?.enumerated())! {
                let otherAction = UIAlertAction(title: value, style: .default, handler: { (action) in
                    if otherHandler != nil {
                        otherHandler!(index)
                    }
                })
                alertController.addAction(otherAction)
            }
        }
        
        currentVC.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: 获取当前屏幕上的控制器
    class var topViewController: UIViewController? {
        var resultVC: UIViewController?
        resultVC = self._topViewController(UIApplication.shared.keyWindow?.rootViewController)
        while ((resultVC?.presentedViewController) != nil) {
            resultVC = self._topViewController(resultVC?.presentedViewController)
        }
        return resultVC
    }
    
    private class func _topViewController(_ vc: UIViewController?) -> UIViewController? {
        if (vc is UINavigationController) {
            return self._topViewController((vc as? UINavigationController)?.topViewController)
        } else if (vc is UITabBarController) {
            return self._topViewController((vc as? UITabBarController)?.selectedViewController)
        } else {
            return vc
        }
    }
}
