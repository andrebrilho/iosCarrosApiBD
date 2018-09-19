//
//  DetalesViewController.swift
//  CarrosApi
//
//  Created by André Brilho on 31/07/2018.
//  Copyright © 2018 André Brilho. All rights reserved.
//

import UIKit
import AlamofireImage

class DetalhesViewController: UIViewController {
    
    var carro:Carro!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtDesc: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = carro.nome
        txtDesc.text = carro.desc
        imgView.af_setImage(withURL: URL(string:carro.url_foto)!, filter: AspectScaledToFitSizeFilter(size: imgView.frame.size), imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: true, completion: { (_) in
            self.actIndicator.stopAnimating()
        }
        )}
    
    @IBAction func btnVoltar(_ sender: Any) {
        dismiss(animated: true)
    }
}
