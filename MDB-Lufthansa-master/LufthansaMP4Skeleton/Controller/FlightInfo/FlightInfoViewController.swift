//
//  FlightInfoViewController.swift
//  LufthansaMP4Skeleton
//
//  Created by Sinjon Santos on 3/5/19.
//  Copyright © 2019 us. All rights reserved.
//

import UIKit
import MapKit

class FlightInfoViewController: UIViewController {
    
    var flight: Flight?
    var flightNum = ""
    var flightTime = ""
    var selectedAirport = ""
    var favoriteButton: UIBarButtonItem!
    var planeIcon: UIImageView!
    var statusLabel: UILabel!
    var startAirportLabel: UILabel!
    var endAirportLabel: UILabel!
    var startTimeLabel: UILabel!
    var endTimeLabel: UILabel!
    var startTerminalLabel: UILabel!
    var endTerminalLabel: UILabel!
    var startGateLabel: UILabel!
    var endGateLabel: UILabel!
    var planeTypeLabel: UILabel!
    
    var mapView: MKMapView!
    
    var airportArray: [Airport] = [] {
        didSet {
            if airportArray.count == 2 {
                let coords = self.airportArray.map {$0.coordinate}
                print(coords)
                let line = MKPolyline(coordinates: coords, count: 2)
                self.mapView.addOverlay(line)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "ProximaNova-Semibold", size: 24)!, NSAttributedString.Key.foregroundColor: UIColor.yellow]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "ProximaNova-Semibold", size: 40)!, NSAttributedString.Key.foregroundColor: UIColor.yellow]
        self.navigationItem.title = "Flight \(flightNum)"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.tintColor = .yellow
        
        setupUI()
        
        mapView = MKMapView(frame: CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height/2))
        mapView.delegate = self
        view.addSubview(mapView)
        addAirports()
        centerMap()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.backgroundColor = .clear
        let favoritesArray = UserDefaults.standard.array(forKey: "favorites") as! [String]
        if (favoritesArray.contains("\(self.flightNum) \(self.flightTime)")) {
            favoriteButton = UIBarButtonItem(image: UIImage(named: "favorited"), style: .plain, target: self, action: #selector(favorite))
        } else {
            favoriteButton = UIBarButtonItem(image: UIImage(named: "unfavorited"), style: .plain, target: self, action: #selector(favorite))
        }
        self.navigationItem.rightBarButtonItem = favoriteButton
        
    }
    
    @objc func favorite() {
        var favoritesArray = UserDefaults.standard.array(forKey: "favorites") as! [String]
        if (favoriteButton.image == UIImage(named: "unfavorited")) {
            favoritesArray.append("\(self.flightNum) \(self.flightTime)")
            favoriteButton = UIBarButtonItem(image: UIImage(named: "favorited"), style: .plain, target: self, action: #selector(favorite))
        } else {
            favoritesArray = favoritesArray.filter{$0 != "\(self.flightNum) \(self.flightTime)"}
            favoriteButton = UIBarButtonItem(image: UIImage(named: "unfavorited"), style: .plain, target: self, action: #selector(favorite))
        }
        favoriteButton.tintColor = .yellow
        self.navigationItem.rightBarButtonItem = favoriteButton
        
        UserDefaults.standard.set(favoritesArray, forKey: "favorites")
    }
    
    func addAirports() {
        LufthansaAPIClient.getAirportLocation(name: flight!.startAirport) { airport in
            self.mapView.addAnnotation(airport)
            self.airportArray.append(airport)
        }
        
        LufthansaAPIClient.getAirportLocation(name: flight!.endAirport) { airport in
            self.mapView.addAnnotation(airport)
            self.airportArray.append(airport)
        }
    }
    
    func centerMap() {
        let location = CLLocationCoordinate2D(latitude: 48.1657, longitude: 5.00)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 3000000, longitudinalMeters: 3000000)
        self.mapView.setRegion(region, animated : true)
    }
    
    @objc func airportSelected(_ sender: UITapGestureRecognizer) {
        selectedAirport = (sender.view as? UILabel)!.text!
        performSegue(withIdentifier: "toAirportInfo", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAirportInfo" {
            let resultVC = segue.destination as! AirportInfoViewController
            resultVC.airportName = selectedAirport
        }
    }
    
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
