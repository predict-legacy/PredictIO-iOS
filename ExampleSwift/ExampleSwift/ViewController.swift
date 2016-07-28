//
//  ViewController.swift
//  ExampleSwift
//
//  Created by Abdul Haseeb on 6/20/16.
//  Copyright © 2016 Abdul Haseeb. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PredictIODelegate {
    
    // MARK: Properties
    
    let  API_KEY = "260ef48214d69f06c1ad373c1354eab6605cf2792afc82e6e70f402e9cd1acee"
    let cellIdentifier = "CellIdentifier"
    var tableData: NSMutableArray = []
    var parktagEnabled = false;
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .Plain, target: self, action: #selector(ViewController.startStopParktag))
        
        self.tableView.sectionHeaderHeight=0
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UITableView delegate methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath)
        
        // Fetch Fruit
        let fruit = tableData[indexPath.row]
        
        // Configure Cell
        cell.textLabel?.text = fruit as? String
        
        return cell
    }
    
    func startStopParktag() {
        let pt: PredictIO = PredictIO.sharedInstance()
        if self.parktagEnabled {
            pt.stop()
            self.navigationItem.rightBarButtonItem!.title = "Start"
            NSUserDefaults.standardUserDefaults().removeObjectForKey("enabled")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.parktagEnabled = false
        }
        else if !(API_KEY=="") && !(API_KEY == "YOUR-API-KEY") {
            pt.delegate = self
            pt.apiKey = API_KEY
            pt.startWithCompletionHandler ({
                (error: NSError?) in
                if (error != nil) {
                    print("\(error!.description)")
                } else {
                    print("Started ParkTAG...")
                    self.tableData = NSMutableArray();
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            })
            self.navigationItem.rightBarButtonItem!.title = "Stop"
            NSUserDefaults.standardUserDefaults().setValue("YES", forKey: "enabled")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.parktagEnabled = true
        } else {
            NSLog(">>> ERROR: Please set your API key in API_KEY preprocessor macro.");
        }
    }
    
    func addEventName(eventName: String) {
        tableData.addObject(eventName)
        self.tableView.reloadData()
    }
    
    // MARK: Predict.io delegate methods
    
    func departingFromLocation(departureLocation: CLLocation!, transportationMode: TransportationMode) {
        self.addEventName(PTEventVacatingParking)
    }
    
    func departedLocation(departureLocation: CLLocation!, departureTime: NSDate!, transportationMode: TransportationMode) {
        self.addEventName(PTEventVacatedParking)
    }
    
    func departureCanceled() {
        self.addEventName(PTEventVacatedParkingCancel)
    }
    
    func arrivalSuspectedFromLocation(departureLocation: CLLocation!, arrivalLocation: CLLocation!, departureTime: NSDate!, arrivalTime: NSDate!, transportationMode: TransportationMode) {
        self.addEventName(PTEventParkingSuspected)
    }
    
    func arrivedAtLocation(arrivalLocation: CLLocation!, departureLocation: CLLocation!, arrivalTime: NSDate!, departureTime: NSDate!, transportationMode: TransportationMode) {
        self.addEventName(PTEventVehicleParked)
    }
    
    func searchingInPerimeter(searchingLocation: CLLocation!) {
        self.addEventName(PTEventSearchingParking)
    }
    
    func didUpdateLocation(location: CLLocation!) {
        self.addEventName(PTEventUpdateLocation)
    }
    
    func getPredictIOStatus() {
        let pt: PredictIO = PredictIO.sharedInstance()
        pt.status();
    }
    
}

