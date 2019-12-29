//
//  DetailViewController.swift
//  Task 2
//
//  Created by Mustafa on 29/12/19.
//  Copyright © 2019 Mustafa Nafie. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	// MARK: Outlets and Properties

	@IBOutlet weak var titleTextView: UITextView!
	@IBOutlet weak var bodyTextView: UITextView!
	
	var parentVC: ViewController?
	
	// MARK: Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Style the textviews
		titleTextView.layer.borderColor = UIColor.gray.cgColor
		titleTextView.layer.borderWidth = 1.0
		titleTextView.layer.cornerRadius = 8
		titleTextView.textContainer.maximumNumberOfLines = 2
		titleTextView.textContainer.lineBreakMode = .byWordWrapping
		bodyTextView.layer.borderColor = UIColor.gray.cgColor
		bodyTextView.layer.borderWidth = 1.0
		bodyTextView.layer.cornerRadius = 8
		bodyTextView.textContainer.maximumNumberOfLines = 2
		bodyTextView.textContainer.lineBreakMode = .byWordWrapping
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		// Add item only when both textviews are edited
		if titleTextView.text != "Title" &&
			bodyTextView.text != "Body" {
			let newItem = [
				"title": titleTextView.text,
				"body": bodyTextView.text,
			]
			// Add the new item to items list
			parentVC?.itemsList.append(newItem as [String : Any])
			
			let controller = UIAlertController()
			controller.title = "Item Added Successfully"
			parentVC!.present(controller, animated: true, completion: nil)
			DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
				controller.dismiss(animated: true, completion: nil)
			}
		}
	}

}
