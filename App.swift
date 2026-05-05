import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject var engine = GameEngine()
    @State private var showFilePicker = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if engine.isRunning {
                // The "Playable" Screen
                VStack {
                    Text("FPS: \(engine.fps)").foregroundColor(.green)
                    Spacer()
                    VirtualController()
                }
            } else {
                // Boot Menu
                VStack(spacing: 20) {
                    Text("GAMEHUB EMULATOR").font(.largeTitle).bold().foregroundColor(.white)
                    Button("Load Game File (.iso, .exe, .bin)") {
                        showFilePicker = true
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
        }
        .sheet(isPresented: $showFilePicker) {
            DocumentPicker(engine: engine)
        }
    }
}

// Logic to pick a file from the iPhone
struct DocumentPicker: UIViewControllerRepresentable {
    let engine: GameEngine
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.data])
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(engine: engine) }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let engine: GameEngine
        init(engine: GameEngine) { self.engine = engine }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first { engine.bootGame(from: url) }
        }
    }
}
