import Foundation

enum ProjectsResult
{
    case Success([Project])
    case Failure(Error)
}

class ProjectStore
{
    var Projects: [Project] = []
    
    init() { }
}
