import MapKit
import UIKit

class MapViewController: BaseViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled()) {
            
            setLocation(locationManager.location)
            
        } else {
            
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // See flux
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            
            mapView.showsUserLocation = true
        }
    }
    
    private func setLocation(location: CLLocation) {
        
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.01, 0.01))
        
        mapView.setRegion(region, animated: true)
    }
}
