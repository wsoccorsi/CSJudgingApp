import UIKit

class HomeScreenViewController : UIViewController {
    
    var HomeScreen : HomeScreen!
    
    var img : UIImage!
    @IBOutlet var imgView : UIImageView!
    @IBOutlet var name : UILabel!
    @IBOutlet var deeescription: UILabel!
    @IBOutlet var date : UILabel!
    
    var API: WebAPI!
    var CData: CoreData!

    var isVisible: Bool = false
    
    @IBOutlet var Username: UITextField!
    @IBOutlet var Password: UITextField!
    @IBOutlet var Status: UILabel!
    @IBOutlet var SignInButton: UIButton!
    @IBOutlet var SignOutButton: UIButton!
    
    @IBOutlet var MenuLead: NSLayoutConstraint!
    @IBOutlet var MenuWidth: NSLayoutConstraint!
    @IBOutlet weak var UsernameCenter: NSLayoutConstraint!
    @IBOutlet weak var PasswordCenter: NSLayoutConstraint!
    @IBOutlet var SignInCenter: NSLayoutConstraint!
    @IBOutlet var SignOutCenter: NSLayoutConstraint!
    
    @IBOutlet weak var NavBar: UINavigationItem!
    
    var InitialStatus : String = "NotLoggedIn"
        
    override func viewDidLoad()
    {
        super.viewDidLoad()        
        
        //Username.text = "william.slocum@uvm.edu"
        //Password.text = "Password12345Password"
        
        MenuWidth.constant = UIScreen.main.bounds.width
        MenuLead.constant = UIScreen.main.bounds.width * -1
        
        Status.text = "Sign In!"
        Status.textColor = UIColor.white
        //Status.lineBreakMode = .byWordWrapping
        Username.isHidden = false
        Username.text = "william.slocum@uvm.edu"
        Password.isHidden = false
        Password.text = "Password12345Password"
        SignInButton.isHidden = false
        SignOutButton.isHidden = true
        
        Username.autocorrectionType = UITextAutocorrectionType.no
        Password.autocorrectionType = UITextAutocorrectionType.no
        Password.isSecureTextEntry = true
        
        updateMenuView(LogInStatus: InitialStatus)
        
        API.FetchHomeScreenFromWeb(completion: updateView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        API.FetchHomeScreenFromWeb(completion: updateView)
    }
    
    func updateView(homeScreenResult: HomeScreenResult)
    {
        switch homeScreenResult
        {
            case let .Success(HomeScreen):
                
                let image_url: String? = HomeScreen.featured_img_url
                if let img_url = image_url
                {
                    do {
                        let url = URL(string: img_url)
                        let data = try Data(contentsOf: url!)
                        imgView.image = UIImage(data: data)
                    }
                    catch {
                        print(error)
                    }
                }
                
                name.text = HomeScreen.name
                name.textAlignment = .left
                
                let deeescriptiontemp = HomeScreen.deescription.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                deeescription.text = deeescriptiontemp
                
                date.text = HomeScreen.date
            
            case let .Failure(error):
                imgView.image = nil
                name.text = "Tap the Top Left Corner to Sign In"
                name.textAlignment = .center
                deeescription.text = ""
                date.text = ""
                print("Error Fetching HomeScreen: \(error)")
        }        
    }
    
    @IBAction func SignOutTapped(_ sender: Any) {
        API.LogOut()
        self.updateView(homeScreenResult: .Failure(NSError(domain:"", code:400, userInfo:nil)))
        self.updateMenuView(LogInStatus: "NotLoggedIn")
    }
    
    @IBAction func buttonTapped(_ sender: Any)
    {
        if (!isVisible)
        {
            MenuLead.constant = 0
            isVisible = true
        }
        else
        {
            MenuLead.constant = UIScreen.main.bounds.width * -1
            API.FetchHomeScreenFromWeb(completion: updateView)
            isVisible = false
        }
        
        UIView.animate(withDuration: 0.4, animations: {self.view.layoutIfNeeded()})
    }
    
    @IBAction func submit(_ sender: Any) {
        API.LogIn(username: Username.text!, password: Password.text!, completion: updateMenuView)
    }
    
    func updateMenuView(LogInStatus: String)
    {
        if(LogInStatus == "SuccessfulLogIn") {
            Status.text = "Logged In As\n" + API.Username!
            Status.textColor = HexStringToUIColor(hex: "50C878")
            Username.isHidden = true
            Password.isHidden = true
            SignInButton.isHidden = true
            SignOutButton.isHidden = false
            API.FetchHomeScreenFromWeb(completion: updateView)
        }
        if(LogInStatus == "NotLoggedIn") {
            Status.text = "Sign In!"
            Status.textColor = UIColor.white
            Username.isHidden = false
            Password.isHidden = false
            SignInButton.isHidden = false
            SignOutButton.isHidden = true
        }
        if(LogInStatus == "FailedLogIn") {
            Status.text = "Incorrect Username or Password"
            Status.textColor = HexStringToUIColor(hex: "AD2710")
            Username.isHidden = false
            Password.isHidden = false
            SignInButton.isHidden = false
            SignOutButton.isHidden = true
        }
    }
    
    func InitializeStatus(LogInStatus: String)
    {
        InitialStatus = LogInStatus
    }
}
