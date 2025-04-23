import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    // MARK: - UI элементы
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profilePhoto") // Замените на ваше изображение
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Задания", "Карта"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск по названию"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TaskCell.self, forCellWithReuseIdentifier: "TaskCell")
        return collectionView
    }()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isHidden = true
        mapView.showsUserLocation = true // Показываем местоположение пользователя
        return mapView
    }()
    
    private let bottomNavigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let navigationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Данные
    private var tasks: [Task] = []
    private var filteredTasks: [Task] = []
    private let locationManager = CLLocationManager()
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        mapView.delegate = self
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        loadTasks()
    }
    
    // MARK: - Настройка интерфейса
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(profileImageView)
        view.addSubview(notificationButton)
        view.addSubview(segmentedControl)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(mapView)
        view.addSubview(bottomNavigationView)
        bottomNavigationView.addSubview(navigationStackView)
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(profileTap)
        
        notificationButton.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        
        setupBottomNavigation()
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            notificationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            notificationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            notificationButton.widthAnchor.constraint(equalToConstant: 24),
            notificationButton.heightAnchor.constraint(equalToConstant: 24),
            
            segmentedControl.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomNavigationView.topAnchor),
            
            mapView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomNavigationView.topAnchor),
            
            bottomNavigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomNavigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomNavigationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomNavigationView.heightAnchor.constraint(equalToConstant: 60),
            
            navigationStackView.topAnchor.constraint(equalTo: bottomNavigationView.topAnchor, constant: 8),
            navigationStackView.leadingAnchor.constraint(equalTo: bottomNavigationView.leadingAnchor, constant: 16),
            navigationStackView.trailingAnchor.constraint(equalTo: bottomNavigationView.trailingAnchor, constant: -16),
            navigationStackView.bottomAnchor.constraint(equalTo: bottomNavigationView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Настройка геолокации
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation() // Останавливаем обновление, чтобы не центрировать карту постоянно
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка геолокации: \(error.localizedDescription)")
        showAlert(message: "Не удалось получить ваше местоположение.")
    }
    
    // MARK: - Настройка карты
    private func setupMapView() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        let tasksToShowOnMap = tasks.filter { $0.status == "В работе" || $0.status == "Новое" }
        
        if let firstTask = tasksToShowOnMap.first {
            let coordinate = CLLocationCoordinate2D(latitude: firstTask.latitude, longitude: firstTask.longitude)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
        
        for task in tasksToShowOnMap {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: task.latitude, longitude: task.longitude)
            annotation.title = task.title
            annotation.subtitle = task.address
            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: - Настройка нижней навигации
    private func setupBottomNavigation() {
        let buttonData: [(iconName: String, title: String)] = [
            ("house.fill", "Главная"),
            ("doc.text", "Задания"),
            ("square.grid.2x2", "Все объекты"),
            ("clock", "История")
        ]
        
        for (index, data) in buttonData.enumerated() {
            var configuration = UIButton.Configuration.plain()
            
            if let image = UIImage(systemName: data.iconName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15)) {
                configuration.image = image
            } else {
                configuration.image = UIImage(systemName: "questionmark.circle")
            }
            
            configuration.title = data.title
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.foregroundColor = .black
                outgoing.font = .systemFont(ofSize: 12)
                return outgoing
            }
            
            configuration.imagePlacement = .top
            configuration.imagePadding = 6
            
            let button = UIButton(configuration: configuration, primaryAction: nil)
            button.tag = index
            button.addTarget(self, action: #selector(navigationButtonTapped(_:)), for: .touchUpInside)
            navigationStackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Загрузка задач из API
    private func loadTasks() {
        // Заглушка для тестов
        tasks = [
            Task(id: 123, title: "Задача 1", address: "ул. Примерная, 1", status: "Новое", date: "01.01.2025", latitude: 55.7558, longitude: 37.6173),
            Task(id: 456, title: "Задача 2", address: "ул. Примерная, 2", status: "В работе", date: "02.01.2025", latitude: 55.7559, longitude: 37.6174),
            Task(id: 789, title: "Задача 3", address: "ул. Примерная, 3", status: "Завершено", date: "03.01.2025", latitude: 55.7560, longitude: 37.6175)
        ]
        filteredTasks = tasks
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.setupMapView()
        }
        
        // Реальный запрос к API
        guard let url = URL(string: "https://api.example.com/tasks") else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("Ошибка загрузки задач: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            
            do {
                let tasks = try JSONDecoder().decode([Task].self, from: data)
                DispatchQueue.main.async {
                    self.tasks = tasks
                    self.filteredTasks = tasks
                    self.collectionView.reloadData()
                    self.setupMapView()
                }
            } catch {
                print("Ошибка парсинга JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // MARK: - Построение маршрута
    private func buildRoute(to destinationCoordinate: CLLocationCoordinate2D) {
        guard let userLocation = locationManager.location?.coordinate else {
            showAlert(message: "Не удалось определить ваше местоположение.")
            return
        }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.transportType = .automobile
        
        mapView.removeOverlays(mapView.overlays)
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(message: "Ошибка построения маршрута: \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else { return }
            
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
        }
    }
    
    // MARK: - Обработчики событий
    @objc private func profileImageTapped() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc private func notificationButtonTapped() {
        let alert = UIAlertController(title: "Уведомления", message: "Здесь будут ваши уведомления", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // Задания
            collectionView.isHidden = false
            mapView.isHidden = true
        case 1: // Карта
            collectionView.isHidden = true
            mapView.isHidden = false
            setupMapView()
        default:
            break
        }
    }
    
    @objc private func navigationButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0: print("Нажата иконка Главная")
        case 1: print("Нажата иконка Задания")
        case 2: print("Нажата иконка Все объекты")
        case 3: print("Нажата иконка История")
        default: break
        }
    }
    
    // MARK: - Фильтрация задач
    private func filterTasks(with searchText: String) {
        if searchText.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }
    
    // MARK: - Вспомогательные методы
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Не применяем кастомизацию для аннотации пользователя
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "TaskAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let routeButton = UIButton(type: .detailDisclosure)
            routeButton.addTarget(self, action: #selector(buildRouteFromCallout(_:)), for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = routeButton
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    @objc private func buildRouteFromCallout(_ sender: UIButton) {
        guard let selectedAnnotation = mapView.selectedAnnotations.first,
              let task = tasks.first(where: { $0.title == selectedAnnotation.title }) else { return }
        
        buildRoute(to: CLLocationCoordinate2D(latitude: task.latitude, longitude: task.longitude))
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    // MARK: - UICollectionViewDataSource и Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.configure(with: filteredTasks[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 32, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let taskDetailVC = TaskDetailViewController(task: filteredTasks[indexPath.item])
        navigationController?.pushViewController(taskDetailVC, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTasks(with: searchText)
    }
}
