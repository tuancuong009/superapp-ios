//
//  NearByViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/6/20.
//

import UIKit
import GoogleMaps
class NearByViewController: BaseViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapStyleStackView: UIStackView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var satelliteButton: UIButton!
    
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var markers: [GMSMarker] = []
    
    var users: [NearestUser] = []
    var didUpdateCamera: Bool = false
    var tappedMarker : GMSMarker?
    var customInfoWindow : MarkerInfoView?
    var currentStyle: Int = 0
    
    private let path = GMSMutablePath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupLocation()
        setupUI()
        self.tappedMarker = GMSMarker()
        self.customInfoWindow = MarkerInfoView(frame: CGRect(x: 0, y: 0, width: 300.0, height: 80.0))
        
        fetchNearbyUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isLocationServiceEnabled()
    }
    
    @IBAction func changeStyleAction(_ sender: UIButton) {
        guard sender.tag != currentStyle else { return}
        currentStyle = sender.tag
        if currentStyle == 0 {
            mapView.mapType = .normal
            mapButton.titleLabel?.font = UIFont.myriadProBold(ofSize: 15)
            satelliteButton.titleLabel?.font = UIFont.myriadProRegular(ofSize: 15)
        } else {
            mapView.mapType = .satellite
            satelliteButton.titleLabel?.font = UIFont.myriadProBold(ofSize: 15)
            mapButton.titleLabel?.font = UIFont.myriadProRegular(ofSize: 15)
        }
    }
}

// MARK: - NETWORKING

extension NearByViewController {
    
    private func fetchNearbyUser() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        showSimpleHUD()
        ManageAPI.shared.fetchNearByUsers(userId: userId) {[weak self] (users, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showErrorAlert(message: err)
                    return
                }
                self.users = users
                self.updateMap(users)
            }
        }
    }
    
    private func updateMap(_ users: [NearestUser]) {
        setupPinMarker(users: users)
    }
}

// MARK: - UI

extension NearByViewController {
    
    
    private func setupUI() {
        mapStyleStackView.layer.cornerRadius = 3
        mapStyleStackView.layer.shadowColor = UIColor.black.cgColor
        mapStyleStackView.layer.shadowOpacity = 1
        mapStyleStackView.layer.shadowOffset = .zero
        mapStyleStackView.layer.shadowRadius = 3
        
        mapView.delegate = self
    }
    
    private func setupLocation() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    private func setupPinMarker(users: [NearestUser]) {
        mapView.clear()
        markers.removeAll()
        guard !users.isEmpty else { return }
        for user in users {
            guard let lat = user.lat, let lng = user.lng else {
                continue
            }
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: lng))
            marker.icon = #imageLiteral(resourceName: "ic_pin")
            marker.map = mapView
            marker.snippet = user.name
            markers.append(marker)
            self.path.add(marker.position)
        }
        
        if let userLocation = AppSettings.shared.currentLocation {
            self.path.add(userLocation.coordinate)
        }
        let bound = GMSCoordinateBounds(path: self.path)
        let update = GMSCameraUpdate.fit(bound, withPadding: 30)
        mapView.animate(with: update)
    }
    
    private func isLocationServiceEnabled(){
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        checkAuthorizationStatus()
    }
    
    private func checkAuthorizationStatus(){
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.settings.myLocationButton = true
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.settings.myLocationButton = true
        default:
            break
        }
    }
    
    private func displayAlert(isServiceEnabled:Bool) {
        let serviceEnableMessage = "Location services must to be enabled to use this awesome app feature. You can enable location services in your settings."
        let authorizationStatusMessage = "This awesome app needs authorization to do some cool stuff with the map"
        
        let message = isServiceEnabled ? serviceEnableMessage : authorizationStatusMessage
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(acceptAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension NearByViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else {return}
        print("Location: \(location)")
        currentLocation = location
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        guard !didUpdateCamera else { return }
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 3.0)
        mapView.camera = camera
        didUpdateCamera = true
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}

extension NearByViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        tappedMarker = marker
        let position = marker.position
        mapView.animate(toLocation: position)
        let point = mapView.projection.point(for: position)
        let newPoint = mapView.projection.coordinate(for: point)
        let camera = GMSCameraUpdate.setTarget(newPoint)
        mapView.animate(with: camera)
        
        customInfoWindow?.center = mapView.projection.point(for: position)
        customInfoWindow?.center.y -= 72
        customInfoWindow?.delegate = self
        if let index = markers.firstIndex(where: {$0.snippet == marker.snippet}) {
            let user = users[index]
            customInfoWindow?.configurationView(user)
        }
        self.mapView.addSubview(customInfoWindow!)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        customInfoWindow?.removeFromSuperview()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let position = tappedMarker?.position
        customInfoWindow?.center = mapView.projection.point(for: position!)
        customInfoWindow?.center.y -= 72
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        print("My Location = ", mapView.myLocation as Any)
        if let location = currentLocation {
            let camera = GMSCameraUpdate.setTarget(location.coordinate)
            mapView.animate(with: camera)
        }
        return true
    }
}

extension NearByViewController: MarkerInfoViewDelegate {
    
    func closeInfoWindow() {
        customInfoWindow?.removeFromSuperview()
    }
    
    func showInfomation(_ user: NearestUser) {
        let controller = FriendProfileViewController.instantiate()
        controller.basicInfo = UniversalUser(id: user.id, username: user.name, country: nil, pic: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
}
