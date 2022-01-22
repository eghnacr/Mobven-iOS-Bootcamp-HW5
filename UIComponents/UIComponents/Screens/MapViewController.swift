//
//  MapViewController.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 9.01.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        checkLocationPermission()
        addLongGestureRecognizer()
    }

    private var currentCoordinate: CLLocationCoordinate2D?
    private var destinationCoordinate: CLLocationCoordinate2D?

    func addLongGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(handleLongPressGesture(_ :)))
        self.view.addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        destinationCoordinate = coordinate

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Pinned"
        mapView.addAnnotation(annotation)
    }

    func checkLocationPermission() {
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.requestLocation()
        case .denied, .restricted:
            //popup gosterecegiz. go to settings butonuna basildiginda
            //kullaniciyi uygulamamizin settings sayfasina gonder
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError()
        }
    }

    @IBAction func showCurrentLocationTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }

    
    var polylines : [MKPolyline] = []
    var selectedPath = 0
    var currentDrawing = 0
    
    @IBAction func drawRouteButtonTapped(_ sender: UIButton) {
        guard let currentCoordinate = currentCoordinate,
              let destinationCoordinate = destinationCoordinate else {
                  // log
                  // alert
            return
        }

        let sourcePlacemark = MKPlacemark(coordinate: currentCoordinate)
        let source = MKMapItem(placemark: sourcePlacemark)

        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        let destination = MKMapItem(placemark: destinationPlacemark)

        let directionRequest = MKDirections.Request()
        directionRequest.source = source
        directionRequest.destination = destination
        directionRequest.transportType = .automobile
        directionRequest.requestsAlternateRoutes = true

        let direction = MKDirections(request: directionRequest)

        direction.calculate { response, error in
            guard error == nil else {
                //log error
                //show error
                print(error?.localizedDescription)
                return
            }

//            guard let polyline: MKPolyline = response?.routes.first?.polyline else { return }
//            self.mapView.addOverlay(polyline, level: .aboveLabels)
//
//            let rect = polyline.boundingMapRect
//            let region = MKCoordinateRegion(rect)
//            self.mapView.setRegion(region, animated: true)
            

            //Odev 1 navigate buttonlari ile diger route'lar gosterilmelidir.
            self.removeOverlays()
            self.polylines.removeAll()
            if let routes = response?.routes {
                routes.forEach { route in
                    let polyline = route.polyline
                    self.polylines.append(polyline)
                }
                if let first = routes.first?.polyline {
                    let rect = first.boundingMapRect
                    let region = MKCoordinateRegion(rect)
                    self.mapView.setRegion(region, animated: true)
                }
                self.drawOverlays()
            }
        }
    }
    
    func removeOverlays() {
        currentDrawing = 0
        self.mapView.removeOverlays(polylines)
    }
    
    func drawOverlays() {
        if polylines.isEmpty {
            return
        }
        
        for polyline in polylines {
            self.mapView.addOverlay(polyline, level: .aboveLabels)
            currentDrawing += 1
        }
    }
    
    @IBAction func didNextButtonTapped(_ sender: UIBarButtonItem) {
        if polylines.isEmpty {
            return
        }
        selectedPath += 1
        selectedPath %= polylines.count
        removeOverlays()
        drawOverlays()
    }
    
    @IBAction func didBackButtonTapped(_ sender: Any) {
        if polylines.isEmpty {
            return
        }
        selectedPath -= 1
        if selectedPath < 0 {
            selectedPath += polylines.count
        }
        removeOverlays()
        drawOverlays()
    }
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        currentCoordinate = coordinate
        print("latitude: \(coordinate.latitude)")
        print("longitude: \(coordinate.longitude)")

        mapView.setCenter(coordinate, animated: true)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationPermission()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .magenta
        if currentDrawing == selectedPath {
            renderer.lineWidth = 9
            renderer.alpha = 1
        } else {
            renderer.lineWidth = 6
            renderer.alpha = 0.3
        }
        return renderer
    }
}
