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
    var SignUpAlertMessage = "Please enter all information to register."
    
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
       createUser()
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        toggleToLogIn()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        toggleToSignUp()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        setupConfirmPasswordTextField()
        setupViewBackgroundColor()
        setupPasswordTextField()
        setupCreateUserButton()
        setupContainerView()
        setupNameTextField()
        setupSignUpButton()
        setupLoginButton()
        dismissKeyboard()
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
    
    func createUser() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = enterPasswordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text,
              password == confirmPassword else {
            alertUserSignUpError()
            return
        }
        
        guard password.count >= 6 else {
            SignUpAlertMessage = SignUpAlertStrings.passwordCharacterCountKey
            alertUserSignUpError()
            return
        }
        
        UserController.shared.createUser(username: username, profilePhoto: image) { (result) in
            switch result {
            case .success(_):
                self.presentOverviewVC()
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    //MARK: - Views
    func setupNameTextField(){
        usernameTextField.autocapitalizationType = .none
        usernameTextField.returnKeyType = .continue
        usernameTextField.autocorrectionType = .no
        usernameTextField.layer.cornerRadius = 5
        usernameTextField.addAccentBorder()
    }
    
    func setupPasswordTextField(){
        enterPasswordTextField.autocapitalizationType = .none
        enterPasswordTextField.returnKeyType = .continue
        enterPasswordTextField.autocorrectionType = .no
        enterPasswordTextField.isSecureTextEntry = true
        enterPasswordTextField.layer.cornerRadius = 5
        enterPasswordTextField.addAccentBorder()
    }
    
    func setupConfirmPasswordTextField(){
        confirmPasswordTextField.autocapitalizationType = .none
        confirmPasswordTextField.autocorrectionType = .no
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.layer.cornerRadius = 5
        confirmPasswordTextField.returnKeyType = .done
        confirmPasswordTextField.addAccentBorder()
    }
    
    func setupCreateUserButton() {
        createUserButton.backgroundColor = .darkGray
        createUserButton.layer.cornerRadius = 5
        createUserButton.tintColor = .red
        createUserButton.addAccentBorder()
    }
    
    func setupSignUpButton() {
        signUpButton.tintColor = .white
        signUpButton.rotate()
    }
    
    func setupLoginButton() {
        loginButton.tintColor = .white
        loginButton.rotate()
    }
    
    func setupContainerView() {
        containerView.addCornerRadius(radius: containerView.frame.height / 2)
        containerView.clipsToBounds = true
    }
    
    func setupViewBackgroundColor() {
        view.backgroundColor = .lightGray
    }
    
    func dismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Navigation
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
