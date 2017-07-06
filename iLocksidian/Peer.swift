import Foundation
import MapKit

class Peer {
    let address: String
    let key: String
    
    var coord: CLLocationCoordinate2D?
    
    init(address: String, key: String) {
        self.address = address
        self.key = key
    }
}
