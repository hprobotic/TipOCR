//
//  ViewController.swift
//  Tip
//
//  Created by Johnny Pham on 6/5/16.
//  Copyright © 2016 Johnny Pham. All rights reserved.
//

import UIKit
import MobileCoreServices
import MicroBlink
import CoreData
class MasterViewController: UIViewController, UITextFieldDelegate, PPScanDelegate {
  
  @IBOutlet weak var billAmountField: UITextField!
  @IBOutlet weak var tipPercentage: UISlider!
  @IBOutlet weak var tipPercentageLabel: UILabel!
  @IBOutlet weak var tipAmountLabel: UILabel!
  @IBOutlet weak var tipAmount: UILabel!
  @IBOutlet weak var exactTotalLabel: UILabel!
  
  @IBOutlet weak var defaultTipPercentangeLabel: UILabel!
  @IBOutlet weak var currency: UILabel!
  @IBOutlet weak var billAmountView: UIView!
  @IBOutlet weak var sliderView: UIView!
  @IBOutlet weak var calDetailView: UIView!
  @IBOutlet weak var scanView: UIView!
  @IBOutlet weak var optionsView: UIView!
  @IBOutlet weak var tipPercentageOptionSlider: UISlider!
  var isHideView = true
  var rawOcrParserId : String = "Raw ocr"
  var priceParserId : String = "Price"
  var test : String = ""
  var payItem = [NSManagedObject]()
  var people = [NSManagedObject]()
  
  
  
  // Tip calculator values update
  
  func tipCalValuesUpdate(sY: CGFloat,cY: CGFloat, isScanned: Bool, scannedValue: Int) -> (Double, Double) {
    // Check input amout is valid
    var isInputValid = textField(billAmountField, shouldChangeCharactersInRange: NSRange(location: 3, length: 2), replacementString: "")
    let tipPercentageValue = tipPercentage.value
    tipPercentageLabel.text = String(format: "$%.1f", tipPercentageValue*100)
    if isScanned {
      billAmountField.text = String(scannedValue)
      showElement()
      isHideView = false
      isInputValid = true
    }
    if isInputValid &&  Double(billAmountField.text!) > 0 {
      if isHideView {
        showElement()
        isHideView = false
      }
      let billAmountTotal = Double(billAmountField.text!)
      let tipAmount = billAmountTotal! * Double(tipPercentageValue)
      let exactTotalAmount = billAmountTotal! + tipAmount
      
      tipAmountLabel.text = String(tipAmount.asLocaleCurrency)
      exactTotalLabel.text = String(ceil(exactTotalAmount).asLocaleCurrency)
      
      return (billAmountTotal!, Double(tipPercentageValue))
    } else {
      hideInneedElement()
      tipAmountLabel.text = "$0.00"
      exactTotalLabel.text = "$0.00"
      return(0,0)
    }
    return(0,0)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad() 
    var theLocale: NSLocale = NSLocale.currentLocale()
    let currencySymbol = theLocale.objectForKey(NSLocaleCurrencySymbol)
    currency.text = String("\(currencySymbol!)")
    billAmountField.delegate = self
    billAmountField.keyboardType = .NumberPad
    optionsView.transform = CGAffineTransformMakeTranslation(0, 500)
    sliderView.transform = CGAffineTransformMakeTranslation(0, 500)
    calDetailView.transform = CGAffineTransformMakeTranslation(0, 500)
    
     
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
   
    
    
  }
  override func viewDidDisappear(animated: Bool) {
    
  }
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  func showElement() {
    UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.5, options: [], animations: {
                                self.sliderView.transform = CGAffineTransformMakeScale(1, 1)
      }, completion: nil)
    UIView.animateWithDuration(1, delay: 0.5, usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.5, options: [], animations: {
                                self.calDetailView.transform = CGAffineTransformMakeScale(1, 1)
      }, completion: nil)
    
  }
  func hideInneedElement() {
    UIView.animateWithDuration(1, delay: 0.5, usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.5, options: [], animations: {
                                self.sliderView.transform = CGAffineTransformMakeTranslation(0, 500)
      }, completion: nil)
    UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.5, options: [], animations: {
                                self.calDetailView.transform = CGAffineTransformMakeTranslation(0, 500)
      }, completion: nil)
  }
  
  
  
  
  func showOptions() {
    UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.3, options: [], animations: {
                                self.optionsView.transform = CGAffineTransformMakeScale(1, 1)
      }, completion: nil)
  }
  func hideOptions() {
    UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.3, options: [], animations: {
                                self.optionsView.transform = CGAffineTransformMakeTranslation(0, 500)
      }, completion: nil)
    
  }
  
  
  // Mark: Actions
  
  @IBAction func onOpensSetting(sender: AnyObject) {
    showOptions()
  }
  @IBAction func onSaveOption(sender: AnyObject) {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setDouble(Double(tipPercentageOptionSlider.value), forKey: "default_tip_percentage")
    hideOptions()
    
  }
  @IBAction func onPercentageOptionSliderChanged(sender: AnyObject) {
    defaultTipPercentangeLabel.text = "\(Int(tipPercentageOptionSlider.value*100))%"
  }
  @IBAction func onBillAmoutChanged(sender: AnyObject) {
    let sYOrigin = self.sliderView.frame.origin.y
    let cYOrigin = self.calDetailView.frame.origin.y
    let (billAmount, tipPercentage) = tipCalValuesUpdate(sYOrigin, cY: cYOrigin, isScanned: false, scannedValue: 0)
  }
  
  
  @IBAction func onTap(sender: AnyObject) {
      self.view.endEditing(true)
      hideOptions()
  }
  
  
  @IBAction func onSliderValueChanged(sender: AnyObject) {
    let (billAmount, tipercentate) = tipCalValuesUpdate(0, cY: 0, isScanned: false, scannedValue: 0)
  }
  @IBAction func didTapScan(sender: AnyObject) {
    let error : NSErrorPointer = nil
    let coordinator : PPCoordinator? = self.coordinatorWithError(error)
    
    if(coordinator == nil) {
      let messageString: String = (error.memory?.localizedDescription)!
      UIAlertView(title: "Warning", message: messageString, delegate: nil, cancelButtonTitle: "Ok").show()
      return
    }
    
    /** Present the scanning view controller */
    let overlay: PPCameraOverlayViewController = PPCameraOverlayViewController(nibName: "PPCameraOverlayViewController",bundle: nil)
    let scanningViewController: UIViewController = coordinator!.cameraViewControllerWithDelegate(self,overlayViewController: overlay)
    
    /** You can use other presentation methods as well */
    self.presentViewController(scanningViewController, animated: true, completion: nil)
    
  }
  
  @IBAction func onTapSavePayItem(sender: AnyObject) {
    let (billAmount, tipercentate) = tipCalValuesUpdate(0, cY: 0, isScanned: false, scannedValue: 0)
    savePayItem(billAmount)
  }
  
  
  
  
  
  
  
  
  
  
  // OCR Function
  func coordinatorWithError(error: NSErrorPointer) -> PPCoordinator? {
    
    NSLog("%@", PPCoordinator.getBuildVersionString());
    
    /** 0. Check if scanning is supported */
    
    if (PPCoordinator.isScanningUnsupportedForCameraType(PPCameraType.Back, error: nil)) {
      return nil;
    }
    
    
    /** 1. Initialize the Scanning settings */
    
    // Initialize the scanner settings object. This initialize settings with all default values.
    let settings: PPSettings = PPSettings()
    
    
    /** 2. Setup the license key */
    
    // Visit www.microblink.com to get the license key for your app
    settings.licenseSettings.licenseKey = "FNZ4XQXE-6BHPVPNY-43PITRER-JUTJ5GIB-OFQOZYLF-SCSJETEV-KA42QD4A-PEHZQTXP"
    
    
    /**
     * 3. Set up what is being scanned. See detailed guides for specific use cases.
     * Here's an example for initializing raw OCR scanning.
     */
    
    // To specify we want to perform OCR recognition, initialize the OCR recognizer settings
    let ocrRecognizerSettings = PPBlinkOcrRecognizerSettings()
    
    // We want raw OCR parsing
    let rawOcrFactory = PPRawOcrParserFactory()
    rawOcrFactory.isRequired = true;
    ocrRecognizerSettings.addOcrParser(rawOcrFactory, name: self.rawOcrParserId)
    
    
    // We want to parse prices from raw OCR result as well
    //    let priceOcrFactory = PPPriceOcrParserFactory()
    //    priceOcrFactory.isRequired = true;
    //
    //    ocrRecognizerSettings.addOcrParser(priceOcrFactory, name: self.priceParserId)
    
    
    
    
    
    // Add the recognizer setting to a list of used recognizer
    settings.scanSettings.addRecognizerSettings(ocrRecognizerSettings)
    
    
    /** 4. Initialize the Scanning Coordinator object */
    
    let coordinator: PPCoordinator = PPCoordinator(settings: settings)
    
    return coordinator
  }
  
  
  func scanningViewController(scanningViewController: UIViewController?, didOutputResults results: [PPRecognizerResult]) {
    
    let scanConroller : PPScanningViewController = scanningViewController as! PPScanningViewController
    
    scanConroller.scanningRegion = CGRectMake(0.15, 0.4, 0.7, 0.2)
    scanConroller.autorotate = true
    
    // Here you process scanning results. Scanning results are given in the array of PPRecognizerResult objects.
    
    // first, pause scanning until we process all the results
    scanConroller.pauseScanning()
    // Collect data from the result
    for result in results {
      if(result.isKindOfClass(PPBlinkOcrRecognizerResult)) {
        let ocrRecognizerResult = result as! PPBlinkOcrRecognizerResult
        
        
        //        print("Raw ocr: %@", ocrRecognizerResult.parsedResultForName(self.rawOcrParserId))
        //        print("Price: %@", ocrRecognizerResult.parsedResultForName(self.priceParserId))
        //        let floatValue = ocrRecognizerResult.parsedResultForName(self.self.priceParserId)
        let scannedValue = ocrRecognizerResult.parsedResultForName(self.rawOcrParserId)
        
        let strArr = scannedValue.characters.split{$0 == " "}.map(String.init)
        
        func converStrToNum(strArr: NSArray) -> Int{
          var rtnVal = 0
          for item in strArr {
            let components = item.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let part = components.joinWithSeparator("")
            
            if let intVal = Int(part) {
              rtnVal = intVal
            }
            
          }
          return rtnVal
        }
        let formatedValue = converStrToNum(strArr)
        if formatedValue > 0 { 
          var refreshAlert = UIAlertController(title: "Bill Amout:\(formatedValue)", message: "It oke?", preferredStyle: UIAlertControllerStyle.Alert)
          refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.scanningViewControllerDidClose(scanningViewController!)
            self.tipCalValuesUpdate(0, cY: 0, isScanned: true, scannedValue: formatedValue)
            
          }))
          
          refreshAlert.addAction(UIAlertAction(title: "Re-scan", style: .Cancel, handler: { (action: UIAlertAction!) in
            scanConroller.resumeScanningAndResetState(false);
          }))
          
          scanningViewController!.presentViewController(refreshAlert, animated: true, completion: nil)
        } else {
          scanConroller.resumeScanningAndResetState(false);
        }
        
        //        let ocrLayout : PPOcrLayout=ocrRecognizerResult.ocrLayout()
        //        print("Dimensions of ocrLayout are %@", NSStringFromCGRect(ocrLayout.box))
      }
    }
    
    // resume scanning while preserving internal recognizer state
    
  }
  func scanningViewControllerUnauthorizedCamera(scanningViewController: UIViewController){
    // Add any logic which handles UI when app user doesn't allow usage of the phone's camera
  }
  
  func scanningViewController(scanningViewController: UIViewController, didFindError error: NSError) {
    // Can be ignored. See description of the method
  }
  
  func scanningViewControllerDidClose(scanningViewController: UIViewController) {
    // As scanning view controller is presented full screen and modally, dismiss it
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  func textField(textField: UITextField,shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool
  {
    let newCharacters = NSCharacterSet(charactersInString: string)
    let boolIsNumber = NSCharacterSet.decimalDigitCharacterSet().isSupersetOfSet(newCharacters)
    if boolIsNumber == true {
      return true
    } else {
      if string == "." {
        let countdots = textField.text!.componentsSeparatedByString(".").count - 1
        if countdots == 0 {
          return true
        } else {
          if countdots > 0 && string == "." {
            return false
          } else {
            return true
          }
        }
      } else {
        return false
      }
    }
  }
  
  // Save to core data
  func savePayItem(billAmount: Double) {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let entity = NSEntityDescription.entityForName("PayList", inManagedObjectContext: managedContext)
    let payItem = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
    
    payItem.setValue(billAmount, forKey: "billAmount")
    do {
      try managedContext.save()
      
    } catch let error as NSError {
      print("Could not save \(error), \(error.userInfo)")
    }
    
  }
  
  
}
extension String {
  func replace(string:String, replacement:String) -> String {
    return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
  }
  
  func removeWhitespace() -> String {
    return self.replace(" ", replacement: "")
  }
}
extension Double {
  var asLocaleCurrency:String {
    var formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    formatter.locale = NSLocale.currentLocale()
    return formatter.stringFromNumber(self)!
  }
}
