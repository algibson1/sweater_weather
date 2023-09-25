class BookSearchSerializer 
  def initialize(forecast, book_results)
    @forecast = forecast[:current]
    @book_results = book_results
  end

  def to_json 
    { 
      data: {
        id: nil,
        type: "books",
        attributes: {
          destination: @book_results[:destination],
          forecast: {
            summary: @forecast[:condition][:text],
            temperature: "#{@forecast[:temp_f].round} F"
          },
          total_books_found: @book_results[:total_books_found],
          books: @book_results[:books].map do |book|
            {isbn: book[:isbn],
            title: book[:title]}
          end
        }
      }
    }
  end
end