//
//  GameScene.swift
//  minigame
//
//  Created by Giovanni Madalozzo on 13/09/21.
//

import SpriteKit
import GameplayKit

class Level1: SKScene {
    
    private var player: SKSpriteNode = SKSpriteNode(imageNamed: "player")
    private var enemy1: SKSpriteNode = SKSpriteNode(imageNamed: "enemy")
    private var enemy2: SKSpriteNode = SKSpriteNode(imageNamed: "enemy")
    private var soul: SKSpriteNode = SKSpriteNode(imageNamed: "soul")
    
    private var background: SKSpriteNode = SKSpriteNode(imageNamed: "background")
    private var obstacleHorizontal: SKSpriteNode = SKSpriteNode(imageNamed: "obstacleHorizontal")
    private var obstacleVertical: SKSpriteNode = SKSpriteNode(imageNamed: "obstacleVertical")
    private var platform: SKSpriteNode = SKSpriteNode(imageNamed: "platform")
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.blue
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        createBackground()
        createPlayer()
    }
    
    func createPlayer() {
        player.position = CGPoint(x: 0, y: 0)
        addChild(player)
    }
    
    func createBackground(){
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background.zPosition = 0
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        createPlatforms()
        createObstacles()
        createSouls()
        createEnemies()
        addChild(background)
    }
    
    func createObstacles(){
        obstacleVertical.position = CGPoint(x: 0, y: 0)
        background.addChild(obstacleVertical)
        
        obstacleHorizontal.position = CGPoint(x: 0, y: 0)
        background.addChild(obstacleHorizontal)
    }
    
    func createEnemies(){
        enemy1.position = CGPoint(x: 0, y: 0)
        background.addChild(enemy1)
        
        enemy2.position = CGPoint(x: 0, y: 0)
        background.addChild(enemy2)
    }
    
    func createSouls(){
        soul.position = CGPoint(x: 0, y: 0)
        background.addChild(soul)
    }
    
    func createPlatforms(){
        platform.position = CGPoint(x: 0, y: 0)
        background.addChild(platform)
    }
    
    func attackAction(){
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
