//
//  UIResponder + Extension.swift
//  tip-calculator
//
//  Created by 方奎元 on 2023/11/7.
//

import UIKit

extension UIResponder {
    var parentViewConroller: UIViewController? {
        return next as? UIViewController ?? next?.parentViewConroller
    }
}
