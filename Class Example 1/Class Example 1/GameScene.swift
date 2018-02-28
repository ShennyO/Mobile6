//
//  GameScene.swift
//  Class Example 1
//
//  Created by Sunny Ouyang on 2/22/18.
//  Copyright © 2018 Sunny Ouyang. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Direction {
    case up
    case down
    case right
    case left
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var player: SKSpriteNode!
    var swipeUp: UISwipeGestureRecognizer!
    var swipeDown: UISwipeGestureRecognizer!
    var swipeRight: UISwipeGestureRecognizer!
    var swipeLeft: UISwipeGestureRecognizer!
    var boxDirection: Direction!
    var enemies: [SKSpriteNode] = []
    var enemyPoints: [CGPoint] = []
    
    
    
    override func didMove(to view: SKView) {
        makeBoard(rows: 3, cols: 3)
        makePlayer()
        setUpGestures()
        configureEnemyPoints()
        restartTimer()
       
    }
    
    func configureEnemyPoints() {
        //points for the right side
        let screenHeight = self.frame.height
        let screenWidth = self.frame.width
        for x in -1 ... 1 {
            let y = screenHeight/2 + CGFloat(x * 60)
            let point = CGPoint(x: self.frame.width, y: y)
            self.enemyPoints.append(point)
        }
        //points for the top side
        for x in -1 ... 1 {
            let x = screenWidth/2 + CGFloat(x * 60)
            let point = CGPoint(x: x, y: self.frame.height)
            self.enemyPoints.append(point)
        }
        //points for the left side
        for x in -1 ... 1 {
            let y = screenHeight/2 + CGFloat(x * 60)
            let point = CGPoint(x: 0, y: y)
            self.enemyPoints.append(point)
        }
        //points for the bottom side
        for x in -1 ... 1 {
            let x = screenWidth/2 + CGFloat(x * 60)
            let point = CGPoint(x: x, y: 0)
            self.enemyPoints.append(point)
        }
    }
    
    func makeBoard(rows: Int, cols: Int) {
        let screenWidth = self.size.width
        let screenHeight = self.size.height
        
        for i in -1 ... 1 {
            let stripe = self.makeStripe(width: screenWidth, height: 60)
            addChild(stripe)
            stripe.position.x = screenWidth / 2
            stripe.position.y = (screenHeight / 2) + (65 * CGFloat(i))
            
        }
        
        for i in -1 ... 1 {
            let stripe = self.makeStripe(width: 60, height: screenHeight)
            addChild(stripe)
            stripe.position.x = (screenWidth / 2) + (65 * CGFloat(i))
            stripe.position.y = screenHeight / 2
        }
    }
    
    func restartTimer(){
        
        let wait:SKAction = SKAction.wait(forDuration: 1)
        let finishTimer:SKAction = SKAction.run {
            
            let random = Int(arc4random_uniform(UInt32(self.enemyPoints.count)))
            let randomPoint = self.enemyPoints[random]
            let newEnemy = self.makeEnemy(pos: randomPoint)
            if newEnemy.position.x == 0 {
                self.moveEnemy(node: newEnemy, direction: Direction.right)
            } else if newEnemy.position.x == self.frame.width {
                self.moveEnemy(node: newEnemy, direction: Direction.left)
            } else if newEnemy.position.y == self.frame.height {
                self.moveEnemy(node: newEnemy, direction: Direction.down)
            } else if newEnemy.position.y == 0 {
                self.moveEnemy(node: newEnemy, direction: Direction.up)
            }
            
            self.restartTimer()
        }
        
        let seq:SKAction = SKAction.sequence([wait, finishTimer])
        self.run(seq)
        
        
    }
    
    func makePlayer() {
        let color = UIColor.red
        let size = CGSize(width: 40, height: 40)
        player = SKSpriteNode(color: color, size: size)
        addChild(player)
        
        let playerPoint = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        player.position = playerPoint
    }
    
    func makeEnemy(pos: CGPoint) -> SKSpriteNode {
        let color = UIColor.black
        let size = CGSize(width: 40, height: 40)
        let enemy = SKSpriteNode(color: color, size: size)
        enemy.position = pos
        addChild(enemy)
        self.enemies.append(enemy)
        return enemy
    }
    
    func moveEnemy(node: SKSpriteNode, direction: Direction) {
        let removeNode = SKAction.removeFromParent()
        var move: SKAction!
        switch direction {
        case .up:
            let endPoint = CGFloat(self.frame.height + 30)
            move = SKAction.moveTo(y: endPoint, duration: 1)
            
        case .down:
            let endPoint = CGFloat(-30)
            move = SKAction.moveTo(y: endPoint, duration: 1)
        case .right:
            let endPoint = CGFloat(self.frame.width + 30)
            move = SKAction.moveTo(x: endPoint, duration: 1)
        case .left:
            let endPoint = CGFloat(-30)
            move = SKAction.moveTo(x: endPoint, duration: 1)
        }
        let sequence = SKAction.sequence([move, removeNode])
        node.run(sequence)
    }
    
    func makeStripe(width: CGFloat, height: CGFloat) -> SKSpriteNode {
        let color = UIColor(white: 1, alpha: 0.2)
        let size = CGSize(width: width, height: height)
        let stripe = SKSpriteNode(color: color, size: size)
        return stripe
    }
    
    func setUpGestures() {
        
        self.swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view?.addGestureRecognizer(self.swipeUp)
        self.swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(self.swipeDown)
        self.swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(self.swipeLeft)
        self.swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(self.swipeRight)
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        
        print("swipe")
        switch gesture.direction {
        case .up:
            player.position.y += 60
        case .down:
            player.position.y -= 60
        case .right:
            player.position.x += 60
        case .left:
            player.position.x -= 60
        default:
            return
        }
    }
    
    
    
}
