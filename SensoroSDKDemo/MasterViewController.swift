//
//  MasterViewController.swift
//  SensoroSDKDemo
//
//  Created by David Yang on 15/1/26.
//  Copyright (c) 2015年 beaconcluster. All rights reserved.
//

import UIKit

let CellIdentifier = "BeaconCell";

class MasterViewController: UITableViewController, SBKBeaconManagerDelegate {

    var beacons = NSMutableArray()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
//        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
//        self.navigationItem.rightBarButtonItem = addButton
        
        self.tableView.rowHeight = 105;
        self.tableView.registerNib(UINib(nibName: CellIdentifier, bundle: nil),
            forCellReuseIdentifier: CellIdentifier);
        
        let sdkDefaultID = SBKBeaconID(proximityUUID: SBKSensoroDefaultProximityUUID);
        SBKBeaconManager.sharedInstance().delegate = self;
        SBKBeaconManager.sharedInstance().startRangingBeaconsWithID(sdkDefaultID, wakeUpApplication: false);
        //申请总是使用位置授权
        //SBKBeaconManager.sharedInstance().requestAlwaysAuthorization();
        //申请在需要时使用位置授权
        SBKBeaconManager.sharedInstance().requestWhenInUseAuthorization();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func insertNewObject(sender: AnyObject) {
//        beacons.insertObject(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = beacons[indexPath.row] as SBKBeacon;
            (segue.destinationViewController as DetailViewController).detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beacons.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BeaconCell", forIndexPath: indexPath) as BeaconCell

        if let beacon = beacons[indexPath.row] as? SBKBeacon {
            cell.UUID!.text = beacon.beaconID!.proximityUUID.UUIDString;
            cell.SN!.text = beacon.serialNumber!;
            cell.majorAndMinor!.text = NSString(format: "Major: 0x%04X, Minor: 0x%04X",
                beacon.beaconID!.major.integerValue,beacon.beaconID!.minor.integerValue);
            cell.modelInfo.text = "Model \(beacon.hardwareModelName) Firmware \(beacon.firmwareVersion)";
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: self);
    }
//    
//    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
//        self.performSegueWithIdentifier("showDetail", sender: self);
//    }

//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            beacons.removeObjectAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }

    // MARK: SBKBeaconManagerDelegate
    
    func beaconManager(beaconManager: SBKBeaconManager!, didRangeNewBeacon beacon: SBKBeacon!) {
        beacons.addObject(beacon);
        
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: beacons.count-1, inSection: 0)], withRowAnimation: .Fade);
    }
    
    func beaconManager(beaconManager: SBKBeaconManager!, beaconDidGone beacon: SBKBeacon!) {
        beacons.removeObject(beacon);
        
        if beacons.count < self.tableView.numberOfRowsInSection(0){
            
            let path = NSIndexPath(forRow: beacons.count, inSection: 0);
            self.tableView.deleteRowsAtIndexPaths([path], withRowAnimation: .Fade);
        }
    }
    
    func beaconManager(beaconManager: SBKBeaconManager!, scanDidFinishWithBeacons beacons: [AnyObject]!) {
        self.tableView.reloadRowsAtIndexPaths(self.tableView.indexPathsForVisibleRows()!,
            withRowAnimation: .None);
        
        //self.tableView.reloadData();
    }
    
    
    
}

