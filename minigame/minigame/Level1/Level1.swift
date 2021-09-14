//
//  GameScene.swift
//  minigame
//
//  Created by Giovanni Madalozzo on 13/09/21.
//

import SpriteKit
import GameplayKit

class Level1: SKScene, SKPhysicsContactDelegate {
    
    private var player: SKSpriteNode = SKSpriteNode(imageNamed: "player")
    private var soul: SKSpriteNode = SKSpriteNode(imageNamed: "soul")
    
    private var background: SKSpriteNode = SKSpriteNode(imageNamed: "background")
    private var ground: SKSpriteNode = SKSpriteNode()
    
    private var lastNodeAdded: SKSpriteNode = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        let physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
        self.physicsBody = physicsBody
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background.zPosition = -1
        addChild(background)
        generateGround()
        addChild(ground)
        createPlayer()
    }
    
    func createPlayer() {
        player.position = CGPoint(x: Double(-UIScreen.main.bounds.width)/2+60, y: Double(-UIScreen.main.bounds.height)/2+100)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)
        player.zPosition = 2
        addChild(player)
    }
    
    func createObstacles(positionX: Double, positionY: Double){
        var obstacle: SKSpriteNode = SKSpriteNode(imageNamed: "obstacle")
        obstacle.position = CGPoint(x: positionX, y: positionY)
        obstacle.zPosition = 2
        obstacle.setScale(0.5)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.frame.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.allowsRotation = false
        ground.addChild(obstacle)
    }
    
    func createEnemies(positionX: Double, positionY: Double){
        var enemy: SKSpriteNode = SKSpriteNode(imageNamed: "enemy")
        enemy.position = CGPoint(x: positionX, y: positionY)
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.frame.size)
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.allowsRotation = false
        ground.addChild(enemy)
    }
    
    func createSouls(){
        soul.position = CGPoint(x: 0, y: 0)
        background.addChild(soul)
    }
    
    func generateGround() {
        let anchorPlatformX = Double(-UIScreen.main.bounds.width)/2+20.5
        let anchorPlatformY = Double(-UIScreen.main.bounds.height)/2+50
        
        createPlatforms(assetName: "platform", positionX: anchorPlatformX, positionY: anchorPlatformY)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createPlatforms(assetName: "platformAir1", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+120)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY-30)
        createEnemies(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)+20, positionY: Double(-UIScreen.main.bounds.height)/2+70)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY-30)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createEnemies(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: Double(-UIScreen.main.bounds.height)/2+100)
        createEnemies(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)+50, positionY: Double(-UIScreen.main.bounds.height)/2+100)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY-50)
        createObstacles(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)-10, positionY: anchorPlatformY)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY-50)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createObstacles(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)+2, positionY: anchorPlatformY+50)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createObstacles(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)+20, positionY: anchorPlatformY+50)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
        createPlatforms(assetName: "platformAir2", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+170)
        createObstacles(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)+5, positionY: anchorPlatformY+215)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
        createEnemies(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: Double(-UIScreen.main.bounds.height)/2+150)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
    }
    
    func createPlatforms(assetName: String, positionX: Double, positionY: Double){
        let platform: SKSpriteNode = SKSpriteNode(imageNamed: assetName)
        platform.position = CGPoint(x: positionX, y: positionY)
        platform.zPosition = 2
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.frame.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        if assetName == "platform" {
            lastNodeAdded = platform
        }
        ground.addChild(platform)
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
        ground.position = CGPoint(x: ground.position.x-2, y: ground.position.y)
    }
}
