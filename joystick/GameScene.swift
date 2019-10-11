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
    
    var 🕹️: Joystick = Joystick(radius: 50)
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .white
        
        //Gera a posicao das partes do controle e os adiciona a SKView os escondendo
        🕹️.setNewPosition(withLocation: CGPoint(x: 0, y: -size.height/3))
        addChild(🕹️)
        addChild(🕹️.child) //FIXME
        🕹️.hiden()
        
        //Configura a Nave
        nave.physicsBody = SKPhysicsBody(rectangleOf: nave.frame.size)
        nave.position = CGPoint(x: self.frame.midX,
                                y: self.frame.midY)
        nave.xScale = 0.5
        nave.yScale = 0.5
        
        addChild(nave)
        
        //Deixa a gravidade valendo 0
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x:      self.frame.minX,
                                                              y:      self.frame.minY,
                                                              width:  self.frame.size.width,
                                                              height: self.frame.size.height))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if !🕹️.activo {
                //Coloca o joystick onde o click comecou e inicia o movimento.
                🕹️.setNewPosition(withLocation: CGPoint(x: location.x, y: location.y))
                🕹️.activo = true
                🕹️.show()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if 🕹️.activo {
                
                //Toda a lógica matematica na funcao "getDist"
                let dist = 🕹️.getDist(withLocation: location)
                
                //Retorna para onde a nave deve apontar
                nave.zRotation = 🕹️.getZRotation()
                
                //Diivide a velocidade por 16 para diminui-la
                velocidadX = dist.xDist * 100
                velocidadY = dist.yDist * 100
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if 🕹️.activo {
            🕹️.coreReturn()
            nave.physicsBody?.applyForce(CGVector(dx: velocidadX, dy: -velocidadY))
            🕹️.hiden()
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        //...
    }
}

