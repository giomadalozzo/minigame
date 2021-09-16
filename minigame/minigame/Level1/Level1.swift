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
    
    private var background: SKSpriteNode = SKSpriteNode(imageNamed: "background")
    private var ground: SKSpriteNode = SKSpriteNode()
    private var portalLeft: SKSpriteNode = SKSpriteNode(imageNamed: "portalLeft")
    private var portalRight: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "portalRight"))
    
    private var lastNodeAdded: SKSpriteNode = SKSpriteNode()
    private var attackButton: SKNode! = nil
    private var backgroundButton = SKSpriteNode(color: .gray, size: CGSize(width: 70, height: 70))
    
    private var soulCount: Int = 0
    private var counter = SKLabelNode(text: "0 / 3")
    private var scrollBool: Bool = true
    private var gameover:Bool = false
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        let physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
        self.physicsBody = physicsBody
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -10)
        
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background.zPosition = -1
    
        createLayout()
        addChild(background)
        generateGround()
        addChild(ground)
        createPlayer()
    }
    func createLayout(){
        var soulIcon = SKSpriteNode(imageNamed: "soul")
        soulIcon.zPosition = 5
        soulIcon.position = CGPoint(x:self.frame.maxX-160, y:self.frame.maxY-50)
        soulIcon.setScale(0.3)
        background.addChild(soulIcon)
        counter.zPosition = 6
        counter.position = CGPoint(x:self.frame.maxX-100, y:self.frame.maxY-60)
        background.addChild(counter)
        
        backgroundButton.zPosition = 5
        backgroundButton.position = CGPoint(x:self.frame.minX+100, y:self.frame.maxY-60)
        backgroundButton.alpha = 0.5
        attackButton = SKSpriteNode(imageNamed: "attackButton")
        attackButton.setScale(0.1)
        attackButton.position = CGPoint(x:self.frame.minX+100, y:self.frame.maxY-60)
        attackButton.zPosition = 5
        background.addChild(backgroundButton)
        background.addChild(attackButton)
    }
    func createPlayer() {
        player.position = CGPoint(x: Double(-UIScreen.main.bounds.width)/2+120, y: Double(-UIScreen.main.bounds.height)/2+100)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)
        player.zPosition = 2
        player.physicsBody?.mass = 5
        player.physicsBody?.allowsRotation = false
        player.name = "Player"
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        addChild(player)
        
        var playerJumpLimit = SKSpriteNode(texture: nil, size: CGSize(width: 20000, height: 100))
        playerJumpLimit.position = CGPoint(x: Double(-UIScreen.main.bounds.width)/2+120, y: Double(UIScreen.main.bounds.height)-160)
        playerJumpLimit.physicsBody = SKPhysicsBody(rectangleOf: playerJumpLimit.frame.size)
        playerJumpLimit.physicsBody?.allowsRotation = false
        playerJumpLimit.physicsBody?.isDynamic = false
        
        addChild(playerJumpLimit)
        
    }
    
    func createObstacles(positionX: Double, positionY: Double){
        var obstacle: SKSpriteNode = SKSpriteNode(imageNamed: "obstacle")
        obstacle.position = CGPoint(x: positionX, y: positionY)
        obstacle.zPosition = 2
        obstacle.setScale(0.2)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.frame.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.allowsRotation = false
        obstacle.name = "Obstacle"
        obstacle.physicsBody!.contactTestBitMask = obstacle.physicsBody!.collisionBitMask
        ground.addChild(obstacle)
    }
    
    func createEnemies(positionX: Double, positionY: Double){
        var enemy: SKSpriteNode = SKSpriteNode(imageNamed: "enemy")
        enemy.position = CGPoint(x: positionX, y: positionY)
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.frame.size)
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.allowsRotation = false
        enemy.name = "Enemy"
        enemy.physicsBody!.contactTestBitMask = enemy.physicsBody!.collisionBitMask
        ground.addChild(enemy)
    }
    
    func createSouls(positionX: Double, positionY: Double){
        var soul: SKSpriteNode = SKSpriteNode(imageNamed: "soul")
        soul.position = CGPoint(x: positionX, y: positionY)
        soul.zPosition = 2
        soul.setScale(0.2)
        soul.physicsBody = SKPhysicsBody(rectangleOf: soul.frame.size)
        soul.physicsBody?.isDynamic = false
        soul.physicsBody?.allowsRotation = false
        soul.name = "Soul"
        soul.physicsBody!.contactTestBitMask = soul.physicsBody!.collisionBitMask
        ground.addChild(soul)
    }
    
    func createPortal(positionX: Double, positionY: Double){
        portalLeft.position = CGPoint(x: positionX, y: positionY)
        portalLeft.zPosition = 1
        portalLeft.setScale(0.8)
        ground.addChild(portalLeft)
        
        portalRight.position = CGPoint(x: positionX+50, y: positionY)
        portalRight.zPosition = 4
        portalRight.setScale(0.8)
        portalRight.physicsBody = SKPhysicsBody(rectangleOf: portalRight.frame.size)
        portalRight.physicsBody?.isDynamic = false
        portalRight.physicsBody?.allowsRotation = false
        portalRight.name = "Portal"
        portalRight.physicsBody!.contactTestBitMask = portalRight.physicsBody!.collisionBitMask
        ground.addChild(portalRight)
    }
    
    func generateGround() {
        let anchorPlatformX = Double(-UIScreen.main.bounds.width)/2+20.5
        let anchorPlatformY = Double(-UIScreen.main.bounds.height)/2+50
        
        createPlatforms(assetName: "platform", positionX: anchorPlatformX, positionY: anchorPlatformY)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createPlatforms(assetName: "platformAir1", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+120)
        createScrollLimit(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)/2, positionY: anchorPlatformY+120)
        createSouls(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+160)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY-30)
        createEnemies(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)+20, positionY: Double(-UIScreen.main.bounds.height)/2+70)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY-30)
        createScrollLimit(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)/2+10, positionY: anchorPlatformY+5)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createEnemies(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: Double(-UIScreen.main.bounds.height)/2+100)
        createEnemies(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)+50, positionY: Double(-UIScreen.main.bounds.height)/2+100)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY-50)
        createObstacles(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)-10, positionY: anchorPlatformY)
        createSouls(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+120)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY-50)
        createScrollLimit(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)/2+10, positionY: anchorPlatformY+5)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createObstacles(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)+2, positionY: anchorPlatformY+50)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createObstacles(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)+20, positionY: anchorPlatformY+50)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY)
        createScrollLimit(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)/2+10, positionY: anchorPlatformY+55)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
        createPlatforms(assetName: "platformAir2", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)+70, positionY: anchorPlatformY+150)
        createScrollLimit(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)/2-15, positionY: anchorPlatformY+150)
        createSouls(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width)+170, positionY: anchorPlatformY+220)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
        createEnemies(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: Double(-UIScreen.main.bounds.height)/2+150)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
        createPortal(positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+180)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
        createPlatforms(assetName: "platform", positionX: Double(lastNodeAdded.position.x)+Double(lastNodeAdded.size.width), positionY: anchorPlatformY+50)
    }
    
    func createScrollLimit(positionX: Double, positionY: Double){
        var scrollLimit: SKSpriteNode = SKSpriteNode(texture: nil, size: CGSize(width: 25, height: 20))
        scrollLimit.position = CGPoint(x: positionX, y: positionY)
        scrollLimit.zPosition = 5
        scrollLimit.physicsBody = SKPhysicsBody(rectangleOf: scrollLimit.frame.size)
        scrollLimit.physicsBody?.isDynamic = false
        scrollLimit.physicsBody?.allowsRotation = false
        scrollLimit.name = "Limit"
        ground.addChild(scrollLimit)
    }
    
    func createPlatforms(assetName: String, positionX: Double, positionY: Double){
        let platform: SKSpriteNode = SKSpriteNode(imageNamed: assetName)
        platform.position = CGPoint(x: positionX, y: positionY)
        platform.zPosition = 2
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.frame.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.name = "Ground"
        if assetName == "platform" {
            lastNodeAdded = platform
        }
        ground.addChild(platform)
    }
    
    func attackAction(){
        var projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = CGPoint(x: player.position.x+30, y: player.position.y-10)
        projectile.zPosition = 4
        projectile.name = "Projectile"
        projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.frame.size)
        projectile.physicsBody!.contactTestBitMask = projectile.physicsBody!.collisionBitMask
        addChild(projectile)
        projectile.physicsBody?.affectedByGravity = false
        projectile.physicsBody?.velocity = CGVector(dx: 600, dy: 0)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if backgroundButton.contains(location){
                attackAction()
            }else if !gameover{
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 3000))
            }else{
                if let view = self.view as! SKView? {
                    
                    let scene = Level1()
            
                    scene.scaleMode = .aspectFill
                    scene.size = view.frame.size
                    
                    
                    view.presentScene(scene)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = false
                    view.showsNodeCount = false
                    
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        counter.text = "\(self.soulCount) / 3"
        
        if ground.position.x > -2700 && scrollBool{
            ground.position = CGPoint(x: ground.position.x-2, y: ground.position.y)
        }else if ground.position.x <= -2700 && scrollBool{
            player.position = CGPoint(x: player.position.x+2, y: player.position.y)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "Player" {
            collisionBetween(isProjectile: false, principal: contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node?.name == "Player" {
            collisionBetween(isProjectile: false, principal: contact.bodyB.node!, object: contact.bodyA.node!)
        } else if contact.bodyA.node?.name == "Projectile" {
            collisionBetween(isProjectile: true, principal: contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node?.name == "Projectile" {
            collisionBetween(isProjectile: true, principal: contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "Player" {
            if contact.bodyB.node?.name == "Limit"{
                scrollBool = true
            }
        } else if contact.bodyB.node?.name == "Player" {
            if contact.bodyA.node?.name == "Limit"{
                scrollBool = true
            }
    }
    }
    
    func gameoverScene(){
        scrollBool = false
        gameover = true
        var gameoverBackground = SKSpriteNode(color: .black, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        gameoverBackground.zPosition = 7
        gameoverBackground.alpha = 0.8
        addChild(gameoverBackground)
        
        var gameover = SKLabelNode(text: "GAME OVER")
        gameover.zPosition = 8
        addChild(gameover)
        
        var tryAgain = SKLabelNode(text: "Tap to try again")
        tryAgain.zPosition = 8
        tryAgain.fontSize = 20
        tryAgain.position.y = self.frame.maxY/2-200
        addChild(tryAgain)
    }
    
    func levelCompleted(){
        scrollBool = false
        gameover = true
        var completedBackground = SKSpriteNode(color: .black, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        completedBackground.zPosition = 7
        completedBackground.alpha = 0.8
        addChild(completedBackground)
        
        var completed = SKLabelNode(text: "LEVEL COMPLETED!")
        completed.zPosition = 8
        addChild(completed)
        
        var tryAgain = SKLabelNode(text: "Tap to continue")
        tryAgain.zPosition = 8
        tryAgain.fontSize = 20
        tryAgain.position.y = self.frame.maxY/2-200
        addChild(tryAgain)
    }
    
    func collisionBetween(isProjectile: Bool, principal: SKNode, object: SKNode) {
        if isProjectile{
            if object.name == "Enemy" {
                object.removeFromParent()
                principal.removeFromParent()
                print("matou")
            }else{
                principal.removeFromParent()
            }
        }else{
            if object.name == "Enemy" || object.name == "Obstacle" {
                gameoverScene()
            } else if object.name == "Soul" {
                object.removeFromParent()
                self.soulCount += 1
            } else if object.name == "Limit"{
                scrollBool = false
            } else if object.name == "Portal"{
                if soulCount == 3 {
                    levelCompleted()
                }else{
                    gameoverScene()
                }
            }
        }
    }
}
