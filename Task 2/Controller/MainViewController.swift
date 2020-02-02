//
//  MainViewController.swift
//  Task 2
//
//  Created by Mustafa on 29/12/19.
//  Copyright © 2019 Mustafa Nafie. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
	
	// MARK:- Outlets and Properties
	
	@IBOutlet weak var tableView: UITableView! {
		didSet { addRefreshControl(to: tableView) }
	}
	
	private var activityIndicator:UIActivityIndicatorView! {
		didSet { setup(activityIndicator: activityIndicator) }
	}
	
	private let endpoint = "https://jsonplaceholder.typicode.com/posts"
	
	// MARK:- View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Initialize the activity indicator
		activityIndicator = UIActivityIndicatorView()
		
		// Make the API request
		loadDataFromAPI()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}
	
	// MARK:- Actions
	
	@IBAction func addItems(_ sender: Any) {
		let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
		detailVC.navigationItem.title = "Add Item"
		detailVC.parentVC = self
		
		navigationController?.pushViewController(detailVC, animated: true)
	}
	
	// MARK:- Network Functions
	
	@objc func loadDataFromAPI() {
		// Use Alamofire to make the request
		AF.request(endpoint).validate().responseJSON { response in
			switch response.result {
			case .success(let listItems):
				// Cast the response as an array of dictionaries
				ItemsModel.itemsList = listItems as! [[String:Any]]
				// Update the UI
				self.updateUI()
			case .failure(let error):
				print(error)
			}
		}
	}
	
}

// MARK: - TableView DataSource

extension MainViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ItemsModel.itemsList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return setupCell(in: tableView, at: indexPath)
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
}

// MARK: - TableView Delegate

extension MainViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		updateItem(at: indexPath)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if (editingStyle == .delete) { deleteItem(at: indexPath) }
	}
	
}

// MARK: - Helper Functions

extension MainViewController {
	
	private func setup(activityIndicator: UIActivityIndicatorView) {
		activityIndicator.style = .large
		activityIndicator.color = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
		activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0)
		activityIndicator.center = self.view.center
		self.view.addSubview(activityIndicator)
		activityIndicator.bringSubviewToFront(self.view)
		activityIndicator.startAnimating()
	}
	
	private func addRefreshControl(to tableView: UITableView) {
		// Initialize the Refresh Control
		let refreshControl = UIRefreshControl()
		// Add Refresh Control to Table View
		tableView.refreshControl = refreshControl
		// Configure Refresh Control
		refreshControl.addTarget(self, action: #selector(loadDataFromAPI), for: .valueChanged)
		refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
		refreshControl.attributedTitle = NSAttributedString(string: "Fetching List Data ...")
	}
	
	private func setupCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
		
		// Set title and body of the cell
		var title = ItemsModel.itemsList[indexPath.item]["title"] as? String
		title = String(indexPath.item + 1) + "-" + title!
		cell.textLabel?.text = title
		cell.detailTextLabel?.text =  ItemsModel.itemsList[indexPath.item]["body"] as? String
		
		return cell
	}
	
	func updateUI() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
			self.activityIndicator.stopAnimating()
			if self.tableView.refreshControl!.isRefreshing {
				self.tableView.refreshControl!.endRefreshing()
				self.presentAlertController(withTitle: "List Reloaded Successfully")
			}
		}
	}
	
	private func updateItem(at indexPath: IndexPath) {
		let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
		detailVC.navigationItem.title = "Update Item"
		detailVC.parentVC = self
		detailVC.selectedCell = indexPath.item
		detailVC.selectedCellTitle = ItemsModel.itemsList[indexPath.item]["title"] as? String
		detailVC.selectedCellBody = ItemsModel.itemsList[indexPath.item]["body"] as? String
		
		navigationController?.pushViewController(detailVC, animated: true)
	}
	
	private func deleteItem(at indexPath: IndexPath) {
		ItemsModel.itemsList.remove(at: indexPath.item)
		tableView.reloadData()
	
		presentAlertController(withTitle: "Item Deleted Successfully")
	}
	
	private func presentAlertController(withTitle title: String) {
		let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
		present(controller, animated: true, completion: nil)
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			controller.dismiss(animated: true, completion: nil)
		}
	}
	
}

