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
    
    //var para chamar o BD do realm
    static var realm: Realm!
    
    static func getCarros(refresh:Bool, tipoCarro:String, completion:@escaping (([Carro]) -> Void)){
        
        //se refres for false entao pegamos do BD
        if !refresh {
            let carrosBD = realm.objects(Carro.self).filter("tipoCarro = %@", tipoCarro)
            
            //se BD nao estiver vazio entao alocaremos os dados no BD
            if !carrosBD.isEmpty {
                var carros = [Carro]()
                
                //somwnte para ja ter um tamanho no cache, nao precisa dessa linha, é um elemento para otimizar o BD
                  carros.reserveCapacity(carrosBD.count)
                for carroBD in carrosBD {
                    carros.append(carroBD)
                }
                completion(carros)
                return
            }
        }
        
        //se refresh for true entao iremos na API para pegar os carros novamente
        if let networkingRechabilityManager = NetworkReachabilityManager(), networkingRechabilityManager.isReachable {
            if let url = URL(string: Constantes.URLBASE + tipoCarro.lowercased() + Constantes.EXTENSIONURL){
                
                var request = URLRequest(url: url)
                Alamofire.request(request).responseData(completionHandler: { (response) in
                    
                    //chamada de BD e retorno da APi deve ser feita na main Thread
                    DispatchQueue.main.async {
                        do {
                            let carroResponse = try JSONDecoder().decode(CarrosResponse.self, from: response.data!)
                            if let carros = carroResponse.carros.carro {
                                for carro in carros {
                                    
                                    //aki add o tipo de carro no objeto do carro, exmeplo "ESPORTIVODS - FERRARI"
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
                    }
                })
            }
        }
    }
}
