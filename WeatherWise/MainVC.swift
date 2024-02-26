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
    
        
    var scrollViewsList: [UIScrollView] = []
    
    
    let pageScrollView = UIScrollView()
    let toolBar = UIToolbar()
    let weatherPageControl = UIPageControl()
    var oldPageTracker: Int = 0
    
    // Syntax to create a UIActivityIndicatorView
    var loadCircle = UIActivityIndicatorView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        usersInfo.delegate = self
        
        
        // Set scroll view delegate to self to access functions for it
        pageScrollView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name:  UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openActivity), name: UIApplication.didBecomeActiveNotification, object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if usersInfo.skipToLocation == true {
            goToLocationVC()
        }
    }
    
    @objc func openActivity() {
        if usersInfo.skipToLocation == true {
            goToLocationVC()
        }
    }
    
    
    
    func configureUI() {
        setBackgroundColor()
        configureToolBar()
        configureScrollView(locations: usersInfo.forecastWeatherPages.count)
        makeAndConfigureWeatherViews(locations: usersInfo.forecastWeatherPages.count)
        
        configureLoadingCircle()

    }
    
    func disableEverything() {
        // Since we have an activity bar, we don't want users to be able to click anywhere on the screen. This could lead the user to accidentally click on something and navigate to a different screen, possibly causing a crash, etc. This piece of code prevents user interaction.
        view.isUserInteractionEnabled = false

    }
    
    func enableEverything() {
        // This piece of code enables user interaction again.
        view.isUserInteractionEnabled = true
    }
    
    
    func startLoading() {
        // This is how you start the activity indicator.
        loadCircle.startAnimating()
    }
    
    func stopLoading() {
        // This is how you stop the activity indicator.
        loadCircle.stopAnimating()
    }
    
    
    
    func configureLoadingCircle(){
        // This will determine if the activity indicator is visible when UIActivityIndicatorView'sName.stopAnimating() is called.
        loadCircle.hidesWhenStopped = true
        loadCircle.color = .white
        loadCircle.style = .large
        // The activity indicator itself is not very big and by default, it will appear in the middle. Depending on the constraints you set, the rest of it will have a background that you can change the color of. I prefer to have it dark to indicate that something is in progress and to suggest that you shouldn't click anywhere else.
        loadCircle.backgroundColor = .darkGray
        
        loadCircle.translatesAutoresizingMaskIntoConstraints = false
        
        // Set the activity bar with the constraints you want.
        view.addSubview(loadCircle)
        NSLayoutConstraint.activate([
            loadCircle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadCircle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadCircle.topAnchor.constraint(equalTo: view.topAnchor),
            loadCircle.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadCircle.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    
    
    
    
    
    
    
    
    func removePageScrollView() {
        // perform a loop to iterate each subView
        pageScrollView.subviews.forEach { subView in
           // removing subView from its parent view
            subView.removeFromSuperview()
        }
        pageScrollView.removeFromSuperview()
        scrollViewsList.removeAll()
    }
    
    // MARK: UPDATE SCROLLVIEW FUNCTION
    func updateScrollView() {
        removePageScrollView()
        configureScrollView(locations: usersInfo.forecastWeatherPages.count)
        makeAndConfigureWeatherViews(locations: usersInfo.forecastWeatherPages.count)
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
        view.insertSubview(pageScrollView, belowSubview: toolBar)
        //view.addSubview(pageScrollView)
        
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
        weatherPageControl.hidesForSinglePage = true
        weatherPageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
        
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 10))
        
        weatherPageControl.preferredIndicatorImage = UIImage(systemName: "circle.fill")?.applyingSymbolConfiguration(config)
        
        
        weatherPageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
        weatherPageControl.translatesAutoresizingMaskIntoConstraints = false
    
        
    }
    
    func changeFirstPageIndicatorImage(LocationOn: Bool) {
        if LocationOn {
            weatherPageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
        }
        else {
            
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 10))
            weatherPageControl.setIndicatorImage(UIImage(systemName: "circle.fill")?.applyingSymbolConfiguration(config), forPage: 0)
        }
    }
    
    func changeNumberOfPagesInPageControl(arrayCount: Int, currentPage: Int) {
        weatherPageControl.numberOfPages = arrayCount
        weatherPageControl.currentPage = currentPage
        oldPageTracker = weatherPageControl.currentPage
        
    }
    
    // Move the scroll view to the position corresponding to the selected page.
    
    func changeScrollViewBasedOnArray(index: Int) {
        pageScrollView.setContentOffset(.init(x: CGFloat(index) * view.frame.width, y: 0), animated: false)
        let currentTime = usersInfo.locationsForecastArray[index].location.localtime
        let sunsetTime = usersInfo.locationsForecastArray[index].forecast.forecastday[0].astro.sunset
        let sunriseTime = usersInfo.locationsForecastArray[index].forecast.forecastday[0].astro.sunrise
        
        changeBackgroundBasedOnLocationsTime(currentTime: currentTime, sunset: sunsetTime, sunrise: sunriseTime)
    }
    
    @objc func pageControlChanged(_ sender:UIPageControl) {
        let currentPage = sender.currentPage
        changeScrollViewBasedOnArray(index: currentPage)
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
            
            
        }

    }
    
    func goToLocationVC() {
        let nextVC = LocationVC()
        nextVC.mainDelegate = self
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
 
    
    @objc func buttonPressed(_ sender: UIButton) {
        goToLocationVC()

    }
    
    
    
}





extension MainVC: UIScrollViewDelegate {
    
    
    // This function is called every time we scroll in the scroll view. Here, we update the page control to match where we are in the scroll view.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // have to use self because i want to reference the scrollview variabel i made above and since they share a name not having self would reference all scrollviews instead
        
        guard !(round(Float((self.pageScrollView.contentOffset.x)) / Float(self.pageScrollView.frame.width)).isNaN || round(Float((self.pageScrollView.contentOffset.x)) / Float(self.pageScrollView.frame.width)).isInfinite) else { return }

        
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




    
    
