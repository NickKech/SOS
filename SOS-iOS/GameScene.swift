//
//  GameScene.swift
//  SOS
//
//  Created by Nikolaos Kechagias on 20/08/15.
//  Copyright (c) 2015 Nikolaos Kechagias. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let soundSetLetter = SKAction.playSoundFileNamed("letter.mp3", waitForCompletion: false)
    let soundMakeSOS = SKAction.playSoundFileNamed("sos.mp3", waitForCompletion: false)
    let soundWin = SKAction.playSoundFileNamed("winner.mp3", waitForCompletion: false)
    
    let numberOfRows = 7
    let numberOfCols = 7
    
    var cells = [[CellNode]]()
    
    var selectedLetter: SKSpriteNode? = nil
    
    var locationLetterS: CGPoint!
    var locationLetterO: CGPoint!
    
    var playerOneLabel = LabelNode(fontNamed: "Gill Sans Bold Italic") /* See    */
    var playerTwoLabel = LabelNode(fontNamed: "Gill Sans Bold Italic")
    
    var playerOneScoreLabel = LabelNode(fontNamed: "Gill Sans Bold Italic")
    var playerTwoScoreLabel = LabelNode(fontNamed: "Gill Sans Bold Italic")
    
    var arrow: SKSpriteNode!
    
    var currentPlayer: Int = Player.None.rawValue {
        didSet {
            if currentPlayer == Player.PlayerTwo.rawValue {
                arrow.position = CGPointMake(size.width * 0.81, size.height * 0.95)
            } else if currentPlayer == Player.PlayerOne.rawValue {
                arrow.position = CGPointMake(size.width * 0.19, size.height * 0.95)
            } else {
                arrow.position = CGPointMake(size.width * 0.50, size.height * 0.95)
            }
        }
    }
    
    var scoreOneCounter: Int = 0 {
        didSet {
            playerOneScoreLabel.text = "\(scoreOneCounter)"
        }
    }
    
    var scoreTwoCounter: Int = 0 {
        didSet {
            playerTwoScoreLabel.text = "\(scoreTwoCounter)"
        }
    }
    
    var hasMadeSOS = false
    var hasLetterPlaced = false

    
    
    
    
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor(red: 143.0 / 255.0, green: 119.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
        
        createGameBoard()
        addLetters()
        addPlayersInfo()
        addArrow()
        chooseFirstPlayer()
       
    }
    
    
    
    // MARK: - Create Game Board
    func chooseFirstPlayer() {
        let number1 = arc4random()
        let number2 = arc4random()
        
        let delay = SKAction.waitForDuration(3)
        
        let moveRight = SKAction.moveTo(CGPoint(x: size.width * 0.50, y: size.height * 0.95), duration: 0.2)
        let moveLeft = SKAction.moveTo(CGPoint(x: size.width * 0.50, y: size.height * 0.95), duration: 0.2)
        
        var sequence: SKAction!
        if number1 > number2 {
            sequence = SKAction.sequence([delay, moveRight, moveLeft, moveRight, moveLeft])
        } else {
            sequence = SKAction.sequence([delay, moveRight, moveLeft, moveRight, moveLeft, moveRight])
        }
        
        arrow.runAction(sequence, completion: {
            if number1 > number2 {
                self.currentPlayer = Player.PlayerOne.rawValue
            } else {
                self.currentPlayer = Player.PlayerTwo.rawValue
            }
        })
    }

    
    
    
    func addArrow() {
        arrow = SKSpriteNode(imageNamed: "Arrow")
        arrow.name = "Arrow"
        arrow.position = CGPoint(x: size.width * 0.19, y: size.height * 0.95)
        arrow.zPosition = zPozitionValue.Hud.rawValue - 1
        addChild(arrow)
    }

    
    func addPlayersInfo() {
        /* 1 */
        playerOneLabel.fontSize = 32
        playerOneLabel.text = "Player One"
        playerOneLabel.position = CGPoint(x: size.width * 0.19, y: size.height * 0.87)
        playerOneLabel.zPosition = zPozitionValue.Hud.rawValue
        playerOneLabel.fontColor = SKColor(red: 90.0 / 255.0, green: 67.0 / 255.0, blue: 146.0 / 255.0, alpha: 1.0)
        addChild(playerOneLabel)
        /* 2 */
        playerOneScoreLabel.fontSize = 48
        playerOneScoreLabel.text = "0"
        playerOneScoreLabel.position = CGPoint(x: size.width * 0.19, y: size.height * 0.82)
        playerOneScoreLabel.zPosition = zPozitionValue.Hud.rawValue
        playerOneScoreLabel.fontColor = SKColor(red: 90.0 / 255.0, green: 67.0 / 255.0, blue: 146.0 / 255.0, alpha: 1.0)
        addChild(playerOneScoreLabel)
        /* 1 */
        playerTwoLabel.fontSize = 32
        playerTwoLabel.text = "Player Two"
        playerTwoLabel.position = CGPoint(x: size.width * 0.81, y: size.height * 0.87)
        playerTwoLabel.zPosition = zPozitionValue.Hud.rawValue
        playerTwoLabel.fontColor = SKColor(red: 74.0 / 255.0, green: 226.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
        addChild(playerTwoLabel)
        /* 2 */
        playerTwoScoreLabel.fontSize = 48
        playerTwoScoreLabel.text = "0"
        playerTwoScoreLabel.position = CGPoint(x: size.width * 0.81, y: size.height * 0.82)
        playerTwoScoreLabel.zPosition = zPozitionValue.Hud.rawValue
        playerTwoScoreLabel.fontColor = SKColor(red: 74.0 / 255.0, green: 226.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
        addChild(playerTwoScoreLabel)
    }

    
    func addLetters() {
        locationLetterO = CGPoint(x: size.width * 0.58, y: size.height * 0.88)
        locationLetterS = CGPoint(x: size.width * 0.42, y: size.height * 0.88)
        
        addLetter("LetterS", location: locationLetterS)
        addLetter("LetterO", location: locationLetterO)
    }
    
    
    
    func addLetter(imageNamed: String, location: CGPoint) {
        let letter = SKSpriteNode(imageNamed: imageNamed)
        letter.zPosition = zPozitionValue.Selected.rawValue
        letter.position = location
        letter.name = imageNamed
        addChild(letter)
    }

    
    
    func createGameBoard() {
        let initY = size.height * 3 / 4
        
        let cellSize: CGFloat = 96
        
        let offset: CGFloat = (size.width - cellSize * 7) / 2
        
        for row in 0 ..< numberOfRows {
            var cellsRow = [CellNode]()
            for col in 0 ..< numberOfCols {
                let Px = offset + cellSize / 2 + cellSize * CGFloat(col)
                let Py = initY - cellSize * CGFloat(row)
                
                let cell =  CellNode(textureNamed: SKTexture(imageNamed: "Cell"))
                cell.name = "Cell"
                cell.zPosition = zPozitionValue.Cell.rawValue
                cell.position = CGPoint(x: Px, y: Py)
                addChild(cell)
                
                cellsRow.append(cell)
            }
            cells.append(cellsRow)
        }
    }
    
    func checkPatterns(row:Int, col:Int) {
        let cell = cells[row][col]
        
        if cell.state == CellState.LetterO.rawValue {
            checkPatternsForLetterO(row, col:col)
        } else {
            checkPatternsForLetterS(row, col:col)
        }
    }
    
    func isCellState(state: Int, row: Int, col: Int) -> Bool {
        if row < 0 || row > numberOfRows - 1 {
            return false
        }
        
        if col < 0 || col > numberOfCols - 1 {
            return false
        }
        
        let cell = cells[row][col]
        if cell.state == state {
            return true
        } else {
            return false
        }
    }
    
    func highlightSOS(array: [CellNode]){
        hasMadeSOS = true
        
        for cell in array {
            cell.setCellColorForPlayer(currentPlayer)
        }
        runAction(soundMakeSOS)
        
        if currentPlayer == Player.PlayerOne.rawValue {
            scoreOneCounter++
        }
        
        if currentPlayer == Player.PlayerTwo.rawValue {
            scoreTwoCounter++
        }
    }


    func checkPatternsForLetterO(row:Int, col:Int) {
        /* Line 1 */
        if isCellState(CellState.LetterS.rawValue, row: row-1, col: col) && isCellState(CellState.LetterS.rawValue, row: row+1, col: col) {
            /* 1 */
            highlightSOS([cells[row][col], cells[row-1][col], cells[row+1][col]])
        }
        
        /* Line 2 */
        if isCellState(CellState.LetterS.rawValue, row: row, col: col-1) && isCellState(CellState.LetterS.rawValue, row: row, col: col+1) {
            /* 1 */
            highlightSOS([cells[row][col], cells[row][col-1], cells[row][col+1]])
        }
        
        /* Line 3 */
        if isCellState(CellState.LetterS.rawValue, row: row-1, col: col-1) && isCellState(CellState.LetterS.rawValue, row: row+1, col: col+1) {
            /* 1 */
            highlightSOS([cells[row][col], cells[row-1][col-1], cells[row+1][col+1]])
        }
        
        /* Line 4 */
        if isCellState(CellState.LetterS.rawValue, row: row-1, col: col+1) && isCellState(CellState.LetterS.rawValue, row: row+1, col: col-1) {
            /* 1 */
            highlightSOS([cells[row][col], cells[row-1][col+1], cells[row+1][col-1]])
        }
    }
    
    func checkPatternsForLetterS(row:Int, col:Int) {
        /* Line 1 */
        if isCellState(CellState.LetterO.rawValue, row: row-1, col: col-1) && isCellState(CellState.LetterS.rawValue, row: row-2, col: col-2) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row-1][col-1], cells[row-2][col-2]])
        }
        
        /* Line 2 */
        if isCellState(CellState.LetterO.rawValue, row: row-1, col: col) && isCellState(CellState.LetterS.rawValue, row: row-2, col: col) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row-1][col], cells[row-2][col]])
        }
        
        /* Line 3 */
        if isCellState(CellState.LetterO.rawValue, row: row-1, col: col+1) && isCellState(CellState.LetterS.rawValue, row: row-2, col: col+2) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row-1][col+1], cells[row-2][col+2]])
        }
        
        /* Line 4 */
        if isCellState(CellState.LetterO.rawValue, row: row, col: col+1) && isCellState(CellState.LetterS.rawValue, row: row, col: col+2) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row][col+1], cells[row][col+2]])
        }
        
        /* Line 5 */
        if isCellState(CellState.LetterO.rawValue, row: row+1, col: col+1) && isCellState(CellState.LetterS.rawValue, row: row+2, col: col+2) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row+1][col+1], cells[row+2][col+2]])
        }
        
        /* Line 6 */
        if isCellState(CellState.LetterO.rawValue, row: row+1, col: col) && isCellState(CellState.LetterS.rawValue, row: row+2, col: col) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row+1][col], cells[row+2][col]])
        }
        
        /* Line 7 */
        if isCellState(CellState.LetterO.rawValue, row: row+1, col: col-1) && isCellState(CellState.LetterS.rawValue, row: row+2, col: col-2) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row+1][col-1], cells[row+2][col-2]])
        }
        
        /* Line 8 */
        if isCellState(CellState.LetterO.rawValue, row: row, col: col-1) && isCellState(CellState.LetterS.rawValue, row: row, col: col-2) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row][col-1], cells[row][col-2]])
        }
    }

    
    func placeSelectedLetter(completion:() -> ()) {
        let location = selectedLetter?.position
        
        for row in 0 ..< numberOfRows {
            for col in 0 ..< numberOfCols {
                let cell = cells[row][col]
                
                if cell.frame.contains(location!) {
                    if cell.state == CellState.Empty.rawValue {
                        self.hasLetterPlaced = true
                        if selectedLetter?.name == "LetterS" {
                            cell.setStateValue(CellState.LetterS.rawValue)
                        } else {
                            cell.setStateValue(CellState.LetterO.rawValue)
                        }
                        runAction(soundSetLetter)
                        
                        self.checkPatterns(row, col: col)
                        
                        break
                    }
                }
            }
        }
        
        if selectedLetter?.name == "LetterS" {
            selectedLetter?.position = locationLetterS
        } else {
            selectedLetter?.position = locationLetterO
        }
        
        selectedLetter = nil
        
        runAction(SKAction.waitForDuration(0.10), completion: completion)
    }

    func showWinner() {
        if hasLetterPlaced == true {
            if isGridFull() {
                if scoreOneCounter > scoreTwoCounter {
                    currentPlayer = Player.None.rawValue
                } else if scoreOneCounter < scoreTwoCounter {
                    currentPlayer = Player.None.rawValue
                } else {
                    currentPlayer = Player.None.rawValue
                }
                runAction(soundWin)
            } else {
                if hasMadeSOS == false {
                    if self.currentPlayer == Player.PlayerOne.rawValue {
                        self.currentPlayer = Player.PlayerTwo.rawValue
                    } else {
                        self.currentPlayer = Player.PlayerOne.rawValue
                    }
                }
            }
        }
    }
    
    func isGridFull() -> Bool {
        for row in 0 ..< numberOfRows {
            for col in 0 ..< numberOfCols {
                let cell = cells[row][col]
                if cell.state == CellState.Empty.rawValue {
                    return false
                }
            }
        }
        return true
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let location = touches.first?.locationInNode(self)
        let node = nodeAtPoint(location!)
        
        hasLetterPlaced = false
        hasMadeSOS = false
        
        if node.name == "LetterS" || node.name == "LetterO" {
            selectedLetter = node as? SKSpriteNode
            selectedLetter?.position = location!
            selectedLetter?.zPosition = zPozitionValue.Selected.rawValue
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
   
        if selectedLetter != nil {
            self.placeSelectedLetter() {
                self.showWinner()
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let location = touches.first?.locationInNode(self)
        if selectedLetter != nil {
            selectedLetter?.position = location!
        }
    }
    
}
