//
//  SliderViewController.swift
//  UIComponents
//
//  Created by Egehan Acar on 22.01.2022.
//

import UIKit

final class SliderViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    private let itemCount = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScrollView()
        initPageControler()
        initViews()
    }
    
    private func initPageControler() {
        pageController.numberOfPages = itemCount
        pageController.currentPage = 0
        pageController.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
    }
    
    @objc
    private func pageChanged(sender: UIPageControl){
        let offSet = scrollView.frame.width * CGFloat(sender.currentPage)
        
        scrollView.setContentOffset(CGPoint(x: offSet, y: 0), animated: true)
    }
    
    private func initScrollView() {
        scrollView.delegate = self
        scrollView.contentSize.width = scrollView.frame.width * CGFloat(itemCount)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        scrollView.isPagingEnabled = true
    }
    
    private func initViews() {
        for i in 0..<itemCount {
            let view = UIView()
            let xPosition = scrollView.frame.width * CGFloat(i)
            view.frame = CGRect(x: xPosition,
                                y: 0,
                                width: scrollView.frame.width,
                                height: scrollView.frame.height)
            view.backgroundColor = .random
            scrollView.addSubview(view)
        }
    }
}

extension SliderViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageController.currentPage = currentPage
    }
}
