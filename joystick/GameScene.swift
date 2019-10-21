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
    
    var lastTime: TimeInterval = TimeInterval()
    var deltaTime: TimeInterval = TimeInterval()
    
    //TEXTURE
    private let N: SKTextureAtlas = SKTextureAtlas(named: "N")
    private let NE: SKTextureAtlas = SKTextureAtlas(named: "NE")
    private let L: SKTextureAtlas = SKTextureAtlas(named: "L")
    private let SE: SKTextureAtlas = SKTextureAtlas(named: "SE")
    
    private let S: SKTextureAtlas = SKTextureAtlas(named: "S")
    private let SO: SKTextureAtlas = SKTextureAtlas(named: "SO")
    private let O: SKTextureAtlas = SKTextureAtlas(named: "O")
    private let NO: SKTextureAtlas = SKTextureAtlas(named: "NO")
    
    
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
                playerMovedFor(zRotation: nave.zRotation )
                
                
                
                //Diivide a velocidade por 16 para diminui-la
                velocidadX = dist.xDist / 16
                velocidadY = dist.yDist / 16
            }
        }
    }
    
    
    func playerMovedFor(zRotation: CGFloat) {
        // 0.5 = 90 graus
        // x = 0.5 / 2
        // y = 0.5 / 4
        switch zRotation / .pi {
            
            case 0 ..< 0.125:
                print("N")
            
            case -0.125 ..< 0:
                print("N")
            
            case -0.375 ..< -0.125:
                print("NE")
            
            case -0.625 ..< -0.375:
                print("L")
            
            case -0.875 ..< -0.625:
                print("SE")
            
            case -1.125 ..< -0.875:
                print("S")
            
            case -1.375 ..< -1.125:
                print("SO")
            
            case -1.5 ..< -1.375:
                print("O")
            
            case 0.375 ..< 0.5:
                print("O")
            
            case 0 ..< 0.375:
                print("NO")
            default:
                print("RUIM")
        }
    }
    
    func switchTexture() {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if 🕹️.activo {
            //Quando o toque acaba o botao central do joystick volta para a posicao inicial e a velocidade
            //da nave é passada para 0.
            🕹️.coreReturn()
            velocidadX = 0
            velocidadY = 0
            🕹️.hiden()
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        //Delta time garante que a velocidade vai ser sempre a mesma independente da velocidade do dispositivo.
        deltaTime = currentTime - lastTime //TODO - Fazer a velocidade ser multipliacada por essa variavel
        
        if 🕹️.activo {
            nave.position = CGPoint(x: nave.position.x - (velocidadX),
                                    y: nave.position.y + (velocidadY))
        }
        
        
        lastTime = currentTime
    }
}

