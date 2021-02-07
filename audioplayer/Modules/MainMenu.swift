//
//  MainMenu.swift
//  audioplayer
//
//  Created by Arturo Ventura on 04/02/21.
//

import UIKit

class MainMenu:UITabBarController {
    
    let minHeightBottomView:CGFloat = 75
    var maxHeightBottomView:CGFloat {
        return self.playerView.frame.height - 8
    }
    
    weak var heightPlayerView:NSLayoutConstraint?
    
    weak var playerViewController: UIViewController?
    weak var playerPresenter:PlayerPresenterProtocol?
    
    lazy var playerView: UIView = {
        let (VCview,presenter) = PlayerRouter.createModule(delegate: self)
        self.addChild(VCview)
        let view = VCview.view!
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        self.playerViewController = VCview
        self.playerPresenter = presenter
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .white
        let gallery = GalleryRouter.createModule()
        let profile = ProfileRouter.createModule()
        let music = MusicRouter.createModule()
        
        gallery.tabBarItem.image = UIImage(systemName: "photo.on.rectangle")
        gallery.tabBarItem.title = "Gallery"
        
        profile.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        profile.tabBarItem.title = "Profile"
        
        music.tabBarItem.image = UIImage(systemName: "music.note.list")
        music.tabBarItem.title = "Music"
        
        self.viewControllers = [
            music,
            gallery,
            profile,
        ]
        
        view.insertSubview(playerView, belowSubview: tabBar)
        playerViewController?.didMove(toParent: self)
        
        playerView.anchor(size: CGSize(width: 0, height: 508))
        playerView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        let heightPlayerView = NSLayoutConstraint(item: self.tabBar, attribute: .top, relatedBy: .equal, toItem: playerView, attribute: .top, multiplier: 1.0, constant: 0)
        heightPlayerView.isActive = true
        self.heightPlayerView = heightPlayerView
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(bottomViewGesture(_:)))
        panGesture.delegate = self
        playerView.addGestureRecognizer(panGesture)
    }
    
    @objc func bottomViewGesture(_ gesture: UIPanGestureRecognizer) {
        guard let heightPlayerView = self.heightPlayerView else {return}
        let translation = -gesture.translation(in: playerView).y
        let velocity = -gesture.velocity(in: playerView).y
        let y = heightPlayerView.constant
        if (y + translation >= minHeightBottomView) && (y + translation <= maxHeightBottomView) {
            heightPlayerView.constant = y + translation
            gesture.setTranslation(.zero, in: playerView)
        }
        if gesture.state == .ended {
            var duration = velocity < 0 ? (y - minHeightBottomView) / -velocity : (maxHeightBottomView - y) / velocity
            duration = duration > 1.3 ? 1 : duration
            UIView.animate(withDuration: TimeInterval(duration), animations: {
                if velocity >= 0 {
                    heightPlayerView.constant = self.maxHeightBottomView
                } else {
                    heightPlayerView.constant = self.minHeightBottomView
                }
                self.view.layoutSubviews()
            }) { [weak self] _ in
                self?.playerPresenter?.changeStatusView((velocity < 0) ? .partial : .complete)
            }
            
        }
    }
    
    static func createModule() -> UIViewController {
        let mainMenu = MainMenu()
        
        return mainMenu
    }
    
}

extension MainMenu: PlayerStatusDelegate {
    var currentPlayerStatus: PlayerStatus {
        get {
            switch heightPlayerView?.constant ?? 0 {
            case ...minHeightBottomView:
                return PlayerStatus.none
            case minHeightBottomView:
                return .partial
            case minHeightBottomView...:
                return .complete
            default:
                return PlayerStatus.none
            }
        }
    }
    func setPlayerView(_ status: PlayerStatus) {
        UIView.animate(withDuration: TimeInterval(0.8), animations: {
            switch status {
            case .complete:
                self.heightPlayerView?.constant = self.maxHeightBottomView
            case .partial:
                self.heightPlayerView?.constant = self.minHeightBottomView
            case .none:
                self.heightPlayerView?.constant = 0
            }
            self.view.layoutSubviews()
        }) { [weak self] _ in
            self?.playerPresenter?.changeStatusView(status)
        }
    }
}

extension MainMenu: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else { return true}
        //        let upDirection = panGesture.velocity(in: playerView).y < 0
        //        let y = heightPlayerView?.constant
        //        if (y == maxHeightBottomView && redAvailableTable.contentOffset.y == 0 && !upDirection) {
        //            redAvailableTable.isScrollEnabled = false
        //        } else if (y == minHeightBottomView) {
        //            redAvailableTable.isScrollEnabled = false
        //        } else {
        //            redAvailableTable.isScrollEnabled = true
        //        }
        //        return false
        return true
    }
}

