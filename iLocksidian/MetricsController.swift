import UIKit

class MetricsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let metricsService = MetricsService()
    var metrics: Array<Metric> = []
    
    @IBOutlet weak var metricsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.metricsTableView.delegate = self
        self.metricsTableView.dataSource = self
        
        self.metricsTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "metric")
        
        self.getMetrics()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getMetrics() {
        metricsService.getMetrics(block: { (metricsList, error) in
            if (metricsList != nil) {
                self.metrics = metricsList!
                
                DispatchQueue.main.async {
                    self.metricsTableView.reloadData()
                }
            }
            else {
                NSLog("Error in getMetrics")
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.metrics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "metric", for: indexPath)
        let metric = self.metrics[indexPath.row]
        
        cell.textLabel?.text = metric.name + ": " + String(metric.value)
        
        return cell
    }
}
