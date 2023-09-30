//
//  TopicView.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 9/27/23.
//

import UIKit

class TopicView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white.withAlphaComponent(0.9)
        layer.cornerRadius = 5
        clipsToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
}
