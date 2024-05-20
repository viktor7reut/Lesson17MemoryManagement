//
//  ViewController.swift
//  Operation
//
//  Created by Виктор Реут on 11.05.24.
//

import UIKit

//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        print(Thread.current)
//        
//        let calculateOperation = CalculateOperation(a: 2, b: 3)
//        calculateOperation.onCalc = { sum in
//            print(sum)
//            print(Thread.current)
//        }
//        
//        calculateOperation.start()
//        
//    }
//
//
//}
//
//class CalculateOperation: Operation {
//    
//    private let a: Int
//    private let b: Int
//    
//    var onCalc: ((_ sum: Int) -> Void)?
//    
//    init(a: Int, b: Int) {
//        self.a = a
//        self.b = b
//    }
//    
//    override func main() {
//        onCalc?(a + b)
//    }
//}

// поддержка асинхронности операции с помощью gcd

//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        print(Thread.current)
//        
//        let calculateOperation = CalculateOperation(a: 2, b: 3)
//        
//        print("Operation is executing \(calculateOperation.isExecuting)")
//        print("Operation is finished \(calculateOperation.isFinished)")
//        
//        calculateOperation.onCalc = { sum in
//            print("Operation is executing \(calculateOperation.isExecuting)")
//            print("Operation is finished \(calculateOperation.isFinished)")
//            
//            print(sum)
//            print(Thread.current)
//        }
//        
//        calculateOperation.start()
//    }
//}
//
//class CalculateOperation: Operation {
//    
//    private let a: Int
//    private let b: Int
//    
//    private var _isFinished: Bool = false
//    private var _isExecuting: Bool = false
//    
//    private let queue = DispatchQueue(label: "calculate-operation.serial-queue")
//    
//    override var isFinished: Bool { _isFinished }
//    override var isExecuting: Bool { _isExecuting }
//    override var isAsynchronous: Bool { true }
//    
//    var onCalc: ((_ sum: Int) -> Void)?
//    
//    init(a: Int, b: Int) {
//        self.a = a
//        self.b = b
//    }
//    
//    override func main() {
//        onCalc?(a + b)
//        
//        _isExecuting = false
//        _isFinished = true
//        
//        print("Operation is executing \(self.isExecuting)")
//        print("Operation is finished \(self.isFinished)")
//    }
//    
//    override func start() {
//        _isExecuting = true
//        
//        queue.async {
//            self.main()
//        }
//    }
//}

// blockOperation
// применение - сложная анимация объекта, запуск поочередных анимаций.

//class ViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let operation1 = BlockOperation {
//            sleep(5)
//            print("Operation1 start")
//        }
//        
//        // completion block
//        operation1.completionBlock = {
//            print("Operation1 is completed")
//        }
//        
//        let operation2 = BlockOperation {
//            sleep(5)
//            print("Operation2 is completed")
//        }
//        
//        operation2.addDependency(operation1)
//        
//        let operationQueue = OperationQueue()
//        operationQueue.addOperations([operation1, operation2], waitUntilFinished: true)
//    }
//    
//    
//}

//создание задержки

//class ViewController: UIViewController {
//    
//    let timeInterval: TimeInterval = 10
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let operation = BlockOperation {
////            sleep(3)
//            sleep(13)
//            print("Operation is work")
//        }
//        
//        let semaaphore = DispatchSemaphore(value: 0)
//        
//        DispatchQueue.global().async {
//            operation.start()
//            semaaphore.signal()
//        }
//        
//        if semaaphore.wait(timeout: (.now() + timeInterval)) == .timedOut {
//            operation.cancel()
//            print("Operation timed out")
//        } else {
//            print("Operation completed succesfully")
//        }
//    }
//}


// создание нескольких блоков выполнения внутри одной операции
// операции выполняются паралельно (нет гарантии относительно порядка выполнения)

//class ViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let operation = BlockOperation {
//            sleep(1)
//            print("Operation is work")
//        }
//        
//        operation.addExecutionBlock {
//            sleep(1)
//            print("Operation2 is work")
//        }
//        
//        operation.start()
//        
//    }
//}

// операции помещаемые в operationQueue выполняется многопоточно
// можно установить лимит операций, выполняющиеся параллельно (через свойство maxConcurrentOperationCount)
// свойство queuePriority позволяет устанавливать приоритет для операций
// quolity of service свойство позволяет задавать приоритет внутри очереди ()

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let operation1 = BlockOperation {
            sleep(5)
            print("Operation1 is work")
        }
        
        operation1.queuePriority = .low
        
        let operation2 = BlockOperation {
            sleep(5)
            print("Operation2 is work")
        }
        
        operation2.qualityOfService = .userInteractive
        
        let operation3 = BlockOperation {
            sleep(5)
            print("Operation3 is work")
        }
        
        let operation4 = BlockOperation {
            sleep(5)
            print("Operation4 is work")
        }
        
        operation4.queuePriority = .veryHigh
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        
        print("Created queue")
        queue.isSuspended = true // указываем очереди ждать
        print("queue isSuspended")
        
        queue.addOperations([operation1, operation2, operation3, operation4], waitUntilFinished: false)
        
        print("Wait 3s")
        sleep(3)
        
        queue.isSuspended = false
    }
}
