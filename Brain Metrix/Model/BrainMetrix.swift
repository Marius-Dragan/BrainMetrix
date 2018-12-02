//
//  BrainMetrix.swift
//  Brain Metrix
//
//  Created by Marius Dragan on 01/12/2018.
//  Copyright © 2018 Marius Dragan. All rights reserved.
//

import Foundation

class BrainMetrix {
    
    private(set) var cards = [Card]()
    
    private(set) var score = 0
    private(set) var bonus = ""
    private var startTime: Date?
    private var elapsedTime: TimeInterval?
    private var seenCards: Set<Int> = []
    
    private struct Points {
        static let matchBonus = 5
        static let missMatchPenalty = 3
    }
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    guard foundIndex == nil else { return nil }
                    foundIndex = index
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "BrainMetrix.chooseCard(at: \(index)) : Choosen index out of range")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                stopTime()
                if cards[matchIndex].identifier == cards[index].identifier {
                    //cards match
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    
                    //Increase score
                    score += Points.matchBonus
                    //flipCount += 1
                    if elapsedTime != nil {
                        if elapsedTime! < 0.75 {
                            bonus = "Time Bonus: +2"
                            score += 2
                        } else if elapsedTime! < 1.0 {
                            bonus = "Time Bonus: +1"
                            score += 1
                        }
                    }
                } else {
                    //Cards didn't match - Penalise
                    
                    if elapsedTime != nil {
                        if elapsedTime! > 2.25 {
                            bonus = "Time Deduction: -2"
                            score -= 2
                        }
                    }
                    if seenCards.contains(index) {
                        score -= Points.missMatchPenalty
                    }
                    if seenCards.contains(matchIndex) {
                        score -= Points.missMatchPenalty
                        
                    }
                    seenCards.insert(index)
                    seenCards.insert(matchIndex)
                }
                cards[index].isFaceUp = true
                
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        let numberOfFaceUpCards = cards.indices.filter { cards[$0].isFaceUp }.count
        if numberOfFaceUpCards == 1 {
            
            startTime = Date()
        } else {
            elapsedTime = nil
        }
        
    }
    
    func restartGame() {
        score = 0
        //seenCards = []
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        cards.shuffle()
    }
    private func stopTime() {
        if let start = startTime {
            elapsedTime = Date().timeIntervalSince(start)
        }
    }
     func resetTimeBonus () {
        bonus = ""
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "BrainMetrix.init(\(numberOfPairsOfCards)) : You must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        //TODO: Shuffle cards
        cards.shuffle()
    }
}

extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        
        for i in indices.dropLast() {
            let diff = distance(from: i, to: endIndex)
            let j = index(i, offsetBy: diff.arc4random)
            swapAt(i, j)
        }
    }
}
