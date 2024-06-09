//
//  WelcomeViewController.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-10.
//

import UIKit

class WelcomeViewController: UIViewController {
    

    @IBOutlet weak var holderView: UIView!
    let scrollview = UIScrollView()
    
    let titles = ["Welcome to EduHub!", "Learn anytime, anywhere!", "Unlock your potential!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    
    public func configure() {
        scrollview.frame =  holderView.bounds
        holderView.addSubview(scrollview)
        
        for x in 0..<3 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * holderView.frame.size.width, y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            
            scrollview.addSubview(pageView)
            
            let label = UILabel(frame: CGRect(x: 10, y: 150, width: pageView.frame.size.width-20, height: 120))
            
            let imageViewHeight: CGFloat = 300// Define the desired height for the image view

            let imageViewY = (pageView.frame.size.height - 60 - 130 - 15 - imageViewHeight) / 2 + 120 + 10
            let imageView = UIImageView(frame: CGRect(x: 10, y: imageViewY, width: pageView.frame.size.width-20, height: imageViewHeight))

            
            let buttonHeight: CGFloat = 50 // Define the desired height for the button
            let buttonSpacing: CGFloat = 20 // Define the desired spacing between the button and the image view

            let buttonY = imageView.frame.origin.y + imageView.frame.size.height + buttonSpacing
            let button = UIButton(frame: CGRect(x: 10, y: buttonY, width: pageView.frame.size.width - 20, height: buttonHeight))

            
            label.textAlignment = .center
            label.font = UIFont(name: "Marker Felt", size: 28)
            pageView.addSubview(label)
            label.text = titles[x]
            
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "learning-\(x+1)")
            pageView.addSubview(imageView)
            
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemMint
           
            if (x == 2){
                button.setTitle("Get Started !", for: .normal)
            } else {
                button.setTitle("Continue", for: .normal)
            }
            
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = x+1
            pageView.addSubview(button)
            
            
        }
        
        scrollview.contentSize = CGSize(width: holderView.frame.size.width*3, height: 0)
        scrollview.isPagingEnabled = true
    }
    @objc func didTapButton(_ button: UIButton){
        guard button.tag < 3 else {
            Core.shared.setIsNotNewUser()
            let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc,animated: true)
            return
        }
        scrollview.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
    }
   
}


