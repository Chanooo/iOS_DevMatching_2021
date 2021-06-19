import Foundation

struct LectureList: Codable {
    let count: Int
    let numPages: Int
    let previous: String
    let next: String
    var lectures: [Lecture]

    init(count: Int,
         numPages: Int,
         previous: String,
         next: String,
         lectures: [Lecture]) {
        self.count = count
        self.numPages = numPages
        self.previous = previous
        self.next = next
        self.lectures = lectures
    }
}

extension LectureList {
    static let EMPTY = LectureList(count: 0, numPages: 0, previous: "", next: "", lectures: [])
}
