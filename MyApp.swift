import SwiftUI

@main
struct MyApp: App {
    
    init() {
        let cfURL = Bundle.main.url(forResource: "SquadaOne-Regular", withExtension: "ttf")! as CFURL

                CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
        for family: String in UIFont.familyNames {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
    var body: some Scene {
        WindowGroup {
            MenuView()
        }
    } 
}
