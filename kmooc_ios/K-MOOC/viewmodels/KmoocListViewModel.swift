import Foundation
import Combine

class KmoocListViewModel: NSObject {
    @IBOutlet var repository: KmoocRepository!

    var reloadRelay: ((Bool)->())?
    private var lectureList: LectureList = LectureList.EMPTY

    func lecturesCount() -> Int {
        return lectureList.lectures.count
    }

    func lecture(at index: Int) -> Lecture {
        return lectureList.lectures[index]
    }

    func list() {
        repository.list {
            self.lectureList = $0
            let isSuccess = $0.count > 0
            self.reloadRelay?(isSuccess)
            
            if isSuccess {
                print("첫번째 페이지 로드 성공")
            }
        }
    }

    func next() {
        repository.next(currentPage: lectureList) {
            var lectureList = $0
            lectureList.lectures.insert(contentsOf: self.lectureList.lectures, at: 0)
            self.lectureList = lectureList
            self.reloadRelay?(true)
            
            if $0.count > 0 {
                print("다음페이지 로드 성공")
            }
        }
    }
    
}
