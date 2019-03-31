import UIKit

class ProjectsViewController: UITableViewController {
    
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
        tableView.estimatedRowHeight = 65
        
        //======
        //==02==
        //======
        ProjectStore.FetchAllProjectsFromWeb(completion: updateTableView)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.backgroundColor = UIColor.gray
        
        let project = ProjectStore.Projects[indexPath.row]
        
   
        cell.nameLabel.text = project.title
        cell.nameLabel.numberOfLines = 0
        cell.nameLabel.lineBreakMode = .byWordWrapping
        cell.catLabel.text = project.category
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "showProject"?:
            
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

