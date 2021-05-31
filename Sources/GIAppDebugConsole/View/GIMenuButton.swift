//
//  GIMenuButton.swift
//
//  Created by daleijn on 27.05.2021.
//  Copyright © 2021 Ivan Gnatyuk. All rights reserved.
//

import UIKit

public class GIMenuButton: UIButton {
    
    var giMenu: GIMenu? {
        didSet {
            addTarget(self, action: #selector(menuButtonDidTap),
                      for: .touchUpInside)
        }
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
}


private extension GIMenuButton {
    
    @objc func menuButtonDidTap() {
        giMenu?.show.toggle()
    }
    
}
