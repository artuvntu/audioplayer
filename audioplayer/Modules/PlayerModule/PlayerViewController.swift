//
//  PlayerViewController.swift
//  audioplayer
//
//  Created Arturo Ventura on 06/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController,PlayerViewControllerProtocol {
    
    var presenter: PlayerPresenterProtocol?
    
    lazy var MiniPlayerPartialView: UIView = {
        let view = UIView()
        view.anchor(size: CGSize(width: 0, height: 75))
        
        view.addSubview(albumMiniPlayerImage)
        view.addSubview(titleMiniPlayerLabel)
        view.addSubview(albumMiniPlayerLabel)
        view.addSubview(playMiniPlayerButton)
        
        albumMiniPlayerImage.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil,padding: .eight)
        titleMiniPlayerLabel.anchor(top: view.topAnchor, leading: albumMiniPlayerImage.trailingAnchor, bottom: nil, trailing: playMiniPlayerButton.leadingAnchor,padding: .eight)
        albumMiniPlayerLabel.anchor(top: titleMiniPlayerLabel.topAnchor, leading: albumMiniPlayerImage.trailingAnchor, bottom: view.bottomAnchor, trailing: playMiniPlayerButton.leadingAnchor,padding: .eight)
        playMiniPlayerButton.anchor(centerY: view.centerYAnchor, centerX: nil)
        playMiniPlayerButton.anchor(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .eight)
        return view
    }()
    
    lazy var albumMiniPlayerImage: LoaderImageView = {
        let image = LoaderImageView()
        image.anchor(aspectRatio: 1)
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var titleMiniPlayerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var albumMiniPlayerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var playMiniPlayerButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 0
        button.anchor(size: CGSize(width: 30, height: 30))
        button.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(playButton), for: .touchUpInside)
        return button
    }()
    
    
    lazy var PlayerCompleteView:UIView = {
        let view = UIView()
        view.addSubview(albumPlayerImage)
        view.addSubview(albumPlayerLabel)
        view.addSubview(titlePlayerLabel)
        view.addSubview(playPlayerButton)
        view.addSubview(nextPlayerButton)
        view.addSubview(previusPlayerButton)
        
        albumPlayerImage.anchor(centerY: nil, centerX: view.centerXAnchor)
        albumPlayerImage.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
        titlePlayerLabel.anchor(top: albumPlayerImage.bottomAnchor, leading: albumPlayerImage.leadingAnchor, bottom: nil, trailing: albumPlayerImage.trailingAnchor, padding: .eight)
        albumPlayerLabel.anchor(top: titlePlayerLabel.bottomAnchor, leading: albumPlayerImage.leadingAnchor, bottom: nil, trailing: albumPlayerImage.trailingAnchor, padding: .eight)
        playPlayerButton.anchor(centerY: nil, centerX: view.centerXAnchor)
        playPlayerButton.anchor(top: albumPlayerLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0))
        nextPlayerButton.anchor(top: albumPlayerLabel.bottomAnchor, leading: playPlayerButton.trailingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 0))
        previusPlayerButton.anchor(top: albumPlayerLabel.bottomAnchor, leading: nil, bottom: nil, trailing: playPlayerButton.leadingAnchor,padding: UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 24))
        
        return view
    }()
    
    
    lazy var albumPlayerImage: LoaderImageView = {
        let image = LoaderImageView()
        image.anchor(size: CGSize(width: 300, height: 300))
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var titlePlayerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var albumPlayerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var playPlayerButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 0
        button.anchor(size: CGSize(width: 30, height: 30))
        button.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(playButton), for: .touchUpInside)
        return button
    }()
    
    
    lazy var previusPlayerButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 2
        button.anchor(size: CGSize(width: 30, height: 30))
        button.setBackgroundImage(UIImage(systemName: "backward.end"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(playButton), for: .touchUpInside)
        return button
    }()
    
    lazy var nextPlayerButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 1
        button.anchor(size: CGSize(width: 30, height: 30))
        button.setBackgroundImage(UIImage(systemName: "forward.end"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(playButton), for: .touchUpInside)
        return button
    }()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(named: "PlayerColor")
        view.addSubview(MiniPlayerPartialView)
        view.addSubview(PlayerCompleteView)
        MiniPlayerPartialView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        PlayerCompleteView.fillSuperView(padding: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        PlayerCompleteView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewLoaded()
    }
    
    func fillCurrentSong(_ song: MusicEntityElement) {
        albumMiniPlayerImage.cambiarImagen(url: Constants.MusicBase(song.image))
        albumMiniPlayerLabel.text = song.album
        titleMiniPlayerLabel.text = song.name
        albumPlayerImage.cambiarImagen(url: Constants.MusicBase(song.image))
        albumPlayerLabel.text = song.album
        titlePlayerLabel.text = song.name
    }
    
    @objc func playButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            presenter?.playSong()
        case 1:
            presenter?.nextSong()
        case 2:
            presenter?.previusSong()
        default:
            break
        }
        
    }
    
    func interfaceComplete(_ complete: Bool) {
        UIView.animate(withDuration: 0.3) { [complete, weak self] in
            guard let self = self else {return}
            self.MiniPlayerPartialView.alpha = complete ? 0.0 : 1.0
            self.PlayerCompleteView.alpha = complete ? 1.0 : 0.0
        } completion: { [weak self] (finish) in
            guard let self = self else {return}
            if finish {
                self.MiniPlayerPartialView.isHidden = complete
                self.PlayerCompleteView.isHidden = !complete
            }
        }
    }
    func changeStatusPlay(_ isPlaying: Bool) {
        let image = isPlaying ? "pause" : "play"
        playMiniPlayerButton.setBackgroundImage(UIImage(systemName: image), for: .normal)
        playPlayerButton.setBackgroundImage(UIImage(systemName: image), for: .normal)
    }
}


