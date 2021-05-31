//
//  UIView+Constraints.swift
//  BP CLUB
//
//  Created by daleijn on 13/12/2018.
//  Copyright © 2018 daleijn. All rights reserved.
//

import UIKit

public extension UIView {
    
   @objc func pin(to parentView: UIView, edges: UIEdgeInsets = UIEdgeInsets.createWith(inset: 0)) {
    self.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
        self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: edges.left),
        parentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: edges.right),
        self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: edges.top),
        parentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: edges.bottom)
    ])
    }
    
}


extension UIStackView {
    
    func pinBackground(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(view, at: 0)
        view.pin(to: self)
    }
    
}

public extension UIEdgeInsets {
    
    /// Create edgeInsets with equal inset for all values
    ///
    /// - Parameter inset: Inset for top, left, bottom and right.
    static func createWith(inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}
