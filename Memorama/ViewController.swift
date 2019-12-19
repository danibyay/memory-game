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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardArray = model.getCards()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
} // End ViewControler Class

