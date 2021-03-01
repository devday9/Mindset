//
//  StyleGuide.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/27/20.
//

import UIKit

//MARK: - Extension
extension UIView {
    
    func addCornerRadius(radius: CGFloat = 4) {
        self.layer.cornerRadius = radius
    }
    
    func addAccentBorderThick(width: CGFloat = 5, color: UIColor = .gray) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func addAccentBorderThin(width: CGFloat = 2, color: UIColor = .gray) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func rotate(by radians: CGFloat = (-CGFloat.pi / 2)) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
}//END OF EXTENSION
