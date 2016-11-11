//
//  CellNode.swift
//  SOS
//

import SpriteKit
/* 1 */
enum CellState: Int {
    case empty, letterS, letterO
}
/* 2 */
class CellNode: SKSpriteNode {
  /* 3 */
  var state = CellState.empty.rawValue
  /* 4 */
  var letter = SKSpriteNode(imageNamed: "LetterS")
  
  
 

  /* 5 */
  init(textureNamed: SKTexture) {
    super.init(texture: textureNamed, color: SKColor.white, size: textureNamed.size())
    /* 6 */
    self.colorBlendFactor = 1
    self.color = SKColor.white
    /* 7 */
    self.letter.zPosition = 1
    self.letter.isHidden = true
    addChild(letter)
  }

  /* 8 */
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  /* 1 */
  func setStateValue(state: Int) {
    self.state = state
    if state == CellState.letterO.rawValue {
      letter.texture = SKTexture(imageNamed: "LetterO")
      letter.isHidden = false
    } else if state == CellState.letterS.rawValue {
      letter.texture = SKTexture(imageNamed: "LetterS")
      letter.isHidden = false
    } else {
      letter.isHidden = true
    }
  }
  
  /* 2 */
  func setCellColorForPlayer(playerID: Int) {
    if playerID == Player.playerOne.rawValue {
    self.color = SKColor(red: 90.0/255.0, green: 67.0/255.0, blue: 146.0/255.0, alpha: 1.0)
  } else if playerID == Player.playerTwo.rawValue {
    self.color = SKColor(red: 74.0/255.0, green: 226.0/255.0, blue: 204.0/255.0, alpha: 1.0)
  } else {
    self.color = SKColor.white
    }
  }

}

