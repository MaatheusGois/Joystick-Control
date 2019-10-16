//
//  GameScene.swift
//  joystick
//
//  Created by Matheus Silva on 09/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import SpriteKit

enum MapCase: Int {
    case red = 0
    case grey
    case brown
}

enum CollisionTypes: UInt32 {
    case playerCollisionMask = 1
    case wallCollisionMask = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Map
    let map = SKNode()
    let tileSet = SKTileSet(named: "mapTest")!
    let tileSize = CGSize(width: 128, height: 128)
    var columns = 0
    var rows = 0
    var layer = SKTileMapNode()
    var halfWidth: CGFloat = CGFloat()
    var halfHeight: CGFloat = CGFloat()
    var startingLocation: CGPoint = CGPoint()
    
    //Joystick
    let ship = SKSpriteNode(imageNamed: "ship")
    var 🕹️: Joystick = Joystick(radius: 50)
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .white
        
        setupPhysics()
        setupShip()
        setupMap()
        
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //        🕹️.activo = false
        🕹️.coreReturn()
        🕹️.hiden()
    }
    
    func setupMap() {
        
        guard let mapJSON = MapHandler.loadMap() else { return }
        columns = mapJSON.getColumns()
        rows = mapJSON.getRows()
        
        addChild(map)
        map.position = ship.position
        startingLocation = map.position
        
        map.xScale = 0.4
        map.yScale = 0.4
        
        let grassTile = tileSet.tileGroups.first { $0.name == "Grass" }
        let sandTile = tileSet.tileGroups.first { $0.name == "Sand"}
        let waterTile = tileSet.tileGroups.first { $0.name == "Water"}
        
        let bottomLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        bottomLayer.fill(with: sandTile)
        map.addChild(bottomLayer)
        
        layer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        
        map.addChild(layer)
        
        
        halfWidth  = CGFloat(columns) / 2.0 * tileSize.width
        halfHeight = CGFloat(rows) / 2.0 * tileSize.height
        
        let sprites = SKTextureAtlas(named: "MySprites")
        
        sprites.preload {
            self.fillMap(mapJSON: mapJSON, grassTile: grassTile, sandTile: sandTile, waterTile: waterTile) {
                self.giveTileMapPhysicsBody(map: self.layer)
            }
        }
        
        
    }
    
    func fillMap(mapJSON: Map,
                 grassTile: SKTileGroup?,
                 sandTile: SKTileGroup?,
                 waterTile: SKTileGroup?,
                 WithCompletion completion: @escaping() -> Void) {
        
        for column in 0 ..< layer.numberOfColumns {
            for row in 0 ..< layer.numberOfRows {
                switch mapJSON.map[column][row] {
                case MapCase.red.rawValue:
                    layer.setTileGroup(grassTile, forColumn: column, row: row)
                case MapCase.grey.rawValue:
                    layer.setTileGroup(sandTile, forColumn: column, row: row)
                default:
                    layer.setTileGroup(waterTile, forColumn: column, row: row)
                }
                
            }
        }
        completion()
    }
    
    func giveTileMapPhysicsBody(map: SKTileMapNode)
    {
        let tileMap = map
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row)
                {
                    let tileArray = tileDefinition.textures
                    
                    let tileTexture = tileArray[0]
                    let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width/2)
                    let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)

                    let tileNode = SKNode()
                    tileNode.position = CGPoint(x: x, y: y)
                    tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, alphaThreshold: 0.3, size: tileTexture.size())
                    tileNode.physicsBody?.isDynamic = false
                
                    tileMap.addChild(tileNode)
                }
            }
        }
    }
    
    func setupShip(){
        //Gera a posicao das partes do controle e os adiciona a SKView os escondendo
        🕹️.setNewPosition(withLocation: CGPoint(x: 0, y: -size.height/3))
        addChild(🕹️)
        addChild(🕹️.child) //FIXME
        🕹️.hiden()
        
        ship.physicsBody = SKPhysicsBody(rectangleOf: ship.frame.size)
        ship.position = CGPoint(x: self.frame.midX,
                                y: self.frame.midY)
        ship.physicsBody?.categoryBitMask = CollisionTypes.playerCollisionMask.rawValue
        ship.physicsBody?.collisionBitMask = 0
        
        ship.xScale = 0.5
        ship.yScale = 0.5
        
        addChild(ship)
    }
    
    func setupPhysics() {
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
                🕹️.getDist(withLocation: location)
                
                //Retorna para onde a nave deve apontar
                ship.zRotation = 🕹️.getZRotation()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if 🕹️.activo {
            //Quando o toque acaba o botao central do joystick volta para a posicao inicial e a velocidade
            //da nave é passada para 0.
            🕹️.coreReturn()
            🕹️.hiden()
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if 🕹️.activo {
            map.position = CGPoint(x: map.position.x + (🕹️.vDx / 16),
                                   y: map.position.y - (🕹️.vDy / 16))
        }
    }
}

