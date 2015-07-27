//
//  FeedsViewController.swift
//  RSS Feed
//
//  Created by admin on 25/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class FeedsViewController: UITableViewController, RSSAddViewControllerDelegate {
    
    var rssdb: RSSDB!
    var feedIDs: Array<Int>!
    var newFeed: [String : AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "BW RSS"
    }
    
    // MARK: - Table View
    
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
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ItemsSegue" {
            let rssItemsViewController = segue.destinationViewController as! ItemsViewController
            let path = tableView.indexPathForSelectedRow()!
            rssItemsViewController.feedID = feedIDs[path.row]
            rssItemsViewController.rssdb = rssdb
        }
        else if segue.identifier == "ToAddView" {
            let addFeedViewController = segue.destinationViewController as! AddFeedViewController
            addFeedViewController.delegate = self
        }
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
    
    private func loadNewFeed() {
        if let newFeed = self.newFeed {
            self.newFeed = nil
            let rc = rssdb.addFeedRow(newFeed)
            let idx = indexPathForDBRec(newFeed)
            if let indexPath = idx {
                if rc == nil { // inserted new row
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
                }
                tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)
                if rc != nil {
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
                }
            }
        }
    }
    
    private func indexPathForDBRec(dbRec: NSDictionary) -> NSIndexPath? {
        let urlString = dbRec[kRSSDB.feedURL] as! String
        let row = rssdb.getFeedRowByURL(urlString)
        if let rowID = row?[kRSSDB.feedID] as? Int {
            let tempFeedIDs = rssdb.getFeedIDs() as NSArray
            return NSIndexPath(forRow: tempFeedIDs.indexOfObject(rowID), inSection: 0)
        } else {
            return nil
        }
    }
    
    // MARK: RSSAddViewControllerDelegate methods
    
    func haveAddViewRecord(avRecord: [String : AnyObject]) {
        self.newFeed = avRecord;
        loadNewFeed()
    }
    
    func haveAddViewError(error: NSError) {
        let alertView = UIAlertView(title: "URL Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func addViewMessage(message: String) {
        let alertView = UIAlertView(title: "BW RSS", message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
}
