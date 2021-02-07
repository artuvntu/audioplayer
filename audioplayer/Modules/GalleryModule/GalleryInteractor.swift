//
//  GalleryInteractor.swift
//  audioplayer
//
//  Created Arturo Ventura on 04/02/21.
//  Copyright © 2021 ___ORGANIZATIONAME___. All rights reserved.
//

import UIKit

class GalleryInteractor: GalleryInteractorProtocol {
    
    final private let ElementsPerPage = 30
    weak var output: GalleryInteractorOutputProtocol?

    func getListGallery(page: Int) {
        let url = Constants.GalleryList(page: page, count: ElementsPerPage)
        RequestManager.generic(url: url, metodo: .get, tipoResultado: GalleryList.self) { [page, weak self] (data, tag) in
            guard let data = data as? GalleryList, let output = self?.output else { return }
            output.onSuccessListGallery(data: data, page: page)
        } rmError: { [page, weak self] (data, code, tag) in
            guard let output = self?.output else { return }
            output.onErrorListGalley(page: page)
        }
    }
    
}
