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
    
    var DesgButtons : [UIButton]!
    var PresButtons : [UIButton]!
    
    override func viewDidLoad()
    {
        FuncButtons = [F1Button, F2Button, F3Button, F4Button, F5Button]
        DesgButtons = []
        PresButtons = []
        
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
}
