import UIKit

class MetricsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let blockService = BlockService()
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
    
    @IBAction func explorerButton(_ sender: Any) {
        self.blockService.getHead(block: { (hash, error) in
            if(hash != nil) {
                DispatchQueue.main.async {
                    let blockController = BlockController(nibName: "BlockController", bundle: nil, hash: hash!)
                    self.navigationController?.pushViewController(blockController, animated: true)
                }
            }
            else {
                NSLog("Error in getHead")
            }
        })
    }
    
    @IBAction func peersButton(_ sender: Any) {
        let peersController = PeersController(nibName: "PeersController", bundle: nil)
        self.navigationController?.pushViewController(peersController, animated: true)
    }
}
