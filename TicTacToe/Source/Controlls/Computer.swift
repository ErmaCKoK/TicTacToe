//
//  Computer.swift
//  TicTacToe
//
//  Created by Andrii Kurshyn on 3/12/16.
//  Copyright © 2016 Andrii Kurshyn. All rights reserved.
//

import UIKit

class Computer: NSObject {
    
    // MARK: Public properties
    private(set) var board: GameBoard
    private(set) var mark = GameMark.Circle
    
    var opponentMark: GameMark {
        get {
            return self.mark == .Circle ? .Cross : .Circle
        }
    }
    
    init(board: GameBoard) {
        self.board = board
    }
    
    // MARK: Public methods
    func makeStep(completion:((index: Int, mark: GameMark) -> ())) {
        
        //look at the penultimate turn an opponent for end line
        if let index = self.emptyStepsWithMark(self.opponentMark, countMark: self.board.size - 1) {
            completion(index: index, mark: self.mark)
            return
        }
        
        //look at the penultimate turn self for end line
        if let index = self.emptyStepsWithMark(self.mark, countMark: self.board.size - 1) {
            completion(index: index, mark: self.mark)
            return
        }
        
        if let index = self.emptyStepsWithMark(self.mark, countMark: self.board.size - 2) {
            completion(index: index, mark: self.mark)
            return
        }
        
        completion(index: self.randomStep(), mark: self.mark)
    }
    
    // MARK: Private methods
    private func randomStep() -> Int {
        let indexs = self.board.indexsAvailable()
        let random = Int(arc4random_uniform(UInt32(indexs.count)))
        return indexs[random]
    }
    
    private func emptyStepsWithMark(mark: GameMark, countMark: Int) -> Int? {
        
        for row in 0..<board.size {
            let lineInfo = board.lineInfoRow(row)
            if let index = self.emptyIndexInLine(lineInfo, sameMark: mark, countMark: countMark) {
                return index
            }
        }
        
        for column in 0..<board.size {
            let lineInfo = board.lineInfoColumn(column)
            if let index = self.emptyIndexInLine(lineInfo, sameMark: mark, countMark: countMark) {
                return index
            }
        }
        
        let lineInfoDiagonal = board.lineInfoDiagonal()
        if let index = self.emptyIndexInLine(lineInfoDiagonal, sameMark: mark, countMark: countMark) {
            return index
        }
        
        let lineInfoAntidiag = board.lineInfoAntidiag()
        if let index = self.emptyIndexInLine(lineInfoAntidiag, sameMark: mark, countMark: countMark) {
            return index
        }
        
        return nil
    }
    
    private func emptyIndexInLine(lineInfo: LineInfo, sameMark: GameMark, countMark: Int) -> Int? {
        for (mark, count) in lineInfo.countMarks where mark == sameMark {
            if count == countMark {
                for (index, mark) in lineInfo.line where mark == .Empty {
                    return index
                }
            }
        }
        return nil
    }
}
