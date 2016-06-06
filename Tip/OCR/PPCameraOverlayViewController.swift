//
//  PPCameraOverlayViewController.swift
//  Tip
//
//  Created by Johnny Pham on 6/5/16.
//  Copyright © 2016 Johnny Pham. All rights reserved.
//


import MicroBlink

class PPCameraOverlayViewController: PPOverlayViewController {
  var tourchOn : Bool = false;
  override func viewDidLoad() {
    super.viewDidLoad()
    self.scanningRegion = CGRectMake(0.15, 0.45, 0.7, 0.1)
    
    // Do any additional setup after loading the view.
  }
  
  
  @IBAction func onTapClose(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
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
  
}
