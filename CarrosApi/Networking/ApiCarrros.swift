//
//  apiCarrros.swift
//  CarrosApi
//
//  Created by André Brilho on 30/07/2018.
//  Copyright © 2018 André Brilho. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import RealmSwift

class ApiCarrros {
    
    static var realm: Realm!
    
    static func getCarros(refresh:Bool, tipoCarro:String, completion:@escaping (([Carro]) -> Void)){
        
        do {
            self.realm = try Realm()
        }catch {
            print("erro ao abrir o Banco de dados App Delegate")
        }
        
        
        if refresh {
            let carrosBD = realm.objects(Carro.self).filter("tipoCarro = %@", tipoCarro)
            if !carrosBD.isEmpty {
                var carros = [Carro]()
                //somwnte para ja ter um tamanho no cache, nao precisa dessa linha, é um elemento para otimizar o BD
              //  carros.reserveCapacity(carrosBD.count)
                for carroBD in carrosBD {
                    carros.append(carroBD)
                }
                completion(carros)
                return
            }
        }
        if let networkingRechabilityManager = NetworkReachabilityManager(), networkingRechabilityManager.isReachable {
        if let url = URL(string: Constantes.URLBASE + tipoCarro.lowercased() + Constantes.EXTENSIONURL){
            var request = URLRequest(url: url)

            Alamofire.request(request).responseData(completionHandler: { (response) in
                do {
                    let carroResponse = try JSONDecoder().decode(CarrosResponse.self, from: response.data!)
                    if let carros = carroResponse.carros.carro {
                        for carro in carros {
                            carro.tipoCarro = tipoCarro
                        }
                        realm.beginWrite()
                        realm.add(carros)
                        try realm.commitWrite()
                        completion(carros)
                    }
                }catch{
                    print("erro na requisição ou no parser")
                }
            })
        }
    }
    }
}
