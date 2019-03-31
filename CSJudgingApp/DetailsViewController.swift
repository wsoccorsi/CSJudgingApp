import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    
    var Project: Project!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.numberOfLines=0
        descLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        nameLabel.text = Project.title
        descLabel.text = Project.desc
        
        
    }
    
}
