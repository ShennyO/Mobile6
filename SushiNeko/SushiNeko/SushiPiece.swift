//
//  SushiPiece.swift
//  SushiNeko
//
//  Created by Sunny Ouyang on 2/26/18.
//  Copyright © 2018 Sunny Ouyang. All rights reserved.
//

import Foundation
import SpriteKit
class SushiPiece: SKSpriteNode {
    /* Chopsticks objects */
    var rightChopstick: SKSpriteNode!
    var leftChopstick: SKSpriteNode!
    
    var side: Side = .none {
        didSet {
            switch side {
            case .left:
                /* Show left chopstick */
                leftChopstick.isHidden = false
            case .right:
                /* Show right chopstick */
                rightChopstick.isHidden = false
            case .none:
                /* Hide all chopsticks */
                leftChopstick.isHidden = true
                rightChopstick.isHidden = true
            }
        }
    }
    /* You are required to implement this for your subclass to work */
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func connectChopsticks() {
        /* Connect our child chopstick nodes */
        rightChopstick = childNode(withName: "rightChopstick") as! SKSpriteNode
        leftChopstick = childNode(withName: "leftChopstick") as! SKSpriteNode
        side = .none
    }
    
    func flip(_ side: Side) {
        /* Flip the sushi out of the screen */
        var actionName: String = ""
        if side == .left {
            actionName = "FlipRight"
        } else if side == .right {
            actionName = "FlipLeft"
        }
        /* Load appropriate action */
        let flip = SKAction(named: actionName)!
        /* Create a node removal action */
        let remove = SKAction.removeFromParent()
        /* Build sequence, flip then remove from scene */
        let sequence = SKAction.sequence([flip,remove])
        run(sequence)
    }
}
