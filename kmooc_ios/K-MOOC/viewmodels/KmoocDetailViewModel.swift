import Foundation

class KmoocDetailViewModel: NSObject {
    @IBOutlet var repository: KmoocRepository!

    private var lecture = Lecture.EMPTY
    var reloadRelay: ((Bool)->())?
    
    var lectureId: String = ""

    func detail() {
        repository.detail(courseId: lectureId)
        { lecture in
            self.lectureId = lecture.id
            self.lecture = lecture
            let isSuccess = self.lectureId != ""
            self.reloadRelay?(isSuccess)
            
            if isSuccess {
                print("상세화면 로드 성공")
            }
        }
    }
    
    func getLecture() -> Lecture {
        return lecture
    }
}
