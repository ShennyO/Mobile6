//
//  GameScene.swift
//  SushiNeko
//
//  Created by Sunny Ouyang on 2/25/18.
//  Copyright © 2018 Sunny Ouyang. All rights reserved.
//

import SpriteKit

enum Side {
    case left, right, none
}

enum GameState {
    case title, ready, playing, gameOver
}

class GameScene: SKScene {
    /* Game objects */
    var sushiBasePiece: SushiPiece!
    var character: Character!
    var sushiTower: [SushiPiece] = []
    var state: GameState = .title
    var playButton: MSButtonNode!
    var healthBar: SKSpriteNode!
    var health: CGFloat = 1.0 {
        didSet {
            /* Scale health bar between 0.0 -> 1.0 e.g 0 -> 100% */
            if health > 1.0 { health = 1.0 }
            healthBar.xScale = health
        }
    }
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        /* Connect game objects */
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        /* Setup chopstick connections */
        sushiBasePiece.connectChopsticks()
        character = childNode(withName: "character") as! Character
        addSushiPiece(side: .none)
        addSushiPiece(side: .right)
        addRandomPieces(total: 10)
        playButton = childNode(withName: "playButton") as! MSButtonNode
        playButton.selectedHandler = {
            /* Start game */
            self.state = .ready
        }
        healthBar = childNode(withName: "healthBar") as! SKSpriteNode
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state == .gameOver || state == .title { return }
        /* Game begins on first touch */
        if state == .ready {
            state = .playing
        }
        //Only need one touch
        let touch = touches.first!
        //Get location of the touch
        let location = touch.location(in: self)
        //check if on the right side or left side
        if location.x > (size.width / 2) - 160 {
            self.character.side = .right
        } else {
            self.character.side = .left
        }
        
        if let firstPiece = sushiTower.first as SushiPiece! {
            if character.side == firstPiece.side {
                /* Drop all the sushi pieces down a place (visually) */
                for sushiPiece in sushiTower {
                    sushiPiece.run(SKAction.move(by: CGVector(dx: 0, dy: -55), duration: 0.10))
                }
                gameOver()
                /* No need to continue as player dead */
                return
            }
            health += 0.1
            score += 1
            /* Remove from sushi tower array */
            sushiTower.removeFirst()
            firstPiece.flip(character.side)
            /* Add a new sushi piece to the top of the sushi tower */
            addRandomPieces(total: 1)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if state != .playing {
            return
        }
        /* Decrease Health */
        health -= 0.01
        /* Has the player ran out of health? */
        if health < 0 {
            gameOver()
        }
        moveTowerDown()
    }
    
    func moveTowerDown() {
        var n: CGFloat = 0
        for piece in sushiTower {
            let y = (n * 55) - 85
            piece.position.y -= (piece.position.y - y) * 0.5
            n += 1
        }
    }
    
    func addSushiPiece(side: Side) {
        //This function adds a new sushi piece to the tower
        // 1) Copy Sushi piece node
        let newPiece = sushiBasePiece.copy() as! SushiPiece
        newPiece.connectChopsticks()
        let lastPiece = sushiTower.last
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        newPiece.position.x = lastPosition.x
        newPiece.position.y = lastPosition.y + 55
        /* Increment Z to ensure it's on top of the last piece, default on first piece*/
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        newPiece.zPosition = lastZPosition + 1
        /* Set side */
        newPiece.side = side
        /* Add sushi to scene */
        addChild(newPiece)
        /* Add sushi piece to the sushi tower */
        sushiTower.append(newPiece)
        
    }
    
    func addRandomPieces(total: Int) {
        for _ in 1...total {
            let lastPiece = self.sushiTower.last as SushiPiece!
            if lastPiece?.side != Side.none {
                addSushiPiece(side: .none)
            } else {
                let rand = arc4random_uniform(100)
                if rand < 45 {
                    addSushiPiece(side: .right)
                } else if rand < 90 {
                    addSushiPiece(side: .left)
                } else {
                    addSushiPiece(side: .none)
                }
            }
            
        }
    }
    
    func gameOver() {
        /* Game over! */
        state = .gameOver
        /* Turn all the sushi pieces red*/
        for sushiPiece in sushiTower {
            sushiPiece.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))
        }
        /* Make the player turn red */
        character.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))
        /* Change play button selection handler */
        playButton.selectedHandler = {
            /* Grab reference to the SpriteKit view */
            let skView = self.view as SKView!
            /* Load Game scene */
            guard let scene = GameScene(fileNamed:"GameScene") as GameScene! else {
                return
            }
            /* Ensure correct aspect mode */
            scene.scaleMode = .aspectFill
            /* Restart GameScene */
            skView?.presentScene(scene)
        }
    }
    
}
