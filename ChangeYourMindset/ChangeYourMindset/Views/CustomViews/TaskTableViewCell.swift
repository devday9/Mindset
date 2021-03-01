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
    
    //    weak var delegate: DayViewController?
    
    var index: Int?
    var day: Day? {
        didSet {
            updateViews()
            setupViews()
        }
    }
    
    func updateViews() {
        guard let day = day, let index = index, let challenge = ChallengeController.shared.currentChallenge
        else { return }
        
        taskLabel.text = challenge.tasks[index]
        if day.tasksCompleted[index] {
            taskLabel.textColor = .red
        } else {
            taskLabel.textColor = .black
        }
        
        let imageName = day.tasksCompleted[index] ? "complete" : "incomplete"
        DispatchQueue.main.async {
            self.completeButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    //MARK: - Actions
    @IBAction func completeButtonTapped(_ sender: Any) {
        taskComplete()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        self.backgroundColor = .white
    }
    
    func taskComplete() {
        guard let day = day, let index = index, let challenge = ChallengeController.shared.currentChallenge else { return }
        
        day.tasksCompleted[index] = !day.tasksCompleted[index]
        
        DayController.shared.update(day) { (result) in
            switch result {
            case .success(_):
                if day.tasksCompleted[index] {
                    DispatchQueue.main.async {
                        self.taskLabel.textColor = .red
                        self.updateViews()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.updateViews()
                        self.backgroundColor = .white
                        self.taskLabel.textColor = .black
                    }
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
}//END OF CLASS
