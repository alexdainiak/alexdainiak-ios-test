//
//  UIView+shadow.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

import Foundation

extension UIView {
    
    func shadow(scale: Bool = true) {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.gray.cgColor
            layer.shadowOpacity = 0.3
            layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            layer.shadowRadius = 2
            layer.shouldRasterize = true
            layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        }
}
