//
//  WeatherView.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 10/20/23.
//

import UIKit

class WeatherView: UIView {
    let verticalStack = UIStackView()
    let locationLabel = UILabel()
    let tempLabel = UILabel()
    let weatherLabel = UILabel()
    let highLowLabel = UILabel()
    
    var timeZoneName = ""
    
    var hourlyForecastCollectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        return collectionView
    }()
    
    let threeDayForecastTableView = UITableView()
    
    
    let hourlyForecastView = TopicView()
    var hourForecastData: [HourResult] = []
    
    let threeDayForecastView = TopicView()
    var threeDayForecastData: [ForecastDayResult] = []
    
    let humidityView = TopicView()
    let humidityLabel = UILabel()
    let feelsLikeView = TopicView()
    let feelsLikeLabel = UILabel()
    
    let moonView = TopicView()
    let moonPhaseImageView = UIImageView()
    let sunsetView = TopicView()
    let sunsetTimeLabel = UILabel()
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        configureForecastStack()
        configureHourlyForecastView()
        configureThreeDayForecastView()
        configureHumidtyAndFeelsLikeViews()
        configureMoonPhaseAndSunsetViews()        
    }
    
    func configureForecastStack() {
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.distribution = .fillProportionally
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        locationLabel.text = "---"
        locationLabel.textColor = .white
        locationLabel.textAlignment = .center
        locationLabel.numberOfLines = 1
        locationLabel.font = .boldSystemFont(ofSize: 25)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tempLabel.text = "--"
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center
        tempLabel.numberOfLines = 1
        tempLabel.font = .boldSystemFont(ofSize: 40)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        weatherLabel.text = "--"
        weatherLabel.textColor = .white
        weatherLabel.textAlignment = .center
        weatherLabel.numberOfLines = 2
        weatherLabel.font = .systemFont(ofSize: 25)
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        
        highLowLabel.text = "L:--°  H:--°"
        highLowLabel.textColor = .white
        highLowLabel.textAlignment = .center
        highLowLabel.numberOfLines = 1
        highLowLabel.font = .boldSystemFont(ofSize: 20)
        highLowLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(verticalStack)
        verticalStack.addArrangedSubview(locationLabel)
        verticalStack.addArrangedSubview(tempLabel)
        verticalStack.addArrangedSubview(weatherLabel)
        verticalStack.addArrangedSubview(highLowLabel)
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            verticalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func configureHourlyForecastView() {
        self.addSubview(hourlyForecastView)
        NSLayoutConstraint.activate([
            hourlyForecastView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 7/8),
            hourlyForecastView.heightAnchor.constraint(equalToConstant: 170),
            hourlyForecastView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hourlyForecastView.topAnchor.constraint(equalTo: verticalStack.bottomAnchor, constant: 40)
        ])
        setHourlyForecastCollectionView()
    }
    
    func setHourlyForecastCollectionView() {
        let titleLabel = UILabel()
        titleLabel.text = "Forecast"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        hourlyForecastView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: hourlyForecastView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: hourlyForecastView.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 29),
            titleLabel.topAnchor.constraint(equalTo: hourlyForecastView.topAnchor, constant: 8)
        ])
        
        
        hourlyForecastCollectionView.backgroundColor = .clear
        hourlyForecastCollectionView.delegate = self
        hourlyForecastCollectionView.dataSource = self
        hourlyForecastCollectionView.showsHorizontalScrollIndicator = false
        hourlyForecastCollectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: "hourCell")
        
        hourlyForecastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        hourlyForecastView.addSubview(hourlyForecastCollectionView)
        NSLayoutConstraint.activate([
            hourlyForecastCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            hourlyForecastCollectionView.bottomAnchor.constraint(equalTo: hourlyForecastView.bottomAnchor, constant: -8),
            hourlyForecastCollectionView.leadingAnchor.constraint(equalTo: hourlyForecastView.leadingAnchor),
            hourlyForecastCollectionView.trailingAnchor.constraint(equalTo: hourlyForecastView.trailingAnchor)
        ])
    }
    
    func configureThreeDayForecastView() {
        self.addSubview(threeDayForecastView)
        NSLayoutConstraint.activate([
            threeDayForecastView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 7/8),
            threeDayForecastView.heightAnchor.constraint(equalToConstant: 337),
            threeDayForecastView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            threeDayForecastView.topAnchor.constraint(equalTo: hourlyForecastView.bottomAnchor, constant: 40)
        ])
        
        setThreeDayTableView()
    }
    
    func setThreeDayTableView() {
        let titleLabel = UILabel()
        titleLabel.text = "Three Day Forecast"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        threeDayForecastView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: threeDayForecastView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: threeDayForecastView.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 29),
            titleLabel.topAnchor.constraint(equalTo: threeDayForecastView.topAnchor, constant: 8)
        ])
        
        threeDayForecastTableView.backgroundColor = .clear
        threeDayForecastTableView.delegate = self
        threeDayForecastTableView.dataSource = self
        threeDayForecastTableView.register(TenDayForecastCell.self, forCellReuseIdentifier: "dayCell")
        threeDayForecastTableView.rowHeight = 100
        threeDayForecastTableView.isScrollEnabled = false
        
        threeDayForecastTableView.translatesAutoresizingMaskIntoConstraints = false
        
        threeDayForecastView.addSubview(threeDayForecastTableView)
        NSLayoutConstraint.activate([
            threeDayForecastTableView.leadingAnchor.constraint(equalTo: threeDayForecastView.leadingAnchor),
            threeDayForecastTableView.trailingAnchor.constraint(equalTo: threeDayForecastView.trailingAnchor),
            threeDayForecastTableView.bottomAnchor.constraint(equalTo: threeDayForecastView.bottomAnchor),
            threeDayForecastTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }
    
    func configureHumidtyAndFeelsLikeViews() {
        self.addSubview(humidityView)
        self.addSubview(feelsLikeView)
        
        NSLayoutConstraint.activate([
            humidityView.widthAnchor.constraint(equalTo: threeDayForecastView.widthAnchor, multiplier: 15/32),
            humidityView.heightAnchor.constraint(equalTo: threeDayForecastView.widthAnchor, multiplier: 15/32),
            humidityView.leadingAnchor.constraint(equalTo: threeDayForecastView.leadingAnchor),
            humidityView.topAnchor.constraint(equalTo: threeDayForecastView.bottomAnchor, constant: 40),
            
            feelsLikeView.widthAnchor.constraint(equalTo: threeDayForecastView.widthAnchor, multiplier: 15/32),
            feelsLikeView.heightAnchor.constraint(equalTo: threeDayForecastView.widthAnchor, multiplier: 15/32),
            feelsLikeView.trailingAnchor.constraint(equalTo: threeDayForecastView.trailingAnchor),
            feelsLikeView.topAnchor.constraint(equalTo: threeDayForecastView.bottomAnchor, constant: 40)
        ])
        setHumidtyUI()
        setFeelsLikeUI()
    }
    
    func setHumidtyUI() {
        humidityLabel.text = "---"
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
    
    func setFeelsLikeUI() {
        feelsLikeLabel.text = "---"
        feelsLikeLabel.font = .boldSystemFont(ofSize: 35)
        feelsLikeLabel.textColor = .black
        feelsLikeLabel.numberOfLines = 1
        feelsLikeLabel.textAlignment = .center
        feelsLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        feelsLikeView.addSubview(feelsLikeLabel)
        NSLayoutConstraint.activate([
            feelsLikeLabel.topAnchor.constraint(equalTo: feelsLikeView.topAnchor),
            feelsLikeLabel.bottomAnchor.constraint(equalTo: feelsLikeView.bottomAnchor),
            feelsLikeLabel.leadingAnchor.constraint(equalTo: feelsLikeView.leadingAnchor),
            feelsLikeLabel.trailingAnchor.constraint(equalTo: feelsLikeView.trailingAnchor)
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

    
    func configureMoonPhaseAndSunsetViews() {
        self.addSubview(moonView)
        self.addSubview(sunsetView)
        
        NSLayoutConstraint.activate([
            moonView.widthAnchor.constraint(equalTo: humidityView.widthAnchor),
            moonView.heightAnchor.constraint(equalTo: humidityView.heightAnchor),
            moonView.leadingAnchor.constraint(equalTo: humidityView.leadingAnchor),
            moonView.topAnchor.constraint(equalTo: humidityView.bottomAnchor, constant: 40),
            moonView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            
            sunsetView.widthAnchor.constraint(equalTo: feelsLikeView.widthAnchor),
            sunsetView.heightAnchor.constraint(equalTo: feelsLikeView.heightAnchor),
            sunsetView.trailingAnchor.constraint(equalTo: feelsLikeView.trailingAnchor),
            sunsetView.topAnchor.constraint(equalTo: feelsLikeView.bottomAnchor, constant: 40),
            sunsetView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50)
        ])
        setMoonPhaseUI()
        setSunsetUI()
    }
    
    func setMoonPhaseUI() {
        moonPhaseImageView.image = UIImage()
        moonPhaseImageView.contentMode = .scaleAspectFit
        moonPhaseImageView.tintColor = .black
        moonPhaseImageView.translatesAutoresizingMaskIntoConstraints = false
        
        moonView.addSubview(moonPhaseImageView)
        NSLayoutConstraint.activate([
            moonPhaseImageView.centerXAnchor.constraint(equalTo: moonView.centerXAnchor),
            moonPhaseImageView.centerYAnchor.constraint(equalTo: moonView.centerYAnchor),
            moonPhaseImageView.widthAnchor.constraint(equalTo: moonView.widthAnchor, multiplier: 1/2),
            moonPhaseImageView.heightAnchor.constraint(equalTo: moonView.widthAnchor, multiplier: 1/2)
        ])
        
        
        let titleLabel = UILabel()
        titleLabel.text = "Moon Phase"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        moonView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: moonView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: moonView.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 29),
            titleLabel.topAnchor.constraint(equalTo: moonView.topAnchor, constant: 8)
        ])
    }
    
    func setSunsetUI() {
        sunsetTimeLabel.text = "--:-- AM"
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
    
    
    
    
    
    // MARK: API/CoreData Functions
    
    func updateTimeZone(timeZoneID: String) {
        timeZoneName = timeZoneID
    }
    
    func updateStackLabels(location: String, temperature: String, weather: String, highLow: String) {
        locationLabel.text = location
        tempLabel.text = temperature
        weatherLabel.text = weather
        highLowLabel.text = highLow
    }
    
    func updateHourData(hourForecast: [HourResult]) {
        hourForecastData = []
        hourlyForecastCollectionView.reloadData()
        hourForecastData = hourForecast
        hourlyForecastCollectionView.reloadData()
    }
    
    func updateThreeDayHourData(threeDayForecast: [ForecastDayResult]) {
        threeDayForecastData = []
        threeDayForecastTableView.reloadData()
        threeDayForecastData = threeDayForecast
        threeDayForecastTableView.reloadData()
        
    }
    
    func updateHumidty(humidity: Int) {
        let humidityString = "\(humidity)%"
        humidityLabel.text = humidityString
    }
    
    func updateFeelsLike(feelsLike: Decimal) {
        
        var feelsDecimal: Decimal = feelsLike
        var feelsDrounded: Decimal = Decimal()
        NSDecimalRound(&feelsDrounded, &feelsDecimal, 0, .plain)
        let feelsString = "\(feelsDrounded)°"
        feelsLikeLabel.text = feelsString
    }
    
    func updateMoonPhase(moonPhase: String) {
        let moonPhaseImage = moonDict[moonPhase]!
        moonPhaseImageView.image = moonPhaseImage
    }
    
    func updateSunset(sunsetTime: String) {
        sunsetTimeLabel.text = sunsetTime
    }
    
    
    
    
    
    
    
    
    
    
    

}


extension WeatherView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        threeDayForecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! TenDayForecastCell
        
        cell.backgroundColor = .clear
        
        cell.selectionStyle = .none
        if !threeDayForecastData.isEmpty {
            var lowDecimal: Decimal = threeDayForecastData[indexPath.row].day.mintempF
            var lowDrounded: Decimal = Decimal()
            NSDecimalRound(&lowDrounded, &lowDecimal, 0, .plain)
            let lowString = "L:\(lowDrounded)° "
            
            var highDecimal: Decimal = threeDayForecastData[indexPath.row].day.maxtempF
            var highDrounded: Decimal = Decimal()
            NSDecimalRound(&highDrounded, &highDecimal, 0, .plain)
            let highString = "H:\(highDrounded)°"
            
            let highLowString = lowString + highString
            let iconImage = weatherCodeDayDict[threeDayForecastData[indexPath.row].day.condition.code]!
            
            if indexPath.row != 0 {
                let dayString = threeDayForecastData[indexPath.row].date
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



extension WeatherView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourForecastData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath) as! HourlyForecastCell
        if !hourForecastData.isEmpty {
            if indexPath.row != 0 {

                let timeZoneID = timeZoneName
                let localTime = hourForecastData[indexPath.row].time
                let hourString = convertStringToLocalHourTime(localTimeString: localTime, timeZoneIdentifier: timeZoneID)
                
                var dexample: Decimal = hourForecastData[indexPath.row].tempF
                var drounded: Decimal = Decimal()
                NSDecimalRound(&drounded, &dexample, 0, .plain)
                let tempString = "\(drounded)°"
                
                var weatherImage = UIImage()
                if hourForecastData[indexPath.row].isDay == 1 {
                    let code = hourForecastData[indexPath.row].condition.code
                    weatherImage = weatherCodeDayDict[code]!
                }
                else {
                    let code = hourForecastData[indexPath.row].condition.code
                    weatherImage = weatherCodeNightDict[code]!
                }
                
                collectionCell.setPictureAndText(hour: hourString!, temp: tempString, weatherIcon: weatherImage)
            }
            
            else {
                
                var dexample: Decimal = hourForecastData[indexPath.row].tempF
                var drounded: Decimal = Decimal()
                NSDecimalRound(&drounded, &dexample, 0, .plain)
                let tempString = "\(drounded)°"
                
                var weatherImage = UIImage()
                if hourForecastData[indexPath.row].isDay == 1 {
                    let code = hourForecastData[indexPath.row].condition.code
                    weatherImage = weatherCodeDayDict[code]!
                }
                else {
                    let code = hourForecastData[indexPath.row].condition.code
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

extension WeatherView {
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
}
