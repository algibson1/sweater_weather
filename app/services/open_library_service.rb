class OpenLibraryService
  def conn 
    Faraday.new("https://openlibrary.org/search.json")
  end

  
end