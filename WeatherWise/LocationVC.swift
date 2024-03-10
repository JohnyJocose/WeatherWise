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
    
    var editButton = UIBarButtonItem()
    

    
    var mainDelegate: MainVC!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        navigationItem.hidesBackButton = true
        usersInfo.locationDelegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name:  UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
            usersInfo.deleteAllCoreData()
            usersInfo.addAllLocationsToCoreData()
            mainDelegate.updateScrollView()
            sender.tintColor = .white
            locationTable.isEditing = false
        }
        else {
            
            if usersInfo.isLocationEnabled() {
                if usersInfo.returnUsersLocationsCount() != 1 {
                    sender.tintColor = .gray
                    locationTable.isEditing = true
                }
            }
            
            if !usersInfo.isLocationEnabled() {
                if usersInfo.returnUsersLocationsCount() != 0 {
                    sender.tintColor = .gray
                    locationTable.isEditing = true
                }
            }
            
            
        }
    }
    
    func changeTableEditing(status:Bool) {
        locationTable.isEditing = status
    }
    
    
    

    func configureNavBar() {
        navigationItem.title = "Weather"

        editButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(buttonPressed(_:)))
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
        if let mainDelegate {
            mainDelegate.changeScrollViewBasedOnArray(index: indexPath.row)
            mainDelegate.changeNumberOfPagesInPageControl(arrayCount: usersInfo.returnUsersLocationsCount(), currentPage: indexPath.row)
        }
        
        navigationController?.popViewController(animated: true)
        
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
        
        if usersInfo.isLocationEnabled() {
            if indexPath.row == 0 {
                return false
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if usersInfo.isLocationEnabled() {
            if proposedDestinationIndexPath.row == 0 {
                return IndexPath.init(row: 1, section: proposedDestinationIndexPath.section)
            }
        }
        
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completionHandler) in
            
            
            tableView.beginUpdates()
            usersInfo.deleteLocation(at: indexPath.row)
            usersInfo.forecastWeatherPages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            
            
            if usersInfo.isLocationEnabled() {
                // These will check if there's nothing in the edit section.
                if usersInfo.returnUsersLocationsCount() == 1 {
                    editButton.tintColor = .white
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [self] in
                        locationTable.isEditing = false
                    })
                }
            }
                
            if !usersInfo.isLocationEnabled() {
                // These will check if there's nothing in the edit section.
                if usersInfo.returnUsersLocationsCount() == 0 {
                    editButton.tintColor = .white
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [self] in
                        locationTable.isEditing = false
                    })
                }
            }
            
            mainDelegate.updateScrollView()
            usersInfo.deleteAllCoreData()
            usersInfo.addAllLocationsToCoreData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let removedElement = usersInfo.removeLocation(at: sourceIndexPath.row)
        usersInfo.insertRemovedLocation(removedLocation: removedElement, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            usersInfo.deleteLocation(at: indexPath.row)
            usersInfo.forecastWeatherPages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            if usersInfo.isLocationEnabled() {
                
                if usersInfo.returnUsersLocationsCount() == 1 {
                    // These will check if there's nothing in the edit section.
                    editButton.tintColor = .white
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [self] in
                        locationTable.isEditing = false
                    })
                }
            }
            
            if !usersInfo.isLocationEnabled() {
                if usersInfo.returnUsersLocationsCount() == 0 {
                    // These will check if there's nothing in the edit section.
                    editButton.tintColor = .white
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [self] in
                        locationTable.isEditing = false
                    })
                }
            }
            
            usersInfo.deleteAllCoreData()
            usersInfo.addAllLocationsToCoreData()
            
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
