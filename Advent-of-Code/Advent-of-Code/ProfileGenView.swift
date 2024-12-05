//
//  TodayView 2.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/5/24.
//



import SwiftUI
import PhotosUI
#if canImport(ImagePlayground)
import ImagePlayground
#endif

enum Suggestion: String, CaseIterable {
    case office
    case mountain
    case beach
    case city
    case forest
}

@available(iOS 18.1, macOS 15.1, *)
struct ProfileGenView: View {
    // MARK: - State Properties
    @State private var showImagePlayground = false
    @State private var createdImageURL: URL?
    @State private var selectedImage: Image?
    @State private var showingPhotoPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var suggestion: Suggestion
    
    var body: some View {
        VStack {
            if let url = createdImageURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 300, maxHeight: 300)
                } placeholder: {
                    ProgressView()
                }
            }
            Picker("Setting", selection: $suggestion) {
                ForEach(Suggestion.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)

            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                Text("Pick Image")
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = Image(uiImage: uiImage)
                    }
                }
            }
            
            if let selectedImage {
                selectedImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
            }
            
            Button("Show Generation Sheet") {
                showImagePlayground = true
            }
            .imagePlaygroundSheet(
                isPresented: $showImagePlayground,
                concepts: [ImagePlaygroundConcept.text("Cartoon version of this photo in a \($suggestion.wrappedValue.rawValue) setting")],
                sourceImage: selectedImage
            ) { url in
                createdImageURL = url
            }
        }
        .padding()
    }
}
