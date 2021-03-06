# Brain-Metrix
With this App you can play the card game "Brain Metrix", also known as "Memory", on your iOS Device.

# Features
* created a revealing splash view and installed dependencies
* shuffle cards
* match cards
* scoring system (+2 for found matches, -1 if selected card was flipped before and mismatched, bonus/deduction dependant on how much time it took to match/mismatch two cards)
* bonus/deduction system dependant on time (+2 if it took <0.75s to find a match, +1 if it took <1.00s to find a match, -2 if it took >2.25s to find a mismatch (at least one of the flipped cards where flipped before))
* label showing time bonus/deduction fades away
* restart button
* random theme (card color, strings (emojis) on card, background, labels and restart button are affected by themes, currently there are 7 themes)
*auto layout using container views
# Future Updates
* cleaner code
* choose theme
* choose difficulty level
* better animations
# Build With
* XCode 10.1
* Swift 4.2
* MVC Architecture
# Acknowledgement
Thanks to Paul Hegarty for the great iOS Course!

# What I've Learned in This Project
How to:

* use access control (private, private(set), fileprivate, asserts)
* use extensions properly
* use computed properties
* use static properties and static/mutating methods
* use filter method
* animate show and fade away text
* get time intervals (Date(), DateFormatter())
