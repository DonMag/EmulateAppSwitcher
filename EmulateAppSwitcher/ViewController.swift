//
//  ViewController.swift
//  EmulateAppSwitcher
//
//  Created by Don Mag on 2/7/21.
//

import UIKit

class ViewController: UIViewController {

	let switcherView = SwitcherView()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemYellow
		
		switcherView.translatesAutoresizingMaskIntoConstraints = false
		switcherView.backgroundColor = .white
		
		view.addSubview(switcherView)
		
		// respect safe area
		let g = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			// constrain switcher view to all 4 sides of safe area
			switcherView.topAnchor.constraint(equalTo: g.topAnchor, constant: 0.0),
			switcherView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
			switcherView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
			switcherView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: 0.0),
		])
		
	}
	
}

