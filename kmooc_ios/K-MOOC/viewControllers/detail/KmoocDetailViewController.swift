import UIKit
import WebKit

class KmoocDetailViewController: UIViewController{
    @IBOutlet var viewModel: KmoocDetailViewModel!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var innerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var lectureImage: UIImageView!
    @IBOutlet var lectureNumber: UILabel!
    @IBOutlet var lectureType: UILabel!
    @IBOutlet var lectureOrg: UILabel!
    @IBOutlet var lectureTeachers: UILabel!
    @IBOutlet var lectureDue: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var loading: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loading.startAnimating()
        
        initView()
        bindViewModel()
        
        viewModel.detail()
    }
    
    
    private func initView() {
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    private func bindViewModel() {
        viewModel.reloadRelay = { isLoadSuccess in
            if isLoadSuccess {
                self.setData()
            } else {
                self.showErrorAlert()
            }
        }
    }
    
    private func setData() {
        let lecture = viewModel.getLecture()
        
        navigationItem.title = lecture.name
        
        lectureImage.downloaded(from: lecture.courseImageLarge)
        lectureNumber.text = lecture.number
        lectureType.text = "\(lecture.classfyName) (\(lecture.middleClassfyName))"
        lectureOrg.text = lecture.orgName
        lectureTeachers.text = lecture.teachers
        let startDate = lecture.start.toString(format: "yyyy/MM/dd")
        let endDate = lecture.end.toString(format: "yyyy/MM/dd")
        lectureDue.text = "\(startDate) ~ \(endDate)"
        
        
        if let html = lecture.overview {
            webView.loadHTMLString(html, baseURL: nil)
        }
        
        loading.stopAnimating()
    }
    
    
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "알림",
                                      message: "데이터를 로드하지 못했습니다.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "확인",
                                   style: .default,
                                   handler: { alert in
                                    self.navigationController?.popViewController(animated: true)
                                   })
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}


// MARK: - 웹뷰 관련
extension KmoocDetailViewController: WKNavigationDelegate, UIScrollViewDelegate {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print("웹뷰 로드 중... \(self.webView.estimatedProgress)");
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("웹뷰 로드 시작")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("웹뷰에 뿌려주기 시작")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let urlStr = webView.url?.absoluteString {
            print("웹뷰 로드 완료: \(urlStr)")
        }
    }
    
    
    // UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.webView.scrollView {
            if scrollView.contentOffset.y < scrollView.frame.size.height + 20 {
                self.scrollView.setContentOffset(CGPoint(x: 0, y:scrollView.contentOffset.y), animated: false)
                innerViewHeightConstraint.constant = scrollView.contentOffset.y
            }
        }
    }
    
}
