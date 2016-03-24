//
//  GameController.swift
//  TicTacToe
//
//  Created by Andrii Kurshyn on 3/12/16.
//  Copyright © 2016 Andrii Kurshyn. All rights reserved.
//

import UIKit

protocol GameControllerDelegate: NSObjectProtocol {
    func gameControllerDidWon(mark: GameMark, lineInfo: LineInfo)
    func gameControllerDidDraw()
    func gameControllerDidStep(gameMark: GameMark, index: Int, nextPlayer: String)
}

enum GameType {
    case PlayerVSPlayer
    case PlayerVSComputer
}

private class WonGame: NSObject {
    var mark: GameMark
    var lineInfo: LineInfo
    
    init(mark: GameMark, lineInfo: LineInfo) {
        self.mark = mark
        self.lineInfo = lineInfo
    }
}

class GameController: NSObject {
    
    weak var delegate: GameControllerDelegate?
    
    var finised = false
    
    private(set) var gameBoard: GameBoard?
    private(set) var gameType = GameType.PlayerVSPlayer
    private(set) var steps: Int = 0
    private(set) var computer: Computer?
    private(set) var isComputerTurn = false
    
    // MARK: Public methods
    /**
    Call when you start new game.
    
    - parameter gameType: slect methods PlayerVSPlayer or PlayerVSComputer
    - parameter boardSize: size board min 3x3 max 8x8
    
    */
    func startNewGame(gameType: GameType, boardSize: Int) {
        self.gameType = gameType
        let board = GameBoard(gameSize: boardSize)
        self.gameBoard = board
        self.finised = false
        self.steps = 0
        
        if gameType == .PlayerVSComputer {
            self.computer = Computer(board: board)
        }
    }
    
    /**
     Call when user tap on area.
     
     - parameter index: place where tap user
     
     */
    func playerTapAtIndex(index: Int) {
        
        if self.finised == true || self.isComputerTurn == true {
            return
        }
        
        let gameMark = self.steps % 2 == 1 ? GameMark.Circle : GameMark.Cross
        self.makeStep(index, mark: gameMark)
        
        self.makeStepIfNeedComputer()
    }
    
    // MARK: Private methods
    private func checkWinners() {
        guard let gameBoard = self.gameBoard else { return }
        
        var game: WonGame? = nil
        
        if let mark = self.winnerMarkRow(gameBoard) {
            game = mark
        } else if let mark = self.winnerMarkColumn(gameBoard) {
            game = mark
        } else if let mark = self.winnerMarkDiagonal(gameBoard) {
            game = mark
        } else if let mark = self.winnerMarkAntidiag(gameBoard) {
            game = mark
        }
        
        if let wonGame = game {
            self.finised = true
            self.delegate?.gameControllerDidWon(wonGame.mark, lineInfo: wonGame.lineInfo)
            return
        }
        
        // IS a DRAW
        if gameBoard.indexsAvailable().count == 0 {
            self.finised = true
            self.delegate?.gameControllerDidDraw()
        }
    }
    
    private func makeStepIfNeedComputer() {
        guard let computer = self.computer where self.finised == false else { return }
        
        self.isComputerTurn = true
        computer.makeStep({ [weak self](index, mark) -> () in
            guard let strongSelf = self else { return }
            strongSelf.isComputerTurn = false
            strongSelf.makeStep(index, mark: mark)
        })
    }
    
    private func makeStep(index: Int, mark: GameMark) {
        if self.gameBoard?.isIndexAvailable(index) == false {
            return
        }
        
        self.steps = self.steps + 1
        
        self.gameBoard?.setMark(mark, atIndex: index)
        
        var nextPlayer = self.steps % 2 == 1 ? GameMark.Circle.describe : GameMark.Cross.describe
        nextPlayer = self.computer != nil && self.steps % 2 == 1 ? "Computer" : GameMark.Cross.describe
        self.delegate?.gameControllerDidStep(mark, index: index, nextPlayer: nextPlayer)
        
        self.checkWinners()
    }
    
    private func winnerMarkRow(board: GameBoard) -> WonGame? {

        for row in 0..<board.size {
            
            let lineInfo = board.lineInfoRow(row)
            
            for (mark, count) in lineInfo.countMarks {
                if count == board.size && mark != .Empty {
                    return WonGame(mark: mark, lineInfo: lineInfo)
                }
            }
        }
        
        return nil
    }
    
    private func winnerMarkColumn(board: GameBoard) -> WonGame? {

        for column in 0..<board.size {
            
            let lineInfo = board.lineInfoColumn(column)
            
            for (mark, count) in lineInfo.countMarks {
                if count == board.size && mark != .Empty {
                    return WonGame(mark: mark, lineInfo: lineInfo)
                }
            }
        }
        
        return nil
    }
    
    private func winnerMarkDiagonal(board: GameBoard) -> WonGame? {
        
        let lineInfo = board.lineInfoDiagonal()
        
        for (mark, count) in lineInfo.countMarks {
            if count == board.size && mark != .Empty {
                return WonGame(mark: mark, lineInfo: lineInfo)
            }
        }
        
        return nil
    }
    
    private func winnerMarkAntidiag(board: GameBoard) -> WonGame? {

        let lineInfo = board.lineInfoAntidiag()
        
        for (mark, count) in lineInfo.countMarks {
            if count == board.size && mark != .Empty {
                return WonGame(mark: mark, lineInfo: lineInfo)
            }
        }
        
        return nil
    }
}
