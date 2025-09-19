//
//  SEARCHViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 1/19/21.
//

import UIKit

extension SEARCHViewController {
    enum SearchType: Int {
        case profile = 0
        case events = 1
        case review = 2
        case jobs = 3
        case circle = 4
        case resume = 5
        
        var index: Int {
            switch self {
            case .profile:
                return 0
            case .events:
                return 1
            case .review:
                return 2
            case .jobs, .resume:
                return 3
            case .circle:
                return 4
            }
        }
    }
    
    enum CircleSearchType: String, Equatable {
        case Circles = "All"
        case Dating
        case DineOut = "Dine Out"
        case Travel
    }
}

class SEARCHViewController: BaseViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var datingCircleSearchView: UIView!
    @IBOutlet weak var jobsSearchView: UIView!
    @IBOutlet weak var resumesSearchView: UIView!
    @IBOutlet weak var stackContainerView: UIStackView!
    @IBOutlet weak var datingAnchorView: UIView!
    @IBOutlet weak var datingButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var jobButton: UIButton!
    
    var searchType: SearchType = .profile {
        didSet {
            currentIndex = searchType.index
        }
    }
    
    private var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var pages: [UIViewController] = []
    private var currentIndex: Int = 0
    private var numberOfSection: CGFloat = 0
    
    private var dropDown = DropDown()
    private let circleDataSource: [CircleSearchType] = [.Circles, .Travel, .DineOut, .Dating]
    private var currentCircleSearch: CircleSearchType = .Circles {
        didSet {
            self.updateSearchTypeForChildView(currentCircleSearch)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPageController()
        setupDropdown()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.pageController.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
    }
    
    @IBAction func selectTabAction(_ sender: UIButton) {
        guard let searchType = SearchType(rawValue: sender.tag) else { return }
        guard searchType.index != currentIndex else {
            if searchType == .circle {
                dropDown.show()
            }
            return
        }
        pageController.setViewControllers([pages[searchType.index]], direction: searchType.index < currentIndex ? .reverse : .forward, animated: true, completion: nil)
        currentIndex = searchType.index
        self.searchType = searchType
        updateUI()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension SEARCHViewController {
    
    private func updateUI() {
        profileButton.backgroundColor = searchType == .profile ? Constants.red_brown : UIColor.clear
        eventButton.backgroundColor   = searchType == .events  ? Constants.red_brown : UIColor.clear
        reviewsButton.backgroundColor = searchType == .review  ? Constants.red_brown : UIColor.clear
        datingButton.backgroundColor  = searchType == .circle  ? Constants.red_brown : UIColor.clear
        jobButton.backgroundColor     = searchType == .jobs    ? Constants.red_brown : UIColor.clear
        resumeButton.backgroundColor  = searchType == .resume  ? Constants.red_brown : UIColor.clear
    }
    
    func setupUI() {
        updateUI()
        self.datingButton.setTitle("Circles", for: .normal)
        guard let user = AppSettings.shared.currentUser else { return }
        switch user.accountType {
        case .personal:
            resumesSearchView.isHidden = true
            pages = [SearchProfileViewController.instantiate(),
                     SearchEventsViewController.instantiate(),
                     SearchReviewsViewController.instantiate(),
                     SearchJobsViewController.instantiate(),
                     SearchDatingCircleViewController.instantiate()]
        case .business:
            datingCircleSearchView.isHidden = true
            jobsSearchView.isHidden = true
            pages = [SearchProfileViewController.instantiate(),
                     SearchEventsViewController.instantiate(),
                     SearchReviewsViewController.instantiate(),
                     SearchResumeViewController.instantiate()]
        }
        numberOfSection = CGFloat(pages.count)
    }
    
    private func setupPageController() {
        self.pageController.dataSource = self
        self.pageController.delegate = self
        self.pageController.view.backgroundColor = .clear
        self.pageController.view.frame = CGRect(x: 0,y: 0,width: self.containerView.frame.width,height: self.containerView.frame.height)
        self.addChild(self.pageController)
        self.containerView.addSubview(self.pageController.view)
        let initialVC = pages[currentIndex]
        
        self.pageController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        self.pageController.didMove(toParent: self)
        
        for v in pageController.view.subviews {
            if v.isKind(of: UIScrollView.self) {
                (v as! UIScrollView).isScrollEnabled = false
            }
        }
    }
    
    private func setupDropdown() {
        dropDown.anchorView = datingAnchorView
        dropDown.dataSource = circleDataSource.map( { $0.rawValue })
        dropDown.bottomOffset = CGPoint(x: 0, y: datingAnchorView.frame.height + 5)
        dropDown.direction = .bottom
        dropDown.selectRow(0)
        dropDown.textFont = UIFont.myriadProRegular(ofSize: 15)
        dropDown.cellHeight = 44.0
        dropDown.animationduration = 0.2
        dropDown.backgroundColor = UIColor.white
        dropDown.selectionBackgroundColor = UIColor.white
        dropDown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        dropDown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.handleCircleSearchSelection(searchType: self.circleDataSource[index])
        }
    }
    
    private func showUpdateDatingCircle(_ text: String) {
        self.showAlert(title: "Oops!", message: text, buttonTitles: ["No", "Yes"], highlightedButtonIndex: nil) { (index) in
            if index == 1 {
                self.navigationController?.pushViewController(DatingCircleViewController.instantiate(), animated: true)
            }
        }
    }
    
    private func showUpdateDinnerCircle(_ text: String) {
        self.showAlert(title: "Oops!", message: text, buttonTitles: ["No", "Yes"], highlightedButtonIndex: nil) { (index) in
            if index == 1 {
                self.navigationController?.pushViewController(DineoutCircleViewController.instantiate(), animated: true)
            }
        }
    }
    
    private func showUpdateTravelCircle(_ text: String) {
        self.showAlert(title: "Oops!", message: text, buttonTitles: ["No", "Yes"], highlightedButtonIndex: nil) { (index) in
            if index == 1 {
                self.navigationController?.pushViewController(TravelCircleViewController.instantiate(), animated: true)
            }
        }
    }
    
    private func handleCircleSearchSelection(searchType: CircleSearchType) {
        guard let user = AppSettings.shared.currentUser else { return }
        switch searchType {
        case .Circles:
            self.currentCircleSearch = searchType
            DispatchQueue.main.async {
                self.datingButton.setTitle(self.currentCircleSearch.rawValue, for: .normal)
            }
        case .Dating:
            if user.dating_status == false {
                self.showUpdateDatingCircle("To use Dating Circle Search, you must first Opt into the Dating Circle.")
            } else {
                self.currentCircleSearch = searchType
                DispatchQueue.main.async {
                    self.datingButton.setTitle(self.currentCircleSearch.rawValue, for: .normal)
                }
            }
        case .DineOut:
            if user.dinner_status == nil || user.dinner_status == false {
                self.showUpdateDinnerCircle("To use Dine Out Circle Search, you must first Opt into the Dine out Circle.")
            } else {
                self.currentCircleSearch = searchType
                DispatchQueue.main.async {
                    self.datingButton.setTitle(self.currentCircleSearch.rawValue, for: .normal)
                }
            }
        case .Travel:
            if user.travel_status == nil || user.travel_status == false {
                self.showUpdateTravelCircle("To use Travel Circle Search, you must first Opt into the Travel Circle.")
            } else {
                self.currentCircleSearch = searchType
                DispatchQueue.main.async {
                    self.datingButton.setTitle(self.currentCircleSearch.rawValue, for: .normal)
                }
            }
        }
    }
    
    private func updateSearchTypeForChildView(_ searchType: CircleSearchType) {
        guard let searchCircleVC = pages.last as? SearchDatingCircleViewController else { return }
        searchCircleVC.searchType = searchType
    }
}

extension SEARCHViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private func viewController(comingFrom viewController: UIViewController, indexModifier: Int) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        
        let newIndex = index + indexModifier
        guard newIndex >= 0 && newIndex < pages.count else { return nil }
        return pages[newIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return self.viewController(comingFrom: viewController, indexModifier: -1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return self.viewController(comingFrom: viewController, indexModifier: 1)
    }
}
