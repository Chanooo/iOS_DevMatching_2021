import Foundation

struct Lecture: Codable {
    let id: String                 // 아이디
    let number: String             // 강좌번호
    let name: String               // 강좌명
    let classfyName: String        // 강좌분류
    let middleClassfyName: String  // 강좌분류2
    let courseImage: String        // 강좌 썸네일 (media>image>small)
    let courseImageLarge: String   // 강좌 이미지 (media>image>large)
    let shortDescription: String   // 짧은 설명
    let orgName: String            // 운영기관
    let start: Date                // 운영기간 시작
    let end: Date                  // 운영기간 종료
    let teachers: String?          // 교수진
    let overview: String?          // 상제정보(html)

    init(id: String,
         number: String,
         name: String,
         classfyName: String,
         middleClassfyName: String,
         courseImage: String,
         courseImageLarge: String,
         shortDescription: String,
         orgName: String,
         start: Date,
         end: Date,
         teachers: String?,
         overview: String?) {
        self.id = id
        self.number = number
        self.name = name
        self.classfyName = classfyName
        self.middleClassfyName = middleClassfyName
        self.courseImage = courseImage
        self.courseImageLarge = courseImageLarge
        self.shortDescription = shortDescription
        self.orgName = orgName
        self.start = start
        self.end = end
        self.teachers = teachers
        self.overview = overview
    }
}

extension Lecture {
    static let EMPTY = Lecture(id: "", number: "", name: "", classfyName: "", middleClassfyName: "", courseImage: "", courseImageLarge: "", shortDescription: "", orgName: "", start: Date(), end: Date(), teachers: nil, overview: nil)
}
