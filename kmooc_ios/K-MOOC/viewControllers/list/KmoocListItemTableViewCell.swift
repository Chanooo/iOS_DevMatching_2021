import UIKit

class KmoocListItemTableViewCell: UITableViewCell {
    static let CellIdentifier = "LectureItem"

    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var orgName: UILabel!
    @IBOutlet var duration: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
