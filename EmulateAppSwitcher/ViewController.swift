//
//  ViewController.swift
//  EmulateAppSwitcher
//
//  Created by Don Mag on 2/7/21.
//

import UIKit

class ViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 20
		stack.translatesAutoresizingMaskIntoConstraints = false
		
		["Demo", "With Vertical"].forEach { str in
			let b = UIButton()
			b.setTitle(str, for: [])
			b.setTitleColor(.white, for: .normal)
			b.setTitleColor(.lightGray, for: .highlighted)
			b.backgroundColor = .systemTeal
			b.addTarget(self, action: #selector(showDemo(_:)), for: .touchUpInside)
			stack.addArrangedSubview(b)
		}
		
		view.addSubview(stack)
		
		let g = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			stack.widthAnchor.constraint(equalTo: g.widthAnchor, multiplier: 0.75),
			stack.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			stack.centerYAnchor.constraint(equalTo: g.centerYAnchor),
		])
		
	}
	
	@objc func showDemo(_ sender: Any?) -> Void {
		
		let vc = DemoViewController()
		
		if let btn = sender as? UIButton,
		   let t = btn.currentTitle,
		   t != "Demo" {
			vc.testVertical = true
		}
		
		navigationController?.pushViewController(vc, animated: true)
		
	}
	
}

