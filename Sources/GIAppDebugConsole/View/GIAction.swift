//
//  GIAction.swift
//
//  Created by daleijn on 27.05.2021.
//  Copyright © 2021 Ivan Gnatyuk. All rights reserved.
//

import UIKit

public class GIAction: UIView {
    let title: String
    let image: UIImage?
    let handler: ()->()
    
    private let button: UIButton
    
    
    // MARK: - Init
    
    public init(title: String, image: UIImage? = nil, handler: @escaping ()->()) {
        self.title = title
        self.image = image
        self.handler = handler
        
        self.button = GIAction.createButton(title: title, image: image)
        
        super.init(frame: .zero)
        
        self.button.addTarget(self, action: #selector(buttonDidTap),
                              for: .touchUpInside)
        
        addSubview(button)
        button.pin(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}


private extension GIAction {
    
    @objc func buttonDidTap() {
        handler()
    }
    
}


private extension GIAction {
    
    static func createButton(title: String, image: UIImage?) -> UIButton {
        let btn = UIButton(type: .system)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        btn.setImage(image, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.tintColor = .black
        btn.setTitleColor(.black, for: .normal)
        return btn
    }
    
}
