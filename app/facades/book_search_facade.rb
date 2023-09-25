class BookSearchFacade 
  def find_books(query_params)
    response = service.search(query_params[:location])
    format(JSON.parse(response.body, symbolize_names: true), query_params)
  end

  def format(results, query_params)
    {
      total_books_found: results[:numFound],
      destination: query_params[:location],
      books: results[:docs][0...query_params[:quantity].to_i]
    }
  end

  def service 
    @book_service ||= OpenLibraryService.new
  end
end