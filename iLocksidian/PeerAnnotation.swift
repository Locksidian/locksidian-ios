import Foundation
import MapKit

class PeerAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
