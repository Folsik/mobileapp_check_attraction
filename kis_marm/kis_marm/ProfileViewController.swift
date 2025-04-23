import UIKit

class ProfileViewController: UIViewController {
    
    private let profileCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profilePhoto")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Иванов Иван Иванович"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "user.email@mos.ru"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let myDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Мои данные", for: .normal)
        button.setImage(UIImage(systemName: "person"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(myDataButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let helpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Помощь", for: .normal)
        button.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(helpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выйти", for: .normal)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.left"), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = "Профиль"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        
        
        view.addSubview(profileCardView)
        profileCardView.addSubview(profileImageView)
        profileCardView.addSubview(nameLabel)
        profileCardView.addSubview(emailLabel)
        view.addSubview(myDataButton)
        view.addSubview(helpButton)
        view.addSubview(logoutButton)
        
        
        NSLayoutConstraint.activate([
            profileCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileCardView.heightAnchor.constraint(equalToConstant: 100),
            
            profileImageView.centerYAnchor.constraint(equalTo: profileCardView.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: profileCardView.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: profileCardView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: profileCardView.trailingAnchor, constant: -16),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            myDataButton.topAnchor.constraint(equalTo: profileCardView.bottomAnchor, constant: 32),
            myDataButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            myDataButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            myDataButton.heightAnchor.constraint(equalToConstant: 50),
            
            helpButton.topAnchor.constraint(equalTo: myDataButton.bottomAnchor, constant: 16),
            helpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            helpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            helpButton.heightAnchor.constraint(equalToConstant: 50),
            
            logoutButton.topAnchor.constraint(equalTo: helpButton.bottomAnchor, constant: 16),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func myDataButtonTapped() {
        let myDataVC = MyDataViewController()
        navigationController?.pushViewController(myDataVC, animated: true)
    }
    
    @objc private func helpButtonTapped() {
        let helpVC = HelpViewController()
        navigationController?.pushViewController(helpVC, animated: true)
    }
    
    @objc private func logoutButtonTapped() {
        dismiss(animated: true, completion: nil) // Логика выхода
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
