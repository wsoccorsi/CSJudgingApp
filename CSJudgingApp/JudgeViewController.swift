import UIKit

class JudgeViewController: UIViewController
{
    @IBOutlet weak var F1Button: UIButton!
    @IBOutlet weak var F2Button: UIButton!
    @IBOutlet weak var F3Button: UIButton!
    @IBOutlet weak var F4Button: UIButton!
    @IBOutlet weak var F5Button: UIButton!
    var FuncButtons : [UIButton]!
    var FuncScore : Int?
    
    @IBOutlet weak var D1Button: UIButton!
    @IBOutlet weak var D2Button: UIButton!
    @IBOutlet weak var D3Button: UIButton!
    @IBOutlet weak var D4Button: UIButton!
    @IBOutlet weak var D5Button: UIButton!
    var DesgButtons : [UIButton]!
    var DesgScore : Int?
    
    @IBOutlet weak var P1Button: UIButton!
    @IBOutlet weak var P2Button: UIButton!
    @IBOutlet weak var P3Button: UIButton!
    @IBOutlet weak var P4Button: UIButton!
    @IBOutlet weak var P5Button: UIButton!
    var PresButtons : [UIButton]!
    var PresScore : Int?
    
    @IBOutlet weak var ProjTitle: UILabel!    
    
    var Project: Project!
    
    override func viewDidLoad()
    {
        ProjTitle.text = Project.name
        
        FuncButtons = [F1Button, F2Button, F3Button, F4Button, F5Button]
        DesgButtons = [D1Button, D2Button, D3Button, D4Button, D5Button]
        PresButtons = [P1Button, P2Button, P3Button, P4Button, P5Button]
        
        let AllButtons = [FuncButtons, DesgButtons, PresButtons]
        for bs in AllButtons
        {
            for b in bs! {
                b.alpha = 0.25
            }
        }
    }
    
    func FillButtons(tap: Int, buttons: [UIButton])
    {
        for i in 0...4
        {
            if (i < tap) {
                buttons[i].alpha = 1
            }
            else {
                buttons[i].alpha = 0.25
            }
        }
    }
    
    @IBAction func F1Tap(_ sender: Any) {
        FillButtons(tap: 1, buttons: FuncButtons)
        FuncScore = 1
    }
    @IBAction func F2Tap(_ sender: Any) {
        FillButtons(tap: 2, buttons: FuncButtons)
        FuncScore = 2
    }
    @IBAction func F3Tap(_ sender: Any) {
        FillButtons(tap: 3, buttons: FuncButtons)
        FuncScore = 3
    }
    @IBAction func F4Tap(_ sender: Any) {
        FillButtons(tap: 4, buttons: FuncButtons)
        FuncScore = 4
    }
    @IBAction func F5Tap(_ sender: Any) {
        FillButtons(tap: 5, buttons: FuncButtons)
        FuncScore = 5
    }
    
    @IBAction func D1Tap(_ sender: Any) {
        FillButtons(tap: 1, buttons: DesgButtons)
        DesgScore = 1
    }
    @IBAction func D2Tap(_ sender: Any) {
        FillButtons(tap: 2, buttons: DesgButtons)
        DesgScore = 2
    }
    @IBAction func D3Tap(_ sender: Any) {
        FillButtons(tap: 3, buttons: DesgButtons)
        DesgScore = 3
    }
    @IBAction func D4Tap(_ sender: Any) {
        FillButtons(tap: 4, buttons: DesgButtons)
        DesgScore = 4
    }
    @IBAction func D5Tap(_ sender: Any) {
        FillButtons(tap: 5, buttons: DesgButtons)
        DesgScore = 5
    }
    
    @IBAction func P1Tap(_ sender: Any) {
        FillButtons(tap: 1, buttons: PresButtons)
        PresScore = 1
    }
    @IBAction func P2Tap(_ sender: Any) {
        FillButtons(tap: 2, buttons: PresButtons)
        PresScore = 2
    }
    @IBAction func P3Tap(_ sender: Any) {
        FillButtons(tap: 3, buttons: PresButtons)
        PresScore = 3
    }
    @IBAction func P4Tap(_ sender: Any) {
        FillButtons(tap: 4, buttons: PresButtons)
        PresScore = 4
    }
    @IBAction func P5Tap(_ sender: Any) {
        FillButtons(tap: 5, buttons: PresButtons)
        PresScore = 5
    }
}
