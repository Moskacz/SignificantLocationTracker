//
//  ViewController.swift
//  SignificantLocationTracker
//
//  Created by Michal Moskala on 18/10/2019.
//  Copyright © 2019 Michal Moskala. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private let frc: NSFetchedResultsController<Location>
    
    @IBOutlet weak var tableView: UITableView!
    private let locationCellReuseID = "locationCell"
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    init?(coder: NSCoder, context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Location.timestamp, ascending: false)]
        self.frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! frc.performFetch()
        frc.delegate = self
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return frc.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.fetchedObjects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: locationCellReuseID, for: indexPath) as! LocationCell
        let location = frc.object(at: indexPath)
        cell.update(with: location, dateFormatter: formatter)
        return cell
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .update: tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .insert: tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete: tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move: tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default: fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert: tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete: tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default: fatalError()
        }
    }
}

extension LocationCell {
    
    fileprivate func update(with location: Location, dateFormatter: DateFormatter) {
        longitudeLabel.text = String(location.longitude)
        latitudeLabel.text = String(location.latitude)
        timestampLabel.text = dateFormatter.string(from: location.timestamp)
    }
}
