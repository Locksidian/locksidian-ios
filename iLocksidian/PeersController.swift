import UIKit
import MapKit

class PeersController: UIViewController, MKMapViewDelegate {

    let peerService = PeerService()
    var peers: Array<Peer> = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getPeers() {
        self.peerService.getPeers(block: { (peers, error) in
            if (peers != nil) {
                for peer in peers! {
                    let annotation = PeerAnnotation(coordinate: peer.coord)
                    annotation.title = peer.address
                    
                    self.mapView.addAnnotation(annotation)
                }
            }
            else {
                NSLog("Error in getPeers")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
