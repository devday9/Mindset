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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    var image: UIImage?
    var viewsLaidOut = false
    var day: Day?
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.dataSource = self
        taskTableView.delegate = self
        addObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewsLaidOut == false {
            setupViews()
            viewsLaidOut = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        setupBodyTextView()
        setupContainerView()
        setupTaskTableView()
        setupDayNumberLabel()
        setupBackgroundColor()
        dismissKeyboard()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardWillAppear(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentOffset = CGPoint(x: 0, y: keyboardSize.height)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    //MARK: - Views
    func setupBodyTextView() {
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
    }
    
    func setupContainerView() {
        containerView.addAccentBorder()
        containerView.contentMode = .scaleToFill
        containerView.layer.cornerRadius = 32
        containerView.clipsToBounds = true
    }
    
    func setupTaskTableView() {
        taskTableView.backgroundColor = .white
        taskTableView.isScrollEnabled = false
    }
    
    func setupDayNumberLabel() {
        guard let day = day else
        { return }
        
        dayNumberLabel.text = "Day \(day.dayNumber)"
    }
    
    func setupBackgroundColor() {
        view.backgroundColor = .white
    }
    
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
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
    }
}//END OF EXTENSION

extension DayViewController: UITableViewDelegate, UITableViewDataSource {
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return self.view.frame.height / 22
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.shared.tasks.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        
//        cell.delegate = self
        
        guard let day = ChallengeController.shared.currentChallenge?.days[indexPath.row] else { return UITableViewCell() }
        
        cell.index = indexPath.row
        cell.day = day
        
        return cell
    }
}//END OF EXTENSION

//extension DayViewController: TaskCellDelegate {
//    func completeButtonTapped(sender: TaskTableViewCell) {
//        guard let task = sender.task else { return }
//        TaskController.shared.toggleComplete(task: task)
//
//        sender.task = task
//    }
//}//END OF EXTENSION
