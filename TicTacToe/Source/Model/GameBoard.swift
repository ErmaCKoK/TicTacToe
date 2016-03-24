//
//  GameBoard.swift
//  TicTacToe
//
//  Created by Andrii Kurshyn on 3/12/16.
//  Copyright © 2016 Andrii Kurshyn. All rights reserved.
//

import UIKit

enum LineType {
    case Row
    case Column
    case Diagonal
    case Antidiag
}

enum GameMark {
    case Empty
    case Cross
    case Circle
    
    var describe: String {
        get {
            switch self {
            case .Empty: return "Empty"
            case .Circle: return "Circles"
            case .Cross: return "Crosses"
            }
        }
    }
}

class LineInfo {
    var countMarks = [GameMark: Int]()
    var line = [Int: GameMark]()
    var type: LineType
    
    var startIndex: Int {
        get {
            return Array(self.line.keys).sort(<).first ?? 0
        }
    }
    
    var endIndex: Int {
        get {
            return Array(self.line.keys).sort(>).first ?? 0
        }
    }
    
    init(type:LineType) {
        self.type = type
    }
    
    func setGameMark(gameMark: GameMark, arIndex: Int) {
        self.countMarks[gameMark] = (self.countMarks[gameMark] ?? 0) + 1
        self.line[arIndex] = gameMark
    }
}

class GameBoard: NSObject {
    
    // MARK: Public properties
    private(set) var size: Int
    
    var gameAreaCout: Int {
        get {
            return self.size * self.size
        }
    }
    
    // MARK: Private properties
    private var marks = [GameMark]()
    
    // MARK: Init
    init(gameSize: Int) {
        self.size = max(min(gameSize, 8), 3)
        super.init()
        
        for _ in 0..<self.gameAreaCout {
            marks.append(.Empty)
        }
    }
    
    // MARK: Public methods
    func isIndexAvailable(index: Int) -> Bool {
        return self.marks[index] == .Empty
    }
    
    func indexsAvailable() -> [Int] {
        var indexs = [Int]()
        
        for index in 0..<self.gameAreaCout {
            if self.isIndexAvailable(index) {
                indexs.append(index)
            }
        }
        
        return indexs
    }
    
    func setMark(mark:GameMark, atIndex:Int) {
        self.marks[atIndex] = mark
    }
    
    func markAtIndex(index: Int) -> GameMark {
        return self.marks[index]
    }
    
    func lineInfoRow(row: Int) -> LineInfo {
        
        let lineInfo = LineInfo(type: .Row)
        
        for column in 0..<self.size {
            let indexCurrent = (self.size*row) + column
            let markCurrent = self.markAtIndex(indexCurrent)
            
            lineInfo.setGameMark(markCurrent, arIndex: indexCurrent)
        }
        
        return lineInfo
    }
    
    func lineInfoColumn(column: Int) -> LineInfo {
        
        let lineInfo = LineInfo(type: .Column)
        
        for row in 0..<self.size {
            let indexCurrent = (self.size*row) + column
            let markCurrent = self.markAtIndex(indexCurrent)
            
            lineInfo.setGameMark(markCurrent, arIndex: indexCurrent)
        }
        
        return lineInfo
    }
    
    func lineInfoDiagonal() -> LineInfo {
        
        let lineInfo = LineInfo(type: .Diagonal)
        
        for row in 0..<self.size {
            
            let indexCurrent = (self.size*row) + row
            
            let markCurrent = self.markAtIndex(indexCurrent)
            lineInfo.setGameMark(markCurrent, arIndex: indexCurrent)
        }
        
        return lineInfo
    }
    
    func lineInfoAntidiag() -> LineInfo {
        
        let lineInfo = LineInfo(type: .Diagonal)
        
        for row in 0..<self.size {
            
            let currentRow = row
            let currentColumn = (self.size-row-1)
            
            let indexCurrent = (currentRow*self.size) + currentColumn
            
            let markCurrent = self.markAtIndex(indexCurrent)
            lineInfo.setGameMark(markCurrent, arIndex: indexCurrent)
        }
        
        return lineInfo
    }
    
}
