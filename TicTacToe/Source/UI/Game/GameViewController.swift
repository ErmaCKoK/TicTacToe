//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Andrii Kurshyn on 3/12/16.
//  Copyright © 2016 Andrii Kurshyn. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GameControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var wonLineView: WonLineView!
    @IBOutlet weak var infoLabel: UILabel!
    
    let gameController = GameController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.gameController.delegate = self
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showNewGameAlert()
    }
    
    @IBAction func startNewGame() {
        self.showNewGameAlert()
    }
    
    func showNewGameAlert() {
        
        var newWordField: UITextField?
        
        let alertController = UIAlertController(title: "Enter size board bettwen 3-8", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.text = "8"
            textField.textAlignment = .Center
            textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
            newWordField = textField
            
        }
        
        let actionPlayerVSPlayer = UIAlertAction(title: "Player VS Player", style: UIAlertActionStyle.Default) { (action) -> Void in
            let boardSize = Int(newWordField?.text ?? "8") ?? 8
            self.startNewGameWithBoardSize(.PlayerVSPlayer, size:boardSize)
        }
        alertController.addAction(actionPlayerVSPlayer)
        
        let actionPlayerVSComputer = UIAlertAction(title: "Player VS Computer", style: UIAlertActionStyle.Default) { (action) -> Void in
            let boardSize = Int(newWordField?.text ?? "8") ?? 8
            self.startNewGameWithBoardSize(.PlayerVSComputer, size:boardSize)
        }
        alertController.addAction(actionPlayerVSComputer)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func startNewGameWithBoardSize(gameType: GameType, size: Int) {
        self.gameController.startNewGame(gameType, boardSize: size)
        self.wonLineView.removedLine()
        self.infoLabel.textColor = UIColor.blackColor()
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.infoLabel.text = "It's \(GameMark.Cross.describe) Turn"
            self.collectionView.reloadData()
        }
    }
    
    // MARK: GameController delegate
    func gameControllerDidStep(gameMark: GameMark, index: Int, nextPlayer: String) {
        
        self.infoLabel.text = "It's \(nextPlayer) Turn"
        
        if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? FieldCollectionViewCell {
            cell.markView.color = gameMark == .Cross ? UIColor.greenColor() : UIColor.yellowColor()
            cell.markView.setGameMark(gameMark, animated: true)
        }
    }
    
    func gameControllerDidDraw() {
        self.infoLabel.textColor = UIColor.greenColor()
        self.infoLabel.text = "It's a DRAW!!!!"
    }
    
    func gameControllerDidWon(mark: GameMark, lineInfo: LineInfo) {
        
        self.infoLabel.textColor = UIColor.redColor()
        self.infoLabel.text = "It's \(mark.describe) WON!!!!"
        
        if let starCell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: lineInfo.startIndex, inSection: 0)),
            let endCell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: lineInfo.endIndex, inSection: 0)) {
                
                let startPoint = self.wonLineView.convertPoint(starCell.center, fromView: starCell.superview)
                let endPoint = self.wonLineView.convertPoint(endCell.center, fromView: endCell.superview)
                self.wonLineView.drawLine(startPoint, endPoint: endPoint)
        }
        
    }
    
    // MARK: UICollectionView DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gameController.gameBoard?.gameAreaCout ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! FieldCollectionViewCell
        
        let gameSize = self.gameController.gameBoard?.size ?? 1
        
        cell.lineDownView.hidden = indexPath.row/gameSize == gameSize - 1
        cell.lineRightView.hidden = indexPath.row%gameSize == gameSize - 1
        
        let mark = self.gameController.gameBoard?.markAtIndex(indexPath.row) ?? .Empty
        cell.markView.color = mark == .Cross ? UIColor.greenColor() : UIColor.yellowColor()
        cell.markView.setGameMark(mark, animated: false)
        
        return cell
    }
    
    // MARK: UICollectionView Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.gameController.playerTapAtIndex(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let gameSize = self.gameController.gameBoard?.size ?? 1
        let size = self.collectionView.frame.size.width/CGFloat(gameSize)
        return CGSizeMake(size, size)
    }
    
}

