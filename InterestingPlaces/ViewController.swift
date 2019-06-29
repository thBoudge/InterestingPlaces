/**
 * Copyright (c) 2018 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN  AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreLocation

class ViewController: UIViewController {

  @IBOutlet weak var placeName: UILabel!
  @IBOutlet weak var locationDistance: UILabel!
  @IBOutlet weak var placeImage: UIImageView!
  var placesViewController: PlaceScrollViewController?
    var LocationManager: CLLocationManager?
    var previousLocation: CLLocation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let childViewController = children.first as? PlaceScrollViewController {
      placesViewController = childViewController
    }
    loadPlaces()
    LocationManager = CLLocationManager()
    LocationManager?.delegate = self
    //Accuracy of location
    LocationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func selectPlace() {
    print("place selected")
  }
  
  @IBAction func startLocationService(_ sender: UIButton) {
    // 1 - we control if we do have user otaurisation
    if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
        
     activateLocationService()
        
    }else{
        //we request permission
        LocationManager?.requestWhenInUseAuthorization()
    }
    
    
  }
    
    private func activateLocationService() {
        
        LocationManager?.startUpdatingLocation()
    }
  
  func loadPlaces() {
    
    guard let entries = loadPlist() else { fatalError("Unable to load data") }
    
    for property in entries {
      guard let name = property["Name"] as? String,
            let latitude = property["Latitude"] as? NSNumber,
            let longitude = property["Longitude"] as? NSNumber,
            let image = property["Image"] as? String else { fatalError("Error reading data") }
      print("name: \(name)")
      print("latitude: \(latitude)")
      print("longitude: \(longitude)")
      print("image: \(image)")
    }
  }
  
  private func loadPlist() -> [[String: Any]]? {
    guard let plistUrl = Bundle.main.url(forResource: "Places", withExtension: "plist"),
      let plistData = try? Data(contentsOf: plistUrl) else { return nil }
    var placedEntries: [[String: Any]]? = nil
    
    do {
      placedEntries = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: Any]]
    } catch {
      print("error reading plist")
    }
    return placedEntries
  }
}

// MARK: Corelocation protocol Delegate

extension ViewController: CLLocationManagerDelegate {
    
    // call when user change this authorisation or during first time
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            activateLocationService()
        }
    }
    
    // We receive location and we ruse them
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if previousLocation == nil {
            previousLocation = locations.first
            
        } else {
            guard let latest = locations.first else {return}
            //get distance in meter from the first location to our current location
            let distanceInMeters = previousLocation?.distance(from: latest) ?? 0
            print("distance en metre : \(distanceInMeters)")
            // we set previousLocation we our newLocation
            previousLocation = latest
        }
    }
    
}
