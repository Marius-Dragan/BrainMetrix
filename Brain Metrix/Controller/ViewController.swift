//
//  ViewController.swift
//  Brain Metrix
//
//  Created by Marius Dragan on 01/12/2018.
//  Copyright © 2018 Marius Dragan. All rights reserved.
//

import UIKit
import RevealingSplashView

class ViewController: UIViewController {
    
    private lazy var game = BrainMetrix(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet { //Property observers to keep the UI in sync with the instance variables of our class
            flipCountLbl.text = "Flips: \(flipCount)"
        }
    }

    //Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bonusLbl: UILabel!
    @IBOutlet weak var flipCountLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var newGameBtn: UIButton!
    
    //Actions
    @IBAction func newGameBtnPressed(_ sender: UIButton) {
            game.restartGame()
            flipCount = 0
            indexTheme = emojiThemes.count.arc4random
            updateViewFromModel()
    }
    
    let revealingSplashView = RevealingSplashView (iconImage: UIImage(named: "LaunchScreenIcon")!, iconInitialSize: CGSize(width: 150, height: 150), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTheme = emojiThemes.count.arc4random
        updateViewFromModel()
        newGameBtn.layer.cornerRadius = 2.5
        //newGameBtn.isHidden = true
        
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.heartBeat
        revealingSplashView.startAnimation()
        revealingSplashView.heartAttack = true
    }
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            bonusLbl.text = game.bonus
            bonusLbl.alpha = 1
            UIView.animate(withDuration: 3.0, animations: {
                self.bonusLbl.alpha = 0
            })
            game.resetTimeBonus()
            scoreLbl.text = "Score: \(game.score)"
            //flipsCountLbl.text = "Flips: \(game.flipCount)"
        } else {
            print("Choosen card was not found in cardButtons")
        }
        //newGameBtn.isHidden = false
    }
    
    var indexTheme = 0 {
        didSet {
            //print(indexTheme, emojiThemes[indexTheme].name)
            emoji = [Int:String]()
            titleLbl.text = emojiThemes[indexTheme].name
            emojiChoises = emojiThemes[indexTheme].emojis
            backgroundColor = emojiThemes[indexTheme].viewColor
            cardBackColor = emojiThemes[indexTheme].cardColor
            
            updateApperance()
        }
    }
    
    private func updateApperance() {
        view.backgroundColor = backgroundColor
        flipCountLbl.textColor = cardBackColor
        scoreLbl.textColor = cardBackColor
        titleLbl.textColor = cardBackColor
        newGameBtn.setTitleColor(backgroundColor, for: .normal)
        newGameBtn.backgroundColor = cardBackColor
        bonusLbl.textColor = cardBackColor
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : cardBackColor
            }
            if card.isMatched {
                button.isEnabled = false
            } else {
                button.isEnabled = true
            }
        }
        scoreLbl.text = "Score: \(game.score)"
        //flipsCountLbl.text = "Flips: \(game.flipCount)"
    }
    
    private var emojiChoises = [String]()
    private var backgroundColor = UIColor.black
    private var cardBackColor = UIColor.orange
    private var emoji = [Int:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoises.count > 0 {
            emoji[card.identifier] = emojiChoises.remove(at: emojiChoises.count.arc4random)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    private var emojiThemes: [Theme] = [
        Theme(name: "Fruits",
              emojis:["🍏", "🍊", "🍓", "🍉", "🍇", "🍒", "🍌", "🥝", "🍆", "🍑", "🍋", "🥥", "🍐", "🍈", "🥭"], viewColor: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), cardColor: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),
        Theme(name: "Faces",
              emojis:["😀", "😂", "🤣", "😃", "😄", "😅", "😆", "😉", "😊", "😋", "😎", "😜", "😇", "🤓", "🥶"], viewColor: #colorLiteral(red: 1, green: 0.8999392299, blue: 0.3690503591, alpha: 1), cardColor: #colorLiteral(red: 0.5519944677, green: 0.4853407859, blue: 0.3146183148, alpha: 1)),
        Theme(name: "Activity",
              emojis:["⚽️", "🏄‍♂️", "🏑", "🏓", "🚴‍♂️","🥋", "🎸", "🎯", "🎮", "🎹", "🎲", "🏀", "🏈", "⚾️", "🎱"], viewColor: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), cardColor: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)),
        Theme(name: "Animals",
              emojis:["🐶", "🐭", "🦊", "🦋", "🐢", "🐸", "🐵", "🐞", "🐿", "🐇", "🐯", "🐷", "🐥", "🦆", "🦅"], viewColor: #colorLiteral(red: 0.8306297664, green: 1, blue: 0.7910112419, alpha: 1), cardColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),
        Theme(name: "Christmas",
              emojis:["🎅", "🎉", "🦌", "⛪️", "🌟", "❄️", "⛄️","🎄", "🎁", "🔔", "🕯", "🥶", "🥂", "🍾", "🍸"], viewColor: #colorLiteral(red: 0.9678710938, green: 0.9678710938, blue: 0.9678710938, alpha: 1), cardColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)),
        Theme(name: "Clothes",
              emojis:["👚", "👕", "👖", "👔", "👗", "👓", "👠", "🎩", "👟", "⛱","🎽", "🥋", "🎿", "👙", "👘"], viewColor: #colorLiteral(red: 0.9098039269, green: 0.7650054947, blue: 0.8981300767, alpha: 1), cardColor: #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)),
        Theme(name: "Halloween",
              emojis:["💀", "👻", "👽", "🙀", "🦇", "🕷", "🕸", "🎃", "🎭","😈", "⚰", "👾", "🤖", "🤠", "👹"], viewColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), cardColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)),
        Theme(name: "Transport",
              emojis:["🚗", "🚓", "🚚", "🏍", "✈️", "🚜", "🚎", "🚲", "🚂", "🛴", "🛳", "🚀", "🛩", "🚊", "🚁"], viewColor: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), cardColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)),
        Theme(name: "Flags",
              emojis:["🇧🇿", "🇦🇸", "🇦🇽", "🇱🇷", "🇻🇮", "🇵🇲", "🇬🇸", "🇮🇲", "🇨🇰", "🇦🇩", "🏴‍☠️", "🚩", "🇦🇹", "🇷🇴", "🇳🇬"], viewColor: #colorLiteral(red: 0.004498224705, green: 0.9877070785, blue: 0.9525943398, alpha: 0.8), cardColor: #colorLiteral(red: 0.970674932, green: 0.8789842725, blue: 0.9043495059, alpha: 1))
    ]
    
}

extension Int {
    
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
