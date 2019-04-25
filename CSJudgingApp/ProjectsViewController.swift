import UIKit

enum Category: String {
    case BegProg = "Beginner Programming "
    case IntProj = "Intermediate Projects "
    case AdvProj = "Advanced Projects "
    case ResProj = "Research Projects "
    case BegWebD = "Beginner Web Design "
    case IntWebD = "Intermediate Web Design "
}

class ProjectsViewController: UITableViewController
{
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
        
        API.FetchAllProjectsFromWeb(completion: updateTableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if(API.isLoggedIn)
//        {
//            let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! CustomCell
//            cell.nameLabel.text = "Loading..."
//        }
//        else
//        {
//            let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! CustomCell
//            cell.nameLabel.text = "Sign In To View Projects"
//        }
        API.FetchAllProjectsFromWeb(completion: updateTableView)
    }
    
    func updateTableView(projectsResult: ProjectsResult)
    {
        switch projectsResult
        {
            case let .Success(projects):
                
                ProjectStore.Projects = projects
                
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
        if (ProjectStore.Projects.count == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotLoggedInCell", for: indexPath) as! CustomCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none;
            return cell
        }
        
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
        
        //bootleg ascii fix :)
        project.name = project.name.replacingOccurrences(of: "&#039;", with: "'")
        project.name = project.name.replacingOccurrences(of: "&rsquo;", with: "'")
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
                }
            
            default:
                preconditionFailure("Unexpected Segue Identifier.")
        }
    }    
}

