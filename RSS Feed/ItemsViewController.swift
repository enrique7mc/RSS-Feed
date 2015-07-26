//
//  ItemsViewController.swift
//  RSS Feed
//
//  Created by admin on 25/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var rssdb : RSSDB!
    var feedID : NSNumber!
    var feedRecord : Dictionary<NSObject, AnyObject>?
    var itemRowIDs : NSArray?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.rowHeight = 55.0
        rssdb.deleteOldItems(feedID)
        loadFeedRecord()
        if let title = feedRecord?[kRSSDB.feedTitle] as! String? {
            self.title = title
        } else {
            self.title = "Feed"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeed()
    }
    
    // MARK: Table view
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemRowIDs = rssdb.getItemIDs(feedID)
        return itemRowIDs!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! UITableViewCell
        
        // Get the feed item
        let itemID = itemRowIDs![indexPath.row] as! NSNumber
        let thisFeedItem = rssdb.getItemRow(itemID)
        
        // Clever variable font size trick
        let systemFontSize = UIFont.labelFontSize()
        let headFontSize = systemFontSize * 0.9
        let smallFontSize = systemFontSize * 0.8
        let widthOfCell = tableView.rectForRowAtIndexPath(indexPath).size.width - 40.0
        
        if let itemText = thisFeedItem[kRSSDB.itemTitle] as? String {
            cell.textLabel?.numberOfLines = 2
            if itemText.sizeWithAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(headFontSize)]).width > widthOfCell {
                cell.textLabel?.font = UIFont.boldSystemFontOfSize(smallFontSize)
            } else {
                cell.textLabel?.font = UIFont.boldSystemFontOfSize(headFontSize)
            }
            cell.textLabel?.text = itemText
        }
        
        // Format the date -- this goes in the detailTextLabel property, which is the "subtitle" of the cell
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(smallFontSize)
        cell.detailTextLabel?.text = dateToLocalizedString(SQLDateToDate(thisFeedItem[kRSSDB.itemPubDate] as! String))
        
        cell.layoutIfNeeded()
        return cell
    }
    
    // MARK: Support functions
    
    private func loadFeed() {
        let loaditems = LoadItems(db: rssdb, feedID: feedID, tableView: self)
    }
    
    private func loadFeedRecord() -> NSDictionary {
        if feedRecord == nil { feedRecord = rssdb.getFeedRow(feedID) }
        return feedRecord!
    }
    
    // MARK: Error Handling
    
    func handleError(error: NSError) {
        let errorMessage = error.localizedDescription
        if error.domain == NSXMLParserErrorDomain && error.code >= 10 {
            alertMessage("Cannot parse feed: \(errorMessage)")
        } else {
            alertMessage(errorMessage)
        }
    }
    
    func alertMessage(message: String) {
        let alertView = UIAlertView(title: "BW RSS", message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
        navigationController?.popViewControllerAnimated(true)
    }
    
}
