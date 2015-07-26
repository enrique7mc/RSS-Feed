//
//  FeedsViewController.swift
//  RSS Feed
//
//  Created by admin on 25/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class FeedsViewController: UITableViewController {
    
    var rssdb: RSSDB!
    var feedIDs: Array<Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "BW RSS"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadFeedIDs()
        return feedIDs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! UITableViewCell
        
        loadFeedIDsIfEmpty()
        let feedRow = rssdb.getFeedRow(feedIDs[indexPath.row])
        
        if let textlabel = cell.textLabel {
            textlabel.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
            textlabel.text = feedRow[kRSSDB.feedTitle] as? String
        }
        
        if let detaillabel = cell.detailTextLabel {
            detaillabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
            detaillabel.text = feedRow[kRSSDB.feedDesc] as? String
        }
        
        cell.layoutIfNeeded() // make sure the cell is properly rendered
        return cell
    }
    
    // MARK: Database methods
    
    private func loadFeedIDs() -> Array<Int> {
        loadDB()
        feedIDs = rssdb.getFeedIDs() as! Array<Int>
        return feedIDs
    }
    
    private func loadFeedIDsIfEmpty() -> Array<Int> {
        loadDB()
        if feedIDs == nil || feedIDs.count == 0 {
            feedIDs = rssdb.getFeedIDs() as! Array<Int>
        }
        return feedIDs
    }
    
    private func loadDB() -> RSSDB {
        if rssdb == nil {
            rssdb = RSSDB(RSSDBFilename: "bwrss.db")
        }
        return rssdb
    }
}
