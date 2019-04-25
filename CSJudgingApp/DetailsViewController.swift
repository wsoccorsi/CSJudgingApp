import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var devLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var presLabel: UILabel!
    
    var Project: Project!
    
    override func viewWillAppear(_ animated: Bool) {
        

        let cat = String(Project.cat.split(separator: "(").first!)

        let CatEnum = Category(rawValue: cat)
        let CatLabelColor = UIColorFromCat(cat: CatEnum!)
        
        courseLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        courseLabel.text = Project.courses.joined()
        courseLabel.numberOfLines = 0
        
      
        
        super.viewWillAppear(animated)
        nameLabel.numberOfLines=0
        descLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        //bootleg fix for ascii '
        Project.name = Project.name.replacingOccurrences(of: "&#039;", with: "'")
        Project.name = Project.name.replacingOccurrences(of: "&rsquo;", with: "'")
        Project.desc = Project.desc.replacingOccurrences(of: "&#039;", with: "'")
        Project.desc = Project.desc.replacingOccurrences(of: "&rsquo;", with: "'")

        nameLabel.text = Project.name
        //descLabel.sizeToFit()
        descLabel.text = Project.desc
        devLabel.text =  Project.students.joined(separator:",")
        catLabel.text =  Project.cat
        catLabel.backgroundColor = CatLabelColor
        catLabel.layer.masksToBounds = true
        catLabel.layer.cornerRadius = 5
        presLabel.text = Project.time
        locLabel.text = Project.boothNumber + " " + Project.boothSide

    }
    
    @IBAction func buttonTapped(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier
        {
            case "showJudging"?:
            
                print("")
            
                let JudgeViewController = segue.destination as! JudgeViewController
                
                JudgeViewController.Project = Project
            
        default:
            preconditionFailure("Unexpected Segue Identifier.")
        }
    }
    
}
    

