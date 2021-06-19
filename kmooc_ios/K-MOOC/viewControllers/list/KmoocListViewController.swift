import UIKit
import Combine

class KmoocListViewController: UITableViewController {
    @IBOutlet var viewModel: KmoocListViewModel!
    private var isFetchingNext: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        bindViewModel()
        refreshList()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "KmoocDetail",
           let lecture = sender as? Lecture,
           let detail = segue.destination as? KmoocDetailViewController {
            detail.viewModel.lectureId = lecture.id
        }
    }
    
    private func initView() {
        let activity = UIActivityIndicatorView()
        view.addSubview(activity)
        activity.tintColor = .red
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // bind refresher
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.beginRefreshing()
        
    }
    
    private func bindViewModel() {
        viewModel.reloadRelay = { isSuccess in
            self.isFetchingNext = false
            if isSuccess {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            } else {
                self.refreshList()
            }
        }
    }
    
    @objc
    private func refreshList() {
        viewModel.list()
    }
}


extension KmoocListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lecturesCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KmoocListItemTableViewCell.CellIdentifier) as! KmoocListItemTableViewCell
        let lecture = viewModel.lecture(at: indexPath.row)
        cell.thumbnail.downloaded(from: lecture.courseImage)
        cell.name.text = lecture.name
        cell.orgName.text = lecture.orgName
        let startDate = lecture.start.toString(format: "yyyy/MM/dd")
        let endDate = lecture.end.toString(format: "yyyy/MM/dd")
        cell.duration.text = "\(startDate) ~ \(endDate)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lecture = viewModel.lecture(at: indexPath.row)
        performSegue(withIdentifier: "KmoocDetail", sender: lecture)
    }
    

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height
        {
            let isRefreshing = tableView.refreshControl?.isRefreshing ?? true
            if !isRefreshing, !isFetchingNext {
                isFetchingNext = true
                viewModel.next()
            }
        }
    }
}
