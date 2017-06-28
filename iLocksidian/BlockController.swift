import UIKit

class BlockController: UIViewController {

    let blockService = BlockService()
    let blockHash: String
    var block: Block?
    
    @IBOutlet weak var hashLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, hash: String) {
        self.blockHash = hash
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBlock()
    }
    
    func getBlock() {
        blockService.getBlock(block: { (block, error) in
            if (block != nil) {
                self.block = block
                
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
            else {
                NSLog("Error in getBlock")
            }
        }, hash: self.blockHash)
    }
    
    func updateUI() {
        if (block == nil) {
            return
        }
        
        hashLabel.text = self.block!.hash
        authorLabel.text = self.block!.author
        dataLabel.text = self.block!.data
        timestampLabel.text = String(self.block!.timestamp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func previousButton(_ sender: Any) {
        if (block == nil) {
            return
        }
        
        self.showBlock(hash: self.block!.previous)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if (block == nil) {
            return
        }
        
        self.showBlock(hash: self.block!.next)
    }
    
    func showBlock(hash: String) {
        if(hash.isEmpty) {
            return
        }
        
        let blockController = BlockController(nibName: "BlockController", bundle: nil, hash: hash)
        self.navigationController?.pushViewController(blockController, animated: true)
    }
}
