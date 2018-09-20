//
//  ViewController.swift
//  CarrosApi
//
//  Created by André Brilho on 30/07/2018.
//  Copyright © 2018 André Brilho. All rights reserved.
//

import UIKit
import MBProgressHUD
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Variabels
    var carros:[Carro] = []
    var tiposCarros = ["Esportivos" ,"Classicos" ,"Luxo"]
    
    @IBOutlet weak var tbvCarros: UITableView!
    @IBOutlet weak var pickerViewTipoCarros: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvCarros.dataSource = self
        tbvCarros.delegate = self
        pickerViewTipoCarros.dataSource = self
        pickerViewTipoCarros.delegate = self
        
        //register da celula customizada para exibir o carro
        tbvCarros.register(UINib(nibName: "CarroTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        //cria um bd com o tipo carro Esporitvos - "nome do carro"
        let carrosBD = ApiCarrros.realm.objects(Carro.self).filter("tipoCarro = %@", "Esportivos")
        //se o BD tiver vazio chama a API
            if carrosBD.isEmpty {
               // call func api
                getCarros()
            } else {
                //se nao abre o BD
                for carroBD in carrosBD {
                    carros.append(carroBD)
                }
                tbvCarros.reloadData()
            }
    }

    //Resquest Api, passando como parametro a string de carros que vier do valor da linha do pickerview carros
    func getCarros(){
        let progress = MBProgressHUD.showAdded(to: view, animated: true)
        progress.label.text = Constantes.CARREGANDO
        ApiCarrros.getCarros(refresh:false, tipoCarro: tiposCarros[pickerViewTipoCarros.selectedRow(inComponent: 0)]) { (carros) in
            self.carros = carros
            DispatchQueue.main.async {
                progress.hide(animated: true)
                self.tbvCarros.reloadData()
            }
        }
    }
    

    //MARK: PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tiposCarros.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tiposCarros[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getCarros()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = tiposCarros[row]
        let myTitle = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir Light", size: 10.0)!,NSAttributedStringKey.foregroundColor:ColorHex(hex: Constantes.CORDEFAULT)])
        return myTitle
    }
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CarroTableViewCell{
            cell.carro = carros[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailCarroViewController = storyboard?.instantiateViewController(withIdentifier: "DetalhesViewController") as? DetalhesViewController {
            detailCarroViewController.carro = carros[indexPath.row]
        self.present(detailCarroViewController, animated: true)
    
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let deleteCar = carros[indexPath.row]
        do {
            ApiCarrros.realm.beginWrite()
            ApiCarrros.realm.delete(deleteCar)
            try ApiCarrros.realm.commitWrite()
            carros.remove(at: indexPath.row)
            tbvCarros.reloadData()
        }catch{
            print("erro ao excluir carro do BD")
        }
    }
    
    @IBAction func atualizarCarros(_ sender: Any) {
        let progress = MBProgressHUD.showAdded(to: view, animated: true)
        progress.label.text = Constantes.CARREGANDO
        let tipoCarro = tiposCarros[pickerViewTipoCarros.selectedRow(inComponent: 0)]
        let carrosBD = ApiCarrros.realm.objects(Carro.self).filter("tipoCarro = %@", tipoCarro)
        do {
            ApiCarrros.realm.beginWrite()
            ApiCarrros.realm.delete(carrosBD)
            try ApiCarrros.realm.commitWrite()
            ApiCarrros.getCarros(refresh:true, tipoCarro: tipoCarro) { (carros) in
                self.carros = carros
                DispatchQueue.main.async {
                    progress.hide(animated: true)
                    self.tbvCarros.reloadData()
                }
            }
        } catch {
            print("erro para escrever no BD")
        }
    }
}

