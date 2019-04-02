import UIKit

class JudgingViewController: UITableViewController {
    
    var ProjectStore: ProjectStore!
    
    //======
    //==01==
    //======
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.darkGray
        
        //======
        //==02==
        //======
        //ProjectStore.FetchAllProjectsFromWeb(completion: updateTableView)
        
        let API = WebAPI()
        API.FetchMyProjectsFromWeb(completion: updateTableView)
    }
    
    //======
    //==11==
    //======
    func updateTableView(projectsResult: ProjectsResult) {
        
        switch projectsResult
        {
        case let .Success(projects):
            
            ProjectStore.Projects = projects
            
            self.tableView.reloadData()
            
        case let .Failure(error):
            
            print("Error Fetching Projects: \(error)")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ProjectStore.Projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let project = ProjectStore.Projects[indexPath.row]
        
        let cat = String(project.cat.split(separator: "(").first!)
        
        var cell : CustomCell
        
        if(cat.contains("Advanced")) {
            cell = tableView.dequeueReusableCell(withIdentifier: "StarCell", for: indexPath) as! CustomCell
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "NoStarCell", for: indexPath) as! CustomCell
        }
        
        let CatEnum = Category(rawValue: cat)
        let CatLabelColor = UIColorFromCat(cat: CatEnum!)
        
        cell.nameLabel.text = project.name
        cell.nameLabel.numberOfLines = 0
        cell.nameLabel.lineBreakMode = .byWordWrapping
        
        cell.catLabel.text = cat
        cell.catLabel.backgroundColor = CatLabelColor
        cell.catLabel.numberOfLines = 0
        cell.catLabel.lineBreakMode = .byWordWrapping
        
        cell.starImage = UIImageView(image: UIImage(named: "StarIcon"))
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "showDetails"?:
            
            if let row = tableView.indexPathForSelectedRow?.row {
                
                let p = ProjectStore.Projects[row]
                
                let DetailsViewController = segue.destination as! DetailsViewController
                
                DetailsViewController.Project = p
            }
        default:
            preconditionFailure("Unexpected Segue Identifier.")
        }
    }
    
}

