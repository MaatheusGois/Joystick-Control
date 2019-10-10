//
//  GameScene.swift
//  joystick
//
//  Created by Matheus Silva on 09/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let nave = SKSpriteNode(imageNamed: "ship")
    
    var velocidadX: CGFloat = 0.0
    var velocidadY: CGFloat = 0.0
    
    var 🕹️: Joystick = Joystick(radius: 100)
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .white
        
        🕹️.setPosition(withLocation: CGPoint(x: 0, y: -size.height/3))
        addChild(🕹️)
        addChild(🕹️.child)
        

        nave.physicsBody = SKPhysicsBody(rectangleOf: nave.frame.size)
        nave.position = CGPoint(x: self.frame.midX,y: self.frame.midY)
        nave.xScale = 0.5
        nave.yScale = 0.5
        
    
        addChild(nave)
        
        //Deixa a gravidade valendo 0
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            🕹️.activo = 🕹️.child.frame.contains(location) ? true : false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if 🕹️.activo {
                let dist = 🕹️.getDist(withLocation: location)
                
                nave.zRotation = 🕹️.angulo - 1.57079633
                velocidadX = dist.xDist / 16
                velocidadY = dist.yDist / 16
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if 🕹️.activo {
            🕹️.coreReturn()
            velocidadX = 0
            velocidadY = 0
        }
    }
    
    var lastTime: TimeInterval = TimeInterval()
    var deltaTime: TimeInterval = TimeInterval()
    
    override func update(_ currentTime: CFTimeInterval) {
        //Delta time garante que a velocidade vai ser sempre a mesma independente da velocidade do dispositivo.
        deltaTime = currentTime - lastTime
        
        if 🕹️.activo {
            nave.position = CGPoint(x: nave.position.x - (velocidadX),
                                    y: nave.position.y + (velocidadY))
        }
        
        lastTime = currentTime
    }
}

