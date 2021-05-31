//
//  AppDebugConsoleMenu.swift
//
//  Created by daleijn on 27.05.2021.
//  Copyright © 2021 Ivan Gnatyuk. All rights reserved.
//

import UIKit

final public class GIMenu: UIView {
    
    private let stackViewContainer: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .fill
        sv.spacing = 4
        sv.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        return sv
    }()
    
    
    // MARK: - API
    
    
    /// Show/hide actions menu
    var show: Bool = false {
        didSet {
            show ? showMenu() : hideMenu()
        }
    }
    
    /// Add action to menu
    /// - Parameter action: New action
    func addAction(_ action: GIAction) {
        addActionToMenu(action)
    }

    
    // MARK: - Init
    
    /// Init menu
    /// - Parameters:
    ///   - actions: Actions
    ///   - parentView: View on which **menu** will be added
    ///   - sourceView: View above which **menu** will be placed
    init(actions: [GIAction], parentView: UIView, sourceView: UIView) {
        super.init(frame: .zero)
        
        configUI()
        setupStackViewContainer(with: actions)
        addMenu(on: parentView, ancoring: sourceView)
        
        hideMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
}


// MARK: - Config View
private extension GIMenu {
    
    func configUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .groupTableViewBackground
        self.layer.cornerRadius = 12
    }
    
    func setupStackViewContainer(with actions: [GIAction]) {
        self.addSubview(stackViewContainer)
        stackViewContainer.pin(to: self,
                               edges: .init(top: 8, left: 16, bottom: 8, right: 16))
        
        actions.forEach { action in
            addActionToMenu(action)
        }
    }
    
    func addActionToMenu(_ action: GIAction) {
        stackViewContainer.addArrangedSubview(
            GIAction(title: action.title, image: action.image,
                     handler: { [weak self] in
                        action.handler()
                        self?.actionDidTap()
                     }))
    }
    
    func actionDidTap()  {
        show.toggle()
    }
    
    func addMenu(on parentView: UIView, ancoring sourceView: UIView) {
        parentView.addSubview(self)
        
        NSLayoutConstraint.activate([
            sourceView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 4),
            self.trailingAnchor.constraint(equalTo: sourceView.trailingAnchor, constant: 0)
        ])
    }
}

private extension GIMenu {
    
    func showMenu() {
        self.isHidden = false
        
        self.transform = .init(scaleX: 0, y: 0)
        animate { self.transform = .identity }
    }
    
    func hideMenu() {
        self.isHidden = true
    }

    func animate(_ block: @escaping ()->()) {
        UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1) {
            block()
        }.startAnimation()
    }
    
}
