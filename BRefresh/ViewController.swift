//
//  ViewController.swift
//  BRefresh
//
//  Created by 猫狩 on 15/10/21.
//  Copyright © 2015年 brant. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    


    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let header = BRefreshView(frame: CGRect(x: 0, y: -50, width: UIScreen.main.bounds.size.width, height: 50))
        self.tableView.addPullToRefresh(refreshView: header) { () -> Void in
            
            
            DispatchQueue.global().async {
                Thread.sleep(forTimeInterval: 5)
                DispatchQueue.main.async {
                    
                    self.tableView.endRefreshing()
                    
                }
                
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Identifier = "identifier"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: Identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: Identifier)
        }
        
        cell?.textLabel?.text = "xxx"
        
        return cell!
    }

}

