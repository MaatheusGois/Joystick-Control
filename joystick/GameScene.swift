//
//  GameScene.swift
//  joystick
//
//  Created by Matheus Silva on 09/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let joys = SKSpriteNode(imageNamed: "JOYS")
    let base = SKSpriteNode(imageNamed: "base")
    let nave = SKSpriteNode(imageNamed: "ship")
    
    var velocidadX: CGFloat = 0.0
    var velocidadY: CGFloat = 0.0
    
    var joysActivo:Bool = false
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .white
        
        base.position = CGPoint(x: 0 , y: 0 )
        base.setScale(0.5)
        base.zPosition = 1.0
        base.alpha = 0.2
        addChild(base)
        
        joys.position = base.position
        joys.setScale(0.5)
        joys.zPosition = 2.0
        joys.alpha = 0.2
        joys.setScale(0.4)
        addChild(joys)
        
        nave.position = CGPoint(x: self.frame.midX,y: self.frame.midY)
        nave.xScale = 0.5
        nave.yScale = 0.5
        
        nave.physicsBody = SKPhysicsBody(rectangleOf: nave.frame.size)
        nave.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))

        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(
            x: self.frame.minX,
            y: self.frame.minY + nave.frame.size.height + 10,
            width: self.frame.size.width,
            height: (self.frame.size.height - (nave.frame.size.height + 10) * 2)))
        
        addChild(nave)
    }
    
     
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if (joys.frame.contains(location)){
                joysActivo = true
            } else {
                joysActivo = false
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if joysActivo == true {
            
                let vector = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
                let angulo = atan2(vector.dy, vector.dx)
                let radio: CGFloat = base.frame.size.height / 2
                
                let xDist:CGFloat = sin(angulo - 1.57079633) * radio
                let yDist:CGFloat = cos(angulo - 1.57079633) * radio
                
                if (base.frame.contains(location)) {
                    joys.position = location
                } else {
                    joys.position = CGPoint(x: base.position.x - xDist, y: base.position.y + yDist)
                }
                
                nave.zRotation = angulo - 1.57079633
                
                velocidadX = xDist / 16
                velocidadY = yDist / 16
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if joysActivo == true {
            let retorno: SKAction = SKAction.move(to: base.position, duration: 0.05)
            retorno.timingMode = .easeOut
            joys.run(retorno)
            joysActivo = false
            velocidadX = 0
            velocidadY = 0
        }
    }
    
    var lastTime: TimeInterval = TimeInterval()
    var deltaTime: TimeInterval = TimeInterval()
    
    override func update(_ currentTime: CFTimeInterval) {
        //Delta time garante que a velocidade vai ser sempre a mesma independente da velocidade do dispositivo.
        
        deltaTime = currentTime - lastTime
        
        
        if joysActivo == true {
            nave.position = CGPoint(x: nave.position.x - (velocidadX),
                                    y: nave.position.y + (velocidadY))
        }
        lastTime = currentTime
    }
}

