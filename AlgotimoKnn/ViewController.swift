//
//  ViewController.swift
//  AlgotimoKnn
//
//  Created by Tiago Queiroz on 21/12/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {
    
    @IBOutlet weak var labelDesvio: UILabel!
    @IBOutlet weak var labelMedia: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var treinamento: UITextField!
    @IBOutlet weak var amostra: UITextField!
    @IBOutlet weak var qtdK: UITextField!
    var flores = [Flor]()
    var floresAux = [Flor]()
    var floresTreinamento = [Flor]()
    var floresAmostra = [Flor]()
    
    var k = 50
    
    var tamTreinamento = 100
    var tamTestes: Int?
    var arrayAcertos = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionPrincipal(_ sender: Any) {
        arrayAcertos = []
        self.textView.text = ""
        getTxt()
        
        k = Int(qtdK.text!)!
        
        tamTreinamento = Int(treinamento.text!)!
        
        tamTestes = Int(amostra.text!)!
        
        let media = mediaAcertos()
        
        let porcentagem = media/Double(tamTestes!)
        
        let desvio = calcularDesvio(array: arrayAcertos, media: media)
        
        self.labelDesvio.text = String.init(format: "%.2f", desvio)

        self.labelMedia.text = String.init(format: "%.2f", porcentagem*100)

    }
    //Pega os dados do arquico iris.txt e transforma em um array de String
    func getTxt(){
        var text: [String]?
        if let path = Bundle.main.path(forResource: "iris", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                //text = myStrings.joined(separator: ",")
                text = myStrings
            } catch {
                print(error)
            }
        }
        //print(text!)
        
        //Transforma cada linha do arquivo em um objeto do tipo Flor
        for str in text!{
            if str != ""{
                let aux = str.components(separatedBy: ",")
                print(aux)
                let flor = Flor(a: Double(aux[0])! , b: Double(aux[1])!, c: Double(aux[2])!, d: Double(aux[3])!, classe: aux[4])
                flores.append(flor)
            }
        }
    }
    
    //Embaralha o array de treinamento e o array de amostra
    func radomTreinamentoAmostra() {
        floresAux = flores
        for _ in 0...tamTreinamento-1{
            let tam = UInt32(floresAux.count)
            let index = arc4random()%tam
            floresTreinamento.append(floresAux[Int(index)])
            floresAux.remove(at: Int(index))
        }
        for _ in 0...floresAux.count-1{
            let tam = UInt32(floresAux.count)
            let index = arc4random()%tam
            floresAmostra.append(floresAux[Int(index)])
            floresAux.remove(at: Int(index))
        }
    }
    
    
    //Pega 10 elementos do array de amostra para serem classificados através do algoritmo knn e verifica o resultado
    func verificaAmostra() -> Int{
        var acertos = 0
        for i in 0...tamTestes!-1{
            let flor = floresAmostra[i]
            let classeObtida = Flor.classificarAmostra(flores: floresTreinamento, novaFlor: flor, k: k)
            print("\nClasse Obtida: \(classeObtida)")
            print(("Classe Desejada: \(flor.classe!)"))
            self.textView.text.append("Classe Obtida: \(classeObtida)\n")
            self.textView.text.append("Classe Desejada: \(flor.classe!)\n")
            if classeObtida == flor.classe!{
                acertos = acertos + 1
            }
        }
        print("Acertos: \(acertos) em 10 testes")
        arrayAcertos.append(acertos)
        self.textView.text.append("Acertos: \(acertos) em \(tamTestes!) testes\n\n")
        return acertos
    }
    
    // Retorna o número médio de acertos
    func mediaAcertos() -> Double{
        var soma = 0
        for _ in 0...29{
            radomTreinamentoAmostra()
            soma = soma + verificaAmostra()
        }
        return Double(soma)/Double(30)
    }
    
    //Retorna o desvio padrão
    func calcularDesvio(array: [Int], media: Double) -> Double{
        var soma = 0.0
        for i in array{
            soma = soma + pow((media - Double(i)), 2)
        }
        print(soma)
        return sqrt(soma/Double(30*tamTestes!))
    }
    
}

