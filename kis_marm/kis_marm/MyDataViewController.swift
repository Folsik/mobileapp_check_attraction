import UIKit

class MyDataViewController: UIViewController {
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "ФИО"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fullNameTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Иванов Иван Иванович"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Логин"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginTextField: UITextField = {
        let textField = UITextField()
        textField.text = "user.email@mos.ru"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let innLabel: UILabel = {
        let label = UILabel()
        label.text = "ИНН"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let innTextField: UITextField = {
        let textField = UITextField()
        textField.text = "778463421562"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let organizationLabel: UILabel = {
        let label = UILabel()
        label.text = "Организация"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let organizationTextField: UITextField = {
        let textField = UITextField()
        textField.text = "УО «Рога и копыта»"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.text = "Должность"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let positionTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Инспектор"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = "Мои данные"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        
        view.addSubview(fullNameLabel)
        view.addSubview(fullNameTextField)
        view.addSubview(loginLabel)
        view.addSubview(loginTextField)
        view.addSubview(innLabel)
        view.addSubview(innTextField)
        view.addSubview(organizationLabel)
        view.addSubview(organizationTextField)
        view.addSubview(positionLabel)
        view.addSubview(positionTextField)
        
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            fullNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fullNameTextField.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8),
            fullNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fullNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            loginLabel.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: 16),
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            innLabel.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 16),
            innLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            innTextField.topAnchor.constraint(equalTo: innLabel.bottomAnchor, constant: 8),
            innTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            innTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            organizationLabel.topAnchor.constraint(equalTo: innTextField.bottomAnchor, constant: 16),
            organizationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            organizationTextField.topAnchor.constraint(equalTo: organizationLabel.bottomAnchor, constant: 8),
            organizationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            organizationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            positionLabel.topAnchor.constraint(equalTo: organizationTextField.bottomAnchor, constant: 16),
            positionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            positionTextField.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 8),
            positionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            positionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
