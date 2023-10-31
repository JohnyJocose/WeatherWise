//
//  LocationVC.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 10/1/23.
//

import UIKit

class LocationVC: UIViewController {

    
    let locationTable = UITableView(frame: .zero, style: .plain)
    let searchBarController = UISearchController(searchResultsController: SearchVC())
    
    //var delegate: MainVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    
    func configureUI () {
        view.backgroundColor = .systemBackground
        configureNavBar()
        configureTable()
        
        
    }
    
    func configureTable() {
        locationTable.delegate = self
        locationTable.dataSource = self
        locationTable.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        
        locationTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationTable)
        NSLayoutConstraint.activate([
            locationTable.topAnchor.constraint(equalTo: view.topAnchor),
            locationTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            locationTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            locationTable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func reloadTable() {
        locationTable.reloadData()
    }
    
    @objc func buttonPressed(_ sender:UIButton) {
        if locationTable.isEditing {
            locationTable.isEditing = false
        }
        else {
            locationTable.isEditing = true
        }
    }
    

    func configureNavBar() {
        navigationItem.title = "Weather"
        let editButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(buttonPressed(_:)))
        editButton.tintColor = .white
        navigationItem.rightBarButtonItem = editButton
        
        
        
        searchBarController.obscuresBackgroundDuringPresentation = true
        searchBarController.searchResultsUpdater = self
        self.navigationItem.searchController = searchBarController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        

    }





}

extension LocationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //navigationController?.dismiss(animated: true)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersInfo.returnUsersLocationsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = usersInfo.returnLocationNameForLocationVC(at: indexPath.row)
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0 {
            return IndexPath.init(row: 1, section: proposedDestinationIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let removedElement = usersInfo.removeLocation(at: sourceIndexPath.row)
        usersInfo.insertRemovedLocation(removedLocation: removedElement, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            usersInfo.deleteLocation(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }

}

extension LocationVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        let vc = searchController.searchResultsController as! SearchVC
        vc.delegate = self
        vc.updateUsingSearchBarsText(text: text)
        
    }
    
    
}
