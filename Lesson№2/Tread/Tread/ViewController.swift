//
//  ViewController.swift
//  Tread
//
//  Created by Виктор Реут on 10.05.24.
//

import UIKit

// поток - одна из технологий которая позволяет выполнять несколько операций в рамках одного приложения, одновременно.

// run loop - бесконечный цикл обслуживания задач и событий (управляет потоком)
// нужен для того чтобы отлавливать все события системы и запускает их обработку на главном потоке, плюс уммет управлять потоком.
// задача поступила -> оживляет поток -> задача закончилась -> усыпляет поток
// источники событий в run loop: 1) input sources (различные источники ввода: мышки, клавиатуры, тач скрин), 2) timer sources (нотификационный центр, таймеры)
// приоритеты:
// 1) user interactive - взаимодействие с пользователеи (анимации, обработкасобытия, обновлениеинтерфейса),
// 2) user iniciated (задачи требующие немедленной реакиции, но не связаны с интерактивными UI событиями),
// 3) default (средний приоритет)
// 4) utilite (когда не требуется получить моментально отклик (например запрос в сеть))
// 5) background (низкий приоритет, задачи которые не видны пользователю (скачанные картинки сохраняем в кэш, сохаренения данных пользователя, чистка кэша))
// 6) unspecified (когда работаем с старыми API)

// Синхронизация - позволяет обеспечить безопастный доступ одного иди нескольких потоков к ресурсу. Инструменты синхронизации:
// mutex - примитив синхронизации, который позволяет захватить ресурс (как только поток обратиться к ресурсу, он заблокирует доступ к другим потокам, которые захотят к нему обратиться; принцип fifo (первый вошел, первый вышел))
// Виды mutex:
// NSLock
// Рекурсивный mutex (разновидность базового mutex, позволяющий потоку захватывать ресурс множество раз, пока он его не освободит, используется в реккурсивных функциях) - (при нескольких запросах в сеть, получаем разные данные и собирая их в модель, по очереди собирается модель)
// read write lock (примитив синхронизации который предоставляет потоку доступ к ресурсу на чтение; все могут считывать, но запись только у одного) (доступен только в библиотеке piece red)
// spin lock (наиболее быстродействующий, но более энерго- и ресурсо-затратный mutex) (непрерывно опрашивает ресурс освобожден ли он или нет)
// semaphore

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Thread.current)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1) создаем поток
        let thread = Thread { [weak self] in
//            print("New thread")
//            print(Thread.current)
            print("Start thread1")
            sleep(5)
//            self?.doSomething()
//            print("Finished1")
//            self.loadData()
            
            self?.test1()
            print("Finished1")
        }
        
        let thread2 = Thread { [weak self] in
            print("Start thread2")
            sleep(5)
//            self?.doSomething()
            self?.test2()
            print("Finished2")
        }
        
         // задаем приоритет
//        thread.qualityOfService = .background
//        thread.name = "My thread"
        
        // 2) запускаем поток
        thread.start()
        thread2.start()
    }
    
    @IBAction func buttonDidTap(_ sender: Any) {
        print("Tap Action")
    }
    
    func loadData() {
        for i in 0...8_000_000 {
            print(i)
        }
    }
    
    // MARK: - NSLock
    
    //создаем блокировщик
    let lock = NSLock()
    
    func doSomething() {
        lock.lock()
    // после данной команды код ниже будет заблокирован, для того потока который будет это выполнять
        
        print("Hello lock")
        
        lock.unlock()
    }
    
    //MARK: - NSRecursiveLock
    
    let recursiveLock = NSRecursiveLock()
    
    func doSomething2() {
        recursiveLock.lock()
        print("doSomething2")
        doSomething3()
        recursiveLock.unlock()
    }
    
    func doSomething3() {
        recursiveLock.lock()
        print("doSomething3")
//        doSomething2()
        recursiveLock.unlock()
    }
    
    //MARK: - NSCondition
    
    let condition = NSCondition()
    
    //необходим bool предикат который будет сообщать о состоянии ресурса
    
    var predicate = false
    
    func test1() {
        condition.lock()
        
        //проверяем bool предикат
        while(!predicate) {
            condition.wait()
        }
        
        print("Hello World")
        
        condition.unlock()
    }
    
    //функция запускающая сигнал
    func test2() {
        condition.lock()
        
        predicate = true
        
        condition.signal()
        
        condition.unlock()
    }
}

