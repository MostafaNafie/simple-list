//
//  ViewController.swift
//  Task 2
//
//  Created by Mustafa on 29/12/19.
//  Copyright © 2019 Mustafa Nafie. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	// MARK: Outlets
	
	@IBOutlet weak var tableView: UITableView!
	
	// MARK: Properties
	
	let endpoint = "https://jsonplaceholder.typicode.com/posts"
	var listItems: [[String:Any]] = []
	
	// MARK: Lifecycle Functions
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Make the API request
		loadDataFromAPI()
	}
	
	// MARK: Data Functions
	
	func loadDataFromAPI() {
		// Use Alamofire to make the request
		AF.request(endpoint).validate().responseJSON { response in
			switch response.result {
			case .success(let listItems):
				// Cast the response as an array of dictionaries
				self.listItems = listItems as! [[String:Any]]
				// Update the UI
				self.tableView.reloadData()
			case .failure(let error):
				print(error)
			}
		}
	}
	
	// MARK: TableView Functions
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
		
		// Set title and body of the cell
		var title = listItems[indexPath.item]["title"] as? String
		title = String(indexPath.item + 1) + "-" + title!
		cell.textLabel?.text = title
		cell.detailTextLabel?.text = listItems[indexPath.item]["body"] as? String
		
		return cell
	}
	
}

