import Foundation

class Project: NSObject {
    
    var title: String
    var id: Int
    //    var desc: String
    //    var year: Int
    //    var image_url: String
    //    var is_judge: Bool
    //    var has_judged: Bool
    //    var category: String
    //    var color: String
    //    var students: [String]
    //    var boothNumber: Int
    //    var boothSide: String
    //    var courses: [String]
    //    var time: String
    
    init(title: String, id: Int) {
        
        self.title = title
        self.id = id
        
        super.init()
    }
}

//"judging_info": [
//{
//"criteria": {
//"name": "Functionality",
//"description": "How well does the project work? Does it do what they claim?",
//"min": "0",
//"max": "5",
//"importance": "1.0"
//},
//"judge_score": null,
//"judge_note": null
//},
//{
//"criteria": {
//"name": "Design",
//"description": "Based this on how professional the final product looks.",
//"min": "0",
//"max": "5",
//"importance": "1.0"
//},
//"judge_score": null,
//"judge_note": null
//},
//{
//"criteria": {
//"name": "Presentation",
//"description": "Did they sell it well?",
//"min": "0",
//"max": "5",
//"importance": "1.0"
//},
//"judge_score": null,
//"judge_note": null
//}
//],
