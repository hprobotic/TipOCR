//
//  HistoryViewController.swift
//  Tip
//
//  Created by Johnny Pham on 6/6/16.
//  Copyright © 2016 Johnny Pham. All rights reserved.
//

import UIKit
import CoreData
class HistoryViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  private var resfreshControl: UIRefreshControl!
  private var loadingAdditionalPay = false
  var payList = [NSManagedObject]()
  
  
  var payHistory: NSDictionary = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
    
    resfreshControl = UIRefreshControl()
    resfreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(resfreshControl, atIndex: 0)
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let fetchRequest = NSFetchRequest(entityName: "PayList")
    do {
      let results =
        try managedContext.executeFetchRequest(fetchRequest)
      payList = results as! [NSManagedObject]
      self.tableView.reloadData()
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
    
  }
  @IBAction func onBackBtn(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func refreshData() {
    
  }
  
  private func fetchData() {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let fetchRequest = NSFetchRequest(entityName: "PayList")
    do {
      let results =
      try managedContext.executeFetchRequest(fetchRequest)
      payList = results as! [NSManagedObject]
      self.tableView.reloadData()
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }

  
}






extension HistoryViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}
extension HistoryViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return payList.count
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("payCell") as! PayCell
    let payItem = payList[indexPath.row]
    print(payItem)
    cell.payAmount!.text = payItem.valueForKey("billAmount") as? String
    
    return cell
  }

}