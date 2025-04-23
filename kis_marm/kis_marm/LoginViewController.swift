import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mosLogo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Получать задания, отслеживать прогресс, и получать оценки теперь проще"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let mosLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "buildingBackground")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Version 0.0.1"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        
        view.addSubview(backgroundImageView)
        view.addSubview(containerView)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(loginButton)
        containerView.addSubview(mosLogoImageView)
        containerView.addSubview(versionLabel)
        
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            
            descriptionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            
            loginButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            
            
            mosLogoImageView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8),
            mosLogoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            mosLogoImageView.heightAnchor.constraint(equalToConstant: 20),
            mosLogoImageView.widthAnchor.constraint(equalToConstant: 60),
            
            
            versionLabel.topAnchor.constraint(equalTo: mosLogoImageView.bottomAnchor, constant: 8),
            versionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        let pinVC = PinEntryViewController()
        navigationController?.pushViewController(pinVC, animated: true)
    }
}

