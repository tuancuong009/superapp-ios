//
//  CategoryAppViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 18/4/25.
//

import UIKit

class CategoryAppViewController: UIViewController {
    var tapCategory:((_ name: String)->())?
    let categories: [String] = [
        "Books",
        "Business",
        "Child Care",
        "Education",
        "Entertainment",
        "Finance",
        "Food & Drink",
        "Games",
        "Health & Fitness",
        "Jobs & Employment",
        "Kids",
        "Lifestyle",
        "Medical",
        "Music",
        "Navigation",
        "News",
        "Photo & Video",
        "Productivity",
        "Reference",
        "Shopping",
        "Social Networking",
        "Sports",
        "Travel",
        "Utilities",
        "Weather"
    ]


    @IBOutlet weak var tblCategory: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCategory.registerNibCell(identifier: "CategoryAppTableViewCell")
        // Do any additional setup after loading the view.
    }


    @IBAction func doClose(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension CategoryAppViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCategory.dequeueReusableCell(withIdentifier: "CategoryAppTableViewCell") as! CategoryAppTableViewCell
        cell.lblName.text = categories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.tapCategory?(categories[indexPath.row])
        dismiss(animated: true)
    }
    
}
