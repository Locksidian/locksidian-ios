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
                    self.peerService.locatePeer(block: { (coord, error) in
                        if (coord != nil) {
                            let annotation = PeerAnnotation(coordinate: coord)
                            annotation.title = peer.address
                    
                            self.mapView.addAnnotation(annotation)
                        }
                    }, address: peer.address)
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
