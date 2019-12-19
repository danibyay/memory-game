//
//  CardCollectionViewCell.swift
//  Memorama
//
//  Created by Daniela Becerra Gonzalez on 17/12/19.
//  Copyright © 2019 Daniela Becerra Gonzalez. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card) {
        self.card = card
        frontImageView.image = UIImage(named: card.imageName)
        if card.isFlipped {
            UIView.transition(from: backImageView, to: frontImageView, duration: 0.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        } else if !card.isFlipped {
            UIView.transition(from: frontImageView, to: backImageView, duration: 0.0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        } else if card.isMatched {
            remove()
        }
    }
    
    func flip() {
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        
        
    }
    
    func remove() {
        // remove the views
        // TODO: animate it
        frontImageView.alpha = 0
        backImageView.alpha = 0
    }

}
