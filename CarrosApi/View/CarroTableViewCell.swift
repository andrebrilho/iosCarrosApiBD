//
//  CarroTableViewCell.swift
//  CarrosApi
//
//  Created by André Brilho on 30/07/2018.
//  Copyright © 2018 André Brilho. All rights reserved.
//

import UIKit
import AlamofireImage

class CarroTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgCarro: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblDescCarro: UILabel!
    
    var carro:Carro!{
        didSet{
            setCarro()
        }
    }
    
    func setCarro(){
        self.selectionStyle = UITableViewCellSelectionStyle.none;
        lblDescCarro.text = carro.nome
        imgCarro.image = nil
        imgCarro.af_cancelImageRequest()
        activityIndicator.startAnimating()
        imgCarro.af_setImage(withURL: URL(string:carro.url_foto)!, filter: AspectScaledToFitSizeFilter(size: CGSize(width: 171, height: 84)), imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: true, completion: { (_) in
            self.activityIndicator.stopAnimating()
        }
        )}
}
