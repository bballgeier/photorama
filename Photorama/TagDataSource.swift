//
//  TagDataSource.swift
//  Photorama
//
//  Created by Ben Allgeier on 10/28/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

import UIKit
import CoreData

class TagDataSource: NSObject, UITableViewDataSource {
    
    var tags: [NSManagedObject] = []
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    } // end tableView(_:numberOfRowsInSection:)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let tag = tags[indexPath.row]
        let name = tag.value(forKey: "name") as! String
        cell.textLabel?.text = name
        
        return cell
    } // end tableView(_:cellForRowAt:)
    
} // end class TagDataSource
