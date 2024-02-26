////
////  EnableLocationVC.swift
////  WeatherWise
////
////  Created by Johnathan Huijon on 10/23/23.
////
//
//import UIKit
//
//class EnableLocationVC: UIViewController {
//    
//    var maybeCityClass: CityClass = CityClass(city: "Austin", region: "Texas", country: "United States of America", lat: 30.27, lon: -97.74)
//    
//    let backgroundImage = UIImageView()
//    let enableButton = UIButton()
//    let declineButton = UIButton()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureUI()
//    }
//    
//
//    func configureUI() {
//        view.backgroundColor = .clear
//        configureBackgroundImage()
//        configureEnableButton()
//        configureDeclineButton()
//    }
//    
//    func configureBackgroundImage() {
//        backgroundImage.image = UIImage(named: "Day")
//        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(backgroundImage)
//        NSLayoutConstraint.activate([
//            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
//            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//        ])
//    }
//    
//    func modallyPresentToMainVC() {
//        let nextVC = MainVC()
//        nextVC.modalPresentationStyle = .fullScreen
//        present(nextVC, animated: true)
//    }
//    
//    @objc func buttonPressed(_ sender:UIButton) {
//        switch sender {
//            
//        case enableButton:
//            let vc = SingularWeatherPageVC()
//            vc.enableLocationDelegate = self
//            vc.locationClass = maybeCityClass
//            present(vc, animated: true)
//            
//        case declineButton:
//            print("Decline Pressed")
//        default:
//            print("Nothing")
//        }
//    }
//    
//    func configureEnableButton() {
//        var config = enableButton.configuration
//        config = .filled()
//        config?.baseBackgroundColor = .white
//        config?.baseForegroundColor = .systemBlue
//        config?.buttonSize = .large
//        config?.image = UIImage(systemName: "location.fill")
//        config?.title = "Enable Location"
//        
//        enableButton.configuration = config
//        enableButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
//        enableButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(enableButton)
//        NSLayoutConstraint.activate([
//            enableButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110),
//            enableButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            enableButton.heightAnchor.constraint(equalToConstant: 70),
//            enableButton.widthAnchor.constraint(equalToConstant: 275)
//        ])
//    }
//    
//    func configureDeclineButton() {
//        var config = declineButton.configuration
//        config = .filled()
//        config?.baseBackgroundColor = .systemRed
//        config?.baseForegroundColor = .white
//        config?.buttonSize = .medium
//        config?.image = UIImage(systemName: "location.slash.fill")
//        config?.title = "Maybe Later"
//        
//        declineButton.configuration = config
//        declineButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(declineButton)
//        NSLayoutConstraint.activate([
//            declineButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            declineButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            declineButton.heightAnchor.constraint(equalToConstant: 50),
//            declineButton.widthAnchor.constraint(equalToConstant: 150)
//        ])
//    }
//
//}
