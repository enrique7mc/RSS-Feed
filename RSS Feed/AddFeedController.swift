//
//  AddFeedController.swift
//  RSS Feed
//
//  Created by admin on 27/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class AddFeedController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addAction(sender: AnyObject) {
        
    }
}
