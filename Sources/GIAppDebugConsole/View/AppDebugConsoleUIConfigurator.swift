//
//  AppDebugConsoleUIConfigurator.swift
//
//  Created by daleijn on 26.05.2021.
//  Copyright © 2021 Ivan Gnatyuk. All rights reserved.
//

import UIKit

class AppDebugConsoleUIConfigurator {
    var consoleUIConfig: GIAppDebugConsoleUIConfig
    
    
    // MARK: - Init
    
    init(consoleUIConfig: GIAppDebugConsoleUIConfig = .init()) {
        self.consoleUIConfig = consoleUIConfig
    }
    
    
    // MARK: - API
    
    func createConsoleTextView(parentFrame: CGRect) -> UITextView {
        let txtView = UITextView()
        txtView.frame = parentFrame.inset(by: .init(top: 8, left: 8, bottom: 8, right: 8))
        txtView.isEditable = false
        txtView.isSelectable = false
        txtView.textContainerInset = UIEdgeInsets(top: 0, left: 4, bottom: 4, right: 10)
        txtView.contentInsetAdjustmentBehavior = .never
        txtView.backgroundColor = .clear
        txtView.showsVerticalScrollIndicator = false
        
        txtView.textColor = consoleUIConfig.textColor
        txtView.font = consoleUIConfig.font
    
        return txtView
    }
    
    func menuButtonFrame(by superViewSize: CGSize) -> CGRect {
        let btnConfig = consoleUIConfig.menuButtonConfig
        
        let insets = UIEdgeInsets(top: 0, left: 0,
                                  bottom: 8, right: 8)
    
        let btnOrigin = CGPoint(x: superViewSize.width - btnConfig.size.width - insets.right,
                                y: superViewSize.height - btnConfig.size.height - insets.bottom)
        
        return CGRect(origin: btnOrigin,
                      size: btnConfig.size)
    }
    
    func createMenuButton(parentSize: CGSize) -> GIMenuButton {
        let btnConfig = consoleUIConfig.menuButtonConfig
        let btn = GIMenuButton(frame: menuButtonFrame(by: parentSize))
        
        btn.imageEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
        btn.layer.cornerRadius = btnConfig.size.width/2
   
        btn.setImage(btnConfig.image, for: .normal)
        btn.setTitle(btnConfig.title, for: .normal)
        btn.backgroundColor = btnConfig.backgroundColor
        btn.tintColor = btnConfig.tintColor
        btn.alpha = btnConfig.alpha
        
        return btn
    }

}
