require "rails_helper"

RSpec.describe "Book Search Endpoint", :vcr do
  it "returns book results for a given city" do
    get "/api/v0/book-search", params: {location: "denver,co", quantity: 5}

    expect(response).to be_successful
    expect(response.status).to eq(200)

    results = JSON.parse(response.body, symbolize_names: true)

    expect(results).to have_key(:data)
    expect(results[:data]).to be_a(Hash)

    expect(results[:data]).to have_key(:id)
    expect(results[:data][:id]).to eq(nil)

    expect(results[:data]).to have_key(:type)
    expect(results[:data][:type]).to eq("books")
    
    expect(results[:data]).to have_key(:attributes)
    expect(results[:data][:attributes]).to be_a(Hash)

    expect(results[:data][:attributes]).to have_key(:destination)
    expect(results[:data][:attributes][:destination]).to eq("denver,co")

    expect(results[:data][:attributes]).to have_key(:forecast)
    expect(results[:data][:attributes][:forecast]).to be_a(Hash)
    expect(results[:data][:attributes][:forecast]).to have_key(:summary)
    expect(results[:data][:attributes][:forecast][:summary]).to be_a(String)

    expect(results[:data][:attributes][:forecast]).to have_key(:temperature)
    expect(results[:data][:attributes][:forecast][:temperature]).to be_a(String)
    expect(results[:data][:attributes][:forecast][:temperature]).to end_with("F")

    expect(results[:data][:attributes]).to have_key(:total_books_found)
    expect(results[:data][:attributes][:total_books_found]).to be_an(Integer)

    expect(results[:data][:attributes]).to have_key(:books)
    books = results[:data][:attributes][:books]

    expect(books).to be_an(Array)
    expect(books.count).to eq(5)

    books.each do |book|
      expect(book).to have_key(:title)
      expect(book[:title]).to be_a(String)
      expect(book).to have_key(:isbn)
      if book[:isbn]
        expect(book[:isbn]).to be_an(Array)
        expect(book[:isbn]).to all be_a(String)
      end
    end
  end

  xit "has an error if given city is invalid" do

  end

  xit "has an error if missing a city in query" do

  end

  xit "has an error if quantity is missing" do

  end

  xit "has an error if quantity is not greater than zero" do
    
  end
end