import UIKit

class HelpViewController: UIViewController {
    
    private let faqLabel: UILabel = {
        let label = UILabel()
        label.text = "Ответы на частые вопросы"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let faq1Label: UILabel = {
        let label = UILabel()
        label.text = "1. Возможны проблемы с авторизацией, проверьте корректность эл. почты, используемой для входа."
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let faq2Label: UILabel = {
        let label = UILabel()
        label.text = "2. На текущий день нет заданий для осмотра."
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let supportLabel: UILabel = {
        let label = UILabel()
        label.text = "Служба поддержки: help-mamr@it.mos.ru"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Телефон: +7(495) 080-85-83"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contactButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Написать в поддержку", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(HelpViewController.self, action: #selector(contactButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = "Помощь"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        
        view.addSubview(faqLabel)
        view.addSubview(faq1Label)
        view.addSubview(faq2Label)
        view.addSubview(supportLabel)
        view.addSubview(phoneLabel)
        view.addSubview(contactButton)
        
        NSLayoutConstraint.activate([
            faqLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            faqLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            faqLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            faq1Label.topAnchor.constraint(equalTo: faqLabel.bottomAnchor, constant: 16),
            faq1Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            faq1Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            faq2Label.topAnchor.constraint(equalTo: faq1Label.bottomAnchor, constant: 8),
            faq2Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            faq2Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            supportLabel.topAnchor.constraint(equalTo: faq2Label.bottomAnchor, constant: 32),
            supportLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            phoneLabel.topAnchor.constraint(equalTo: supportLabel.bottomAnchor, constant: 8),
            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            contactButton.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 32),
            contactButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contactButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contactButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    @objc private func contactButtonTapped() {
        let alert = UIAlertController(title: "Сообщение", message: "Функция в разработке", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
