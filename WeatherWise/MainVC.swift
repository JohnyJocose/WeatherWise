//
//  ViewController.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 9/25/23.
//

import UIKit


// This file will be the home screen where the weather is displayed for the user's current location and any other locations they choose to add

class MainVC: UIViewController {
    
    
    let backgroundImage = UIImageView()
    
    // Data
//    var locationList = usersInfo.locationsForecastArray
//    var hourlyForecastData: [[HourResult]] = []
//    var threeDayForecastData: [[ForecastDayResult]] = []
    
    
    var scrollViewsList: [UIScrollView] = []
    //var weatherViewsList: [WeatherView] = []
    
    
    let pageScrollView = UIScrollView()
    let toolBar = UIToolbar()
    let weatherPageControl = UIPageControl()
    var oldPageTracker: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        setBackgroundColor()
        print("the weatherpages count is \(usersInfo.forecastWeatherPages.count)")
        configureScrollView(locations: usersInfo.forecastWeatherPages.count)
        configureToolBar()
        makeAndConfigureWeatherViews(locations: usersInfo.forecastWeatherPages.count)
        
//        if usersInfo.isFirstTimeBootingApp() {
//            
//            LocationService.shared.getUsersLocation { [weak self] location in
//                guard let strongSelf = self else {return}
//                usersInfo.addUsersLocationAsFirstArray(lat: Decimal(location.coordinate.latitude), lon: Decimal(location.coordinate.longitude))
//                
//            }
//
//        }
    }
    
    // MARK: UI Functions
    func setBackgroundColor() {
        backgroundImage.image = UIImage(named: "Day")
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
    
    func configureScrollView(locations: Int) {
        
        
        pageScrollView.contentSize = .init(width: view.frame.width * CGFloat(locations), height: view.frame.height)
        
        
        pageScrollView.bounces = false
        pageScrollView.isPagingEnabled = true
        pageScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageScrollView)
        
//        // Calculate the height of the top safe area
//        let topSafeAreaHeight = view.safeAreaInsets.top
//
//        // Set the content offset to move the content down to the top safe area
//        pageScrollView.contentOffset = CGPoint(x: 0, y: -topSafeAreaHeight)
        
        NSLayoutConstraint.activate([
            pageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            pageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func configureToolBar() {
        
        configureWeatherPageControl(locations: usersInfo.forecastWeatherPages.count)
        let pageItem = UIBarButtonItem(customView: weatherPageControl)
    
        toolBar.barTintColor = UIColor(red: 76/255.0, green: 156/255.0, blue: 169/255.0, alpha: 1)
        
        
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
    
    func configureWeatherPageControl(locations: Int) {
        
        weatherPageControl.numberOfPages = locations
        weatherPageControl.currentPage = 0
        oldPageTracker = weatherPageControl.currentPage
        weatherPageControl.hidesForSinglePage = false
        weatherPageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
        
        weatherPageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
        weatherPageControl.translatesAutoresizingMaskIntoConstraints = false
    
        
    }
    
    // Move the scroll view to the position corresponding to the selected page.
    
    // TODO: change Backgorund function matchBackgroundToLocation() to be able to use location struct; get similar code from SingularWeatherPageVC
    @objc func pageControlChanged(_ sender:UIPageControl) {
        let currentPage = sender.currentPage
        pageScrollView.setContentOffset(.init(x: CGFloat(currentPage) * view.frame.width, y: 0), animated: false)
        let currentTime = usersInfo.locationsForecastArray[currentPage].location.localtime
        let sunsetTime = usersInfo.locationsForecastArray[currentPage].forecast.forecastday[0].astro.sunset
        let sunriseTime = usersInfo.locationsForecastArray[currentPage].forecast.forecastday[0].astro.sunrise
        
        changeBackgroundBasedOnLocationsTime(currentTime: currentTime, sunset: sunsetTime, sunrise: sunriseTime)
    }
    
    func changeBackgroundBasedOnLocationsTime(currentTime: String, sunset: String, sunrise: String) {
        let sunriseSunsetFormat = "hh:mm a"
        let currentDateFormat = "yyyy-MM-dd H:mm"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentDateFormat
        
        guard let currentDateTime = dateFormatter.date(from: currentTime) else {
            print("Invalid current time format.")
            return
        }
        
        let HourDateFormatter = DateFormatter()
        HourDateFormatter.dateFormat = "hh:mm a"
        let hourMinOnlyCurrentTime = HourDateFormatter.string(from: currentDateTime)
        
        dateFormatter.dateFormat = sunriseSunsetFormat
        
        guard let sunsetTime = dateFormatter.date(from: sunset),
              let sunriseTime = dateFormatter.date(from: sunrise),
              let newCurrentTime = dateFormatter.date(from: hourMinOnlyCurrentTime) else {
            print("Invalid sunset, sunrise, or current time format.")
            return
        }
        
        
        // Calculate sunset and sunrise times with an hour subtracted and added
        let sunsetMinusOneHour = Calendar.current.date(byAdding: .hour, value: -1, to: sunsetTime)!
        let sunriseMinusOneHour = Calendar.current.date(byAdding: .hour, value: -1, to: sunriseTime)!
        
        let sunsetPlusOneHour = Calendar.current.date(byAdding: .hour, value: 1, to: sunsetTime)!
        let sunrisePlusOneHour = Calendar.current.date(byAdding: .hour, value: 1, to: sunriseTime)!
        
        // Special case: midnight to sunriseMinusOneHour
        let midnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: newCurrentTime)!
        
        
        // Check the current time against the sunset and sunrise times with the offsets
        if newCurrentTime >= midnight && newCurrentTime <= sunriseMinusOneHour {
            UIView.transition(with: self.backgroundImage,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.backgroundImage.image = UIImage(named: "Night") },
                          completion: nil)
            
            UIView.transition(with: self.toolBar,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.toolBar.barTintColor = UIColor(red: 13/255.0, green: 14/255.0, blue: 17/255.0, alpha: 1) },
                          completion: nil)
            
        } else if newCurrentTime >= sunriseMinusOneHour && newCurrentTime <= sunrisePlusOneHour {
            UIView.transition(with: self.backgroundImage,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.backgroundImage.image = UIImage(named: "Sunrise") },
                          completion: nil)
            
            UIView.transition(with: self.toolBar,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.toolBar.barTintColor = UIColor(red: 14/255.0, green: 45/255.0, blue: 79/255.0, alpha: 1) },
                          completion: nil)
        } else if newCurrentTime >= sunrisePlusOneHour && newCurrentTime <= sunsetMinusOneHour {
            UIView.transition(with: self.backgroundImage,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.backgroundImage.image = UIImage(named: "Day") },
                          completion: nil)
            
            UIView.transition(with: self.toolBar,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.toolBar.barTintColor = UIColor(red: 76/255.0, green: 156/255.0, blue: 169/255.0, alpha: 1) },
                          completion: nil)
        } else if newCurrentTime >= sunsetMinusOneHour && newCurrentTime <= sunsetPlusOneHour {
            UIView.transition(with: self.backgroundImage,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.backgroundImage.image = UIImage(named: "Sunset") },
                          completion: nil)
            
            UIView.transition(with: self.toolBar,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.toolBar.barTintColor = UIColor(red: 25/255.0, green: 56/255.0, blue: 87/255.0, alpha: 1) },
                          completion: nil)
        } else {
            UIView.transition(with: self.backgroundImage,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.backgroundImage.image = UIImage(named: "Night") },
                          completion: nil)
            
            UIView.transition(with: self.toolBar,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.toolBar.barTintColor = UIColor(red: 13/255.0, green: 14/255.0, blue: 17/255.0, alpha: 1) },
                          completion: nil)
        }
    }
    
    func makeAndConfigureWeatherViews(locations: Int) {

        // Add a view for each user-set location.
        for _ in usersInfo.forecastWeatherPages{
            scrollViewsList.append(UIScrollView())
        }
        setWeatherViews(scrolls: scrollViewsList)
        if !usersInfo.isUsersLocationsEmpty() {
            usersInfo.updateAllWeatherViews()
            
            let currentTime = usersInfo.locationsForecastArray[weatherPageControl.currentPage].location.localtime
            let sunsetTime = usersInfo.locationsForecastArray[weatherPageControl.currentPage].forecast.forecastday[0].astro.sunset
            let sunriseTime = usersInfo.locationsForecastArray[weatherPageControl.currentPage].forecast.forecastday[0].astro.sunrise
            changeBackgroundBasedOnLocationsTime(currentTime: currentTime, sunset: sunsetTime, sunrise: sunriseTime)
        }
        
        
    }
    
    func setWeatherViews(scrolls: [UIScrollView]) {
        
        // For loop to add each view into the scrollview.
        for pageCount in 0..<scrolls.count {
            let weatherView = usersInfo.forecastWeatherPages[pageCount]
            weatherView.backgroundColor = .clear
            weatherView.translatesAutoresizingMaskIntoConstraints = false
            
            scrolls[pageCount].backgroundColor = .clear
            // This code dynamically adjusts the height of the content size based on the elements placed.
            // Make sure to anchor the top element to the top of the weather view and the bottom elements to the bottom of the weather view.
            scrolls[pageCount].contentSize = .init(width: view.frame.width, height: weatherView.frame.height)
            scrolls[pageCount].showsVerticalScrollIndicator = false
            
            scrolls[pageCount].translatesAutoresizingMaskIntoConstraints = false
            pageScrollView.addSubview(scrolls[pageCount])
            
            switch pageCount {
            case 0:
                // Add the first screen to the scroll view; the leading anchor should be aligned with the scroll view's leading anchor.
                NSLayoutConstraint.activate([
                    scrolls[pageCount].widthAnchor.constraint(equalToConstant: view.frame.width),
                    scrolls[pageCount].heightAnchor.constraint(equalToConstant: pageScrollView.contentSize.height),
                    scrolls[pageCount].leadingAnchor.constraint(equalTo: pageScrollView.leadingAnchor)
                ])
                // Anything in the middle of the list after the first and before the last will have their leading anchor to the trailing anchor of the previous view.
            case 1..<scrolls.count-1:
                NSLayoutConstraint.activate([
                    scrolls[pageCount].widthAnchor.constraint(equalToConstant: view.frame.width),
                    scrolls[pageCount].heightAnchor.constraint(equalToConstant: pageScrollView.contentSize.height),
                    scrolls[pageCount].leadingAnchor.constraint(equalTo: scrolls[pageCount - 1].trailingAnchor)
                ])
            case scrolls.count-1:
                // The last view will have the leading anchor to the trailing anchor of the previous view but also the trailing anchor to the trailing anchor of the scroll view.
                NSLayoutConstraint.activate([
                    scrolls[pageCount].widthAnchor.constraint(equalToConstant: view.frame.width),
                    scrolls[pageCount].heightAnchor.constraint(equalToConstant: pageScrollView.contentSize.height),
                    scrolls[pageCount].leadingAnchor.constraint(equalTo: scrolls[pageCount - 1].trailingAnchor),
                    scrolls[pageCount].trailingAnchor.constraint(equalTo: pageScrollView.trailingAnchor)
                ])
            default:
                fatalError("ScrollViews weren't properly placed")
            }
            
            // Placing the `weatherviews` in the `scrolls[pagecount]`.
            scrolls[pageCount].addSubview(weatherView)
            NSLayoutConstraint.activate([
                weatherView.leadingAnchor.constraint(equalTo: scrolls[pageCount].leadingAnchor),
                weatherView.topAnchor.constraint(equalTo: scrolls[pageCount].topAnchor),
                weatherView.trailingAnchor.constraint(equalTo: scrolls[pageCount].trailingAnchor),
                weatherView.bottomAnchor.constraint(equalTo: scrolls[pageCount].bottomAnchor),
                
                
                
                weatherView.widthAnchor.constraint(equalToConstant: scrolls[pageCount].contentSize.width),

                // The height is not set because it will be determined when all the UI elements for the `weatherview` are placed. The `contentsize` will dynamically adjust to fit the `weatherview`'s height.
            ])
            
//            weatherViewsList.append(weatherView)
//            hourlyForecastData.append([])
//            threeDayForecastData.append([])
            
            
        }
        
        // Set scroll view delegate to self to access functions for it
        pageScrollView.delegate = self

    }
    
    
    
//    // MARK: CoreData/API Functions
//    func updateAllWeatherViews() {
//        for i in 0..<usersInfo.returnUsersLocationsCount(){
//            updateWeatherViewInfo(weatherView: weatherViewsList[i], forecastInfo: usersInfo.locationsForecastArray[i], index: i)
//        }
//    }
//    
//    func updateWeatherViewInfo(weatherView: WeatherView, forecastInfo: ForecastStruct, index: Int) {
//        
//        populateHourlyForecastData(forecastInfo: forecastInfo, index: index)
//        
//        populateThreeDayForecastData(forecastInfo: forecastInfo, index: index)
//        
//        
//        var tempDecimal: Decimal = forecastInfo.current.tempF
//        var tempDrounded: Decimal = Decimal()
//        NSDecimalRound(&tempDrounded, &tempDecimal, 0, .plain)
//        let tempString = "\(tempDrounded)°"
//        
//        var lowDecimal: Decimal = forecastInfo.forecast.forecastday[0].day.mintempF
//        var lowDrounded: Decimal = Decimal()
//        NSDecimalRound(&lowDrounded, &lowDecimal, 0, .plain)
//        let lowString = "L:\(lowDrounded)°  "
//        
//        var highDecimal: Decimal = forecastInfo.forecast.forecastday[0].day.maxtempF
//        var highDrounded: Decimal = Decimal()
//        NSDecimalRound(&highDrounded, &highDecimal, 0, .plain)
//        let highString = "H:\(highDrounded)°"
//        
//        let highLowString = lowString + highString
//        
//        weatherView.updateStackLabels(location: "\(forecastInfo.location.name), \(forecastInfo.location.region)", temperature: tempString, weather: forecastInfo.current.condition.text, highLow: highLowString)
//        
//        
//        
//        weatherView.updateHourData(hourForecast: hourlyForecastData[index])
//        weatherView.updateThreeDayHourData(threeDayForecast: threeDayForecastData[index])
//        weatherView.updateHumidty(humidity: forecastInfo.current.humidity)
//        weatherView.updateFeelsLike(feelsLike: forecastInfo.current.feelslikeF)
//        weatherView.updateSunset(sunsetTime: forecastInfo.forecast.forecastday[0].astro.sunset)
//        
//        changeBackgroundBasedOnLocationsTime(currentTime: forecastInfo.location.localtime, sunset: forecastInfo.forecast.forecastday[0].astro.sunset, sunrise: forecastInfo.forecast.forecastday[0].astro.sunrise)
//
//    }
//    
//    func populateHourlyForecastData(forecastInfo: ForecastStruct, index: Int) {
//        
//        let timeZoneID = forecastInfo.location.tzId
//        if let date = convertStringToLocalDate(localTimeString: forecastInfo.location.localtime, timeZoneIdentifier: timeZoneID) {
//            var hourIndex: Int = 0
//            
//            var previousHourlyTimeStruct: HourResult! = nil
//            for forecastDay in forecastInfo.forecast.forecastday {
//                for hourForecast in forecastDay.hour {
//                    if let hourlyTime = convertStringToLocalDate(localTimeString: hourForecast.time, timeZoneIdentifier: timeZoneID) {
//                        if hourlyTime > date && hourIndex < 23 {
//                            //print(hourIndex)
//                            //print()
//                            hourlyForecastData[index].append(hourForecast)
//                            hourIndex += 1
//                        }
//                        else if hourIndex < 23 {
//                            previousHourlyTimeStruct = hourForecast
//                        }
//                    }
//                }
//            }
//            
//            let nowHourStruct = HourResult(timeEpoch: forecastInfo.location.localtimeEpoch,
//                                           time: forecastInfo.location.tzId,
//                                           tempC: forecastInfo.current.tempC,
//                                           tempF: forecastInfo.current.tempF,
//                                           condition: forecastInfo.current.condition,
//                                           windMph: forecastInfo.current.windMph,
//                                           windKph: forecastInfo.current.windKph,
//                                           windDegree: forecastInfo.current.windDegree,
//                                           windDir: forecastInfo.current.windDir,
//                                           pressureMb: forecastInfo.current.pressureMb,
//                                           pressureIn: forecastInfo.current.pressureIn,
//                                           precipMm: forecastInfo.current.precipMm,
//                                           precipIn: forecastInfo.current.precipIn,
//                                           humidity: forecastInfo.current.humidity,
//                                           cloud: forecastInfo.current.cloud,
//                                           feelslikeC: forecastInfo.current.feelslikeC,
//                                           feelslikeF: forecastInfo.current.feelslikeF,
//                                           windchillC: previousHourlyTimeStruct.windchillC,
//                                           windchillF: previousHourlyTimeStruct.windchillF,
//                                           heatindexC: previousHourlyTimeStruct.heatindexC,
//                                           heatindexF: previousHourlyTimeStruct.heatindexF,
//                                           dewpointC: previousHourlyTimeStruct.dewpointC,
//                                           dewpointF: previousHourlyTimeStruct.dewpointF,
//                                           willItRain: previousHourlyTimeStruct.willItRain,
//                                           willItSnow: previousHourlyTimeStruct.willItSnow,
//                                           isDay: forecastInfo.current.isDay,
//                                           visKm: previousHourlyTimeStruct.visKm,
//                                           visMiles: previousHourlyTimeStruct.visMiles,
//                                           chanceOfRain: previousHourlyTimeStruct.chanceOfRain,
//                                           chanceOfSnow: previousHourlyTimeStruct.chanceOfSnow,
//                                           gustMph: forecastInfo.current.gustMph,
//                                           gustKph: forecastInfo.current.gustKph,
//                                           uv: forecastInfo.current.uv)
//            
//            hourlyForecastData[index].insert(nowHourStruct, at: 0)
//            
//        }
//    }
//    
//    func populateThreeDayForecastData(forecastInfo: ForecastStruct, index: Int) {
//        for dayForecast in forecastInfo.forecast.forecastday {
//            threeDayForecastData[index].append(dayForecast)
//        }
//    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let nextVC = UINavigationController(rootViewController: LocationVC())
        nextVC.navigationBar.prefersLargeTitles = true
        
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }
    
    
    
}





extension MainVC: UIScrollViewDelegate {
    
    //func isDifferentPage()
    // This function is called every time we scroll in the scroll view. Here, we update the page control to match where we are in the scroll view.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // have to use self because i want to reference the scrollview variabel i made above and since they share a name not having self would reference all scrollviews instead
        weatherPageControl.currentPage = Int(round(Float((self.pageScrollView.contentOffset.x)) / Float(self.pageScrollView.frame.width)))
        if oldPageTracker != weatherPageControl.currentPage {
            oldPageTracker = weatherPageControl.currentPage
            let currentTime = usersInfo.locationsForecastArray[oldPageTracker].location.localtime
            let sunsetTime = usersInfo.locationsForecastArray[oldPageTracker].forecast.forecastday[0].astro.sunset
            let sunriseTime = usersInfo.locationsForecastArray[oldPageTracker].forecast.forecastday[0].astro.sunrise
            
            changeBackgroundBasedOnLocationsTime(currentTime: currentTime, sunset: sunsetTime, sunrise: sunriseTime)
        }
    }
}




    
    
