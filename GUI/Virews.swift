import SwiftUI

struct Views: View {
    @ObservedObject var presenter: Presenters

    var body: some View {
        if let screen = presenter.currentScreen {
            #if os(macOS)
            buildMacOSView(from: screen, actionHandler: handleAction)
            #else
            buildiOSView(from: screen, actionHandler: handleAction)
            #endif
        } else {
            Text("Loading...")
                .onAppear {
                    presenter.loadScreen(named: "Home")
                }
        }
    }

    func handleAction(_ action: String) {
        presenter.handleAction(action)
    }

    // View cho iOS
    func buildiOSView(from screen: Screen, actionHandler: @escaping (String) -> Void) -> some View {
        NavigationView {
            buildContentView(from: screen, actionHandler: actionHandler)
                .navigationTitle(screen.name)
        }
    }

    // View cho macOS
    @ViewBuilder
    func buildMacOSView(from screen: Screen, actionHandler: @escaping (String) -> Void) -> some View {
        if #available(macOS 13, *) {
            NavigationSplitView {
                List {
                    ForEach(presenter.interactor.loadScreens(), id: \.self) { screenModel in
                        Button(action: {
                            presenter.loadScreen(named: screenModel.name)
                        }) {
                            Text(screenModel.name)
                        }
                    }
                }
                .listStyle(SidebarListStyle())
            } detail: {
                buildContentView(from: screen, actionHandler: actionHandler)
            }
        } else {
            HStack(spacing: 0) {
                List {
                    ForEach(presenter.interactor.loadScreens(), id: \.self) { screenModel in
                        Button(action: {
                            presenter.loadScreen(named: screenModel.name)
                        }) {
                            Text(screenModel.name)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .listStyle(SidebarListStyle())
                .frame(minWidth: 150, idealWidth: 200, maxWidth: 250)
                
                Divider()
                
                buildContentView(from: screen, actionHandler: actionHandler)
            }
        }
    }

    @ViewBuilder
    func buildContentView(from screen: Screen, actionHandler: @escaping (String) -> Void) -> some View {
        ZStack {
            if let backgroundImage = screen.backgroundImage {
                Image(backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
            }
            if screen.isTransparent {
                Color.clear
            } else if let backgroundColor = screen.backgroundColor {
                backgroundColor
            } else {
                Color.white
            }

            if let blurEffect = screen.blurEffect {
                VisualEffectView(material: blurEffect)
                    .edgesIgnoringSafeArea(.all)
            }

            VStack {
                ForEach(screen.components) { component in
                    buildView(from: component, actionHandler: actionHandler)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    func buildView(from component: Component, actionHandler: @escaping (String) -> Void) -> some View {
        if component.isHidden == true {
            return AnyView(EmptyView())
        }

        switch component.type {
        case "VStack":
            return AnyView(VStack {
                if let children = component.children {
                    ForEach(children) { child in
                        buildView(from: child, actionHandler: actionHandler)
                    }
                }
            })
        case "HStack":
            return AnyView(HStack {
                if let children = component.children {
                    ForEach(children) { child in
                        buildView(from: child, actionHandler: actionHandler)
                    }
                }
            })
        case "Text":
            var text = Text(component.content ?? "")
            if let font = component.font {
                text = text.font(font)
            }
            if let color = component.foregroundColor {
                text = text.foregroundColor(color)
            }
            return AnyView(text)
        case "Button":
            return AnyView(Button(action: {
                actionHandler(component.action ?? "")
            }) {
                Text(component.label ?? "")
            })
        case "Image":
            if let imageName = component.content {
                return AnyView(Image(systemName: imageName))
            }
            return AnyView(EmptyView())
        case "Spacer":
            return AnyView(Spacer())
        case "Divider":
            return AnyView(Divider())
        default:
            return AnyView(EmptyView())
        }
    }
}

// Custom VisualEffectView cho hiệu ứng mờ nền
struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = .behindWindow
        nsView.state = .active
    }
}
