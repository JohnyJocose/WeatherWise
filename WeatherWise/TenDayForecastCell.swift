//
//  TenDayForecastCell.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 9/30/23.
//

import UIKit

class TenDayForecastCell: UITableViewCell {
    
    let cellView = UIView()
    let dayLabel = UILabel()
    let weatherIcon = UIImageView()
    let highLowLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTenLabelsAndPicture(day: String, highLow: String, icon: UIImage) {
        dayLabel.text = day
        highLowLabel.text = highLow
        weatherIcon.image = icon
    }
    
    func configureUI() {
        configureWeatherIcon()
        configureDayLabel()
        configureHighLowLabel()
        
    }
    
    func configureCellView() {
        cellView.backgroundColor = .clear
        cellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cellView)
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
    }
    
    func configureWeatherIcon() {
        weatherIcon.image = .day
        weatherIcon.tintColor = .black
        weatherIcon.contentMode = .center
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(weatherIcon)
        
        NSLayoutConstraint.activate([
            weatherIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIcon.heightAnchor.constraint(equalToConstant: contentView.frame.height),
            weatherIcon.widthAnchor.constraint(equalToConstant: contentView.frame.height)
        ])
    }
    
    func configureDayLabel() {
        dayLabel.text = "Today"
        dayLabel.textAlignment = .left
        dayLabel.numberOfLines = 1
        dayLabel.textColor = .black
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dayLabel)
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            dayLabel.trailingAnchor.constraint(equalTo: weatherIcon.leadingAnchor),
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureHighLowLabel() {
        highLowLabel.text = "L:0° H:107°"
        highLowLabel.textAlignment = .right
        highLowLabel.numberOfLines = 1
        highLowLabel.textColor = .black
        highLowLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(highLowLabel)
        NSLayoutConstraint.activate([
            highLowLabel.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor),
            highLowLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            highLowLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            highLowLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    

}
