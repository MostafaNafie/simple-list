//
//  DetailViewController.swift
//  Task 2
//
//  Created by Mustafa on 29/12/19.
//  Copyright © 2019 Mustafa Nafie. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	// MARK:- Outlets and Properties

	@IBOutlet weak var titleTextView: UITextView!
	@IBOutlet weak var bodyTextView: UITextView!
	
	var parentVC: MainViewController?
	var selectedCell: Int?
	var selectedCellTitle: String?
	var selectedCellBody: String?
	
	// MARK:- View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationItem.largeTitleDisplayMode = .never
		
		setup(textView: titleTextView)
		setup(textView: bodyTextView)
		
		// Display text if an item is selected from the parentVC
		displaySelectedItem()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		if navigationItem.title == "Add Item" {
			addItem()
		} else {
			updateItem()
		}
	}

}

// MARK:- TextView Delegate

extension DetailViewController: UITextViewDelegate {
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		textView.layer.borderColor = UIColor.green.cgColor
		// Set placeholder text
		if textView.text == "Enter text for title" || textView.text == "Enter text for body" {
			textView.text = ""
			textView.textColor = .black
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		textView.layer.borderColor = UIColor.gray.cgColor
		// Set placeholder text
		if textView.text == "" {
			if textView == titleTextView {
				textView.text = "Enter text for title"
			} else {
				textView.text = "Enter text for body"
			}
			textView.textColor = .lightGray
		}
	}
	
}

// MARK: - Helper Functions

extension DetailViewController {
	
	private func setup(textView: UITextView) {
		textView.delegate = self
		textView.layer.borderColor = UIColor.gray.cgColor
		textView.layer.borderWidth = 1.0
		textView.layer.cornerRadius = 8
		textView.textColor = .lightGray
		
		if textView == titleTextView {
			textView.textContainer.maximumNumberOfLines = 2
			textView.textContainer.lineBreakMode = .byWordWrapping
		}

	}
	
	private func displaySelectedItem() {
		if let title = selectedCellTitle, let body = selectedCellBody {
			titleTextView.text = title
			titleTextView.textColor = UIColor.black
			bodyTextView.text = body
			bodyTextView.textColor = UIColor.black
		}
	}
	
	private func addItem() {
		if (titleTextView.text != "Enter text for title" && titleTextView.text != "") &&
			(bodyTextView.text != "Enter text for body" && bodyTextView.text != "") {
			
			let newItem = [
				"title": titleTextView.text,
				"body": bodyTextView.text,
			]
			// Add the new item to items list
			ItemsModel.itemsList.append(newItem as [String : Any])
			presentAlertController(withTitle: "Item Added Successfully")
		}
	}
	
	private func updateItem() {
		if (titleTextView.text != selectedCellTitle ||
			bodyTextView.text != selectedCellBody) {
			ItemsModel.itemsList[selectedCell!]["title"] = titleTextView.text
			ItemsModel.itemsList[selectedCell!]["body"] = bodyTextView.text
			presentAlertController(withTitle: "Item Updated Successfully")
		}
	}
	
	private func presentAlertController(withTitle title: String) {
		let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
		parentVC!.present(controller, animated: true, completion: nil)
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			controller.dismiss(animated: true, completion: nil)
		}
	}
	
}

