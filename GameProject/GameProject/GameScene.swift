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
    //let jump = SKAction.move(to: CGPoint(x: size.width * 0.3, y: size.width * 0.1), duration: TimeInterval(CGFloat(2.0)))
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        hero.position = CGPoint(x: size.width * 0.1, y: size.width * 0.1)
        addChild(hero)
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addBlock), SKAction.wait(forDuration: 1.0)])))
        
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
    
    func addBlock(){
        let block = SKSpriteNode(imageNamed: "block")
        block.position = CGPoint(x: size.width + block.size.width/2, y: size.width * 0.1)
        addChild(block)
        
        let duration = CGFloat(2.0)
        let move = SKAction.move(to: CGPoint(x: -block.size.width/2, y: size.width * 0.1),
        duration: TimeInterval(duration))
        let finish = SKAction.removeFromParent()
        block.run(SKAction.sequence([move, finish]))
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
        let fall = SKAction.move(to: CGPoint(x: size.width * 0.1, y: size.width * 0.1), duration: TimeInterval(CGFloat(0.4)))
        
        guard let touch = touches.first else{
            return
        }
        
        let location = touch.location(in: self)
        //hero.run(SKAction.move(to: CGPoint(x: size.width * 0.1, y: size.width * 0.2), duration: TimeInterval(CGFloat(0.25))))
        hero.run(SKAction.sequence([jump, fall]))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
