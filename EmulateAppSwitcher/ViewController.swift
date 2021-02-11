//
//  ViewController.swift
//  EmulateAppSwitcher
//
//  Created by Don Mag on 2/7/21.
//

import UIKit

class ViewController: UIViewController {

	var cards: [CardView] = []
	
	var currentCard: CardView?
	
	var firstLayout: Bool = true

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// add 8 "cards" to the view
		for i in 1...8 {
			let v = CardView()
			v.backgroundColor = .cyan
			v.cardID = i
			cards.append(v)
			view.addSubview(v)
			v.isHidden = true
		}

		// and a "center" indicator
		let v = UIView()
		v.backgroundColor = .red
		v.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(v)
		NSLayoutConstraint.activate([
			v.widthAnchor.constraint(equalToConstant: 1.0),
			v.heightAnchor.constraint(equalTo: view.heightAnchor),
			v.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			v.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])

		// add a pan gesture recognizer to the view
		let pan = UIPanGestureRecognizer(target: self, action: #selector(self.didPan(_:)))
		view.addGestureRecognizer(pan)
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		if firstLayout {
			// if it's the first time through, layout the cards
			firstLayout = false
			if let firstCard = cards.first {
				if firstCard.frame.width == 0 {
					cards.forEach { thisCard in
						//thisCard.alpha = 0.750
						thisCard.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width * 1.0, height: view.frame.height * 1.0))
						thisCard.transform = CGAffineTransform(scaleX: 0.71, y: 0.71)
						thisCard.frame.origin.x = 0
						if thisCard == cards.last {
							thisCard.frame.origin.x = 10
						}
						thisCard.isHidden = false
					}
					doCentering(false)
				}
			}
		}
	}
	
	@objc func didPan(_ gesture: UIPanGestureRecognizer) -> Void {
		
		let translation = gesture.translation(in: view)
		
		var pt = gesture.location(in: view)
		pt.y = view.frame.midY
		for c in cards.reversed() {
			if c.frame.contains(pt) {
				if let cc = currentCard {
					if  let idx1 = cards.firstIndex(of: cc),
						let idx2 = cards.firstIndex(of: c),
						idx2 > idx1 {
						currentCard = c
					}
				} else {
					currentCard = c
				}
				break
			}
		}

		switch gesture.state {
		case .changed:
			if let controlCard = currentCard {
				// update card leading edge
				controlCard.frame.origin.x += translation.x
				// don't allow drag left past 1.0
				controlCard.frame.origin.x = max(controlCard.frame.origin.x, 1.0)
				// update the positions for the rest of the cards
				updateCards(controlCard)
				gesture.setTranslation(.zero, in: view)
			}

		case .ended:
			// if we want to "throw" the card, we'd need to
			//	implement a "future x location" here using velocity
			//let panSpeed = gesture.velocity(in: view)

			// "center" the card
			doCentering(true)
			currentCard = nil

		default:
			break
		}
		
	}

	func updateCards(_ controlCard: CardView) -> Void {
		
		guard let idx = cards.firstIndex(of: controlCard) else {
			print("controlCard not found in array of cards - can't update")
			return
		}
		
		var relativeCard: CardView = controlCard
		var n = idx
		
		// for each card to the right of the control card
		while n < cards.count - 1 {
			let nextCard = cards[n + 1]
			// get percent distance of leading edge of relative card
			//	to 30% of the view width
			let pct = relativeCard.frame.origin.x / (view.frame.width * 0.3)
			// move next card that percentage of the width of a card
			nextCard.frame.origin.x = relativeCard.frame.origin.x + (relativeCard.frame.size.width * min(pct, 1.0))
			relativeCard = nextCard
			n += 1
		}

		// reset relative card and index
		relativeCard = controlCard
		n = idx
		
		// for each card to the left of the control card
		while n > 0 {
			let prevCard = cards[n - 1]
			// get percent distance of leading edge of relative card
			//	to half the view width
			let pct = relativeCard.frame.origin.x / view.frame.width
			// move prev card that percentage of one-quarter of the view width
			prevCard.frame.origin.x = (view.frame.width * 0.25) * pct
			relativeCard = prevCard
			n -= 1
		}
		
		self.cards.forEach { c in

			let x = c.frame.origin.x
			
			// scale transform each card between 71% and 75%
			//	based on card's leading edge distance to one-half the view width
			let pct = x / (self.view.frame.width * 0.5)
			let sc = 0.71 + (0.04 * min(pct, 1.0))
			c.transform = CGAffineTransform(scaleX: sc, y: sc)
			
			// set translucent for far left cards
			if cards.count > 1 {
				c.alpha = min(1.0, x / 10.0)
			}

		}
		
	}
	
	func getControlCard() -> CardView? {
		// get the card whose Leading edge is closest to the center
		let halfWidth = view.frame.width * 0.5
		let centerCard = cards.min { a, b in abs(a.frame.minX - halfWidth) < abs(b.frame.minX - halfWidth) }
		return centerCard
	}
	
	func doCentering(_ animated: Bool) -> Void {
		
		guard let cCard = getControlCard(),
			  let idx = cards.firstIndex(of: cCard)
		else {
			return
		}

		var controlCard = cCard
		
		// if the leading edge is greater than 1/2 the view width,
		//	and it's not the Bottom card,
		//	set cur card to the previous card
		if idx > 0 && controlCard.frame.origin.x > view.frame.width * 0.5 {
			controlCard = cards[idx - 1]
		}

		// center of control card will be offset to the right of center
		var newX = self.view.frame.width * 0.575
		if controlCard == cards.last {
			// if it's the Top card, center it
			newX = view.frame.width * 0.5
		}
		if controlCard == cards.first {
			// if it's the Bottom card, center it + just a little to the right
			newX = view.frame.width * 0.51
		}
		UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: [.allowUserInteraction, .curveEaseOut], animations: {
			controlCard.center.x = newX
			self.updateCards(controlCard)
		}, completion: nil)
		
	}
	
}


