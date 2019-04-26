import Foundation

class Project: NSObject {
    
    var name: String
    var id: Int
    var desc: String
    var cat: String
    var boothNumber: String
    var time: String
    var students: [String]
    var courses: [String]
    var boothSide: String
    var judgingInfo: [(Any)]
    var areJudged: Bool
    var hasJudged: Bool
    var functionality: Int
    var design: Int
    var presentation: Int
    
//    var year: Int
//    var image_url: String
//    var is_judge: Bool
//    var has_judged: Bool
//    var color: String
    
    
    init(name: String, id: Int, desc: String, cat: String, booth: String, time: String,
         students: [String], courses: [String], boothSide: String, judgingInfo: [(Any)], areJudged: Bool,
         hasJudged: Bool, functionality: Int, design: Int, presentation: Int){
        
        
        self.name = name
        self.id = id
        self.desc = desc
        self.cat = cat
        self.boothNumber = booth
        self.courses = courses
        self.time = time
        self.students = students
        self.boothSide = boothSide
        self.judgingInfo = judgingInfo
        self.areJudged = areJudged
        self.hasJudged = hasJudged
        self.functionality = functionality
        self.design = design
        self.presentation = presentation
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
