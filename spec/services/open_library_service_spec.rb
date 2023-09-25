require "rails_helper"

RSpec.describe OpenLibraryService do
  it "connects to open library API" do
    service = OpenLibraryService.new

    expect(service.conn).to be_a(Faraday::Connection)
  end

  it "searches books by location", :vcr do
    service = OpenLibraryService.new

    response = service.search("denver,co")

    results = JSON.parse(response.body, symbolize_names: true)
    
    expect(results).to have_key(:numFound)
    expect(results[:numFound]).to be_an(Integer)

    expect(results).to have_key(:docs)

    books = results[:docs]
    expect(books).to be_an(Array)
    expect(books.count <= results[:numFound]).to eq(true)

    books.each do |book|
      expect(book).to have_key(:title)
      expect(book[:title]).to be_a(String)
      if book[:isbn]
        expect(book[:isbn]).to be_an(Array)
        expect(book[:isbn]).to all be_a(String)
      end
      expect(book.count).to eq(1).or eq(2)
    end
  end
end