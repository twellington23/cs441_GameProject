//
//  GameScene.swift
//  GameProject
//
//  Created by Tyler Wellington on 9/27/19.
//  Copyright © 2019 Tyler Wellington. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    let playButton = SKSpriteNode(imageNamed:"play")
    let hero = SKSpriteNode(imageNamed:"hero")
    let grass = SKSpriteNode(imageNamed: "grass")
    let sky = SKSpriteNode(imageNamed: "sky")
    let sky2 = SKSpriteNode(imageNamed: "sky")
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.lightGray
        hero.position = CGPoint(x: size.width * 0.1, y: size.width * 0.08)
        hero.zPosition = 0
        addChild(hero)
        
        sky.zPosition = -1
        sky.position = CGPoint(x: size.width * 0.3, y: size.width * 0.45)
        addChild(sky)
        sky2.zPosition = -1
        sky2.position = CGPoint(x: size.width * 0.7, y: size.width * 0.45)
        addChild(sky2)
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addGrass), SKAction.wait(forDuration: 1.0)])))
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addEye), SKAction.wait(forDuration: 4.0)])))
        
        // Get label node from scene and store it for use later
        /*
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        */
    }
    
    //func random(min: CGFloat, max: CGFloat) -> CGFloat {
    //  return random() * (max - min) + min
    //}
    func addGrass(){
        let grass = SKSpriteNode(imageNamed: "grass")
        grass.zPosition = 1
        //grass.position = CGPoint(x: size.width * 0.511, y: size.width * 0.031)
        grass.position = CGPoint(x: size.width, y: size.width * 0.031)
        addChild(grass)
        
        let duration = CGFloat(4.0)
        let move = SKAction.move(to: CGPoint(x: -grass.size.width/2, y: size.width * 0.031),
        duration: TimeInterval(duration))
        let finish = SKAction.removeFromParent()
        grass.run(SKAction.sequence([move, finish]))
    }
    
    func addEye(){
        let eye = SKSpriteNode(imageNamed: "eye")
        eye.zPosition = 0
        eye.position = CGPoint(x: size.width + eye.size.width/2, y: size.width * 0.085)
        addChild(eye)
        
        let duration = CGFloat(2.0)
        let move = SKAction.move(to: CGPoint(x: -eye.size.width/2, y: size.width * 0.085),
        duration: TimeInterval(duration))
        let finish = SKAction.removeFromParent()
        eye.run(SKAction.sequence([move, finish]))
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        let jump = SKAction.move(to: CGPoint(x: size.width * 0.1, y: size.width * 0.3), duration: TimeInterval(CGFloat(0.4)))
        let fall = SKAction.move(to: CGPoint(x: size.width * 0.1, y: size.width * 0.08), duration: TimeInterval(CGFloat(0.5)))
        
        guard let touch = touches.first else{
            return
        }
        
        let location = touch.location(in: self)
        hero.run(SKAction.sequence([jump, fall]))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
