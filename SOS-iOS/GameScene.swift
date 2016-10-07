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
    
    var currentPlayer: Int = Player.none.rawValue {
        didSet {
            if currentPlayer == Player.playerTwo.rawValue {
                arrow.position = CGPoint(x: size.width * 0.81, y: size.height * 0.95)
            } else if currentPlayer == Player.playerOne.rawValue {
                arrow.position = CGPoint(x: size.width * 0.19, y: size.height * 0.95)
            } else {
                arrow.position = CGPoint(x: size.width * 0.50, y: size.height * 0.95)
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

    
    
    
    
    
    override func didMove(to view: SKView) {
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
        
        let delay = SKAction.wait(forDuration: 3)
        
        let moveRight = SKAction.move(to: CGPoint(x: size.width * 0.50, y: size.height * 0.95), duration: 0.2)
        let moveLeft = SKAction.move(to: CGPoint(x: size.width * 0.50, y: size.height * 0.95), duration: 0.2)
        
        var sequence: SKAction!
        if number1 > number2 {
            sequence = SKAction.sequence([delay, moveRight, moveLeft, moveRight, moveLeft])
        } else {
            sequence = SKAction.sequence([delay, moveRight, moveLeft, moveRight, moveLeft, moveRight])
        }
        
        arrow.run(sequence, completion: {
            if number1 > number2 {
                self.currentPlayer = Player.playerOne.rawValue
            } else {
                self.currentPlayer = Player.playerTwo.rawValue
            }
        })
    }

    
    
    
    func addArrow() {
        arrow = SKSpriteNode(imageNamed: "Arrow")
        arrow.name = "Arrow"
        arrow.position = CGPoint(x: size.width * 0.19, y: size.height * 0.95)
        arrow.zPosition = zPozitionValue.hud.rawValue - 1
        addChild(arrow)
    }

    
    func addPlayersInfo() {
        /* 1 */
        playerOneLabel.fontSize = 32
        playerOneLabel.text = "Player One"
        playerOneLabel.position = CGPoint(x: size.width * 0.19, y: size.height * 0.87)
        playerOneLabel.zPosition = zPozitionValue.hud.rawValue
        playerOneLabel.fontColor = SKColor(red: 90.0 / 255.0, green: 67.0 / 255.0, blue: 146.0 / 255.0, alpha: 1.0)
        addChild(playerOneLabel)
        /* 2 */
        playerOneScoreLabel.fontSize = 48
        playerOneScoreLabel.text = "0"
        playerOneScoreLabel.position = CGPoint(x: size.width * 0.19, y: size.height * 0.82)
        playerOneScoreLabel.zPosition = zPozitionValue.hud.rawValue
        playerOneScoreLabel.fontColor = SKColor(red: 90.0 / 255.0, green: 67.0 / 255.0, blue: 146.0 / 255.0, alpha: 1.0)
        addChild(playerOneScoreLabel)
        /* 1 */
        playerTwoLabel.fontSize = 32
        playerTwoLabel.text = "Player Two"
        playerTwoLabel.position = CGPoint(x: size.width * 0.81, y: size.height * 0.87)
        playerTwoLabel.zPosition = zPozitionValue.hud.rawValue
        playerTwoLabel.fontColor = SKColor(red: 74.0 / 255.0, green: 226.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
        addChild(playerTwoLabel)
        /* 2 */
        playerTwoScoreLabel.fontSize = 48
        playerTwoScoreLabel.text = "0"
        playerTwoScoreLabel.position = CGPoint(x: size.width * 0.81, y: size.height * 0.82)
        playerTwoScoreLabel.zPosition = zPozitionValue.hud.rawValue
        playerTwoScoreLabel.fontColor = SKColor(red: 74.0 / 255.0, green: 226.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
        addChild(playerTwoScoreLabel)
    }

    
    func addLetters() {
        locationLetterO = CGPoint(x: size.width * 0.58, y: size.height * 0.88)
        locationLetterS = CGPoint(x: size.width * 0.42, y: size.height * 0.88)
        
        addLetter("LetterS", location: locationLetterS)
        addLetter("LetterO", location: locationLetterO)
    }
    
    
    
    func addLetter(_ imageNamed: String, location: CGPoint) {
        let letter = SKSpriteNode(imageNamed: imageNamed)
        letter.zPosition = zPozitionValue.selected.rawValue
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
                cell.zPosition = zPozitionValue.cell.rawValue
                cell.position = CGPoint(x: Px, y: Py)
                addChild(cell)
                
                cellsRow.append(cell)
            }
            cells.append(cellsRow)
        }
    }
    
    func checkPatterns(_ row:Int, col:Int) {
        let cell = cells[row][col]
        
        if cell.state == CellState.letterO.rawValue {
            checkPatternsForLetterO(row, col:col)
        } else {
            checkPatternsForLetterS(row, col:col)
        }
    }
    
    func isCellState(_ state: Int, row: Int, col: Int) -> Bool {
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
    
    func highlightSOS(_ array: [CellNode]){
        hasMadeSOS = true
        
        for cell in array {
            cell.setCellColorForPlayer(currentPlayer)
        }
        run(soundMakeSOS)
        
        if currentPlayer == Player.playerOne.rawValue {
            scoreOneCounter += 1
        }
        
        if currentPlayer == Player.playerTwo.rawValue {
            scoreTwoCounter += 1
        }
    }


    func checkPatternsForLetterO(_ row:Int, col:Int) {
        /* Line 1 */
        if isCellState(CellState.letterS.rawValue, row: row-1, col: col) && isCellState(CellState.letterS.rawValue, row: row+1, col: col) {
            /* 1 */
            highlightSOS([cells[row][col], cells[row-1][col], cells[row+1][col]])
        }
        
        /* Line 2 */
        if isCellState(CellState.letterS.rawValue, row: row, col: col-1) && isCellState(CellState.letterS.rawValue, row: row, col: col+1) {
            /* 1 */
            highlightSOS([cells[row][col], cells[row][col-1], cells[row][col+1]])
        }
        
        /* Line 3 */
        if isCellState(CellState.letterS.rawValue, row: row-1, col: col-1) && isCellState(CellState.letterS.rawValue, row: row+1, col: col+1) {
            /* 1 */
            highlightSOS([cells[row][col], cells[row-1][col-1], cells[row+1][col+1]])
        }
        
        /* Line 4 */
        if isCellState(CellState.letterS.rawValue, row: row-1, col: col+1) && isCellState(CellState.letterS.rawValue, row: row+1, col: col-1) {
            /* 1 */
            highlightSOS([cells[row][col], cells[row-1][col+1], cells[row+1][col-1]])
        }
    }
    
    func checkPatternsForLetterS(_ row:Int, col:Int) {
        /* Line 1 */
        if isCellState(CellState.letterO.rawValue, row: row-1, col: col-1) && isCellState(CellState.letterS.rawValue, row: row-2, col: col-2) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row-1][col-1], cells[row-2][col-2]])
        }
        
        /* Line 2 */
        if isCellState(CellState.letterO.rawValue, row: row-1, col: col) && isCellState(CellState.letterS.rawValue, row: row-2, col: col) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row-1][col], cells[row-2][col]])
        }
        
        /* Line 3 */
        if isCellState(CellState.letterO.rawValue, row: row-1, col: col+1) && isCellState(CellState.letterS.rawValue, row: row-2, col: col+2) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row-1][col+1], cells[row-2][col+2]])
        }
        
        /* Line 4 */
        if isCellState(CellState.letterO.rawValue, row: row, col: col+1) && isCellState(CellState.letterS.rawValue, row: row, col: col+2) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row][col+1], cells[row][col+2]])
        }
        
        /* Line 5 */
        if isCellState(CellState.letterO.rawValue, row: row+1, col: col+1) && isCellState(CellState.letterS.rawValue, row: row+2, col: col+2) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row+1][col+1], cells[row+2][col+2]])
        }
        
        /* Line 6 */
        if isCellState(CellState.letterO.rawValue, row: row+1, col: col) && isCellState(CellState.letterS.rawValue, row: row+2, col: col) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row+1][col], cells[row+2][col]])
        }
        
        /* Line 7 */
        if isCellState(CellState.letterO.rawValue, row: row+1, col: col-1) && isCellState(CellState.letterS.rawValue, row: row+2, col: col-2) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row+1][col-1], cells[row+2][col-2]])
        }
        
        /* Line 8 */
        if isCellState(CellState.letterO.rawValue, row: row, col: col-1) && isCellState(CellState.letterS.rawValue, row: row, col: col-2) {
            /* 2 */
            highlightSOS([cells[row][col], cells[row][col-1], cells[row][col-2]])
        }
    }

    
    func placeSelectedLetter(_ completion:@escaping () -> ()) {
        let location = selectedLetter?.position
        
        for row in 0 ..< numberOfRows {
            for col in 0 ..< numberOfCols {
                let cell = cells[row][col]
                
                if cell.frame.contains(location!) {
                    if cell.state == CellState.empty.rawValue {
                        self.hasLetterPlaced = true
                        if selectedLetter?.name == "LetterS" {
                            cell.setStateValue(CellState.letterS.rawValue)
                        } else {
                            cell.setStateValue(CellState.letterO.rawValue)
                        }
                        run(soundSetLetter)
                        
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
        
        run(SKAction.wait(forDuration: 0.10), completion: completion)
    }

    func showWinner() {
        if hasLetterPlaced == true {
            if isGridFull() {
                if scoreOneCounter > scoreTwoCounter {
                    currentPlayer = Player.none.rawValue
                } else if scoreOneCounter < scoreTwoCounter {
                    currentPlayer = Player.none.rawValue
                } else {
                    currentPlayer = Player.none.rawValue
                }
                run(soundWin)
            } else {
                if hasMadeSOS == false {
                    if self.currentPlayer == Player.playerOne.rawValue {
                        self.currentPlayer = Player.playerTwo.rawValue
                    } else {
                        self.currentPlayer = Player.playerOne.rawValue
                    }
                }
            }
        }
    }
    
    func isGridFull() -> Bool {
        for row in 0 ..< numberOfRows {
            for col in 0 ..< numberOfCols {
                let cell = cells[row][col]
                if cell.state == CellState.empty.rawValue {
                    return false
                }
            }
        }
        return true
    }

    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let location = touches.first?.location(in: self)
        let node = atPoint(location!)
        
        hasLetterPlaced = false
        hasMadeSOS = false
        
        if node.name == "LetterS" || node.name == "LetterO" {
            selectedLetter = node as? SKSpriteNode
            selectedLetter?.position = location!
            selectedLetter?.zPosition = zPozitionValue.selected.rawValue
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
   
        if selectedLetter != nil {
            self.placeSelectedLetter() {
                self.showWinner()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let location = touches.first?.location(in: self)
        if selectedLetter != nil {
            selectedLetter?.position = location!
        }
    }
    
}
