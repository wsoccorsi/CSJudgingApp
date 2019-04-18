enum HomeScreenResult {
    case Success(HomeScreen)
    case Failure(Error)
}

import Foundation

class HomeScreen : NSObject
{
    var id : Int!
    var name : String!
    var deescription : String!   // description is a feild in NSobject, cannot use as a variable as a result
    var year : String!
    var is_current : Bool!
    var featured_img_url : String!
    var date : String!
    
    override init()
    {
        super.init()
    }
    
    init(id: Int, name: String, deescription: String, year: String, is_current: Bool, featured_img_url: String, date: String )
    {
        self.id = id
        self.name = name
        self.deescription = deescription
        self.year = year
        self.is_current = is_current
        self.featured_img_url = featured_img_url
        self.date = date
        
        super.init()
    }
}

