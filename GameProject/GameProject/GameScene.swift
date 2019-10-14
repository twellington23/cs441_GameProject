//
//  GameScene.swift
//  GameProject
//
//  Created by Tyler Wellington on 9/27/19.
//  Copyright © 2019 Tyler Wellington. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    let playButton = SKSpriteNode(imageNamed:"play")
    let hero = SKSpriteNode(imageNamed:"hero")
    let grass = SKSpriteNode(imageNamed: "grass")
    let sky = SKSpriteNode(imageNamed: "sky")
    let sky2 = SKSpriteNode(imageNamed: "sky")
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        sky.zPosition = -1
        sky.position = CGPoint(x: size.width * 0.3, y: size.width * 0.45)
        addChild(sky)
        sky2.zPosition = -1
        sky2.position = CGPoint(x: size.width * 0.7, y: size.width * 0.45)
        addChild(sky2)
        
        scoreLabel = SKLabelNode(fontNamed: "Courier")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: size.width * 0.6, y: size.width * 0.4)
        scoreLabel.zPosition = 3
        addChild(scoreLabel)
        
        hero.position = CGPoint(x: size.width * 0.1, y: size.width * 0.08)
        hero.zPosition = 0
        hero.physicsBody = SKPhysicsBody(rectangleOf: hero.size)
        hero.physicsBody?.restitution = 0.0
        hero.physicsBody?.isDynamic = true
        hero.name = "hero"
        addChild(hero)
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addGrass), SKAction.wait(forDuration: 0.75)])))
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addBug), SKAction.wait(forDuration: 4.0)])))
    }
    
    func addGrass(){
        let grass = SKSpriteNode(imageNamed: "grass")
        grass.zPosition = 1
        grass.position = CGPoint(x: size.width, y: size.width * 0.001)
        addChild(grass)
        
        let duration = CGFloat(4.0)
        let move = SKAction.move(to: CGPoint(x: -grass.size.width/2, y: size.width * 0.001), duration: TimeInterval(duration))
        let finish = SKAction.removeFromParent()
        grass.run(SKAction.sequence([move, finish]))
    }
    
    func addBug(){
        let bug = SKSpriteNode(imageNamed: "bug")
        
        let num = Int.random(in: 1 ... 2)
        if num == 1{
            bug.position = CGPoint(x: size.width + bug.size.width/2, y: size.width * 0.065)
        } else {
            bug.position = CGPoint(x: size.width + bug.size.width/2, y: size.width * 0.15)
        }
            
        bug.zPosition = 0
        bug.physicsBody = SKPhysicsBody(rectangleOf: bug.size)
        bug.physicsBody!.contactTestBitMask = bug.physicsBody!.collisionBitMask
        bug.physicsBody?.isDynamic = false
        bug.name = "bug"
        addChild(bug)
        
        let duration = CGFloat(2.0)
        
        let move1 = SKAction.move(to: CGPoint(x: -bug.size.width/2, y: size.width * 0.065),
        duration: TimeInterval(duration))
        let move2 = SKAction.move(to: CGPoint(x: -bug.size.width/2, y: size.width * 0.15),
        duration: TimeInterval(duration))
        let finish = SKAction.removeFromParent()
        if num == 1 {
            bug.run(SKAction.sequence([move1, finish]))
        } else {
            bug.run(SKAction.sequence([move2, finish]))
        }
        
        if bug.position.x > CGFloat(size.width * 0.08){
            score += 1
        }
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
    
    func collisionBetween(bug: SKNode, object: SKNode) {
        if object.name == "hero" {
            destroy(bug: bug)
            destroy(bug: hero)
            
            score = 0
            
            hero.position = CGPoint(x: size.width * 0.1, y: size.width * 0.08)
            addChild(hero)
        }
    }

    func destroy(bug: SKNode) {
        bug.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "bug" {
            collisionBetween(bug: nodeA, object: nodeB)
        } else if nodeB.name == "bug" {
            collisionBetween(bug: nodeB, object: nodeA)
        }
    }
}
