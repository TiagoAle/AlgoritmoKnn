//
//  Flor.swift
//  AlgotimoKnn
//
//  Created by Tiago Queiroz on 21/12/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import UIKit
import Darwin

struct FlorDistance {
    var index: Int
    var distance: Double
}

class Flor: NSObject {
    private(set) var classe: String?
    var a,b,c,d: Double?
    override var description: String {
        return "\(a!) | \(b!) | \(c!) | \(d!) | \(classe!)\n"
    }
    
    override init() {
        super.init()
    }
    
    init(a: Double, b: Double, c: Double, d: Double, classe: String) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.classe = classe
        
    }
    
    func getA() -> Double {
        return self.a!
    }
    func getB() -> Double {
        return self.b!
    }
    func getC() -> Double {
        return self.c!
    }
    func getD() -> Double {
        return self.d!
    }
    func getClasse() -> String {
        return self.classe!
    }

    //função para obter a distância euclidiana entre dois objetos do tipo Flor
    static func obterDistanciaEuclidiana(flor1: Flor, flor2: Flor) -> Double{
        let soma = pow(flor1.getA() - flor2.getA(), 2) + pow(flor1.getB() - flor2.getB(), 2) + pow(flor1.getC() - flor2.getC(), 2) + pow(flor1.getD() - flor2.getD(), 2)
        return sqrt(soma)
    }
    
    //função que classifica uma Flor de acordo com o algoritmo knn
    static func classificarAmostra(flores: [Flor], novaFlor: Flor, k: Int) -> String {
        var q = k
        if q <= 0 {
            q = 1
        }
        
        
        var dist_individuos = [FlorDistance]()
        var aux: FlorDistance?
        var contk = 0
        var contVersicolor = 0
        var contSetosa = 0
        var contVirginica = 0
        
        //armazena os indices das flores de treinamento e as distâncias para a flor a ser classificada
        for i in 0...flores.count-1{
            let dist = obterDistanciaEuclidiana(flor1: flores[i], flor2: novaFlor)
            
            aux = FlorDistance(index: i, distance: dist)
        
            dist_individuos.append(aux!)
            
        }
        
        //ordena o array de indices/distância pela menor distância
        dist_individuos = dist_individuos.sorted(by: { $0.distance < $1.distance })
        
        //verifica a classe dos k elementos mais próximos da flor a ser classificada
        for j in dist_individuos{
            let classe = flores[j.index].getClasse()
            if classe == "Iris-setosa"{
                contSetosa = contSetosa+1
            }else if classe == "Iris-versicolor"{
                contVersicolor = contVersicolor + 1
            }else{
                contVirginica = contVirginica + 1
            }
            
            if contk > k{ break}
            
            contk = contk + 1
        }
        
        var classeNovaFlor = ""
        
        //classifica a nova flor de acordo com a classe que apareceu mais vezes dentro dos k elementos
        if contSetosa >= contVersicolor && contSetosa >= contVirginica {
            classeNovaFlor = "Iris-setosa"
        }else if contSetosa <= contVersicolor && contVersicolor >= contVirginica {
            classeNovaFlor = "Iris-versicolor"
        }else{
            classeNovaFlor = "Iris-virginica"
        }
        return classeNovaFlor
    }

}
