//
//  PageViewController.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 15.01.2022.
//

import UIKit

class PageViewController: UIPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self

        controllers = setViewControllers()

        pageControl.currentPage = currentPageIndex
        setViewControllers([controllers[currentPageIndex]],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        self.view.addSubview(pageControl)
    }

    var controllers: [UIViewController] = []
    private var currentPageIndex = 1

    private lazy var pageControl: UIPageControl = {
        let pageControlWidth: CGFloat = 150
        let pageControlHeight: CGFloat = 50

        let frame = CGRect(x: (screenWidth - pageControlWidth) / 2,
                           y: screenHeight - 100,
                           width: pageControlWidth,
                           height: pageControlHeight)

        let pageControl = UIPageControl(frame: frame)
        pageControl.numberOfPages = controllers.count
        pageControl.backgroundColor = .blue
        pageControl.currentPageIndicatorTintColor = .yellow
        pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
        return pageControl
    }()

    @objc func pageControlValueChanged(_ sender: UIPageControl) {
        let index = sender.currentPage
        let direction: UIPageViewController.NavigationDirection = currentPageIndex > index ? .reverse : .forward
        currentPageIndex = index
        setViewControllers([controllers[index]], direction: direction, animated: true, completion: nil)
    }

    func setViewControllers() -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let firstViewControler = storyboard.instantiateViewController(withIdentifier: "DynamicTableViewController")
        firstViewControler.view.tag = 0
        firstViewControler.view.backgroundColor = .red

        let secondViewController = storyboard.instantiateViewController(withIdentifier: "DynamicTableViewController")
        secondViewController.view.tag = 1
        secondViewController.view.backgroundColor = .yellow

        let thirdViewController = storyboard.instantiateViewController(withIdentifier: "TableViewController")
        thirdViewController.view.tag = 2

        return [firstViewControler, secondViewController, thirdViewController]
    }
}

// MARK: - PageController DataSource
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag

        if index + 1 < controllers.count {
            return controllers[index + 1]
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag

        if index == 0 {
            return nil
        } else {
            return controllers[index - 1]
        }
    }
}

// MARK: - PageController Delegate
extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        guard let index = pageViewController.viewControllers?.first?.view.tag else { return }
        self.pageControl.currentPage = index
    }
}

/*
Odev 2
 viewController icerisinde scrollView, bu scrollView uzerinde bir pageControl componenti olacak
 let views = [UIView(), UIView(), UIView(), UIView()]
her bir view'in bgcolor farkli olsun
 1. timer her 10sn'de bir bir sonraki view'a scroll ettirsin
 2. scrollView'da infiniteScroll olsun 1 > 2 > 3 > 4 > 5 > 1 > 2
 */
