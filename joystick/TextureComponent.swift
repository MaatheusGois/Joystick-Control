//
//  TextureComponet.swift
//  joystick
//
//  Created by Matheus Silva on 21/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import GameplayKit
import SpriteKit

class SpriteComponent: GKComponent {
    let node: SKSpriteNode

    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
