//
//  ViewController.swift
//  testDivisores
//
//  Created by user196830 on 12/12/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textFieldA: UITextField!
    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var labelPorcet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Solicitar los permisos de las notificaciones
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Nos han concedido los permisos")
            }else{
                print("No nos han concedido los permisos")
                print(error.debugDescription)
            }
        }
    }

    @IBAction func calculoDivis(_ sender: Any) {
        progressBar.setProgress(0.0, animated: false)
        labelResult.text = ""
        labelPorcet.text = ""
        //Inicializo las variables
        let number = Int(textFieldA.text ?? "0") ?? 0
        var result = ""
        //Comienzo el hilo
        DispatchQueue.global().async {
            //Gestiono divisores de cero
            if number == 0 {
                result = "infinitos"
                DispatchQueue.main.async {
                    self.progressBar.setProgress(1, animated: true)
                    self.labelPorcet.text = "100%"
                }
            } else {
                //Gestiono distintos de cero
            for i in 1...number{
                //Añado al string
                if number % i == 0 {
                    result = result+"  "+String(i)
                }
                DispatchQueue.main.async {
                    self.progressBar.setProgress(Float(i/number), animated: true)
                    self.labelPorcet.text = String(Float(i/number)*100) + "%"
                }
            }
        }
                
            DispatchQueue.main.async {
                
                self.labelResult.text = "Los divisores de \(number) son \(result)"
                //Crear y actualizar la notificacion
                self.throwNotification(text: "Los divisores de \(number) son \(result)")
            }
   
        }
   
    }
    
    
    func throwNotification(text: String) {
        //Creamos el content
        let content = UNMutableNotificationContent()
        content.title = "Estos son los divisores"
        content.subtitle = "Separados por espacios"
        content.body = text
        content.sound = .default
        content.badge = 13
        //Creamos el trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        //Creamos la request
        let request = UNNotificationRequest(identifier: "Mi notificacion", content: content, trigger: trigger)
        //Añadimos la request al centro de notificaciones
        UNUserNotificationCenter.current().add(request) { (error) in
            print(error.debugDescription)
        }
        
    }
    
}

