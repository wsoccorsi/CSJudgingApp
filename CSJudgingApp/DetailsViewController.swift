import UIKit


class DetailsViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var devLabel: UILabel!
    
    var Project: Project!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.numberOfLines=0
        descLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        nameLabel.text = Project.name
        //descLabel.sizeToFit()
        descLabel.text = Project.desc
        devLabel.text =  Project.students.joined(separator:",")
    
    }
    
}
