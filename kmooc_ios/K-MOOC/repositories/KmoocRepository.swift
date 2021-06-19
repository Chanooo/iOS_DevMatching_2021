import Foundation

class KmoocRepository: NSObject {
    /**
     * 국가평생교육진흥원_K-MOOC_강좌정보API
     * https://www.data.go.kr/data/15042355/openapi.do
     */

    private let httpClient = HttpClient(baseUrl: "http://apis.data.go.kr/B552881/kmooc")
    private let serviceKey =
        "a5nkHGYLkC%2BOQLPPeg8MS0df6PQnu%2BO0eKc59KOfngS21WZ8P4G92v%2BVVTlIb8e7LTrilxAyxJBsDm7dg0jXyQ%3D%3D"

    func list(completed: @escaping (LectureList) -> Void) {
        httpClient.getJson(path: "/courseList",
                           params: ["serviceKey": serviceKey, "Mobile": 1]
        ) { result in
            let json = try? result.get()
            let list = self.convertToList(json: json)
            completed(list)
        }
    }

    func next(currentPage: LectureList, completed: @escaping (LectureList) -> Void) {
        let nextPageUrl = currentPage.next
        httpClient.getJson(path: nextPageUrl, params: [:])
        { result in
            let json = try? result.get()
            let list = self.convertToList(json: json)
            completed(list)
        }
    }

    func detail(courseId: String, completed: @escaping (Lecture) -> Void) {
        httpClient.getJson(path: "/courseDetail",
                           params: ["CourseId": courseId, "serviceKey": serviceKey])
        { result in
            let json = try? result.get()
            let lecture = self.convertToDetail(json: json)
            completed(lecture)
        }
    }
    
    
    private func convertToDetail(json: String?) -> Lecture {
        guard let json = json else { return Lecture.EMPTY }
        let data = json.data(using: .utf8)!
        let item = try? JSONSerialization.jsonObject(with: data, options: [])
        if let recvData = item as? [String:Any] {
            let media = recvData["media"] as? [String: Any]
            let image = media?["image"] as? [String: Any]
            let largeImage = image?["large"] as? String ?? ""
            let rawImage = image?["raw"] as? String ?? ""
            
            return Lecture(
                id : recvData["id"] as? String ?? "",
                number:  recvData["number"] as? String ?? "",
                name:  recvData["name"] as? String ?? "",
                classfyName:  recvData["classfy_name"] as? String ?? "",
                middleClassfyName:  recvData["middle_classfy"] as? String ?? "",
                courseImage: rawImage,
                courseImageLarge: largeImage,
                shortDescription:  recvData["short_description"] as? String ?? "",
                orgName:  recvData["org_name"] as? String ?? "",
                start:  (recvData["start"] as? String ?? "").toDate(),
                end:  (recvData["end"] as? String ?? "").toDate(),
                teachers:  recvData["teachers"] as? String ?? "",
                overview:  recvData["overview"] as? String ?? ""
            )
        } else {
            return Lecture.EMPTY
        }
        
    }
    
    
    
    private func convertToList(json: String?) -> LectureList {
        guard let json = json else { return LectureList.EMPTY }
        
        let data = json.data(using: .utf8)!
        let item = try? JSONSerialization.jsonObject(with: data, options: [])
        if let recvData = item as? [String:Any] {
            
            guard
                let pagination = recvData["pagination"] as? [String:Any],
                let results = recvData["results"] as? [[String:Any]]
            else {
                return LectureList.EMPTY
            }
            
            var lectures:[Lecture] = []
            results.forEach{
                
                let media = $0["media"] as? [String: Any]
                let image = media?["image"] as? [String: Any]
                let largeImage = image?["large"] as? String ?? ""
                let rawImage = image?["raw"] as? String ?? ""
                
                lectures.append(
                    Lecture(
                        id : $0["id"] as? String ?? "",
                        number:  $0["number"] as? String ?? "",
                        name:  $0["name"] as? String ?? "",
                        classfyName:  $0["classfy_name"] as? String ?? "",
                        middleClassfyName:  $0["middle_classfy_name"] as? String ?? "",
                        courseImage: rawImage,
                        courseImageLarge: largeImage,
                        shortDescription:  $0["short_description"] as? String ?? "",
                        orgName:  $0["org_name"] as? String ?? "",
                        start:  ($0["start"] as? String ?? "").toDate(),
                        end:  ($0["end"] as? String ?? "").toDate(),
                        teachers:  $0["teachers"] as? String ?? "",
                        overview:  $0["overview"] as? String ?? ""
                    )
                )
            }
            
            let list = LectureList(
                count: pagination["count"] as? Int ?? 0,
                numPages: pagination["num_pages"] as? Int ?? 0,
                previous: pagination["previous"] as? String ?? "",
                next: pagination["next"] as? String ?? "",
                lectures: lectures
            )
            return list
        } else {
            return LectureList.EMPTY
        }
    }
}
