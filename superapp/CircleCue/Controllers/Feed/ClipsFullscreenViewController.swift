//
//  ClipsFullscreenViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 5/18/21.
//

import UIKit

protocol FullscreenViewDelegate: AnyObject {
    func didLoadMore(_ results: [NewFeed], hasMore: Bool, currentPage: Int)
    func updateNewFeed(_ newFeed: NewFeed?)
}

class ClipsFullscreenViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    
    var allClipFeeds: [NewFeed] = []
    var currentFeed: NewFeed!
    var currentType: FeedType = .all
    var username: String = ""
    var currentPage: Int = 1
    var hasMore: Bool = true
    weak var delegate: FullscreenViewDelegate?
    var isLoop = true
    private var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
    private var pages: [UIViewController] = []
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupPageController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.pageController.view.frame = CGRect(x: 0,y: 0,width: self.containerView.frame.width,height: self.containerView.frame.height)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let playerController = pages[currentIndex] as? PlayerViewController
        playerController?.playPauseVideo(play: false)
        
        let feed = allClipFeeds[currentIndex]
        let content = "\(feed.title) - \(feed.description) - \(feed.date)"
        var activityItems: [Any] = [content]
        if let url = URL(string: feed.pic) {
            activityItems.append(url)
        }
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.completionWithItemsHandler = {(_, _, _, _) in
            playerController?.playPauseVideo(play: true)
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
        }
        
        DispatchQueue.main.async {
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ClipsFullscreenViewController {
    
    private func setup() {
        addSwipe()
    }
    
    private func addSwipe() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGestureAction(_:)))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
    }
    
    @objc private func swipeGestureAction(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .down:
            print("Swipe down")
            guard currentIndex > 0 else { return }
            currentIndex -= 1
            self.pageController.setViewControllers([pages[currentIndex]], direction: .reverse, animated: true, completion: nil)
        case .up:
            print("Swipe Up")
            guard currentIndex < pages.count - 1 else { return }
            currentIndex += 1
            self.pageController.setViewControllers([pages[currentIndex]], direction: .forward, animated: true, completion: nil)
            
            if currentIndex == pages.count - 2, hasMore {
                self.fetchMoreNewFeed()
            }
        default:
            print("left or right")
        }
    }
    
    private func setupPageController() {
        
        for feed in allClipFeeds {
            let controller = PlayerViewController()
            controller.videoNewFeed = feed
            controller.delegate = self
            
            self.pages.append(controller)
        }
        
        if allClipFeeds.count <= 2, hasMore {
            self.fetchMoreNewFeed()
        }
        
        self.pageController.dataSource = self
        self.pageController.delegate = self
        self.pageController.view.backgroundColor = .clear
        self.pageController.view.frame = CGRect(x: 0,y: 0,width: self.containerView.frame.width,height: self.containerView.frame.height)
        self.addChild(self.pageController)
        self.containerView.addSubview(self.pageController.view)
        
        if let index = allClipFeeds.firstIndex(where: {$0 == currentFeed}) {
            currentIndex = index
        }
        
        let initialVC = pages[currentIndex]
        self.pageController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        self.pageController.didMove(toParent: self)
        
        for v in pageController.view.subviews {
            if v.isKind(of: UIScrollView.self) {
                (v as! UIScrollView).isScrollEnabled = false
            }
        }
    }
    
    private func fetchMoreNewFeed() {
        self.currentPage += 1
        print("fetchMoreNewFeed", currentPage, currentType)
        let userId = AppSettings.shared.userLogin?.userId
        ManageAPI.shared.fetchNewFeed(userId, page: currentPage, type: currentType, searchQuery: username) {[weak self] (results, hasMore, error) in
            guard let self = self else { return }
            self.hasMore = hasMore
            DispatchQueue.main.async {
                self.delegate?.didLoadMore(results, hasMore: self.hasMore, currentPage: self.currentPage)
                let clipFeed = results.filter({$0.newFeedType == .video})
                guard !clipFeed.isEmpty else {
                    if self.hasMore {
                        self.fetchMoreNewFeed()
                    }
                    return
                }
                self.updatePageController(newFeeds: clipFeed)
            }
        }
    }
    
    func updatePageController(newFeeds: [NewFeed]) {
        for feed in newFeeds {
            let controller = PlayerViewController()
            controller.videoNewFeed = feed
            controller.delegate = self
            controller.isLoop = self.isLoop
            self.pages.append(controller)
        }
        allClipFeeds.append(contentsOf: newFeeds)
    }
}

extension ClipsFullscreenViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
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

extension ClipsFullscreenViewController: PlayerViewControllerDelegate {
    
    func updateFeed(_ newFeed: NewFeed?) {
        delegate?.updateNewFeed(newFeed)
    }
    
    func playedToTheEnd() {
        if isLoop{
            guard currentIndex < pages.count - 1 else { return }
            currentIndex += 1
            self.pageController.setViewControllers([pages[currentIndex]], direction: .forward, animated: true, completion: nil)
            if currentIndex == pages.count - 2, hasMore {
                self.fetchMoreNewFeed()
            }
        }
        else{
            print("EEEEN")
            let playerController = pages[currentIndex] as? PlayerViewController
            playerController?.resetPlayer()
            playerController?.player?.controlView.hidePlayToTheEndView()
        }
    }
}
