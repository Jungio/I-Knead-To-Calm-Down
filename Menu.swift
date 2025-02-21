import SwiftUI

enum Router {
    case first, second, third
}

struct MenuView: View {
    @State var router: Router = .first
    
    var body: some View {
        VStack {
            switch router {
            case .first:
                FirstView(router: $router)
            case .second:
                SecondView(router: $router)
            case .third:
                ThirdView(router: $router)
            }
        }
    }
}

struct FirstView: View {
    @Binding var router: Router
    
    var body: some View {
        ZStack {
            Image("KITCHEN")
                .resizable()
                .scaledToFit()
             
            
            VStack {
                Text("I KNEAD TO CALM DOWN")
                    .font(.custom("SquadaOne-Regular", size:125))
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
                    .padding(.top, 200)
                    .padding(.bottom, 200)
            
                HStack {
                    Spacer()
                    Spacer()
                    
                    Button {
                        router = .second
                    } label: {
                        
                        Text("Start")
                            .frame(maxWidth: 450, minHeight: 125)
                            .foregroundStyle(.black)
                            .font(.custom("SquadaOne-Regular", size:65))
                            .background(.brown)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 8))
                    }
                    
                    Spacer()
                   
                    Button {
        
                        router = .third
                        
                    } label: {
                        
                        Text("Recipe")
                            .frame(maxWidth: 450, minHeight: 125)
                            .foregroundStyle(.black)
                            .font(.custom("SquadaOne-Regular", size:65))
                            .background(.brown)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 8))
                    }
                    
                    Spacer()
                    Spacer()
                }
             .padding(.bottom, 465)
            }
        }
    }
    
}

struct SecondView: View {
    @Binding var router: Router
    
    var body: some View {
        VStack {
            IntroView()
        }
        
    }
}

struct ThirdView: View {
    @Binding var router: Router
    
    var body: some View {
            ZStack {
                Image("blank")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Image("bread")
                        .frame(width: 100, height: 100)
                        .padding(.top, 100)
                    
                    Text("Bread Recipe")
                        .font(.custom("SquadaOne-Regular", size: 70))
                        .padding(.top, 75)
                    
                    Text("""
                         This game is based on my own personal experience, thus the recipe chosen to base it around is not random,
                         but one that's helped me the most, which is why I'm sharing it here.
                         """)
                    .font(.custom("SquadaOne-Regular", size: 30))
                    
                    HStack {
                        Text("""
                Ingredients:
                - 1 1/2 cups water
                - 1 tbsp instant yeast
                - 1 tsp salt
                - 2 tbsp sugar
                - 3 cups flour
                """)
                        .font(.custom("SquadaOne-Regular", size: 30))
                        .padding()
                        
                        
                        Text("""
                Instructions:
                1. Mix all ingredients in a bowl (put flour in gradually).
                2. Knead the dough for 3 minutes, the dough should be soft.
                3. Let it rise for 30 minutes.
                4. Bake at 400°F (200°C) for 20 minutes.
                5. Enjoy your homemade bread!
                """)
                        .font(.custom("SquadaOne-Regular", size: 30))
                        .padding()
                        
                    }
                    Button("Back to Menu") {
                        router = .first
                    }
                    .padding()
                    .font(.custom("SquadaOne-Regular", size: 30))
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
        }
    }
