//
//  ViewController.swift
//  iDuino Gesture
//
//  Created by Mark on 2016-02-07.
//  Copyright © 2016 Clutch Industries. All rights reserved.
//


/*------------------------------------------------*/

//Import required Frameworks

import UIKit
import CoreMotion
import CoreBluetooth
import Foundation

/*------------------------------------------------*/

//Class

class ViewController: UIViewController {
    
    
    /*------------------------------------------------*/
    
    //Objects
    
    
    //Rotation
    var motionManager = CMMotionManager()
    var DMManager = NSOperationQueue()
    
    //BLE
    var nrfManager:NRFManager!
    
    
    //Data Transfer
    
    var fltXatt: Int = 0
    var fltYatt: Int = 0
    var fltZatt: Int = 0
    
    
    var xAttitude = ""
    var yAttitude = ""
    var zAttitude = ""
    
    
    
    
    /*------------------------------------------------*/
    
    // Define properties to interact with the UI
    
    @IBOutlet var rotX: UILabel!
    
    @IBOutlet var rotY: UILabel!
    
    @IBOutlet var rotZ: UILabel!
    
    
    @IBOutlet var pitch: UILabel!
    
    @IBOutlet var roll: UILabel!
    
    @IBOutlet var yaw: UILabel!
    
    
    @IBOutlet var BLEstatus: UILabel!
    
    @IBOutlet var BLEConnectionTitle: UILabel!
    
    
    /*------------------------------------------------*/
    
    //Functions
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        //Set Motion Manager Properties
        motionManager.gyroUpdateInterval = 0.2
        
        motionManager.deviceMotionUpdateInterval = 0.2
        
        
        /*------------------------------------------------*/
        
        //Device Attitude Data Reading
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!,
            withHandler:  { (deviceMotion: CMDeviceMotion?, NSError) ->
                Void in
                self.outputAttitude(deviceMotion!.attitude)
                if (NSError != nil) {
                    print("\(NSError)")
                }
        })
        
        //Device Gyro Data Reading
        motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!,
            withHandler: { (gyroData: CMGyroData?, NSError) ->
                Void in
                self.outputRotationData(gyroData!.rotationRate)
                if (NSError != nil) {
                    print("\(NSError)")
                }
        })
        
        
    }
    
    
    /*------------------------------------------------*/
    
    //Output Gyro Data Function
    func outputRotationData(rotation: CMRotationRate) {
        
        rotX?.text = "\(rotation.x).2fr/s"
        
        rotY?.text = "\(rotation.y).2fr/s"
        
        rotZ?.text = "\(rotation.z).2fr/s"
        
        
    }
    
    //Output Attitude Data Function
    
    func outputAttitude(attitude: CMAttitude) {
        
        
        let xAt = attitude.pitch
        fltXatt = (Int(xAt))
        pitch?.text = "\(fltXatt)rad"
        
        let yAt = attitude.roll
        fltYatt = (Int(yAt))
        roll?.text = "\(fltYatt)rad"
        
//        let zAt = attitude.yaw
//        fltZatt = (Int(zAt))
        yaw?.text = "not in use"
        
        nrfManager = NRFManager(
            onConnect: {
                
                for var i = 0; i < 2; ++i {
                    
                    self.sendData(i)
                    //print("connected \(self.fltXatt)")
                    self.BLEstatus?.text = "Connected"
                }
                
            },
            onDisconnect: {
                print("Disconnected")
                self.BLEstatus?.text = "Disconnected"
                
            },
            onData: {
                (data:NSData?, string:String?)->() in
                print("Recieved data - String: \(string) - Data: \(data)")
            }
        )
        
        
    }
    
    //NRF sendData function
    
    func sendData(type: Int) {
        if ( type == 0) {
            let result = self.nrfManager.writeString("\(fltXatt)")
        }
        else if( type == 1) {
            let result = self.nrfManager.writeString("\(fltYatt)")
        }
        else {
            print("Out of bounds of array error")
        }
    }
    
    
    
    /*------------------------------------------------*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

