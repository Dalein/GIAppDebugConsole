//
//  AppDebugConsole.swift
//
//  Created by daleijn on 25.05.2021.
//  Copyright © 2021 Ivan Gnatyuk. All rights reserved.
//

import UIKit

/// Console configurator. If you would like to create custom console
final public class GIAppDebugConsoleConfigurator {
    
    /// Create console with custom UI
    /// - Parameter consoleUIConfig: Console UI config
    public static func configureAppDebugConsole(consoleUIConfig: GIAppDebugConsoleUIConfig) {
        GIAppDebugConsole.shared = GIAppDebugConsole(consoleUIConfig: consoleUIConfig)
    }
    
}


final public class GIAppDebugConsole: NSObject, UIGestureRecognizerDelegate {
    private var uiConfigurator: AppDebugConsoleUIConfigurator!
    
    // MARK: - Init
    
    fileprivate init(consoleUIConfig: GIAppDebugConsoleUIConfig) {
        self.uiConfigurator = .init(consoleUIConfig: consoleUIConfig)
        super.init()
        createConsoleView()
    }
    
    
    // MARK: - Properties
    
    private lazy var consoleWindow: ConsoleWindow = {
        let window = ConsoleWindow()
        window.backgroundColor = .clear
        window.windowLevel = UIWindow.Level.statusBar
        window.isHidden = true
        return window
    }()
    
    private let viewController = UIViewController()
    private lazy var consoleView = viewController.view!
    
    /// Feedback generator for the long press action.
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    /// Used for panning
    private lazy var consoleViewLocation: CGPoint = .zero
    
    /// Tracks whether the PiP console is in text view scroll mode or pan mode.
    private var scrollLocked = true
    
    private var lastTranslationDeltaY: CGFloat?
    
    private lazy var panGestureRec: UIPanGestureRecognizer = {
        var panGestureRec = UIPanGestureRecognizer(target: self,
                                                   action: #selector(handleMapViewPanning(gestureRecognizer:)))
        panGestureRec.delegate = self
        return panGestureRec
    }()
    
    private lazy var longPressRecognizer: UILongPressGestureRecognizer = {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(longPressAction(recognizer:)))
        longPressRecognizer.minimumPressDuration = 0.3
        longPressRecognizer.delegate = self
        return longPressRecognizer
    }()
    
    private lazy var consoleTextView: UITextView = {
        uiConfigurator.createConsoleTextView(parentFrame: consoleView.bounds)
    }()
    
    private lazy var menuButton: GIMenuButton = {
        uiConfigurator.createMenuButton(parentSize: consoleView.bounds.size)
    }()
    
    private var separateSymbol: String {
        isSeparateLogsByNewLine ? "\n" : ""
    }

    
    // MARK: - API
    
    /// Is it need to insert new line symbols between log print statements.
    /// `true` by default.
    public var isSeparateLogsByNewLine = true
    
    /// Shared instance
    public fileprivate(set) static var shared: GIAppDebugConsole = .init(consoleUIConfig: .init())
    
    /// Show console
    public func show() {
        consoleWindow.isHidden = false
    }
    
    /// Hide console
    public func hide() {
        consoleWindow.isHidden = true
    }
    
    /// Log items to the console view.
    /// Executing on the **main thread**.
    public func log(_ log: String) {
        logAttributed(.init(string: "\(separateSymbol)\(log)\(separateSymbol)",
                            attributes: uiConfigurator.defaultTextAttributes))
    }
    
    /// Log items to the console view.
    /// Executing on the **main thread**.
    public func logAttributed(_ log: NSAttributedString) {
        DispatchQueue.main.async { [self] in
            consoleTextView.attributedText = {
                let currAttributedText = NSMutableAttributedString(attributedString: consoleTextView.attributedText ?? .init(string: ""))
                currAttributedText.append(.init(string: separateSymbol))
                currAttributedText.append(log)
                currAttributedText.append(.init(string: separateSymbol))
                return currAttributedText
            }()
        }
    }
    
    /// Add action to the actions menu
    public func addAction(_ action: GIAction) {
        menuButton.giMenu?.addAction(action)
    }
    

    // MARK: - UIGestureRecognizerDelegate
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if gestureRecognizer == longPressRecognizer, otherGestureRecognizer == panGestureRec {
            return true
        }
        
        return false
    }
    
}


// MARK: - Config console
private extension GIAppDebugConsole {
    
    func createConsoleView() {
        configConsoleView(consoleView)
        
        consoleWindow.addSubview(consoleView)
        consoleView.addSubview(consoleTextView)
        consoleView.addSubview(menuButton)
        
        menuButton.giMenu = makeMenu()
    }
    
    func configConsoleView(_ viewConsole: UIView) {
        viewConsole.frame = uiConfigurator.consoleUIConfig.consoleFrame
        viewConsole.backgroundColor = uiConfigurator.consoleUIConfig.consoleBackgroundColor

        viewConsole.layer.shadowRadius = 16
        viewConsole.layer.shadowOpacity = 0.5
        viewConsole.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewConsole.layer.cornerRadius = 20
    
        viewConsole.addGestureRecognizer(panGestureRec)
        viewConsole.addGestureRecognizer(longPressRecognizer)
        viewConsole.addGestureRecognizer(UIPinchGestureRecognizer(target: self,
                                                                  action: #selector(handlePinch)))
    }
    
}


// MARK: - GestureRecognizers handle
private extension GIAppDebugConsole {

    @objc func handleMapViewPanning(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        
        case .began:
            consoleViewLocation = consoleView.center
            
        case .changed:
            let translation = gestureRecognizer.translation(in: consoleView.superview)
            consoleView.center = .init(x: consoleViewLocation.x + translation.x,
                                       y: consoleViewLocation.y + translation.y)
            
        case .ended, .cancelled, .failed:
          break
            
        default:
            break
        }
    }
    
    @objc func longPressAction(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        
        case .began:
            feedbackGenerator.selectionChanged()
            scrollLocked = false
            
            UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1) { [self] in
                consoleView.transform = .init(scaleX: 1.04, y: 1.04)
                consoleTextView.alpha = 0.5
            }.startAnimation()
            
        case .cancelled, .ended:
            scrollLocked = true
            
            UIViewPropertyAnimator(duration: 0.8, dampingRatio: 0.5) { [self] in
                consoleView.transform = .init(scaleX: 1, y: 1)
            }.startAnimation()
            
            UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1) { [self] in
                consoleTextView.alpha = 1
            }.startAnimation()
            
        default: break
        }
    }
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        
        var curConsoleFrame = gestureView.frame
        
        let newSize: CGSize = {
            let consoleDefaultSize = uiConfigurator.consoleUIConfig.consoleDefaultSize
            
            return .init(width: max(consoleDefaultSize.width, min(uiConfigurator.consoleUIConfig.consoleMaxSize.width,
                                                                  curConsoleFrame.size.width * gesture.scale)),
                         height: max(consoleDefaultSize.height, min(uiConfigurator.consoleUIConfig.consoleMaxSize.height,
                                                                    curConsoleFrame.size.height * gesture.scale)))
        }()
        
        curConsoleFrame.size = newSize
        
        gestureView.frame = curConsoleFrame
        gesture.scale = 1
        
        updateMenuButtonFrame()
        updateTextViewFrame()
    }
}


// MARK: - Menu config
private extension GIAppDebugConsole {
    
    func makeMenu() -> GIMenu {
       let menu = GIMenu(actions: [
            GIAction(title: "Copy", image: nil, handler: { [weak self] in
                self?.copy()
            }),
            GIAction(title: "Clear console", image: nil, handler: { [weak self] in
                self?.clearConsole()
            })
        ],
        parentView: consoleWindow,
        sourceView: menuButton)
        
        return menu
    }
    
}


// MARK: Menu actions
private extension GIAppDebugConsole {
    
    func clearConsole() {
        consoleTextView.text = ""
    }
    
    func copy() {
        UIPasteboard.general.string = consoleTextView.text
    }
    
    func updateMenuButtonFrame() {
        menuButton.frame = uiConfigurator.menuButtonFrame(by: consoleView.bounds.size)
    }
    
    func updateTextViewFrame() {
        consoleTextView.frame = consoleView.bounds.inset(by: .init(top: 8, left: 8,
                                                                   bottom: 8, right: 8))
    }
    
}


/// Custom window for the console to appear above other
/// windows while passing touches down.
private class ConsoleWindow: UIWindow {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) {
            return hitView.isKind(of: ConsoleWindow.self) ? nil : hitView
        }
        return super.hitTest(point, with: event)
    }
    
}
