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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var taskTableView: UITableView!
    
    //MARK: - Properties
    var image: UIImage?
    var viewsLaidOut = false
    var day: Day?
    
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
        guard let day = day else { return }
        
        view.backgroundColor = .white
        containerView.addAccentBorder()
        containerView.contentMode = .scaleToFill
        containerView.layer.cornerRadius = 32
        containerView.clipsToBounds = true
        bodyTextView.addAccentBorder()
        bodyTextView.backgroundColor = .white
        bodyTextView.textColor = .black
        bodyTextView.layer.cornerRadius = 32
        bodyTextView.allowsEditingTextAttributes = true
        bodyTextView.autocapitalizationType = .sentences
        bodyTextView.autocorrectionType = .yes
        bodyTextView.textContainerInset.top = 12
        bodyTextView.textContainerInset.bottom = 12
        bodyTextView.textContainerInset.left = 12
        bodyTextView.textContainerInset.right = 12
//        taskTableView.layer.cornerRadius = 32
        taskTableView.backgroundColor = .white
        taskTableView.isScrollEnabled = false
        dayNumberLabel.text = "Day \(day.dayNumber)"
    }
    
    func updateViews() {
        guard let day = day else { return }
        
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPickerVC" {
            let destination = segue.destination as? PhotoPickerViewController
            destination?.delegate = self
        }
    }
}//END OF CLASS

//MARK: - Extensions
extension DayViewController: PhotoSelectorDelegate {
    func photoPickerSelected(image: UIImage) {
        self.image = image
//        TaskController.shared.update(task: <#T##Task#>, progressPhoto: <#T##UIImage?#>)
    }
}//END OF EXTENSION

extension DayViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.view.frame.height / 7
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.shared.tasks.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
       
        cell.delegate = self
        
        let taskToDisplay = TaskController.shared.tasks[indexPath.row]
        cell.task = taskToDisplay
        
        return cell
    }
}//END OF EXTENSION

extension DayViewController: TaskCellDelegate {
    func completeButtonTapped(sender: TaskTableViewCell) {
        guard let task = sender.task else { return }
        TaskController.shared.toggleComplete(task: task)

        sender.task = task
    }
}//END OF EXTENSION
