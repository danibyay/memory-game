//
//  ViewController.swift
//  Memorama
//
//  Created by Daniela Becerra Gonzalez on 17/12/19.
//  Copyright © 2019 Daniela Becerra Gonzalez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var model = CardModel()
    var cardArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    var timer:Timer?
    var milliseconds:Float = 10000
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardArray = model.getCards()
        collectionView.delegate = self
        collectionView.dataSource = self
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Timer methods
    @objc func timerElapsed() {
        milliseconds -= 1
        let seconds = String(format: "%.2f", milliseconds/1000)
        if milliseconds >= 0 {
            timerLabel.text = "Time remaining: \(seconds)"
        }
        
        if milliseconds < 0 {
            // stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // check if the player lost
            checkGameEnded()
            
        }
    }
    
    // MARK: - UICollectionView Protocol Methods
    func collectionView(_ collectionView: UICollectionView,
            numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        let card = cardArray[indexPath.row]
        cell.setCard(card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
            didSelectItemAt indexPath: IndexPath) {
        
        // check if it's valid to play
        if milliseconds <= 0 {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        let card = cardArray[indexPath.row]
        
        if !card.isFlipped && !card.isMatched{
            cell.flip()
            card.isFlipped = true
            
            // Determine if it's the first card or second card
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            } else {
                checkForMatches(indexPath)
            }
            
        }
        
    } // End didSelectItemAt method
    
    // MARK: - Game Logic
    func checkForMatches(_ secondFlippedCardIndex:IndexPath) {
        // get the cells for the two revealed cards
        let firstCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let secondCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // get the cards for the two revealed cards
        let firstCard = cardArray[firstFlippedCardIndex!.row]
        let secondCard = cardArray[secondFlippedCardIndex.row]
        
        // check for match
        if firstCard.imageName == secondCard.imageName {
            // set the status
            firstCard.isMatched = true
            secondCard.isMatched = true
            
            // update the view
            firstCell?.remove()
            secondCell?.remove()
            
            // every time there is a pair, it could be the last one, check!
            checkGameEnded()
            
        } else {
            // set the status of the model
            firstCard.isFlipped = false
            secondCard.isFlipped = false
            
            // update the view
            firstCell?.flipBack()
            secondCell?.flipBack()
        }
        
        // if the matched card is out of view (scrolled)
        if firstCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // reset the index to keep playing
        firstFlippedCardIndex = nil
        
    }
    
    func checkGameEnded() {
        // Determine if there are unmatched cards
        var wonTheGame = true
        for card in cardArray {
            if !card.isMatched {
                wonTheGame = false
                break
            }
        }
        
        // Messaging variables
        var title = ""
        var message = ""
        
        // win condition
        if wonTheGame {
            if milliseconds > 0 {
                timer?.invalidate()
            }
            title = "Congratulations!"
            message = "You've won"
        } else {
            // lose condition
            if milliseconds > 0 {
                return
            }
            title = "Game Over"
            message = "You've lost"
        }
        
        showAlert(title, message)
        
    }
    
    func showAlert(_ title:String, _ message:String) {
        // notify user
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
} // End ViewControler Class

