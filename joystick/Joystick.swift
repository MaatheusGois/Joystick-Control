//
//  Joystick.swift
//  joystick
//
//  Created by Matheus Silva on 09/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation
import SpriteKit

class Joystick: SKShapeNode {
    
    var activo: Bool = false
    var radius: CGFloat = 0
    var child: SKShapeNode = SKShapeNode()
    
    var vector: CGVector = CGVector()
    var angulo: CGFloat = 0
    var raio: CGFloat = 0
    
    override init() {
        super.init()
    }

    convenience init(radius: CGFloat) {
        self.init()
        self.radius = radius
        createJoystickBase()
        createJoystickBaseMain()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createJoystickBase() {
        self.path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -radius,
                                                             y: -radius),
                                             size: CGSize(width: radius * 2,
                                                          height: radius * 2)),
                                             transform: nil)
        self.strokeColor = .black
        self.alpha = 0.2
        self.lineWidth = 0.5
        self.zPosition = 1.0
    }
    
    
    private func createJoystickBaseMain() {
        child = SKShapeNode(circleOfRadius: radius / 2)
        child.strokeColor = .black
        child.alpha = 0.5
        child.lineWidth = 1.0
        child.zPosition = 2.0
    }
    
    func getDist(withLocation location: CGPoint) -> (xDist: CGFloat, yDist: CGFloat) {
        
        vector = CGVector(dx: location.x - self.position.x, dy: location.y - self.position.y)
        angulo = atan2(vector.dy, vector.dx)
        raio = self.frame.size.height / 2
        
        let xDist: CGFloat = sin(angulo - 1.57079633) * raio
        let yDist: CGFloat = cos(angulo - 1.57079633) * raio
        
        if (self.frame.contains(location)) {
            self.child.position = location
        } else {
            self.child.position = CGPoint(x: self.position.x - xDist, y: self.position.y + yDist)
        }
        
        return (xDist: xDist, yDist: yDist)
    }
    
    func coreReturn() {
        let retorno: SKAction = SKAction.move(to: self.position, duration: 0.05)
        retorno.timingMode = .easeOut
        child.run(retorno)
        activo = false
    }
    
    func setPosition(withLocation location: CGPoint) {
        self.position = location
        self.child.position = location
    }
    
    func getZRotation() -> CGFloat {
        return angulo - 1.57079633
    }
    
    func hiden() {
        self.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
        self.child.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
    }
    
    func show() {
        self.run(SKAction.fadeAlpha(to: 0.2, duration: 0.5))
        self.child.run(SKAction.fadeAlpha(to: 0.5, duration: 0.5))
    }
}
