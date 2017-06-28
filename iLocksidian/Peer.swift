import Foundation
import MapKit

class Peer {
    let address: String
    let key: String
    let coord: CLLocationCoordinate2D
    
    init(address: String, key: String, coord: CLLocationCoordinate2D) {
        self.address = address
        self.key = key
        self.coord = coord
    }
}
