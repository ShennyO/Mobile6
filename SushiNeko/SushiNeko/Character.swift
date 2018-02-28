//
//  Character.swift
//  SushiNeko
//
//  Created by Sunny Ouyang on 2/26/18.
//  Copyright © 2018 Sunny Ouyang. All rights reserved.
//

import Foundation
import SpriteKit

class Character: SKSpriteNode {
    /* Character side */
    var side: Side = .left {
        didSet {
            if side == .left {
                xScale = 1
                position.x = -89
            } else {
                /* An easy way to flip an asset horizontally is to invert the X-axis scale */
                xScale = -1
                position.x = 89
            }
            let punch = SKAction(named: "Punch")!
            run(punch)
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
}
