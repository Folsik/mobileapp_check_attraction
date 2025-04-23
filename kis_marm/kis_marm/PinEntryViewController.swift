import UIKit
import LocalAuthentication

class PinEntryViewController: UIViewController {
    
    // Элементы интерфейса
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pinDotsView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let keypadStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let forgotPinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Забыли PIN?", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var pin: String = ""
    private let pinLength = 4
    private var isSettingPin: Bool = false
    private var faceIDButton: UIButton? // Ссылка на кнопку Face ID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPinDots()
        setupKeypad()
        
        // Проверяем, установлен ли PIN
        let isPinSet = UserDefaults.standard.bool(forKey: "isPinSet")
        isSettingPin = !isPinSet
        if isPinSet {
            instructionLabel.text = "Введите PIN-код для быстрого доступа в приложение"
        } else {
            instructionLabel.text = "Установите PIN-код для быстрого доступа в приложение"
        }
        
        // Показываем кнопку Face ID только если она активирована
        let isFaceIDEnabled = UserDefaults.standard.bool(forKey: "isFaceIDEnabled")
        faceIDButton?.isHidden = !isFaceIDEnabled
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let isPinSet = UserDefaults.standard.bool(forKey: "isPinSet")
        let isFaceIDEnabled = UserDefaults.standard.bool(forKey: "isFaceIDEnabled")
        if isPinSet && isFaceIDEnabled {
            authenticateWithFaceID()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(instructionLabel)
        view.addSubview(pinDotsView)
        view.addSubview(keypadStackView)
        view.addSubview(forgotPinButton)
        
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            pinDotsView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 32),
            pinDotsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            keypadStackView.topAnchor.constraint(equalTo: pinDotsView.bottomAnchor, constant: 32),
            keypadStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            forgotPinButton.topAnchor.constraint(equalTo: keypadStackView.bottomAnchor, constant: 16),
            forgotPinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        forgotPinButton.addTarget(self, action: #selector(forgotPinButtonTapped), for: .touchUpInside)
    }
    
    private func setupPinDots() {
        for _ in 0..<pinLength {
            let dot = UIView()
            dot.backgroundColor = .lightGray
            dot.layer.cornerRadius = 8
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: 16).isActive = true
            dot.heightAnchor.constraint(equalToConstant: 16).isActive = true
            pinDotsView.addArrangedSubview(dot)
        }
    }
    
    private func setupKeypad() {
        let buttonTitles = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "FaceID", "0", "⌫"]
        var rowStackView: UIStackView?
        
        for (index, title) in buttonTitles.enumerated() {
            if index % 3 == 0 {
                rowStackView = UIStackView()
                rowStackView?.axis = .horizontal
                rowStackView?.spacing = 16
                keypadStackView.addArrangedSubview(rowStackView!)
            }
            
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 80).isActive = true
            button.heightAnchor.constraint(equalToConstant: 80).isActive = true
            button.backgroundColor = .systemGray6
            button.layer.cornerRadius = 40
            
            if title == "FaceID" {
                if let faceIDImage = UIImage(systemName: "faceid") {
                    button.setImage(faceIDImage, for: .normal)
                    button.tintColor = .black
                    button.imageView?.contentMode = .scaleAspectFit
                }
                updateFaceIDButtonIcon(button: button)
                button.addTarget(self, action: #selector(faceIDButtonTapped), for: .touchUpInside)
                faceIDButton = button // Сохраняем ссылку на кнопку
            } else {
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 24)
                button.setTitleColor(.black, for: .normal)
                
                if title == "⌫" {
                    button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
                } else if title != "" {
                    button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
                }
            }
            
            rowStackView?.addArrangedSubview(button)
        }
    }
    
    private func updateFaceIDButtonIcon(button: UIButton) {
        let context = LAContext()
        if context.biometryType == .faceID {
            button.setImage(UIImage(systemName: "faceid"), for: .normal)
        } else if context.biometryType == .touchID {
            button.setImage(UIImage(systemName: "touchid"), for: .normal)
        } else {
            button.isEnabled = false
        }
    }
    
    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard pin.count < pinLength, let number = sender.titleLabel?.text else { return }
        pin += number
        updatePinDots()
        
        if pin.count == pinLength {
            checkPin()
        }
    }
    
    @objc private func deleteButtonTapped() {
        guard !pin.isEmpty else { return }
        pin.removeLast()
        updatePinDots()
    }
    
    @objc private func forgotPinButtonTapped() {
        UserDefaults.standard.set(false, forKey: "isPinSet")
        instructionLabel.text = "Установите новый PIN-код"
        isSettingPin = true
        pin = ""
        updatePinDots()
        
        let alert = UIAlertController(title: "PIN-код сброшен", message: "Установите новый PIN-код.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func faceIDButtonTapped() {
        authenticateWithFaceID()
    }
    
    private func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Используйте Face ID для входа в приложение"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        let homeVC = HomeViewController()
                        self.navigationController?.pushViewController(homeVC, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Ошибка", message: "Face ID не сработал. Введите PIN-код.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Face ID недоступен", message: "Ваше устройство не поддерживает Face ID или биометрия не настроена.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    private func updatePinDots() {
        for (index, dot) in pinDotsView.arrangedSubviews.enumerated() {
            dot.backgroundColor = index < pin.count ? .black : .lightGray
        }
    }
    
    private func checkPin() {
        if isSettingPin {
            // Устанавливаем новый PIN-код
            UserDefaults.standard.set(pin, forKey: "pinCode")
            UserDefaults.standard.set(true, forKey: "isPinSet")
            
            // Показываем предложение активировать Face ID
            let alert = UIAlertController(title: "PIN-код установлен", message: "Хотите активировать Face ID для быстрого входа?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { _ in
                UserDefaults.standard.set(true, forKey: "isFaceIDEnabled")
                let homeVC = HomeViewController()
                self.navigationController?.pushViewController(homeVC, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: { _ in
                let homeVC = HomeViewController()
                self.navigationController?.pushViewController(homeVC, animated: true)
            }))
            present(alert, animated: true)
        } else {
            // Проверяем введенный PIN-код
            let savedPin = UserDefaults.standard.string(forKey: "pinCode")
            if pin == savedPin {
                let homeVC = HomeViewController()
                navigationController?.pushViewController(homeVC, animated: true)
            } else {
                showInvalidPinAnimation()
            }
        }
    }
    
    private func showInvalidPinAnimation() {
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shakeAnimation.values = [-10, 10, -10, 10, 0]
        shakeAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        shakeAnimation.duration = 0.4
        keypadStackView.layer.add(shakeAnimation, forKey: "shake")
        
        for dot in pinDotsView.arrangedSubviews {
            dot.backgroundColor = .red
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.pin = ""
            self.updatePinDots()
        }
    }
}
