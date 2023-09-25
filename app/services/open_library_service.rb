class OpenLibraryService
  def conn 
    Faraday.new("https://openlibrary.org/")
  end

  def search(location)
    conn.get("search.json") do |faraday|
      faraday.params[:q] = location
      faraday.params[:fields] = "title,isbn"
    end
  end
end