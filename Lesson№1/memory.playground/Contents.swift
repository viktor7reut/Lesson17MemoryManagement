import UIKit

//class Person {
//    
//    var department: Department?
//    
//    init() {
//        print("Person init")
//    }
//    
//    deinit {
//        print("Person deinit")
//    }
//}
//
//class Department {
//    
//    init() {
//        print("Department init")
//    }
//    
//    deinit {
//        print("Department deinit")
//    }
//}
//
//var person: Person? = Person()
//var department: Department? = Department()
//
//person?.department = department
//
//person = nil
//department = nil
//

// тк есть сильная ссылка не вызывается deinit

//class Person {
//    
//    var department: Department?
//    
//    init() {
//        print("Person init")
//    }
//    
//    deinit {
//        print("Person deinit")
//    }
//}
//
//class Department {
//    
//    var person: Person?
//    
//    init() {
//        print("Department init")
//    }
//    
//    deinit {
//        print("Department deinit")
//    }
//}
//
//var person: Person? = Person()
//var department: Department? = Department()
//
//person?.department = department
//department?.person = person
//
//person = nil
//department = nil
//

// решение - одну из связей person внутри department или department в person пометить как weak (не будем повышать счетчик сильных ссылок)
//
//class Person {
//    
//    var department: Department?
//    
//    init() {
//        print("Person init")
//    }
//    
//    deinit {
//        print("Person deinit")
//    }
//}
//
//class Department {
//    
//    weak var person: Person?
//    
//    init() {
//        print("Department init")
//    }
//    
//    deinit {
//        print("Department deinit")
//    }
//}
//
//var person: Person? = Person()
//var department: Department? = Department()
//
//person?.department = department
//department?.person = person
//
//person = nil
//department = nil


//class Auto {
//    var run: (() -> Void)? = nil
//    
//    var process: String = ""
//    
//    init() {
//        print("init auto")
//    }
//    
//    deinit {
//        print("deinit auto")
//    }
//}
//
//var auto: Auto? = Auto()
//
//auto?.run = {
//    auto?.process = "run"
//}
//
//auto = nil


class Auto {
    var run: (() -> Void)? = nil
    
    var process: String = ""
    
    init() {
        print("init auto")
    }
    
    deinit {
        print("deinit auto")
    }
}

var auto: Auto = Auto()

// почему не вызывался deinit
// замыкания внутри себя неявно захватывают объекты с которых они вызываются, и мы должны эту связь разрывать.

auto.run = { [weak auto] in
    auto?.process = "run"
}

