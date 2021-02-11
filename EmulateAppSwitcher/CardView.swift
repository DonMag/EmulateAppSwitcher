//
//  CardView.swift
//  EmulateAppSwitcher
//
//  Created by Don Mag on 2/7/21.
//

import UIKit

class CardView: UIView {
	
	var cardID: Int = 0 {
		didSet {
			label1.text = "\(cardID)"
			label2.text = "\(cardID)"
		}
	}
	
	weak var leading: NSLayoutConstraint?
	
	let label1: UILabel = {
		let v = UILabel()
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	let label2: UILabel = {
		let v = UILabel()
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() -> Void {
		addSubview(label1)
		addSubview(label2)
		
		NSLayoutConstraint.activate([
			label1.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
			label1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
			label2.centerXAnchor.constraint(equalTo: centerXAnchor),
			label2.centerYAnchor.constraint(equalTo: centerYAnchor),
		])
		
		layer.cornerRadius = 10
		
		// border
		layer.borderWidth = 1.0
		layer.borderColor = UIColor.gray.cgColor
		
		// shadow
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: -3, height: 3)
		layer.shadowOpacity = 0.25
		layer.shadowRadius = 2.0
	}
	
}

