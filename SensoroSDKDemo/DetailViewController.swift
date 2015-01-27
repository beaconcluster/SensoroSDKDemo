//
//  DetailViewController.swift
//  SensoroSDKDemo
//
//  Created by David Yang on 15/1/26.
//  Copyright (c) 2015年 beaconcluster. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, SBKBeaconDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var minor: UITextField!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        // Update the user interface for the detail item.
        if let detail: SBKBeacon = self.detailItem as? SBKBeacon {
            
            detail.delegate = self;
            self.major!.text = NSString(format: "0x%04X", detail.beaconID!.major.integerValue);
            self.minor!.text = NSString(format: "0x%04X", detail.beaconID!.minor.integerValue);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Write Function.
    
    @IBAction func writeMajorMinor(sender: AnyObject) {
        
        if let detail: SBKBeacon = self.detailItem as? SBKBeacon {
            
            detail.connectWithCompletion({ (error : NSError!) -> Void in
                if error == nil {
                    
                    var sccessfull = true;
                    let majorText = self.major!.text;
                    let scannerMajor = NSScanner(string: self.major!.text);
                    var majorI : UInt32 = 0;
                    if scannerMajor.scanHexInt(&majorI) == false{
                        sccessfull = false;
                    }
                    
                    var minorI : UInt32 = 0;
                    let minorText = self.minor!.text;
                    let scannerMinor = NSScanner(string: self.minor!.text);
                    if scannerMinor.scanHexInt(&minorI) == false{
                        sccessfull = false;
                    }
                    
                    if sccessfull {
                        detail.writeMajor(NSNumber(unsignedInt: majorI),
                            minor: NSNumber(unsignedInt: minorI),
                            completion: { (error : NSError!) -> Void in
                                if error != nil {
                                    NSLog("Erorr %@", error);
                                }else{
                                    NSLog("Write major & minor was sccessfull!");
                                }
                                detail.disconnect();
                        })
                    }else{
                        detail.disconnect();
                    }
                    
                }else{
                    NSLog("Erorr %@", error);
                    detail.disconnect();
                }
            });
        }
    }

    @IBAction func resetToFactory(sender: AnyObject) {
        if let detail: SBKBeacon = self.detailItem as? SBKBeacon {
            
            detail.connectWithCompletion({ (error : NSError!) -> Void in
                if error == nil {
                    detail.resetToFactorySettingsWithCompletion({ (error : NSError!) -> Void in
                            if error != nil {
                                NSLog("Erorr %@", error);
                            }else{
                                NSLog("Reset to factory was sccessfull!");
                            }
                            detail.disconnect();
                    })
                }else{
                    NSLog("Erorr %@", error);
                    detail.disconnect();
                }
            });
        }
    }
    
    // MARK: - SBKBeaconDelegate
    func sensoroBeaconDidConnect(beacon: SBKBeacon!) {
        NSLog("Connect was sccessfull!");
    }
    
    func sensoroBeaconDidDisconnect(beacon: SBKBeacon!, error: NSError!) {
        NSLog("Disconnect was sccessfull!");
    }
}

