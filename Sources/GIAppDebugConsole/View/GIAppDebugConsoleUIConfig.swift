//
//  AppDebugConsoleUIConfig.swift
//
//  Created by daleijn on 27.05.2021.
//  Copyright © 2021 Ivan Gnatyuk. All rights reserved.
//

import UIKit

/// Model describes **Console** UI
public struct GIAppDebugConsoleUIConfig {
    var consoleDefaultSize: CGSize
    var consoleMaxSize: CGSize
    
    var consoleBackgroundColor: UIColor
    
    var textColor: UIColor
    var font: UIFont
    
    var menuButtonConfig: MenuButtonConfig
    
    
    // MARK: - Init
    
    public init(consoleDefaultSize: CGSize = .init(width: UIScreen.main.bounds.width * 0.75,
                                                   height: 124),
                consoleMaxSize: CGSize = .init(width: UIScreen.main.bounds.width,
                                               height: UIScreen.main.bounds.height * 0.5),
                consoleBackgroundColor: UIColor = .black,
                textColor: UIColor = .white,
                font: UIFont = .systemFont(ofSize: 13, weight: .regular),
                menuButtonConfig: GIAppDebugConsoleUIConfig.MenuButtonConfig = .init())
    {
        self.consoleDefaultSize = consoleDefaultSize
        self.consoleMaxSize = consoleMaxSize
        self.consoleBackgroundColor = consoleBackgroundColor
        self.textColor = textColor
        self.font = font
        self.menuButtonConfig = menuButtonConfig
    }
    
    
}

public extension GIAppDebugConsoleUIConfig {
    
    /// Model describes **Console Menu button** UI
    struct MenuButtonConfig {
        var size: CGSize
        var backgroundColor: UIColor
        var image: UIImage?
        var title: String?
        var tintColor: UIColor
        var alpha: CGFloat
        
        
        // MARK: - Init
        
        public init(size: CGSize = .init(width: 36, height: 36),
                    backgroundColor: UIColor = UIColor(white: 1, alpha: 0.75),
                    image: UIImage? = nil,
                    title: String? = "⌘",
                    tintColor: UIColor = UIColor(white: 0.7, alpha: 0.75),
                    alpha: CGFloat = 0.8)
        {
            self.size = size
            self.backgroundColor = backgroundColor
            self.image = image
            self.title = title
            self.tintColor = tintColor
            self.alpha = alpha
        }
    }
    
}
