require "rails_helper"

RSpec.describe BookSearchFacade do
  it "fetches search results from service", :vcr do
    facade = BookSearchFacade.new

    response = facade.find_books({location: "denver,co", quantity: 5})

    expect(response).to be_a(Hash)
    expect(response).to have_key(:total_books_found)
    expect(response[:total_books_found]).to be_an(Integer)

    expect(response).to have_key(:destination)
    expect(response[:destination]).to eq("denver,co")

    expect(response).to have_key(:books)
    expect(response[:books]).to be_an(Array)
    expect(response[:books].count).to eq(5)
    
    response[:books].each do |book|
      expect(book.count).to eq(1).or eq(2)
      expect(book).to have_key(:title)
    end
  end
end