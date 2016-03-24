//
//  CellNode.swift
//  SOS
//

import SpriteKit
/* 1 */
enum CellState: Int {
    case Empty, LetterS, LetterO
}
/* 2 */
class CellNode: SKSpriteNode {
  /* 3 */
  var state = CellState.Empty.rawValue
  /* 4 */
  var letter = SKSpriteNode(imageNamed: "LetterS")
  
  
 

  /* 5 */
  init(textureNamed: SKTexture) {
    super.init(texture: textureNamed, color: SKColor.whiteColor(), size: textureNamed.size())
    /* 6 */
    self.colorBlendFactor = 1
    self.color = SKColor.whiteColor()
    /* 7 */
    self.letter.hidden = true
    addChild(letter)
  }

  /* 8 */
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  /* 1 */
  func setStateValue(state: Int) {
    self.state = state
    if state == CellState.LetterO.rawValue {
      letter.texture = SKTexture(imageNamed: "LetterO")
      letter.hidden = false
    } else if state == CellState.LetterS.rawValue {
      letter.texture = SKTexture(imageNamed: "LetterS")
      letter.hidden = false
    } else {
      letter.hidden = true
    }
  }
  
  /* 2 */
  func setCellColorForPlayer(playerID: Int) {
    if playerID == Player.PlayerOne.rawValue {
    self.color = SKColor(red: 90.0/255.0, green: 67.0/255.0, blue: 146.0/255.0, alpha: 1.0)
  } else if playerID == Player.PlayerTwo.rawValue {
    self.color = SKColor(red: 74.0/255.0, green: 226.0/255.0, blue: 204.0/255.0, alpha: 1.0)
  } else {
    self.color = SKColor.whiteColor()
    }
  }

}

