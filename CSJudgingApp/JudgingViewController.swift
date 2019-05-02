import UIKit

class JudgingViewController: UITableViewController {
    
    var ProjectStore: ProjectStore!
    var API: WebAPI!
    var CData: CoreData!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.darkGray

        API.FetchMyProjectsFromWeb(completion: updateTableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        API.FetchMyProjectsFromWeb(completion: updateTableView)
    }
    
    func updateTableView(projectsResult: ProjectsResult)
    {
        switch projectsResult
        {
            case let .Success(projects):
            
                let sorted_projects = projects.sorted { !$0.hasJudged && $1.hasJudged }
                ProjectStore.Projects = sorted_projects
            
                self.tableView.reloadData()
            
            case let .Failure(error):
            
                print("Error Fetching Projects: \(error)")
                let empty: [Project] = []
                ProjectStore.Projects = empty
                self.tableView.reloadData()
        }
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (ProjectStore.Projects.count == 0)
        {
            return 1
        }
        
        return ProjectStore.Projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (ProjectStore.Projects.count == 0 && !API.isLoggedIn)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotLoggedInCell", for: indexPath) as! CustomCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none;
            return cell
        }
        if (ProjectStore.Projects.count == 0 && API.isLoggedIn)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! CustomCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none;
            return cell
        }
        
        let project = ProjectStore.Projects[indexPath.row]
        
        let cat = String(project.cat.split(separator: "(").first!)
        
        var cell : CustomCell
        
        if(project.areJudged)
        {
            if(project.hasJudged) {
                cell = tableView.dequeueReusableCell(withIdentifier: "StarCell", for: indexPath) as! CustomCell
            }
            else {
                cell = tableView.dequeueReusableCell(withIdentifier: "NeedsJudgeCell", for: indexPath) as! CustomCell
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier
        {
            case "showDetails"?:
            
                if let row = tableView.indexPathForSelectedRow?.row
                {
                    let p = ProjectStore.Projects[row]
                
                    let DetailsViewController = segue.destination as! DetailsViewController
                
                    DetailsViewController.Project = p
                    DetailsViewController.API = API
                }
            
            default:
                preconditionFailure("Unexpected Segue Identifier.")
        }
    }
}

