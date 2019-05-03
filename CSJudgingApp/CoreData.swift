import Foundation
import CoreData

class CoreData {
    
    let Context: NSManagedObjectContext =
    {
        let Container = NSPersistentContainer(name: "LogIn")
        Container.loadPersistentStores
            {
                (description, error) in
                if let error = error
                {
                    print("Error Setting Up Core Data (\(error)).")
                }
        }
        return Container.viewContext
    }()
    
    let UserRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    
    //=========================
    
    func userDataExists() -> Bool
    {
        UserRequest.returnsObjectsAsFaults = false
        
        do {
            let Result = try! Context.fetch(UserRequest)        
            return !(Result.isEmpty)
        }
    }
    
    //=========================
    
    func getUsernameFromCore() -> String
    {
        UserRequest.returnsObjectsAsFaults = false
        
        do {
            let Result = try! Context.fetch(UserRequest)
            
            let User = Result[0] as! NSManagedObject
            
            return User.value(forKey: "username") as! String
        }
    }
    
    //=========================
    
    func getPasswordFromCore() -> String
    {
        UserRequest.returnsObjectsAsFaults = false
        
        do {
            let Result = try! Context.fetch(UserRequest)
            
            let User = Result[0] as! NSManagedObject
            
            return User.value(forKey: "password") as! String
        }
    }
    
    //=========================
    
    func getTokenFromCore() -> String
    {
        UserRequest.returnsObjectsAsFaults = false
        
        do {
            let Result = try! Context.fetch(UserRequest)
            
            let User = Result[0] as! NSManagedObject
            
            return User.value(forKey: "token") as! String
        }
    }
    
    //=========================
    
    func isTokenOld() -> Bool
    {
        UserRequest.returnsObjectsAsFaults = false
        
        do {
            let Result = try! Context.fetch(UserRequest)
            
            let User = Result[0] as! NSManagedObject
            
            let Date = User.value(forKey: "token_date") as! Date
            
            return abs(Date.timeIntervalSinceNow) > 432000 //432,000 Seconds = 5 Days
        }
    }
    
    //=========================
    
    func updateEntity(Username: String, Password: String, Token: String, Date: Date)
    {
        self.cleanEntity()
        
        let Entity = NSEntityDescription.entity(forEntityName: "User", in: Context)
        let NewUser = NSManagedObject(entity: Entity!, insertInto: Context)
        
        NewUser.setValue(Username, forKey: "username")
        NewUser.setValue(Password, forKey: "password")
        NewUser.setValue(Token, forKey: "token")
        NewUser.setValue(Date, forKey: "token_date")
        
        do {
            try Context.save()
        }
        catch {
            print("Failed saving")
        }
    }
    
    //=========================
    
    func cleanEntity()
    {
        UserRequest.includesPropertyValues = false
        
        do {
            let Entities = try Context.fetch(UserRequest) as! [NSManagedObject]
            
            for e in Entities {
                Context.delete(e)
            }
            
            // Save Changes
            try Context.save()
        }
        catch {
            print("Error Cleaning Entity")
        }
    }
}

