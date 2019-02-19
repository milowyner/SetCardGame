//
//  SetCardView.swift
//  Set
//
//  Created by Milo Wyner on 2/11/19.
//  Copyright © 2019 Milo Wyner. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardView: UIView { // Maybe subclass from UIButton instead of UIView
    
    enum Shape: Int {
        case oval
        case squiggle
        case diamond
    }
    
    enum Shading: Int {
        case solid
        case striped
        case outlined
    }
    
    var shape: Shape!
    var color: UIColor!
    var shading: Shading!
    var number: Int!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.isOpaque = false
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 6.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        self.contentMode = .redraw
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Set radius based on width or height depending on which is smaller
        let radius = bounds.width < bounds.height ? bounds.width * 0.11 : bounds.height * 0.11
        
        // Create and fill bounds rectangle
        let cardRect = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        UIColor.white.setFill()
        cardRect.fill()
        
        // Set color
        let color = #colorLiteral(red: 0.9108959436, green: 0.2550508642, blue: 0.2757832707, alpha: 1)
        if shape == Shape.oval {
            // Draw shape
            let ovalHeight = bounds.height * 0.75
            let ovalWidth = ovalHeight / 2
            let ovalRect = CGRect(x: bounds.maxX / 2 - ovalWidth / 2, y: bounds.maxY / 2 - ovalHeight / 2, width: ovalWidth, height: ovalHeight)
            let path = UIBezierPath(roundedRect: ovalRect, cornerRadius: ovalWidth / 2)
            
            color.setFill()
            path.fill()
        }
    }

}
