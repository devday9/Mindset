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
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = enterPasswordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text,
              password == confirmPassword else { return }
        
        UserController.shared.createUser(username: username, profilePhoto: image) { (result) in
            switch result {
            case .success(_):
                self.presentOverviewVC()
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        toggleToLogIn()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        toggleToSignUp()
    }
    
    //MARK: - Helper Functions
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
        self.enterPasswordTextField.isSecureTextEntry = true
        self.confirmPasswordTextField.isSecureTextEntry = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPickerVC" {
            let destinationVC = segue.destination as? PhotoPickerViewController
            destinationVC?.delegate = self
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
}//END OF CLASS

//MARK: - Extensions
extension SignUpLoginViewController: PhotoSelectorDelegate {
    func photoPickerSelected(image: UIImage) {
        self.image = image
    }
}//END OF EXTENSION
