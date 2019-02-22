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
        var shapeWidth = bounds.width * 0.2
        var shapeHeight = shapeWidth * 2
        if shapeHeight > bounds.height * 0.75 {
            shapeHeight = bounds.height * 0.75
            shapeWidth = shapeHeight / 2
        }
        
        var shapeOrigin = CGPoint(x: bounds.midX - shapeWidth / 2, y: bounds.midY - shapeHeight / 2)
        var shapeRect: CGRect {
            return CGRect(origin: shapeOrigin, size: CGSize(width: shapeWidth, height: shapeHeight))
        }
        var offset = shapeRect.width * 1.3
        
        switch number! {
        case 0:
            drawShape(using: shapeRect)
        case 1:
            offset = (shapeOrigin.x - (shapeOrigin.x - offset)) / 2
            shapeOrigin = CGPoint(x: shapeOrigin.x - offset, y: shapeOrigin.y)
            drawShape(using: shapeRect)
            
            shapeOrigin = CGPoint(x: shapeOrigin.x + 2 * offset, y: shapeOrigin.y)
            drawShape(using: shapeRect)
        case 2:
            drawShape(using: shapeRect)
            
            shapeOrigin = CGPoint(x: shapeOrigin.x - offset, y: shapeOrigin.y)
            drawShape(using: shapeRect)
            
            shapeOrigin = CGPoint(x: shapeOrigin.x + 2 * offset, y: shapeOrigin.y)
            drawShape(using: shapeRect)
        default:
            fatalError("Should only be 3 possible card numbers")
        }
    }
    
    private func drawShape(using rect: CGRect) {
        var path = UIBezierPath()
        // Draw shape
        switch shape! {
        case .oval:
            path = UIBezierPath(roundedRect: rect, cornerRadius: rect.width / 2)
        case .diamond:
            path = UIBezierPath()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.close()
        case .squiggle:
            path = UIBezierPath()
            
            let squiggleWidth = rect.width * 0.75
            let squiggleHeight = rect.height * 0.55
            let widthSegment = rect.width / 4
            let heightSegment = rect.height / 4
            
            // Base points
            let topLeft = CGPoint(x: rect.midX - squiggleWidth / 2, y: rect.midY - squiggleHeight / 2)
            let bottomLeft = CGPoint(x: rect.midX - squiggleWidth / 2, y: rect.midY + squiggleHeight / 2)
            let topRight = CGPoint(x: topLeft.x + squiggleWidth, y: topLeft.y)
            let bottomRight = CGPoint(x: bottomLeft.x + squiggleWidth, y: bottomLeft.y)
            
            // Bezier points
            let leftBezierPoint1 = CGPoint(x: topLeft.x + widthSegment, y: topLeft.y + heightSegment)
            let leftBezierPoint2 = CGPoint(x: bottomLeft.x - widthSegment, y: bottomLeft.y - heightSegment)
            
            let rightBezierPoint1 = CGPoint(x: topRight.x + widthSegment, y: topRight.y + heightSegment)
            let rightBezierPoint2 = CGPoint(x: bottomRight.x - widthSegment, y: bottomRight.y - heightSegment)
            
            let topBezierPoint1 = CGPoint(x: topLeft.x - (leftBezierPoint1.x - topLeft.x), y: topLeft.y - (leftBezierPoint1.y - topLeft.y))
            let topBezierPoint2 = CGPoint(x: topRight.x - (rightBezierPoint1.x - topRight.x), y: topRight.y - (rightBezierPoint1.y - topRight.y) * 1.2)
            
            let bottomBezierPoint1 = CGPoint(x: rect.midX + (rect.midX - topBezierPoint1.x), y: rect.midY + (rect.midY - topBezierPoint1.y))
            let bottomBezierPoint2 = CGPoint(x: rect.midX + (rect.midX - topBezierPoint2.x), y: rect.midY + (rect.midY - topBezierPoint2.y))
            
            // Left side
            path.move(to: bottomLeft)
            path.addCurve(to: topLeft, controlPoint1: leftBezierPoint2, controlPoint2: leftBezierPoint1)
            
            // Top
            path.addCurve(to: topRight, controlPoint1: topBezierPoint1, controlPoint2: topBezierPoint2)
            
            // Right side
            path.addCurve(to: bottomRight, controlPoint1: rightBezierPoint1, controlPoint2: rightBezierPoint2)
            
            // Bottom
            path.addCurve(to: bottomLeft, controlPoint1: bottomBezierPoint1, controlPoint2: bottomBezierPoint2)
        }
        
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(path.cgPath)
        context?.saveGState()
        path.addClip()
        
        // Add shading
        switch shading! {
        case .solid:
            path.fill()
        case .outlined, .striped:
            path.lineWidth = rect.height * 0.1
            path.stroke()
            
            if shading == .striped {
                let numberOfStripes = 12
                let stripe = UIBezierPath()
                stripe.lineWidth = rect.height * 0.03
                var firstPoint = CGPoint(x: rect.minX, y: rect.minY)
                var secondPoint = CGPoint(x: rect.maxX, y: firstPoint.y)
                stripe.move(to: firstPoint)
                stripe.addLine(to: secondPoint)
                for _ in 0..<numberOfStripes {
                    firstPoint = CGPoint(x: firstPoint.x, y: firstPoint.y + rect.height / CGFloat(numberOfStripes))
                    secondPoint = CGPoint(x: rect.maxX, y: firstPoint.y)
                    
                    stripe.move(to: firstPoint)
                    stripe.addLine(to: secondPoint)
                }
                
                stripe.stroke()
            }
        }
        context?.restoreGState()
    }

}
