//
//  CardContentViewController.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 1/25/21.
//

import UIKit

class CardContentViewController: UIViewController {
    
    @IBOutlet var rulesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        rulesTableView.delegate = self
        rulesTableView.dataSource = self

    }

}//END OF CLASS

 //MARK: - Extensions
extension CardContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TaskController.shared.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rulesCell", for: indexPath)
        
        let rulesToDisplay = TaskController.shared.tasks[indexPath.row]
        cell.textLabel?.text = rulesToDisplay.name
        
        return cell
    }
}//END OF EXTENSION
