import Foundation
import MapKit

typealias PeerServiceCoord = (CLLocationCoordinate2D?, Error?) -> Void
typealias PeerServiceBlock = (Array<Peer>?, Error?) -> Void

class PeerService: NSObject {
    static let API_URL: String = "http://home.fries.io:8080/peers"
    static let GEOIP_URL: String = "https://freegeoip.net/json"
    
    func locatePeer(block: @escaping PeerServiceCoord, address: String) {
        let addr = address.components(separatedBy: ":")
        let url = URL(string: PeerService.GEOIP_URL + "/" + addr[0])
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(
            with: url!,
            completionHandler: {
                (data: Data?, response: URLResponse?, error: Error?) in
                if (error != nil) {
                    block(nil, error)
                }
                else if (data != nil) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                        let latitude = json["latitude"] as! Double
                        let longitude = json["longitude"] as! Double
                        
                        let coord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        block(coord, nil)
                    }
                    catch let errorEx {
                        block(nil, errorEx)
                    }
                }
        }
        );
        
        task.resume()
    }
    
    func getPeers(block: @escaping PeerServiceBlock) {
        let task: URLSessionDataTask = URLSession.shared.dataTask(
            with: URL(string: PeerService.API_URL)!,
            completionHandler: {
                (data: Data?, response: URLResponse?, error: Error?) in
                if (error != nil) {
                    block(nil, error)
                }
                else if (data != nil) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Array<Dictionary<String, AnyObject>>
                        var peers: Array<Peer> = []
                        
                        for jsonPeer in json {
                            let address = jsonPeer["address"] as! String
                            let key = jsonPeer["key"] as! String
                            
                            let semaphore = DispatchSemaphore(value: 0)
                            self.locatePeer(block: { (coord, error) in
                                peers.append(Peer(
                                    address: address,
                                    key: key,
                                    coord: coord!
                                ))
                            }, address: /*address*/"home.fries.io")
                            semaphore.wait()
                        }
                        
                        block(peers, nil)
                    }
                    catch let errorEx {
                        block(nil, errorEx)
                    }
                }
            }
        );
        
        task.resume()
    }
}
