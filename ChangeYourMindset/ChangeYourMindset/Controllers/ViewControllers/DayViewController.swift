//
//  DayViewController.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/28/20.
//

import UIKit

class DayViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var dayNumberLabel: UILabel!
    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var taskTableView: UITableView!
    
    //MARK: - Properties
    var image: UIImage?
    var viewsLaidOut = false
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.dataSource = self
        taskTableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewsLaidOut == false {
            setupViews()
            viewsLaidOut = true
        }
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        photoContainerView.layer.cornerRadius = 32
        photoContainerView.clipsToBounds = true
        view.backgroundColor = .systemRed
        bodyTextView.backgroundColor = .lightGray
        bodyTextView.textColor = .black
        bodyTextView.layer.cornerRadius = 32
        bodyTextView.allowsEditingTextAttributes = true
        bodyTextView.autocapitalizationType = .sentences
        bodyTextView.autocorrectionType = .yes
        bodyTextView.textContainerInset.top = 12
        bodyTextView.textContainerInset.bottom = 12
        bodyTextView.textContainerInset.left = 12
        bodyTextView.textContainerInset.right = 12
        taskTableView.layer.cornerRadius = 32
        taskTableView.backgroundColor = .lightGray
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPickerVC" {
            let destination = segue.destination as? PhotoPickerViewController
            destination?.delegate = self
        }
    }
}//END OF CLASS

//MARK: - Extension
extension DayViewController: PhotoSelectorDelegate {
    func photoPickerSelected(image: UIImage) {
        self.image = image
    }
}//END OF EXTENSION

extension DayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return ChallengeController.shared.tasks.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        
//        let taskToDisplay = TaskController.shared.tasks[indexPath.row]
//        cell.textLabel?.text = challengeToDisplay.name
        let task = Task(name: "HI", challengeReference: nil)
        cell.task = task
        
        return cell
    }
}//END OF EXTENSION
