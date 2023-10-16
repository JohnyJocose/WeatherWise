//
//  SingularWeatherPageVC.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 10/8/23.
//

import UIKit

class SingularWeatherPageVC: UIViewController {
    
    let backgroundImage = UIImageView()
    let imageFileNames = ["Day", "Night", "Sunrise", "Sunset"]
    
    var hourlyForcastData: [HourResult] = []
    
    var tenDayForcastData: [ForecastDayResult] = []
    

    let locationLabel = UILabel()
    let tempLabel = UILabel()
    let weatherLabel = UILabel()
    let highLowLabel = UILabel()

    
    var locationClass: CityClass! = nil
    
    let weatherView = UIView()
    let weatherScroll = UIScrollView()
    let toolBar = UIToolbar()
    
    enum fileNames {
        case Day
        case Night
        case Sunrise
        case Sunset
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
            backgroundImage.image = UIImage(named: "Night")
            toolBar.setBackgroundImage(UIImage(named: "Night"), forToolbarPosition: .any, barMetrics: .default)
        } else if newCurrentTime >= sunriseMinusOneHour && newCurrentTime <= sunrisePlusOneHour {
            backgroundImage.image = UIImage(named: "Sunrise")
            toolBar.setBackgroundImage(UIImage(named: "Sunrise"), forToolbarPosition: .any, barMetrics: .default)
        } else if newCurrentTime >= sunrisePlusOneHour && newCurrentTime <= sunsetMinusOneHour {
            backgroundImage.image = UIImage(named: "Day")
            toolBar.setBackgroundImage(UIImage(named: "Day"), forToolbarPosition: .any, barMetrics: .default)
        } else if newCurrentTime >= sunsetMinusOneHour && newCurrentTime <= sunsetPlusOneHour {
            backgroundImage.image = UIImage(named: "Sunset")
            toolBar.setBackgroundImage(UIImage(named: "Sunset"), forToolbarPosition: .any, barMetrics: .default)
        } else {
            backgroundImage.image = UIImage(named: "Night")
            toolBar.setBackgroundImage(UIImage(named: "Night"), forToolbarPosition: .any, barMetrics: .default)
        }
    }

    
    
    func convertStringToDayOfTheWeek(timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Parse the local time string into a Date object
        if let date = dateFormatter.date(from: timeString) {
            
            let HourDateFormatter = DateFormatter()
            HourDateFormatter.dateFormat = "EEEE"
            let formattedDate = HourDateFormatter.string(from: date)
            return formattedDate
            
        } else {
            print("Failed to convert the local time string to a Date object.")
            return nil
        }
        
    }
    
    
    
    func convertStringToLocalDate(localTimeString: String, timeZoneIdentifier: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm"
        
        // Set the time zone based on the provided time zone identifier
        if let timeZone = TimeZone(identifier: timeZoneIdentifier) {
            dateFormatter.timeZone = timeZone
        } else {
            print("Invalid time zone identifier.")
            return nil
        }
        
        // Parse the local time string into a Date object
        if let date = dateFormatter.date(from: localTimeString) {
            return date
        } else {
            print("Failed to convert the local time string to a Date object.")
            return nil
        }
    }
    
    
    func convertStringToLocalHourTime(localTimeString: String, timeZoneIdentifier: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm"
        
        // Set the time zone based on the provided time zone identifier
        if let timeZone = TimeZone(identifier: timeZoneIdentifier) {
            dateFormatter.timeZone = timeZone
        } else {
            print("Invalid time zone identifier.")
            return nil
        }
        
        // Parse the local time string into a Date object
        if let date = dateFormatter.date(from: localTimeString) {
            
            let HourDateFormatter = DateFormatter()
            HourDateFormatter.dateFormat = "h a"
            HourDateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
            let formattedDate = HourDateFormatter.string(from: date)
            return formattedDate
            
            
        } else {
            print("Failed to convert the local time string to a Date object.")
            return nil
        }
    }
    
    
    func configureUI() {
        let imageName = imageFileNames.randomElement()!
        setBackgroundColor(imageName: imageName)
        configureToolBar(imageName: imageName)
        configureScrollView()
        
        
        
    }
    
    // configure each topic views content
    func configureViewsContents(dayForecast: UIView, tenDayForcast: UIView, humidity: UIView, feelsLike: UIView, moonPhase: UIView, sunsetTime: UIView) {
        
        Task {
            
            var result = try await forecastJson.getForecastDataAsync(lat: locationClass.lat, lon: locationClass.lon)
            
            // since im seaerching locations by lat and lon sometimes it gives me the city as a whole instead of the specifc area im talking about
            // i need to correct the struct that way when its saved in coredata it wont show the wrong one
            result.location.name = locationClass.city
            result.location.region = locationClass.region
            result.location.country = locationClass.country
            
            configureHourlyForcastData(result: result)
            configureTenDayForecastData(result: result)
            
                        
            var tempDecimal: Decimal = result.current.tempF
            var tempDrounded: Decimal = Decimal()
            NSDecimalRound(&tempDrounded, &tempDecimal, 0, .plain)
            let tempString = "\(tempDrounded)°"
            
            var lowDecimal: Decimal = result.forecast.forecastday[0].day.mintempF
            var lowDrounded: Decimal = Decimal()
            NSDecimalRound(&lowDrounded, &lowDecimal, 0, .plain)
            let lowString = "L:\(lowDrounded)°  "
            
            var highDecimal: Decimal = result.forecast.forecastday[0].day.maxtempF
            var highDrounded: Decimal = Decimal()
            NSDecimalRound(&highDrounded, &highDecimal, 0, .plain)
            let highString = "H:\(highDrounded)°"
            
            let highLowString = lowString + highString
            
            updateStacksLabels(location: "\(result.location.name), \(result.location.region)",
                               temperature: tempString,
                               weather: result.current.condition.text,
                               highLow: highLowString)
            
            configureDayForecast(dayForecastView: dayForecast)
            configureTenDayForecast(tenDayForecastView: tenDayForcast)
            
            let currentHumidty = "\(result.current.humidity)%"
            configureHumidity(humidityView: humidity, humidityString: currentHumidty)
            
            var feelsDecimal: Decimal = result.forecast.forecastday[0].day.maxtempF
            var feelsDrounded: Decimal = Decimal()
            NSDecimalRound(&feelsDrounded, &feelsDecimal, 0, .plain)
            let feelsString = "\(feelsDrounded)°"
            
            let currentFeelsLike = feelsString
            configureFeelsLike(feelsLikeView: feelsLike, feelsLikeString: currentFeelsLike)
            
            let moonPhaseString = result.forecast.forecastday[0].astro.moonPhase
            let moonPhaseImage = moonDict[moonPhaseString]!
            configureMoonPhase(moonPhaseView: moonPhase, moonPhaseImage: moonPhaseImage)
            
            let sunsetTimeString = result.forecast.forecastday[0].astro.sunset
            configureSunset(sunsetView: sunsetTime, sunsetTimeString: sunsetTimeString)
            
            let sunriseTimeString = result.forecast.forecastday[0].astro.sunrise
            changeBackgroundBasedOnLocationsTime(currentTime: result.location.localtime, sunset: sunsetTimeString, sunrise: sunriseTimeString)
            
        }
        
    }
    
    func updateStacksLabels(location: String, temperature: String, weather: String, highLow: String) {
        locationLabel.text = location
        tempLabel.text = temperature
        weatherLabel.text = weather
        highLowLabel.text = highLow
    }
    
    func configureTenDayForecastData(result: ForecastStruct) {
        for dayForecast in result.forecast.forecastday {
            tenDayForcastData.append(dayForecast)
//            print(dayForecast.date)
//            print("\nMin Temp: \(dayForecast.day.mintempF)\nMax Temp: \(dayForecast.day.maxtempF)\nWeather: \(dayForecast.day.condition.text)\n\n\n")
        }
    }
    
    func configureHourlyForcastData(result: ForecastStruct) {
        let timeZoneID = result.location.tzId
        
        if let date = convertStringToLocalDate(localTimeString: result.location.localtime, timeZoneIdentifier: timeZoneID) {
            var hourIndex: Int = 0
            var previousHourlyTimeStruct: HourResult! = nil

            for forecastDay in result.forecast.forecastday {
                for hourForecast in forecastDay.hour {
                    if let hourlyTime = convertStringToLocalDate(localTimeString: hourForecast.time, timeZoneIdentifier: timeZoneID) {
                        if hourlyTime > date && hourIndex < 23 {
                            hourlyForcastData.append(hourForecast)
                            hourIndex += 1
                        }
                        else if hourIndex < 23 {
                            previousHourlyTimeStruct = hourForecast
                        }
                    }
                }
            }
            let nowHourStruct = HourResult(timeEpoch: result.location.localtimeEpoch,
                                           time: result.location.tzId,
                                           tempC: result.current.tempC,
                                           tempF: result.current.tempF,
                                           condition: result.current.condition,
                                           windMph: result.current.windMph,
                                           windKph: result.current.windKph,
                                           windDegree: result.current.windDegree,
                                           windDir: result.current.windDir,
                                           pressureMb: result.current.pressureMb,
                                           pressureIn: result.current.pressureIn,
                                           precipMm: result.current.precipMm,
                                           precipIn: result.current.precipIn,
                                           humidity: result.current.humidity,
                                           cloud: result.current.cloud,
                                           feelslikeC: result.current.feelslikeC,
                                           feelslikeF: result.current.feelslikeF,
                                           windchillC: previousHourlyTimeStruct.windchillC,
                                           windchillF: previousHourlyTimeStruct.windchillF,
                                           heatindexC: previousHourlyTimeStruct.heatindexC,
                                           heatindexF: previousHourlyTimeStruct.heatindexF,
                                           dewpointC: previousHourlyTimeStruct.dewpointC,
                                           dewpointF: previousHourlyTimeStruct.dewpointF,
                                           willItRain: previousHourlyTimeStruct.willItRain,
                                           willItSnow: previousHourlyTimeStruct.willItSnow,
                                           isDay: result.current.isDay,
                                           visKm: previousHourlyTimeStruct.visKm,
                                           visMiles: previousHourlyTimeStruct.visMiles,
                                           chanceOfRain: previousHourlyTimeStruct.chanceOfRain,
                                           chanceOfSnow: previousHourlyTimeStruct.chanceOfSnow,
                                           gustMph: result.current.gustMph,
                                           gustKph: result.current.gustKph,
                                           uv: result.current.uv)
            
            hourlyForcastData.insert(nowHourStruct, at: 0)
        }
    }
    
    @objc func buttonPressed(_ sender:UIButton) {
        
    }
    
    func configureToolBar(imageName: String) {
        
        switch imageName {
            
        case "Day":
            toolBar.setBackgroundImage(UIImage(named: imageName), forToolbarPosition: .any, barMetrics: .default)
            //toolBar.barTintColor = UIColor(red: 76/255.0, green: 156/255.0, blue: 169/255.0, alpha: 1)
        case "Night":
            toolBar.setBackgroundImage(UIImage(named: imageName), forToolbarPosition: .any, barMetrics: .default)
            //toolBar.barTintColor = UIColor(red: 13/255.0, green: 14/255.0, blue: 17/255.0, alpha: 1)
        case "Sunrise":
            toolBar.setBackgroundImage(UIImage(named: imageName), forToolbarPosition: .any, barMetrics: .default)
            //toolBar.barTintColor = UIColor(red: 14/255.0, green: 45/255.0, blue: 79/255.0, alpha: 1)
        case "Sunset":
            toolBar.setBackgroundImage(UIImage(named: imageName), forToolbarPosition: .any, barMetrics: .default)
            //toolBar.barTintColor = UIColor(red: 25/255.0, green: 56/255.0, blue: 87/255.0, alpha: 1)
        default:
            toolBar.barTintColor = UIColor(red: 50/255.0, green: 114/255.0, blue: 144/255.0, alpha: 1)
        }
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(buttonPressed(_:)))
        cancelButton.tintColor = .white
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonPressed(_:)))
        addButton.tintColor = .white
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancelButton, spaceButton, addButton], animated: true)
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.delegate = self
        view.addSubview(toolBar)
        NSLayoutConstraint.activate([
            toolBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureSunset(sunsetView: UIView, sunsetTimeString: String) {
        
        let sunsetTimeLabel = UILabel()
        sunsetTimeLabel.text = sunsetTimeString
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
    
    func configureMoonPhase(moonPhaseView: UIView, moonPhaseImage: UIImage) {
        let moonPhaseImageView = UIImageView()
        moonPhaseImageView.image = moonPhaseImage
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
    
    func configureFeelsLike(feelsLikeView: UIView, feelsLikeString: String) {
        let tempLabel = UILabel()
        tempLabel.text = feelsLikeString
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
    
    func configureHumidity(humidityView: UIView, humidityString: String) {
        let humidityLabel = UILabel()
        humidityLabel.text = humidityString
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
        titleLabel.text = "Three Day Forecast"
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
        tenDayForecastTableView.rowHeight = 100
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
    func setForecastLabels(pageView: UIView) -> UIStackView {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.distribution = .fillProportionally
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        locationLabel.text = "---"
        locationLabel.textAlignment = .center
        locationLabel.numberOfLines = 1
        locationLabel.font = .boldSystemFont(ofSize: 25)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tempLabel.text = "--"
        tempLabel.textAlignment = .center
        tempLabel.numberOfLines = 1
        tempLabel.font = .boldSystemFont(ofSize: 40)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        weatherLabel.text = "--"
        weatherLabel.textAlignment = .center
        weatherLabel.numberOfLines = 2
        weatherLabel.font = .systemFont(ofSize: 25)
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        
        highLowLabel.text = "L:--°  H:--°"
        highLowLabel.textAlignment = .center
        highLowLabel.numberOfLines = 1
        highLowLabel.font = .boldSystemFont(ofSize: 20)
        highLowLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        pageView.addSubview(verticalStack)
        verticalStack.addArrangedSubview(locationLabel)
        verticalStack.addArrangedSubview(tempLabel)
        verticalStack.addArrangedSubview(weatherLabel)
        verticalStack.addArrangedSubview(highLowLabel)
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: pageView.safeAreaLayoutGuide.topAnchor, constant: 50),
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
            tenDayForcastView.heightAnchor.constraint(equalToConstant: 337),
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
            moonView.bottomAnchor.constraint(equalTo: pageView.bottomAnchor, constant: -50),
            
            sunsetView.widthAnchor.constraint(equalTo: topRightUIElement.widthAnchor),
            sunsetView.heightAnchor.constraint(equalTo: topRightUIElement.heightAnchor),
            sunsetView.trailingAnchor.constraint(equalTo: topRightUIElement.trailingAnchor),
            sunsetView.topAnchor.constraint(equalTo: topRightUIElement.bottomAnchor, constant: 40),
            sunsetView.bottomAnchor.constraint(equalTo: pageView.bottomAnchor, constant: -50)
        ])
        
        
        return (moonView, sunsetView)
        
        
    }
    
    func configureScrollView() {
        weatherView.backgroundColor = .clear
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        
        weatherScroll.backgroundColor = .clear
        
        // this will allow the height of the contentsize to adjust based one what was placed, i just have ot make sure for the top elemnt to be anchor to the top of weatheview and the bottom elements ot be anchor to the bottom of weatherview
        weatherScroll.contentSize = .init(width: view.frame.width, height: weatherView.frame.height)
        weatherScroll.showsVerticalScrollIndicator = false
        weatherScroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherScroll)
        
        NSLayoutConstraint.activate([
            weatherScroll.topAnchor.constraint(equalTo: toolBar.bottomAnchor),
            weatherScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        weatherScroll.addSubview(weatherView)
        NSLayoutConstraint.activate([
            weatherView.leadingAnchor.constraint(equalTo: weatherScroll.leadingAnchor),
            weatherView.topAnchor.constraint(equalTo: weatherScroll.topAnchor),
            weatherView.trailingAnchor.constraint(equalTo: weatherScroll.trailingAnchor),
            weatherView.bottomAnchor.constraint(equalTo: weatherScroll.bottomAnchor),
            
            
            
            weatherView.widthAnchor.constraint(equalToConstant: weatherScroll.contentSize.width),
            // height not set cause it will be determined when all the UIelements for the weatherview is placed, the contentsize will dynamically adjust for the weatheerviews height
        ])
        
        let forecastStack = setForecastLabels(pageView: weatherView)
        
        let forecastView = setForcastView(pageView: weatherView, topUIElement: forecastStack)
        
        let tenForecastView = setTenDayForcastView(pageView: weatherView, topUIElement: forecastView)
        
        let humidFeelsViewsTuple = setHumidityAndFeelsLike(pageView: weatherView, topUIElement: tenForecastView)
        
        let moonSunsetViewsTuple = setMoonPhaseAndSunset(pageView: weatherView, topLeftUIElement: humidFeelsViewsTuple.0, topRightUIElement: humidFeelsViewsTuple.1)
        
        configureViewsContents(dayForecast: forecastView, tenDayForcast: tenForecastView, humidity: humidFeelsViewsTuple.0, feelsLike: humidFeelsViewsTuple.1, moonPhase: moonSunsetViewsTuple.0, sunsetTime: moonSunsetViewsTuple.1)
        
        
        
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

extension SingularWeatherPageVC: UIToolbarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension SingularWeatherPageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForcastData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath) as! HourlyForecastCell
        
        if !hourlyForcastData.isEmpty {
            if indexPath.row != 0 {
                let timeZoneID = hourlyForcastData[0].time
                let localTime = hourlyForcastData[indexPath.row].time
                let hourString = convertStringToLocalHourTime(localTimeString: localTime, timeZoneIdentifier: timeZoneID)
                
                var dexample: Decimal = hourlyForcastData[indexPath.row].tempF
                var drounded: Decimal = Decimal()
                NSDecimalRound(&drounded, &dexample, 0, .plain)
                let tempString = "\(drounded)°"
                
                var weatherImage = UIImage()
                if hourlyForcastData[indexPath.row].isDay == 1 {
                    let code = hourlyForcastData[indexPath.row].condition.code
                    weatherImage = weatherCodeDayDict[code]!
                }
                else {
                    let code = hourlyForcastData[indexPath.row].condition.code
                    weatherImage = weatherCodeNightDict[code]!
                }
                
                collectionCell.setPictureAndText(hour: hourString!, temp: tempString, weatherIcon: weatherImage)
            }
            
            else {
                
                var dexample: Decimal = hourlyForcastData[indexPath.row].tempF
                var drounded: Decimal = Decimal()
                NSDecimalRound(&drounded, &dexample, 0, .plain)
                let tempString = "\(drounded)°"
                
                var weatherImage = UIImage()
                if hourlyForcastData[indexPath.row].isDay == 1 {
                    let code = hourlyForcastData[indexPath.row].condition.code
                    weatherImage = weatherCodeDayDict[code]!
                }
                else {
                    let code = hourlyForcastData[indexPath.row].condition.code
                    weatherImage = weatherCodeNightDict[code]!
                }
                
                collectionCell.setPictureAndText(hour: "Now", temp: tempString, weatherIcon: weatherImage)
            }
            
        }
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 6.5, height: collectionView.frame.height)
    }
    
    
}


extension SingularWeatherPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tenDayForcastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! TenDayForecastCell
        
        cell.backgroundColor = .clear
        
        if !tenDayForcastData.isEmpty {
            var lowDecimal: Decimal = tenDayForcastData[indexPath.row].day.mintempF
            var lowDrounded: Decimal = Decimal()
            NSDecimalRound(&lowDrounded, &lowDecimal, 0, .plain)
            let lowString = "L:\(lowDrounded)° "
            
            var highDecimal: Decimal = tenDayForcastData[indexPath.row].day.maxtempF
            var highDrounded: Decimal = Decimal()
            NSDecimalRound(&highDrounded, &highDecimal, 0, .plain)
            let highString = "H:\(highDrounded)°"
            
            let highLowString = lowString + highString
            let iconImage = weatherCodeDayDict[tenDayForcastData[indexPath.row].day.condition.code]!
            
            if indexPath.row != 0 {
                let dayString = tenDayForcastData[indexPath.row].date
                let finalDayString = convertStringToDayOfTheWeek(timeString: dayString)!
                
                cell.setTenLabelsAndPicture(day: finalDayString, highLow: highLowString, icon: iconImage)
            }
            else {
                cell.setTenLabelsAndPicture(day: "Today", highLow: highLowString, icon: iconImage)
            }
        }
        

        
        
        return cell
        
    }

}
