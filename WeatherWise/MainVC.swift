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
    
    let backgroundImage = UIImageView()
    let weatherPageControl = UIPageControl()
    let toolBar = UIToolbar()
    
    let locationList = ["My Location - Del Valle, Texas", "Austin, Texas", "New York City, New York", "Modesto, California" , "Nnewi, Nigeria", "Orlando, Florida"]
        
    let imageFileNames = ["Day", "Night", "Sunrise", "Sunset"]
    
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
        
    }
    
    // Move the scroll view to the position corresponding to the selected page.
    @objc func pageControlChanged(_ sender:UIPageControl) {
        let currentPage = sender.currentPage
        scrollView.setContentOffset(.init(x: CGFloat(currentPage) * view.frame.width, y: 0), animated: false)
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
            scrolls[pageCount].backgroundColor = .clear
            scrolls[pageCount].contentSize = .init(width: view.frame.width, height: 2000)
            //scrolls[pageCount].showsVerticalScrollIndicator = false
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
            let weatherView = UIView()
            weatherView.backgroundColor = .clear
            weatherView.translatesAutoresizingMaskIntoConstraints = false
            scrolls[pageCount].addSubview(weatherView)
            NSLayoutConstraint.activate([
                weatherView.leadingAnchor.constraint(equalTo: scrolls[pageCount].leadingAnchor),
                weatherView.topAnchor.constraint(equalTo: scrolls[pageCount].topAnchor),
                weatherView.widthAnchor.constraint(equalToConstant: scrolls[pageCount].contentSize.width),
                weatherView.heightAnchor.constraint(equalToConstant: scrolls[pageCount].contentSize.height)
            ])
            
            
            // create label that show off which location
            let label = UILabel()
            label.text = "\(locationList[pageCount])"
            label.textAlignment = .center
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            
            // place the label inside the view we just placed
            weatherView.addSubview(label)
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalToConstant: 300),
                label.centerXAnchor.constraint(equalTo: weatherView.centerXAnchor),
                label.topAnchor.constraint(equalTo: weatherView.topAnchor, constant: 70)
            ])
        }
        
        // Set scroll view delegate to self to access functions for it
        scrollView.delegate = self

    }
    
    func configureWeatherPageControl(locations: Int) {
        weatherPageControl.numberOfPages = locations
        weatherPageControl.currentPage = 0
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
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
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

extension MainVC: UIScrollViewDelegate {
    // This function is called every time we scroll in the scroll view. Here, we update the page control to match where we are in the scroll view.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        weatherPageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x)) / Float(scrollView.frame.width))
    }
    
}
