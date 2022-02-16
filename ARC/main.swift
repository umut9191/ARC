//
//  main.swift
//  ARC
//
//  Created by Macintosh on 15.02.2022.
//

import Foundation

//class Person {
//    let name: String
//    init(name: String) {
//        self.name = name
//        print("\(name) is being initialized")
//    }
//    deinit {
//        print("\(name) is being deinitialized")
//    }
//}
//
//var reference1: Person?
//var reference2: Person?
//var reference3: Person?
//reference1 = Person(name: "John Appleseed")
//reference2 = reference1
//reference3 = reference1
//reference1 = nil
//reference2 = nil
//reference3 = nil
// Prints "John Appleseed is being deinitialized"
// // // //2.
//class Person {
//    let name: String
//    init(name: String) { self.name = name }
//    var apartment: Apartment?
//    deinit { print("\(name) is being deinitialized") }
//}
//class Apartment {
//    let unit: String
//    init(unit: String) { self.unit = unit }
//    weak var tenant: Person?
//    deinit { print("Apartment \(unit) is being deinitialized") }
//}
//var john: Person?
//var unit4A: Apartment?
//john = Person(name: "John Appleseed")
//unit4A = Apartment(unit: "4A")
//john!.apartment = unit4A
//unit4A!.tenant = john
//
//unit4A = nil
//john = nil
// // // //3.
//class Customer {
//    let name: String
//    var card: CreditCard?
//    init(name: String) {
//        self.name = name
//    }
//    deinit { print("\(name) is being deinitialized") }
//}
//class CreditCard {
//    let number: UInt64
//    unowned let customer: Customer // can not be weak. because not optional
//    init(number: UInt64, customer: Customer) {
//        self.number = number
//        self.customer = customer
//    }
//    deinit { print("Card #\(number) is being deinitialized") }
//}
//var john: Customer?
//john = Customer(name: "John Appleseed")
//john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
//john = nil

// // // // //4.
//
//class Department {
//    var name: String
//    var courses: [Course]
//    init(name: String) {
//        self.name = name
//        self.courses = []
//    }
//}
//
//class Course {
//    var name: String
//    unowned var department: Department
//    unowned var nextCourse: Course?
//    init(name: String, in department: Department) {
//        self.name = name
//        self.department = department
//        self.nextCourse = nil
//    }
//}
//
//let department = Department(name: "Horticulture")
//
//let intro = Course(name: "Survey of Plants", in: department)
//let intermediate = Course(name: "Growing Common Herbs", in: department)
//let advanced = Course(name: "Caring for Tropical Plants", in: department)
//
//intro.nextCourse = intermediate
//intermediate.nextCourse = advanced
//department.courses = [intro, intermediate, advanced]

// // // // 5.
//class Country {
//    let name: String
//    var capitalCity: City!
//    init(name: String, capitalName: String) {
//        self.name = name
//        self.capitalCity = City(name: capitalName, country: self)
//    }
//    deinit{
//        print("Contry deinit")
//    }
//}
//class City {
//    let name: String
//    unowned let country: Country
//    init(name: String, country: Country) {
//        self.name = name
//        self.country = country
//    }
//    deinit{
//        print("City deinit")
//    }
//}
//var country:Country? = nil
//country = Country(name: "Canada", capitalName: "Ottawa")
//print("\(country!.name)'s capital city is called \(country!.capitalCity.name)")
//// Prints "Canada's capital city is called Ottawa"
//country = nil

// // // // // 6.
//Strong Reference Cycles for Closures

//class HTMLElement {
//
//    let name: String
//    let text: String?
//
//    lazy var asHTML: () -> String = {
//        if let text = self.text {
//            return "<\(self.name)>\(text)</\(self.name)>"
//        } else {
//            return "<\(self.name) />"
//        }
//    }
//
//    init(name: String, text: String? = nil) {
//        self.name = name
//        self.text = text
//    }
//
//    deinit {
//        print("\(name) is being deinitialized")
//    }
//
//}
//let heading = HTMLElement(name: "h1")
//let defaultText = "some default text"
//heading.asHTML = {
//    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
//}
//print(heading.asHTML())
//// Prints "<h1>some default text</h1>"
//var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
//print(paragraph!.asHTML())
//// Prints "<p>hello, world</p>"
//
//paragraph = nil
// 6.closure weak and unowned
//Define a capture in a closure as an unowned reference when the closure and the instance it captures will always refer to each other, and will always be deallocated at the same time.
//
//Conversely, define a capture as a weak reference when the captured reference may become nil at some point in the future. Weak references are always of an optional type, and automatically become nil when the instance they reference is deallocated. This enables you to check for their existence within the closure’s body.
//lazy var someClosure = {
//    [unowned self, weak delegate = self.delegate]
//    (index: Int, stringToProcess: String) -> String in
//    // closure body goes here
//}
//
//lazy var someClosure = {
//    [unowned self, weak delegate = self.delegate] in
//    // closure body goes here
//}
//If the captured reference will never become nil, it should always be captured as an unowned reference, rather than a weak reference.

//SOLUTION;
class HTMLElement {

    let name: String
    let text: String?

    lazy var asHTML: () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }

    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }

    deinit {
        print("\(name) is being deinitialized")
    }

}
var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())
// Prints "<p>hello, world</p>"
paragraph = nil
// Prints "p is being deinitialized"
