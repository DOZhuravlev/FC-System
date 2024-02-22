//
//  DrawingView.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 08.02.2024.
//

import Foundation
import UIKit

final class DrawingView: UIView {

    // MARK: - Properties

    private var lines: [CAShapeLayer] = []
    private var currentPath: UIBezierPath?
    private var startPoint: CGPoint?

    // MARK: - Actions

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for line in lines {
            layer.addSublayer(line)
        }
        if let path = currentPath {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = 7
            layer.addSublayer(shapeLayer)
        }

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        startPoint = touch.location(in: self)
        currentPath = UIBezierPath()
        currentPath?.move(to: startPoint!)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        currentPath?.addLine(to: currentPoint)
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let path = currentPath {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            lines.append(shapeLayer)
            currentPath = nil
            startPoint = nil
            setNeedsDisplay()
        }
    }

    func clearDrawing() {
        lines.removeAll()
        layer.sublayers = nil
        setNeedsDisplay()
    }
}
