//
//  ViewController.swift
//  BRefresh
//
//  Created by 猫狩 on 15/10/21.
//  Copyright © 2015年 brant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let header = BRefreshView(frame: CGRectMake(0, -50, UIScreen.mainScreen().bounds.size.width, 50))
        self.tableView.addPullToRefresh(header) { () -> Void in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                NSThread.sleepForTimeInterval(5)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.endRefreshing()
                })
                
            })
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Identifier = "identifier"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(Identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: Identifier)
        }
        
        cell?.textLabel?.text = "xxx"
        
        return cell!
    }

}

