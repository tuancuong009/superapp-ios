//
//  FeedbackViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/20/20.
//

import UIKit

protocol PersonalFeedbackDelegate: AnyObject {
    func reloadData()
    func didAddNewFeedback()
}

class PersonalFeedbackViewController: BaseViewController {
    
    @IBOutlet weak var leftIndicatorViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    private var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var pages: [UIViewController] = []
    private var currentIndex: Int = 0
    private var previousVC = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pages = [NewFeedbackViewController.instantiate(), OldFeedbackViewController.instantiate()]
        setupPageController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.pageController.view.frame = CGRect(x: 0,y: 0,width: self.containerView.frame.width,height: self.containerView.frame.height)
    }
    
    @IBAction func selectTabAction(_ sender: UIButton) {
        guard sender.tag != currentIndex else { return }
        currentIndex = sender.tag
        leftIndicatorViewConstraint.constant = UIScreen.main.bounds.width/2 * sender.tag.cgFloat
        pageController.setViewControllers([pages[sender.tag]], direction: sender.tag == 0 ? .reverse : .forward, animated: true, completion: nil)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension PersonalFeedbackViewController {
    private func setupPageController() {
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
        
        if let controller = pages[0] as? NewFeedbackViewController {
            controller.delegate = self
        }
    }
}

extension PersonalFeedbackViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
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

extension PersonalFeedbackViewController: PersonalFeedbackDelegate {
    
    func reloadData() {
        if let controller = pages[1] as? OldFeedbackViewController {
            controller.updateData()
        }
    }
    
    func didAddNewFeedback() {
        currentIndex = 1
        leftIndicatorViewConstraint.constant = UIScreen.main.bounds.width/2
        pageController.setViewControllers([pages[1]], direction: .forward, animated: true, completion: nil)
    }
}
