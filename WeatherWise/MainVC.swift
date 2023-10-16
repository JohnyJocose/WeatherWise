//
//  ViewController.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 9/25/23.
//

import UIKit

// This file will be the home screen where the weather is displayed for the user's current location and any other locations they choose to add

class MainVC: UIViewController {
    
    // scrollView that will contain weather information pages, and allow for vertical scrolling in them
    let scrollView = UIScrollView()
    
    // Main Screen UI Elements
    var oldPageTracker: Int = 0
    let backgroundImage = UIImageView()
    let weatherPageControl = UIPageControl()
    let toolBar = UIToolbar()
    
    // WeatherPage UIElements
    
    
    // Data
    let locationList = ["My Location - Del Valle, Texas", "Austin, Texas", "New York City, New York", "Modesto, California" , "Nnewi, Nigeria", "Orlando, Florida"]
    let imageFileNames = ["Day", "Night", "Sunrise", "Sunset"]
    let hourlyForcastData = [
        ["Now", "78°", UIImage(systemName: "moon.fill")!],
        ["1AM", "78°", UIImage(systemName: "moon.fill")!],
        ["2AM", "77°", UIImage(systemName: "moon.fill")!],
        ["3AM", "75°", UIImage(systemName: "moon.fill")!],
        ["4AM", "73°", UIImage(systemName: "moon.fill")!],
        ["5AM", "72°", UIImage(systemName: "moon.fill")!],
        ["6AM", "71°", UIImage(systemName: "sun.max.fill")!],
        ["7AM", "71°", UIImage(systemName: "sun.max.fill")!],
        ["8AM", "72°", UIImage(systemName: "sun.max.fill")!],
        ["9AM", "76°", UIImage(systemName: "sun.max.fill")!],
        ["10AM", "80°", UIImage(systemName: "sun.max.fill")!],
        ["11AM", "84°", UIImage(systemName: "sun.max.fill")!],
        ["12PM", "87°", UIImage(systemName: "sun.max.fill")!],
        ["1PM", "90°", UIImage(systemName: "sun.max.fill")!],
        ["2PM", "92°", UIImage(systemName: "sun.max.fill")!],
        ["3PM", "93°", UIImage(systemName: "sun.max.fill")!],
        ["4PM", "94°", UIImage(systemName: "sun.max.fill")!],
        ["5PM", "93°", UIImage(systemName: "sun.max.fill")!],
        ["6PM", "92°", UIImage(systemName: "sun.max.fill")!],
        ["7PM", "89°", UIImage(systemName: "moon.fill")!],
        ["8PM", "85°", UIImage(systemName: "moon.fill")!],
        ["9PM", "82°", UIImage(systemName: "moon.fill")!],
        ["10PM", "80°", UIImage(systemName: "moon.fill")!],
        ["11PM", "78°", UIImage(systemName: "moon.fill")!],
        ]
    
    
    let tenDayForcastData = [
        ["Today", "L:80° H:105°", UIImage(systemName: "sun.max.fill")!],
        ["Monday", "L:83° H:107°", UIImage(systemName: "sun.max.fill")!],
        ["Tuesday", "L:85° H:108°", UIImage(systemName: "cloud.sun")!],
        ["Wednesday", "L:83° H:106°", UIImage(systemName: "cloud.sun")!],
        ["Thursday", "L:82° H:104°", UIImage(systemName: "cloud.sun")!],
        ["Friday", "L:79° H:100°", UIImage(systemName: "cloud.sun.rain")!],
        ["Saturday", "L:68° H:99°", UIImage(systemName: "cloud.sun.rain")!],
        ["Sunday", "L:67° H:89°", UIImage(systemName: "cloud.sun.bolt.fill")!],
        ["Monday", "L:75° H:96°", UIImage(systemName: "cloud.sun.rain")!],
        ["Tuesday", "L:80° H:104°", UIImage(systemName: "cloud.sun")!],
        ]

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        let imageName = imageFileNames.randomElement()
        setBackgroundColor(imageName: imageName!)
        configureScrollView(locations: locationList.count)
        configureToolBar(imageName: imageName!)
        makeAndConfigureWeatherViews(locations: locationList.count)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let nextVC = UINavigationController(rootViewController: LocationVC())
        nextVC.navigationBar.prefersLargeTitles = true
        
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }
    
    func matchBackgroundToLocation() {
        let imageName = imageFileNames.randomElement()
        let newImage = UIImage(named: imageName!)
        UIView.transition(with: self.backgroundImage,
                      duration:0.5,
                      options: .transitionCrossDissolve,
                      animations: { self.backgroundImage.image = newImage },
                      completion: nil)
        UIView.transition(with: self.toolBar,
                      duration:0.5,
                      options: .transitionCrossDissolve,
                      animations: { switch imageName {
                      case "Day":
                          self.toolBar.barTintColor = UIColor(red: 76/255.0, green: 156/255.0, blue: 169/255.0, alpha: 1)
                      case "Night":
                          self.toolBar.barTintColor = UIColor(red: 13/255.0, green: 14/255.0, blue: 17/255.0, alpha: 1)
                      case "Sunrise":
                          self.toolBar.barTintColor = UIColor(red: 14/255.0, green: 45/255.0, blue: 79/255.0, alpha: 1)
                      case "Sunset":
                          self.toolBar.barTintColor = UIColor(red: 25/255.0, green: 56/255.0, blue: 87/255.0, alpha: 1)
                      default:
                          self.toolBar.barTintColor = UIColor(red: 50/255.0, green: 114/255.0, blue: 144/255.0, alpha: 1)
                      }},
                      completion: nil)
    }
    
    // Move the scroll view to the position corresponding to the selected page.
    @objc func pageControlChanged(_ sender:UIPageControl) {
        let currentPage = sender.currentPage
        scrollView.setContentOffset(.init(x: CGFloat(currentPage) * view.frame.width, y: 0), animated: false)
        matchBackgroundToLocation()
    }
    
    
    // configure each topic views content
    func configureViewsContents(dayForecast: UIView, tenDayForcast: UIView, humidity: UIView, feelsLike: UIView, moonPhase: UIView, sunsetTime: UIView) {
        configureDayForecast(dayForecastView: dayForecast)
        configureTenDayForecast(tenDayForecastView: tenDayForcast)
        configureHumidity(humidityView: humidity)
        configureFeelsLike(feelsLikeView: feelsLike)
        configureMoonPhase(moonPhaseView: moonPhase)
        configureSunset(sunsetView: sunsetTime)
        
    }
    
    func configureSunset(sunsetView: UIView) {
        
        let sunsetTimeLabel = UILabel()
        sunsetTimeLabel.text = "12:59 PM"
        sunsetTimeLabel.font = .boldSystemFont(ofSize: 35)
        sunsetTimeLabel.textColor = .black
        sunsetTimeLabel.numberOfLines = 1
        sunsetTimeLabel.textAlignment = .center
        sunsetTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sunsetView.addSubview(sunsetTimeLabel)
        NSLayoutConstraint.activate([
            sunsetTimeLabel.topAnchor.constraint(equalTo: sunsetView.topAnchor),
            sunsetTimeLabel.bottomAnchor.constraint(equalTo: sunsetView.bottomAnchor),
            sunsetTimeLabel.leadingAnchor.constraint(equalTo: sunsetView.leadingAnchor),
            sunsetTimeLabel.trailingAnchor.constraint(equalTo: sunsetView.trailingAnchor)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = "Sunset"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sunsetView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: sunsetView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: sunsetView.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 29),
            titleLabel.topAnchor.constraint(equalTo: sunsetView.topAnchor, constant: 8)
        ])
    }
    
    func configureMoonPhase(moonPhaseView: UIView) {
        let moonPhaseImageView = UIImageView()
        moonPhaseImageView.image = UIImage(systemName: "moonphase.waxing.gibbous.inverse")
        moonPhaseImageView.contentMode = .scaleAspectFit
        moonPhaseImageView.tintColor = .black
        moonPhaseImageView.translatesAutoresizingMaskIntoConstraints = false
        
        moonPhaseView.addSubview(moonPhaseImageView)
        NSLayoutConstraint.activate([
            moonPhaseImageView.centerXAnchor.constraint(equalTo: moonPhaseView.centerXAnchor),
            moonPhaseImageView.centerYAnchor.constraint(equalTo: moonPhaseView.centerYAnchor),
            moonPhaseImageView.widthAnchor.constraint(equalTo: moonPhaseView.widthAnchor, multiplier: 1/2),
            moonPhaseImageView.heightAnchor.constraint(equalTo: moonPhaseView.widthAnchor, multiplier: 1/2)
        ])
        
        
        let titleLabel = UILabel()
        titleLabel.text = "Moon Phase"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        moonPhaseView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: moonPhaseView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: moonPhaseView.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 29),
            titleLabel.topAnchor.constraint(equalTo: moonPhaseView.topAnchor, constant: 8)
        ])
    }
    
    func configureFeelsLike(feelsLikeView: UIView) {
        let tempLabel = UILabel()
        tempLabel.text = "110°"
        tempLabel.font = .boldSystemFont(ofSize: 35)
        tempLabel.textColor = .black
        tempLabel.numberOfLines = 1
        tempLabel.textAlignment = .center
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        feelsLikeView.addSubview(tempLabel)
        NSLayoutConstraint.activate([
            tempLabel.topAnchor.constraint(equalTo: feelsLikeView.topAnchor),
            tempLabel.bottomAnchor.constraint(equalTo: feelsLikeView.bottomAnchor),
            tempLabel.leadingAnchor.constraint(equalTo: feelsLikeView.leadingAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: feelsLikeView.trailingAnchor)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = "Feels Like"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        feelsLikeView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: feelsLikeView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: feelsLikeView.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 29),
            titleLabel.topAnchor.constraint(equalTo: feelsLikeView.topAnchor, constant: 8)
        ])
    }
    
    func configureHumidity(humidityView: UIView) {
        let humidityLabel = UILabel()
        humidityLabel.text = "50%"
        humidityLabel.font = .boldSystemFont(ofSize: 35)
        humidityLabel.textColor = .black
        humidityLabel.numberOfLines = 1
        humidityLabel.textAlignment = .center
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        humidityView.addSubview(humidityLabel)
        NSLayoutConstraint.activate([
            humidityLabel.topAnchor.constraint(equalTo: humidityView.topAnchor),
            humidityLabel.bottomAnchor.constraint(equalTo: humidityView.bottomAnchor),
            humidityLabel.leadingAnchor.constraint(equalTo: humidityView.leadingAnchor),
            humidityLabel.trailingAnchor.constraint(equalTo: humidityView.trailingAnchor)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = "Humidity"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        humidityView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: humidityView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: humidityView.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 29),
            titleLabel.topAnchor.constraint(equalTo: humidityView.topAnchor, constant: 8)
        ])
    }
    
    func configureTenDayForecast(tenDayForecastView: UIView) {
        let titleLabel = UILabel()
        titleLabel.text = "Ten Day Forecast"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tenDayForecastView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: tenDayForecastView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: tenDayForecastView.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 29),
            titleLabel.topAnchor.constraint(equalTo: tenDayForecastView.topAnchor, constant: 8)
        ])
        
        let tenDayForecastTableView = UITableView()
        tenDayForecastTableView.backgroundColor = .clear
        tenDayForecastTableView.delegate = self
        tenDayForecastTableView.dataSource = self
        tenDayForecastTableView.register(TenDayForecastCell.self, forCellReuseIdentifier: "dayCell")
        tenDayForecastTableView.rowHeight = 40
        tenDayForecastTableView.isScrollEnabled = false
        
        tenDayForecastTableView.translatesAutoresizingMaskIntoConstraints = false
        
        tenDayForecastView.addSubview(tenDayForecastTableView)
        NSLayoutConstraint.activate([
            tenDayForecastTableView.leadingAnchor.constraint(equalTo: tenDayForecastView.leadingAnchor),
            tenDayForecastTableView.trailingAnchor.constraint(equalTo: tenDayForecastView.trailingAnchor),
            tenDayForecastTableView.bottomAnchor.constraint(equalTo: tenDayForecastView.bottomAnchor),
            tenDayForecastTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }
    
    func configureDayForecast(dayForecastView: UIView) {
        
        let titleLabel = UILabel()
        titleLabel.text = "Forecast"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dayForecastView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: dayForecastView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: dayForecastView.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 29),
            titleLabel.topAnchor.constraint(equalTo: dayForecastView.topAnchor, constant: 8)
        ])
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        let hourlyForecastCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        hourlyForecastCollectionView.backgroundColor = .clear
        hourlyForecastCollectionView.delegate = self
        hourlyForecastCollectionView.dataSource = self
        hourlyForecastCollectionView.showsHorizontalScrollIndicator = false
        hourlyForecastCollectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: "hourCell")
        
        hourlyForecastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        dayForecastView.addSubview(hourlyForecastCollectionView)
        NSLayoutConstraint.activate([
            hourlyForecastCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            hourlyForecastCollectionView.bottomAnchor.constraint(equalTo: dayForecastView.bottomAnchor, constant: -8),
            hourlyForecastCollectionView.leadingAnchor.constraint(equalTo: dayForecastView.leadingAnchor),
            hourlyForecastCollectionView.trailingAnchor.constraint(equalTo: dayForecastView.trailingAnchor)
        ])
    }
    
    
    // Set topicViews in each Weatherview code
    func setForecastLabels(pageView: UIView, location: String, temperature: Int, weather: String, high: Int, low: Int) -> UIStackView {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.distribution = .fillProportionally
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        let locationLabel = UILabel()
        locationLabel.text = location
        locationLabel.textAlignment = .center
        locationLabel.numberOfLines = 0
        locationLabel.font = .boldSystemFont(ofSize: 25)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let tempLabel = UILabel()
        tempLabel.text = "\(temperature)°"
        tempLabel.textAlignment = .center
        tempLabel.numberOfLines = 0
        tempLabel.font = .boldSystemFont(ofSize: 40)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let weatherLabel = UILabel()
        weatherLabel.text = weather
        weatherLabel.textAlignment = .center
        weatherLabel.numberOfLines = 0
        weatherLabel.font = .systemFont(ofSize: 25)
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let highLowLabel = UILabel()
        highLowLabel.text = "L:\(low)°  H:\(high)°"
        highLowLabel.textAlignment = .center
        highLowLabel.numberOfLines = 0
        highLowLabel.font = .boldSystemFont(ofSize: 20)
        highLowLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        pageView.addSubview(verticalStack)
        verticalStack.addArrangedSubview(locationLabel)
        verticalStack.addArrangedSubview(tempLabel)
        verticalStack.addArrangedSubview(weatherLabel)
        verticalStack.addArrangedSubview(highLowLabel)
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: pageView.topAnchor, constant: 50),
            verticalStack.leadingAnchor.constraint(equalTo: pageView.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: pageView.trailingAnchor)
        ])
        
        
        return verticalStack
        
    }
    
    
    func setForcastView(pageView: UIView, topUIElement: UIStackView) -> TopicView {
        let forcastView = TopicView()
        pageView.addSubview(forcastView)
        NSLayoutConstraint.activate([
            forcastView.widthAnchor.constraint(equalTo: pageView.widthAnchor, multiplier: 7/8),
            forcastView.heightAnchor.constraint(equalToConstant: 170),
            forcastView.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
            forcastView.topAnchor.constraint(equalTo: topUIElement.bottomAnchor, constant: 40)
        ])
        
        return forcastView
    }
    
    func setTenDayForcastView(pageView: UIView, topUIElement: UIView) -> TopicView {
        let tenDayForcastView = TopicView()
        pageView.addSubview(tenDayForcastView)
        NSLayoutConstraint.activate([
            tenDayForcastView.widthAnchor.constraint(equalTo: pageView.widthAnchor, multiplier: 7/8),
            tenDayForcastView.heightAnchor.constraint(equalToConstant: 437),
            tenDayForcastView.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
            tenDayForcastView.topAnchor.constraint(equalTo: topUIElement.bottomAnchor, constant: 40)
        ])
        
        return tenDayForcastView
    }
    
    func setHumidityAndFeelsLike(pageView: UIView, topUIElement: UIView) -> (TopicView, TopicView) {
        let humidityView = TopicView()
        let feelsLikeView = TopicView()
        pageView.addSubview(humidityView)
        pageView.addSubview(feelsLikeView)
        
        NSLayoutConstraint.activate([
            humidityView.widthAnchor.constraint(equalTo: topUIElement.widthAnchor, multiplier: 15/32),
            humidityView.heightAnchor.constraint(equalTo: topUIElement.widthAnchor, multiplier: 15/32),
            humidityView.leadingAnchor.constraint(equalTo: topUIElement.leadingAnchor),
            humidityView.topAnchor.constraint(equalTo: topUIElement.bottomAnchor, constant: 40),
            
            feelsLikeView.widthAnchor.constraint(equalTo: topUIElement.widthAnchor, multiplier: 15/32),
            feelsLikeView.heightAnchor.constraint(equalTo: topUIElement.widthAnchor, multiplier: 15/32),
            feelsLikeView.trailingAnchor.constraint(equalTo: topUIElement.trailingAnchor),
            feelsLikeView.topAnchor.constraint(equalTo: topUIElement.bottomAnchor, constant: 40)
        ])
        
        
        return (humidityView, feelsLikeView)
        
        
    }
    
    
    func setMoonPhaseAndSunset(pageView: UIView, topLeftUIElement: UIView, topRightUIElement: UIView) -> (TopicView, TopicView) {
        let moonView = TopicView()
        let sunsetView = TopicView()
        pageView.addSubview(moonView)
        pageView.addSubview(sunsetView)
        
        NSLayoutConstraint.activate([
            moonView.widthAnchor.constraint(equalTo: topLeftUIElement.widthAnchor),
            moonView.heightAnchor.constraint(equalTo: topLeftUIElement.heightAnchor),
            moonView.leadingAnchor.constraint(equalTo: topLeftUIElement.leadingAnchor),
            moonView.topAnchor.constraint(equalTo: topLeftUIElement.bottomAnchor, constant: 40),
            moonView.bottomAnchor.constraint(equalTo: pageView.bottomAnchor, constant: -100),
            
            sunsetView.widthAnchor.constraint(equalTo: topRightUIElement.widthAnchor),
            sunsetView.heightAnchor.constraint(equalTo: topRightUIElement.heightAnchor),
            sunsetView.trailingAnchor.constraint(equalTo: topRightUIElement.trailingAnchor),
            sunsetView.topAnchor.constraint(equalTo: topRightUIElement.bottomAnchor, constant: 40),
            sunsetView.bottomAnchor.constraint(equalTo: pageView.bottomAnchor, constant: -100)
        ])
        
        
        return (moonView, sunsetView)
        
        
    }
    
    // UI Code
    func makeAndConfigureWeatherViews(locations: Int) {
        // add a view for each location the user has set to this phone
        var scrollViewsList: [UIScrollView] = []
        for _ in locationList{
            scrollViewsList.append(UIScrollView())
        }
        setWeatherViews(scrolls: scrollViewsList)
    }
    
    func setWeatherViews(scrolls: [UIScrollView]) {
        
        // for loop to add each view into the scrollview
        for pageCount in 0..<scrolls.count {
            // this is up here cause we need scroll to equal this view, we will set the constraints down below
            let weatherView = UIView()
            weatherView.backgroundColor = .clear
            weatherView.translatesAutoresizingMaskIntoConstraints = false
            
            scrolls[pageCount].backgroundColor = .clear
            // this will allow the height of the contentsize to adjust based one what was placed, i just have ot make sure for the top elemnt to be anchor to the top of weatheview and the bottom elements ot be anchor to the bottom of weatherview
            scrolls[pageCount].contentSize = .init(width: view.frame.width, height: weatherView.frame.height)
            scrolls[pageCount].showsVerticalScrollIndicator = false
            scrolls[pageCount].translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(scrolls[pageCount])
            
            switch pageCount {
            case 0:
                // Add the first screen to the scroll view; the leading anchor should be aligned with the scroll views leading anchor
                NSLayoutConstraint.activate([
                    scrolls[pageCount].widthAnchor.constraint(equalToConstant: view.frame.width),
                    scrolls[pageCount].heightAnchor.constraint(equalToConstant: scrollView.contentSize.height),
                    scrolls[pageCount].leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
                ])
                // Anyhting in the middle of the list after first and before last will have their leading anchor to the trailing anchor of the previous view
            case 1..<scrolls.count-1:
                NSLayoutConstraint.activate([
                    scrolls[pageCount].widthAnchor.constraint(equalToConstant: view.frame.width),
                    scrolls[pageCount].heightAnchor.constraint(equalToConstant: scrollView.contentSize.height),
                    scrolls[pageCount].leadingAnchor.constraint(equalTo: scrolls[pageCount - 1].trailingAnchor)
                ])
            case scrolls.count-1:
                // Last view will have the leading anchor to the trailing anchor of hte previous view but also trailing anchored to the trailing anchor of the scroll view
                NSLayoutConstraint.activate([
                    scrolls[pageCount].widthAnchor.constraint(equalToConstant: view.frame.width),
                    scrolls[pageCount].heightAnchor.constraint(equalToConstant: scrollView.contentSize.height),
                    scrolls[pageCount].leadingAnchor.constraint(equalTo: scrolls[pageCount - 1].trailingAnchor),
                    scrolls[pageCount].trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
                ])
            default:
                print("Error")
            }
            
            // place the views in the scrolls[pagecount]
            scrolls[pageCount].addSubview(weatherView)
            NSLayoutConstraint.activate([
                weatherView.leadingAnchor.constraint(equalTo: scrolls[pageCount].leadingAnchor),
                weatherView.topAnchor.constraint(equalTo: scrolls[pageCount].topAnchor),
                weatherView.trailingAnchor.constraint(equalTo: scrolls[pageCount].trailingAnchor),
                weatherView.bottomAnchor.constraint(equalTo: scrolls[pageCount].bottomAnchor),
                
                
                
                weatherView.widthAnchor.constraint(equalToConstant: scrolls[pageCount].contentSize.width),
//
//                // height not set cause it will be determined when all the UIelements fo rthe weatherview is placed, the contentsize will dynamically adjust for the weatheerviews height
//
            ])
            
            

            
            let forecastStack = setForecastLabels(pageView: weatherView, location: locationList[pageCount], temperature: 78, weather: "Sunny", high: 105, low: 79)
            
            let forecastView = setForcastView(pageView: weatherView, topUIElement: forecastStack)
            
            let tenForecastView = setTenDayForcastView(pageView: weatherView, topUIElement: forecastView)
            
            let humidFeelsViewsTuple = setHumidityAndFeelsLike(pageView: weatherView, topUIElement: tenForecastView)
            
            let moonSunsetViewsTuple = setMoonPhaseAndSunset(pageView: weatherView, topLeftUIElement: humidFeelsViewsTuple.0, topRightUIElement: humidFeelsViewsTuple.1)
            
            configureViewsContents(dayForecast: forecastView, tenDayForcast: tenForecastView, humidity: humidFeelsViewsTuple.0, feelsLike: humidFeelsViewsTuple.1, moonPhase: moonSunsetViewsTuple.0, sunsetTime: moonSunsetViewsTuple.1)
            
            
        }
        
        // Set scroll view delegate to self to access functions for it
        scrollView.delegate = self

    }
    
    func configureWeatherPageControl(locations: Int) {
        weatherPageControl.numberOfPages = locations
        weatherPageControl.currentPage = 0
        oldPageTracker = weatherPageControl.currentPage
        weatherPageControl.hidesForSinglePage = true
        weatherPageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
        
        weatherPageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
        weatherPageControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureToolBar(imageName: String) {
        configureWeatherPageControl(locations: locationList.count)
        let pageItem = UIBarButtonItem(customView: weatherPageControl)
    
        switch imageName {
            
        case "Day":
            toolBar.barTintColor = UIColor(red: 76/255.0, green: 156/255.0, blue: 169/255.0, alpha: 1)
        case "Night":
            toolBar.barTintColor = UIColor(red: 13/255.0, green: 14/255.0, blue: 17/255.0, alpha: 1)
        case "Sunrise":
            toolBar.barTintColor = UIColor(red: 14/255.0, green: 45/255.0, blue: 79/255.0, alpha: 1)
        case "Sunset":
            toolBar.barTintColor = UIColor(red: 25/255.0, green: 56/255.0, blue: 87/255.0, alpha: 1)
        default:
            toolBar.barTintColor = UIColor(red: 50/255.0, green: 114/255.0, blue: 144/255.0, alpha: 1)
        }
        
        let listButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, target: self, action: #selector(buttonPressed(_:)))
        listButton.tintColor = .white
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, pageItem, spaceButton, listButton], animated: true)
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureScrollView(locations: Int) {
        scrollView.contentSize = .init(width: view.frame.width * CGFloat(locations), height: view.frame.height)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        setScrollView()
    }
    
    // Placing Scrollview
    func setScrollView() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setBackgroundColor(imageName: String) {
        backgroundImage.image = UIImage(named: imageName)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tenDayForcastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! TenDayForecastCell
        
        cell.backgroundColor = .clear
        
        cell.setTenLabelsAndPicture(day: tenDayForcastData[indexPath.row][0] as! String,
                                    highLow: tenDayForcastData[indexPath.row][1] as! String,
                                    icon: tenDayForcastData[indexPath.row][2] as! UIImage)
        
        
        return cell
        
    }
    
    
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForcastData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath) as! HourlyForecastCell
        
        collectionCell.setPictureAndText(hour: hourlyForcastData[indexPath.row][0] as! String,
                                         temp: hourlyForcastData[indexPath.row][1] as! String,
                                         weatherIcon: hourlyForcastData[indexPath.row][2] as! UIImage)
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 6.5, height: collectionView.frame.height)
    }
    
    
}


extension MainVC: UIScrollViewDelegate {
    
    //func isDifferentPage()
    // This function is called every time we scroll in the scroll view. Here, we update the page control to match where we are in the scroll view.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // have to use self because i want to reference the scrollview variabel i made above and since they share a name not having self would reference all scrollviews instead
        weatherPageControl.currentPage = Int(round(Float((self.scrollView.contentOffset.x)) / Float(self.scrollView.frame.width)))
        if oldPageTracker != weatherPageControl.currentPage {
            oldPageTracker = weatherPageControl.currentPage
            matchBackgroundToLocation()
        }
    }
}
