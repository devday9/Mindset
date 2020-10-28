//
//  SignUpLoginViewController.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/27/20.
//

import UIKit

class SignUpLoginViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var enterPasswordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var createUserButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    //MARK: - Properties
    var image: UIImage?
    var viewsLaidOut = false
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchUser()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewsLaidOut == false {
            setupViews()
            viewsLaidOut = true
        }
    }
    
    //MARK: - Actions
    @IBAction func createUserButtonTapped(_ sender: Any) {
        
    }
    @IBAction func logInButtonTapped(_ sender: Any) {
        toggleToLogIn()
    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        toggleToSignUp()
    }
    
    //MARK: - Helper Functions
//    func fetchUser() {
//        UserController.shared.fetchUser { (result) in
//            switch result {
//            case .success(_):
//                self.present
//            case .failure(_):
//                <#code#>
//            }
//        }
//    }
    
    func setupViews() {
        self.view.backgroundColor = .lightGray
        containerView.clipsToBounds = true
        containerView.addCornerRadius(radius: containerView.frame.height / 2)
        loginButton.rotate()
        signUpButton.rotate()
        signUpButton.tintColor = .white
        loginButton.tintColor = .white
        usernameTextField.addAccentBorder()
        enterPasswordTextField.addAccentBorder()
        confirmPasswordTextField.addAccentBorder()
    }
    
    func toggleToLogIn() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.confirmPasswordTextField.isHidden = true
                self.containerView.isHidden = true
                self.loginButton.tintColor = .white
                self.signUpButton.tintColor = .gray
                self.createUserButton.setTitle("Log Me In!", for: .normal)
                self.usernameTextField.text = UserController.shared.currentUser?.username
            }
        }
    }
    
    func toggleToSignUp() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.confirmPasswordTextField.isHidden = false
                self.containerView.isHidden = false
                self.loginButton.tintColor = .gray
                self.signUpButton.tintColor = .white
                self.createUserButton.setTitle("Sign Me Up!", for: .normal)
                self.usernameTextField.text = ""
            }
        }
    }
    
    func presentOverviewVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Overview", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPickerVC" {
            let destinationVC = segue.destination as? PhotoPickerViewController
            destinationVC?.delegate = self
        }
    }
    
}//END OF CLASS

//MARK: - Extensions
extension SignUpLoginViewController: PhotoSelectorDelegate {
    func photoPickerSelected(image: UIImage) {
        self.image = image
    }
}//END OF EXTENSION
