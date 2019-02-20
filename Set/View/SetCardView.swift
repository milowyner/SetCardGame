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
        
        // Set fill color
        color.setFill()
        color.setStroke()
        
        
        // Set generic shape rect
        let shapeHeight = bounds.height * 0.75
        let shapeWidth = shapeHeight / 2
        let shapeOrigin = CGPoint(x: bounds.midX - shapeWidth / 2, y: bounds.midY - shapeHeight / 2)
        let shapeRect = CGRect(origin: shapeOrigin, size: CGSize(width: shapeWidth, height: shapeHeight))
        
        var path = UIBezierPath()
        
        // Draw shape
        switch shape! {
        case .oval:
            path = UIBezierPath(roundedRect: shapeRect, cornerRadius: shapeWidth / 2)
        case .diamond:
            path = UIBezierPath()
            path.move(to: CGPoint(x: shapeRect.midX, y: shapeRect.minY))
            path.addLine(to: CGPoint(x: shapeRect.maxX, y: shapeRect.midY))
            path.addLine(to: CGPoint(x: shapeRect.midX, y: shapeRect.maxY))
            path.addLine(to: CGPoint(x: shapeRect.minX, y: shapeRect.midY))
            path.close()
        case .squiggle:
//            let path = UIBezierPath()
//            path.move(to: CGPoint(x: shapeRect.midX, y: shapeRect.minY))
//            path.addCurve(to: CGPoint(x: shapeRect.midX, y: shapeRect.maxY), controlPoint1: CGPoint(x: shapeRect.maxX, y: shapeRect.midY / 2), controlPoint2: CGPoint(x: shapeRect.minX, y: shapeRect.maxY - shapeRect.midY / 2))
//            path.stroke()
            break
        }
        
        switch shading! {
        case .solid:
            path.fill()
        case .outlined:
            print("outlined")
            path.lineWidth = shapeRect.height * 0.05
            path.stroke()
        case .striped:
            break
        }
        
    }

}
