//
//  SearchVC.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 10/5/23.
//

import UIKit

class CityClass {
    let city: String
    let region: String
    let country: String
    let lat: Decimal
    let lon: Decimal
    
    init(city: String, region: String, country: String, lat: Decimal, lon: Decimal) {
        self.city = city
        self.region = region
        self.country = country
        self.lat = lat
        self.lon = lon
    }
}

class SearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var searchData: [CityClass] = []
    
    let areaTableView = UITableView()
    
    var delegate: LocationVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureTable()
    }
    
    func updateUsingSearchBarsText(text: String) {
        Task {
            
            let result = try await searchJson.getSearchDataAsync(area: text)
            
            searchData.removeAll()
            areaTableView.reloadData()
            
            if !result.isEmpty{
                for searchResult in result {
                    searchData.append(CityClass(city: searchResult.name, region: searchResult.region, country: searchResult.country, lat: searchResult.lat, lon: searchResult.lon))
                }
            }
            
            areaTableView.reloadData()
        }
    }
    
    
    func configureTable() {
        areaTableView.delegate = self
        areaTableView.dataSource = self
        areaTableView.register(UITableViewCell.self, forCellReuseIdentifier: "areaCell")
        areaTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(areaTableView)
        NSLayoutConstraint.activate([
            areaTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            areaTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            areaTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            areaTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "areaCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let city = searchData[indexPath.row].city
        let region = searchData[indexPath.row].region
        content.text = "\(city), \(region)"
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let vc = SingularWeatherPageVC()
        vc.delegate = self
        vc.locationClass = searchData[indexPath.row]
        present(vc, animated: true)
        
    }

}
