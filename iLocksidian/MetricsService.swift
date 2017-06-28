import Foundation

typealias ServiceItemsBlock = (Array<Metric>?, Error?) -> Void

class MetricsService: NSObject {
    static let API_URL: String = "http://home.fries.io:8080/metrics"
    
    func getMetrics(block: @escaping ServiceItemsBlock) {
        let task: URLSessionDataTask = URLSession.shared.dataTask(
            with: URL(string: MetricsService.API_URL)!,
            completionHandler: {
                (data: Data?, response: URLResponse?, error: Error?) in
                if (error != nil) {
                    block(nil, error)
                }
                else if (data != nil) {
                    do {
                        let jsonMetrics = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Array<Dictionary<String, AnyObject>>
                        var metrics: Array<Metric> = []
                        
                        for jsonMetric in jsonMetrics {
                            let name = jsonMetric["name"] as! String
                            let value = jsonMetric["value"] as! Int
                            let metric = Metric(name: name, value: value)
                            
                            metrics.append(metric)
                        }
                        
                        block(metrics, nil)
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
