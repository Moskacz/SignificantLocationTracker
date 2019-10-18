//
//  LocationManagerHandler.swift
//  SignificantLocationTracker
//
//  Created by Michal Moskala on 18/10/2019.
//  Copyright © 2019 Michal Moskala. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class LocationManagerHandler: NSObject {
    
    private let locationManager: CLLocationManager
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.locationManager = CLLocationManager()
        self.context = context
        super.init()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.delegate = self
    }
}

extension LocationManagerHandler: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
            startMonitoringSignificantLocationChanges()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        context.perform {
            locations.forEach {
                let coreDataLocation = Location(context: self.context)
                coreDataLocation.latitude = $0.coordinate.latitude
                coreDataLocation.longitude = $0.coordinate.longitude
                coreDataLocation.timestamp = $0.timestamp
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    private func startMonitoringSignificantLocationChanges() {
        locationManager.startMonitoringSignificantLocationChanges()
    }
}
