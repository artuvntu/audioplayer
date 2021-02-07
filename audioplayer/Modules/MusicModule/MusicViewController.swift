//
//  MusicViewController.swift
//  audioplayer
//
//  Created Arturo Ventura on 05/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class MusicViewController: UIViewController,MusicViewControllerProtocol {

    var presenter: MusicPresenterProtocol?
    var items: MusicEntity?

    lazy var table: UITableView = {
        let table = UITableView()
        table.rowHeight = 66
        table.estimatedRowHeight = UITableView.automaticDimension
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.init(named: "MainBackground")
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 83, right: 0)
        MusicTableViewCell.register(table: table)
        return table
    }()
    
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.init(named: "MainBackground")
        view.addSubview(table)
        table.fillSuperView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewLoaded()
    }
    
    func fillSongs(data: MusicEntity) {
        items = data
        table.reloadData()
    }
    
    func selectCurrentPlay() {
        
    }
}
extension MusicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        MusicTableViewCell.fillCell(table: table, data: items![indexPath.row], presenter: presenter)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.playSong(id: items![indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

class MusicTableViewCell: UITableViewCell {
    
    weak var presenterDelegate:MusicPresenterProtocol?
    var idSong = ""
    
    static func register(table: UITableView) {
        table.register(MusicTableViewCell.self, forCellReuseIdentifier: "MusicTableViewCell")
    }
    static func fillCell(table:UITableView, data: MusicEntityElement, presenter: MusicPresenterProtocol?) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: "MusicTableViewCell") as? MusicTableViewCell else { fatalError("MusicTableViewCell not register")}
        cell.imageAlbum.cambiarImagen(url: Constants.MusicBase(data.image))
        cell.titleLabel.text = data.name
        cell.albumLabel.text = data.album
        cell.idSong = data.id
        cell.presenterDelegate = presenter
        cell.downloadButton.isHidden = data.downloaded ?? false
        return cell
    }
    
    lazy var imageAlbum: LoaderImageView = {
        let image = LoaderImageView()
        image.anchor(size: CGSize(width: 50, height: 50))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "MainTextColor")
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var albumLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "MainTextColor")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.anchor(size: CGSize(width: 30, height: 30))
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(download), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(imageAlbum)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(albumLabel)
        self.contentView.addSubview(downloadButton)
        self.contentView.backgroundColor = UIColor.init(named: "MainBackground")
        imageAlbum.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: nil, padding: .eight)
        titleLabel.anchor(top: contentView.topAnchor, leading: imageAlbum.trailingAnchor, bottom: albumLabel.bottomAnchor, trailing: downloadButton.leadingAnchor, padding: .eight)
        albumLabel.anchor(top: nil, leading: imageAlbum.trailingAnchor, bottom: contentView.bottomAnchor, trailing: downloadButton.leadingAnchor,padding: .eight)
        downloadButton.anchor(centerY: contentView.centerYAnchor, centerX: nil)
        downloadButton.anchor(top: nil, leading: nil, bottom: nil, trailing: contentView.trailingAnchor, padding: .eight)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init?(coder: NSCoder) { has not been implemented")
    }
    
    @objc func download(_ sender: Any) {
        presenterDelegate?.downloadSong(id: idSong)
    }
    
}
