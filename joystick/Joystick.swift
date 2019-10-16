//
//  Joystick.swift
//  joystick
//
//  Created by Matheus Silva on 09/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import SpriteKit

class Joystick: SKShapeNode {
    
    public var activo: Bool = false
    
    private(set) var radius: CGFloat = 0
    private(set) var child: SKShapeNode = SKShapeNode()
    
    private(set) var vector: CGVector = CGVector()
    private(set) var angle: CGFloat = 0
    private(set) var raio: CGFloat = 0
    
    public var vDx: CGFloat = CGFloat()
    public var vDy: CGFloat = CGFloat()
    
    private var radius90: CGFloat = 1.57079633
    
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
    
    
    private func createJoystickBase() {
        self.path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -radius, y: -radius),
                                             size:   CGSize(width: radius * 2, height: radius * 2)),
                                             transform: nil)
        self.strokeColor = .black
        self.alpha = 0.2
        self.lineWidth = 0.5
        self.zPosition = 1.0
    }
    
    private func createJoystickBaseMain() {
        child = SKShapeNode(circleOfRadius: radius / 2)
        child.strokeColor = .black
        child.alpha = 0.3
        child.lineWidth = 0.7
        child.zPosition = 2.0
    }
    
    public func setNewPosition(withLocation location: CGPoint) {
        position = location
        child.position = location
    }
    
    public func getDist(withLocation location: CGPoint) {
        
        vector = CGVector(dx: location.x - position.x,
                          dy: location.y - position.y)
        angle = atan2(vector.dy, vector.dx)
        raio  = frame.size.height / 2.0
        
        vDx = sin(angle - radius90) * raio
        vDy = cos(angle - radius90) * raio
        
        if (frame.contains(location)) {
            child.position = location
        } else {
            child.position = CGPoint(x: position.x - vDx,
                                     y: position.y + vDy)
        }
    }
    
    public func coreReturn() { //REMAKE - Mudar nome da funcao para ter mais coerencia.
        let retorno: SKAction = SKAction.move(to: position, duration: 0.05)
        retorno.timingMode = .easeOut
        child.run(retorno)
        activo = false
        //TODO - suavisar retorno
        vDx = 0
        vDy = 0
    }
    
    public func getZRotation() -> CGFloat {
        return angle - radius90
    }
    
    public func hiden() {
        run(SKAction.fadeAlpha(to: 0.0, duration: 0.5))
        child.run(SKAction.fadeAlpha(to: 0.0, duration: 0.5))
    }
    
    public func show() {
        run(SKAction.fadeAlpha(to: 0.2, duration: 0.5))
        child.run(SKAction.fadeAlpha(to: 0.3, duration: 0.5))
    }
}
