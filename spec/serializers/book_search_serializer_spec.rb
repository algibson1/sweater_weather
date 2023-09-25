require "rails_helper"

RSpec.describe BookSearchSerializer, :vcr do
  it "formats results for the book search endpoint" do
    forecast = WeatherFacade.new.get_forecast("denver,co")
    book_results = BookSearchFacade.new.find_books({location: "denver,co", quantity: 5})
    serialized = BookSearchSerializer.new(forecast, book_results).to_json

    expect(serialized).to be_a(Hash)
    expect(serialized).to have_key(:data)
    expect(serialized[:data]).to be_a(Hash)

    expect(serialized[:data]).to have_key(:id)
    expect(serialized[:data][:id]).to eq(nil)

    expect(serialized[:data]).to have_key(:type)
    expect(serialized[:data][:type]).to eq("books")
    
    expect(serialized[:data]).to have_key(:attributes)
    expect(serialized[:data][:attributes]).to be_a(Hash)

    expect(serialized[:data][:attributes]).to have_key(:destination)
    expect(serialized[:data][:attributes][:destination]).to eq("denver,co")

    expect(serialized[:data][:attributes]).to have_key(:forecast)
    expect(serialized[:data][:attributes][:forecast]).to be_a(Hash)
    expect(serialized[:data][:attributes][:forecast]).to have_key(:summary)
    expect(serialized[:data][:attributes][:forecast][:summary]).to be_a(String)

    expect(serialized[:data][:attributes][:forecast]).to have_key(:temperature)
    expect(serialized[:data][:attributes][:forecast][:temperature]).to be_a(String)
    expect(serialized[:data][:attributes][:forecast][:temperature]).to end_with("F")

    expect(serialized[:data][:attributes]).to have_key(:total_books_found)
    expect(serialized[:data][:attributes][:total_books_found]).to be_an(Integer)

    expect(serialized[:data][:attributes]).to have_key(:books)
    books = serialized[:data][:attributes][:books]

    expect(books).to be_an(Array)
    expect(books.count).to eq(5)
    
    books.each do |book|
      expect(book).to have_key(:title)
      expect(book[:title]).to be_a(String)
      if book[:isbn]
        expect(book[:isbn]).to be_an(Array)
        expect(book[:isbn]).to all be_a(String)
      end
    end
  end
end