//
//  GameViewController.swift
//  joystick
//
//  Created by Matheus Silva on 09/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    let N = SKTextureAtlas(named: "N")
    let L = SKTextureAtlas(named: "L")
    let O = SKTextureAtlas(named: "O")
    let S = SKTextureAtlas(named: "S")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKTextureAtlas.preloadTextureAtlases([N, L, O, S], withCompletionHandler: {() -> Void in
            NSLog("Preload Texture Atlases Completed...")
        })
        
        guard let view: SKView = self.view as? SKView else { return }
            
        // Load the SKScene
        let scene = GameScene()
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .resizeFill
        
        // Present the scene
        view.presentScene(scene)
        
        #if DEBUG
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        #endif
    }
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
