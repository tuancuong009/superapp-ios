//
//  MainCircularMessageViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 4/20/21.
//

import UIKit

class MainCircularMessageViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    
    private var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var pages: [UIViewController] = []
    
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPageController()
    }
    
    @IBAction func selectTypeAction(_ sender: UIButton) {
        guard sender.tag < pages.count, sender.tag != currentIndex else { return }
        pageController.setViewControllers([pages[sender.tag]], direction: sender.tag < currentIndex ? .reverse : .forward, animated: true, completion: nil)
        currentIndex = sender.tag
    }
}

extension MainCircularMessageViewController {
    
    private func setupUI() {
        self.topBarMenuView.title = MenuItem.circular_chat.rawValue.uppercased()
        self.lblMessage.text = "This message will go to \(AppSettings.shared.currentUser?.totalcircle ?? 0) Members in your Circle"
    }
    
    private func setupPageController() {
        
        pages = [CircularTextViewController.instantiate(),
                 CircularTalkViewController.instantiate(),
                 CircularTelecastViewController.instantiate()]
        
        self.pageController.dataSource = self
        self.pageController.delegate = self
        self.pageController.view.backgroundColor = .clear
        self.pageController.view.frame = CGRect(x: 0,y: 0,width: self.containerView.frame.width,height: self.containerView.frame.height)
        self.addChild(self.pageController)
        self.containerView.addSubview(self.pageController.view)
        let initialVC = pages[0]
        
        self.pageController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        self.pageController.didMove(toParent: self)
        
        for v in pageController.view.subviews {
            if v.isKind(of: UIScrollView.self) {
                (v as! UIScrollView).isScrollEnabled = false
            }
        }
    }
}

extension MainCircularMessageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
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
