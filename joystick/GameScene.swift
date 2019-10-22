//
//  GameScene.swift
//  joystick
//
//  Created by Matheus Silva on 09/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "N_00")
    
    var velocidadX: CGFloat = 0.0
    var velocidadY: CGFloat = 0.0
    
    var lastTime: TimeInterval = TimeInterval()
    var deltaTime: TimeInterval = TimeInterval()
    
    var textures = [[SKTexture]]()
    let textureNames = ["N","NE","L","SE","S","SO","O","NO"]
    var lastMoved = ""
    
    
    var 🕹️: Joystick = Joystick(radius: 50)
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .white
        
        //LOAD
        loadTextures()
        
        //Gera a posicao das partes do controle e os adiciona a SKView os escondendo
        🕹️.setNewPosition(withLocation: CGPoint(x: 0, y: -size.height/3))
        addChild(🕹️)
        addChild(🕹️.child) //FIXME
        🕹️.hiden()
        
        //Configura a Nave
        player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)
        player.position = CGPoint(x: self.frame.midX,
                                y: self.frame.midY)
        player.xScale = 1
        player.yScale = 1
        
        addChild(player)
        
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
//                nave.zRotation = 🕹️.getZRotation()
                playerMovedFor(zRotation: 🕹️.getZRotation())
                
                
                
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
            
            case -0.125 ..< 0.125:
                print("N")
                animateFor(for: "N")
            
            case -0.375 ..< -0.125:
                print("NE")
            
            case -0.625 ..< -0.375:
                print("L")
                animateFor(for: "L")
            
            case -0.875 ..< -0.625:
                print("SE")
            
            case -1.125 ..< -0.875:
                print("S")
                animateFor(for: "S")
            
            case -1.375 ..< -1.125:
                print("SO")
            
            case -1.5 ..< -1.375:
                print("O")
                animateFor(for: "O")
                
            
            case 0.375 ..< 0.5:
                print("O")
                animateFor(for: "O")
                
            
            case 0 ..< 0.375:
                print("NO")
            default:
                print("RUIM")
        }
    }
    
    func animateFor(for position: String) {
        if lastMoved != position {
            guard let index = textureNames.firstIndex(of: position) else { return }
            animate(in: player, with: textures[index])
            lastMoved = position
        }
    }

    func animate(in obj: SKSpriteNode, with frames: [SKTexture]) {
        let animate = SKAction.animate(with: frames, timePerFrame: 1 / (TimeInterval(frames.count)))
        obj.run(SKAction.repeatForever(animate), withKey: "moved")
    }
    
    func buildAtlasTexture(to name: String) -> [SKTexture] {
      let animatedAtlas = SKTextureAtlas(named: name)
      var frames: [SKTexture] = []

      let numImages = animatedAtlas.textureNames.count
      for i in 0..<numImages {
        let textureName = "\(name)_0\(i)"
        frames.append(animatedAtlas.textureNamed(textureName))
      }
      return frames
    }
    
    func loadTextures() {
        for name in textureNames {
            textures.append(buildAtlasTexture(to: name))
        }
    }

    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if 🕹️.activo {
            //Quando o toque acaba o botao central do joystick volta para a posicao inicial e a velocidade
            //da nave é passada para 0.
            🕹️.coreReturn()
            velocidadX = 0
            velocidadY = 0
            🕹️.hiden()
            player.removeAction(forKey: "moved")
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        //Delta time garante que a velocidade vai ser sempre a mesma independente da velocidade do dispositivo.
        deltaTime = currentTime - lastTime //TODO - Fazer a velocidade ser multipliacada por essa variavel
        
        if 🕹️.activo {
            player.position = CGPoint(x: player.position.x - (velocidadX),
                                    y: player.position.y + (velocidadY))
        }
        
        
        lastTime = currentTime
    }
}

