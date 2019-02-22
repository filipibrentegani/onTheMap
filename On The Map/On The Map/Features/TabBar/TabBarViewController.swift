//
//  TabBarViewController.swift
//  On The Map
//
//  Created by Filipi Brentegani on 20/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class TabBarViewController: UITabBarController {

    
    // MARK: - Constants
    
    // MARK: - Enums
    
    // MARK: - Properties
    
    private let mapBusiness = MapBusiness()
    private var studentLocationsDelegates = [StudentLocationsUpdateDelegate]()
    
    // MARK: - Initializers
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewControllers = viewControllers {
            for viewController in viewControllers {
                if let viewController = viewController as? StudentLocationsUpdateDelegate {
                    studentLocationsDelegates.append(viewController)
                }
            }
        }
        requestLocations()
    }
    
    // MARK: - Actions
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    private func requestLocations() {
        mapBusiness.requestLocations { [weak self] response in
            do {
                if let mkPoints = try response(), let delegates = self?.studentLocationsDelegates {
                    for delegate in delegates {
                        delegate.reloadScreenData(mkPoints)
                    }
                }
            } catch {
                print("error: \(error)")
                //TODO show error
            }
        }
    }
    
    // MARK: - Deinitializers


}

// MARK: - Extensions

extension TabBarViewController: NeedsRefreshDelegate {
    func needsRefresh() {
        requestLocations()
    }
}
