//
//  TaskTableViewCell.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/28/20.
//

import UIKit

protocol TaskCellDelegate {
    func completeButtonTapped(sender: TaskTableViewCell)
}

class TaskTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    var delegate: DayViewController?
    
    var task: Task? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        taskLabel.text = task?.name
        
        let imageName = (task?.isComplete ?? false) ? "complete" : "incomplete"
        completeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    //MARK: - Actions
    @IBAction func completeButtonTapped(_ sender: Any) {
//        delegate?.completeButtonTapped(sender: self)
    }
}//END OF CLASS
