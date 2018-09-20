//
//  objCarro.swift
//  CarrosApi
//
//  Created by André Brilho on 30/07/2018.
//  Copyright © 2018 André Brilho. All rights reserved.
//

import Foundation
import RealmSwift

class Carro: Object, Codable {
    
    @objc dynamic var nome = ""
    @objc dynamic var desc = ""
    @objc dynamic var url_info = ""
    @objc dynamic var url_foto = ""
    @objc dynamic var url_video = ""
    @objc dynamic var latitude = ""
    @objc dynamic var longitude = ""
    
    //campo novo, chave para salvar os tipos de carrros no mesmo BD
    @objc dynamic var tipoCarro = ""
    
    //enum necessario para fazer o parse correto do json e desconsiderar o campo tipoCarro que nao vem no json, e sera ultilizado somente no BD
    enum CodingKeys : String, CodingKey {
        
        case nome
        case desc
        case url_info
        case url_foto
        case url_video
        case latitude
        case longitude
        
    }
    
    //chava primaria sera o nome do carro + o tipo do carro, exemplo Esportivo - ferrari...
    override class func primaryKey() -> String? {
        return "nome"
    }
}
