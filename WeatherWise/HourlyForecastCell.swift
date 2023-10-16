//
//  HourlyForecastCell.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 9/30/23.
//

import UIKit

class HourlyForecastCell: UICollectionViewCell {
    
    let hourLabel = UILabel()
    let weatherImageView = UIImageView()
    let tempLabel = UILabel()
    
    // Need to put functions here that are called when the cell is created
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAndSetUI()
    }
    
    // Needed in order to have the function above
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // Every time a cell is being reused, we call this function below because of UICollectionViewDelegate and UICollectionViewDataSource
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherImageView.image = UIImage()
        hourLabel.text = ""
        tempLabel.text = ""
    }
    
    func setPictureAndText(hour: String, temp: String, weatherIcon: UIImage) {
        hourLabel.text = hour
        tempLabel.text = temp
        weatherImageView.image = weatherIcon
    }
    
    func configureAndSetUI() {
        configureHourLabel()
        configureTempLabel()
        configureWeatherImageView()
    }
    
    func configureHourLabel() {
        //hourLabel.text = "12PM"
        hourLabel.font = .systemFont(ofSize: 18)
        hourLabel.textAlignment = .center
        hourLabel.numberOfLines = 1
        hourLabel.textColor = .black
        hourLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(hourLabel)
        NSLayoutConstraint.activate([
            hourLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hourLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hourLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1.5/4),
            hourLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    func configureTempLabel() {
        //tempLabel.text = "92°"
        tempLabel.font = .boldSystemFont(ofSize: 20)
        tempLabel.textAlignment = .center
        tempLabel.numberOfLines = 1
        tempLabel.textColor = .black
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(tempLabel)
        NSLayoutConstraint.activate([
            tempLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tempLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1.5/4),
            tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureWeatherImageView() {
        weatherImageView.contentMode = .center
        weatherImageView.tintColor = .black
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false


        contentView.addSubview(weatherImageView)

        NSLayoutConstraint.activate([
            weatherImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            weatherImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            weatherImageView.topAnchor.constraint(equalTo: hourLabel.bottomAnchor),
            weatherImageView.bottomAnchor.constraint(equalTo: tempLabel.topAnchor)
        ])
    }
    
}
