//
//  PinsListViewController.swift
//  On The Map
//
//  Created by Filipi Brentegani on 20/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class PinsListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    // MARK: - Constants
    
    // MARK: - Enums
    
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView?
    
    private var mkPointsAnnotations: [MKPointAnnotation]?
    
    // MARK: - Initializers
    
    // MARK: - Override
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "AddLocation" {
            if let viewController = segue.destination as? AddLocationViewController, let tabBarController = tabBarController as? NeedsRefreshDelegate {
                viewController.needsRefreshDelegate = tabBarController
            }
        }
    }
    
    // MARK: - Actions
    @IBAction private func reloadAction(_ sender: Any) {
        if let tabBarController = tabBarController as? NeedsRefreshDelegate {
            tabBarController.needsRefresh()
        }
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - Deinitializers


}

// MARK: - Extensions

extension PinsListViewController: StudentLocationsUpdateDelegate {
    func reloadScreenData(_ mkPointAnnotations: [MKPointAnnotation]) {
        mkPointsAnnotations = mkPointAnnotations
        tableView?.reloadData()
    }
}

extension PinsListViewController: UITableViewDelegate {

}

extension PinsListViewController: UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mkPointsAnnotations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath) as UITableViewCell
        if let mkPointsAnnotations = mkPointsAnnotations {
            let mkPointAnnotations = mkPointsAnnotations[indexPath.row]
            
            cell.textLabel?.text = ("\(mkPointAnnotations.title ?? "NO NAME") - \(mkPointAnnotations.subtitle ?? "NO LINK")")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mkPointsAnnotations = mkPointsAnnotations {
            let mkPointAnnotations = mkPointsAnnotations[indexPath.row]
            guard let url = URL(string: mkPointAnnotations.subtitle ?? "") else { return }
            UIApplication.shared.open(url)
        }
    }
}
