//
//  TagsViewController.swift
//  Photorama
//
//  Created by Ben Allgeier on 10/28/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

import UIKit
import CoreData

class TagsViewController: UITableViewController {
    
    var store: PhotoStore!
    var photo: Photo!
    
    var selectedIndexPaths = [IndexPath]()
    
    let tagDataSource = TagDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = tagDataSource
        tableView.delegate = self // doesn't this automatically happen in UITableViewController?
        updateTags()
    } // end viewDidLoad
    
    // MARK: - Methods
    
    func updateTags() {
        let tags = try! store.fetchMainQueueTags(predicate: nil, sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
        tagDataSource.tags = tags
        
        // update selectedIndexPaths with the indices of tags for the photo
        for tag in photo.tags {
            if let index = tagDataSource.tags.index(of: tag) {
                let indexPath = IndexPath(row: index, section: 0)
                selectedIndexPaths.append(indexPath)
            } // end if let
        } // end for
    } // end updateTags
    
    // MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tag = tagDataSource.tags[indexPath.row]
        
        if let index = selectedIndexPaths.index(of: indexPath) {
            selectedIndexPaths.remove(at: index)
            photo.removeTagObject(tag)
        } // end if let
        else {
            selectedIndexPaths.append(indexPath)
            photo.addTagObject(tag)
        } // end else
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        do {
            try store.coreDataStack.saveChanges()
        } // end do
        catch let error {
            print("Core Data save failed: \(error)")
        } // end catch
    } // end tableView(_:didSelectRowAt:)
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if selectedIndexPaths.index(of: indexPath) != nil {
            cell.accessoryType = .checkmark
        } // end if
        else {
            cell.accessoryType = .none
        } // end else
    } // end tableView(_:willDisplay:forRowAt:)
    
    // MARK: - Action methods
    
    @IBAction func done(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    } // end done(_:)
    
    @IBAction func addNewTag(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Add Tag", message: nil, preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "tag name"
            textField.autocapitalizationType = .words
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            if let tagName = alertController.textFields?.first!.text {
                let context = self.store.coreDataStack.mainQueueContext
                let newTag = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: context)
                newTag.setValue(tagName, forKey: "name")
                
                do {
                    try self.store.coreDataStack.saveChanges()
                } // end do
                catch let error {
                    print("Core Data save failed: \(error)")
                } // end catch
                self.updateTags()
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            } // end if let
        })
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    } // end addNewTag(_:)
    
} // end class TagsViewController
