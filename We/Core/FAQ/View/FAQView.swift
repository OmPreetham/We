//
//  FAQView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/6/24.
//

import SwiftUI

struct FAQView: View {
    @ObservedObject var viewModel = FAQViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(FAQCategory.allCases) { category in
                    Section(header: FAQHeaderView(category: category, isExpanded: viewModel.isCategoryExpanded(category)) {
                        viewModel.toggleCategory(category)
                    }) {
                        if viewModel.isCategoryExpanded(category) {
                            ForEach(viewModel.faqList.filter { $0.category == category }) { faq in
                                FAQRow(faq: faq)
                            }
                        }
                    }
                }
            }
            .navigationTitle("FAQs")
        }
    }
}

// MARK: - FAQ Header View for Sections
struct FAQHeaderView: View {
    var category: FAQCategory
    var isExpanded: Bool
    var action: () -> Void
    
    var body: some View {
        HStack {
            Text(category.rawValue)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                .foregroundColor(.gray)
        }
        .onTapGesture {
            action()
        }
    }
}

// MARK: - FAQ Row View
struct FAQRow: View {
    let faq: FAQ
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                isExpanded.toggle()
            }) {
                Text(faq.question)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.vertical, 5)
            }
            
            if isExpanded {
                Text(faq.answer)
                    .font(.body)
                    .padding(.vertical, 5)
            }
        }
    }
}

#Preview {
    FAQView()
}
