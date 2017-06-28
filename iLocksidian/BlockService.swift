import Foundation

typealias BlockServiceHash = (String?, Error?) -> Void
typealias BlockServiceBlock = (Block?, Error?) -> Void

class BlockService: NSObject {
    static let API_URL: String = "http://home.fries.io:8080/blocks"
    
    func getHead(block: @escaping BlockServiceHash) {
        let task: URLSessionDataTask = URLSession.shared.dataTask(
            with: URL(string: BlockService.API_URL)!,
            completionHandler: {
                (data: Data?, response: URLResponse?, error: Error?) in
                if (error != nil) {
                    block(nil, error)
                }
                else if (data != nil) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                        let hash = json["head"] as! String
                        
                        block(hash, nil)
                    }
                    catch let errorEx {
                        block(nil, errorEx)
                    }
                }
            }
        );
        
        task.resume()
    }
    
    func getBlock(block: @escaping BlockServiceBlock, hash: String) {
        let url = URL(string: BlockService.API_URL + "/" + hash)
        
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
                        
                        let model = Block(
                            author: json["author"] as! String,
                            data: json["data"] as! String,
                            dataHash: json["data_hash"] as! String,
                            hash: json["hash"] as! String,
                            height: json["height"] as! Int,
                            next: json["next"] as! String,
                            nonce: json["nonce"] as! Int,
                            previous: json["previous"] as! String,
                            receivedAt: json["received_at"] as! Int,
                            receivedFrom: json["received_from"] as! String,
                            signature: json["signature"] as! String,
                            timestamp: json["timestamp"] as! Int
                        )
                        
                        block(model, nil)
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
