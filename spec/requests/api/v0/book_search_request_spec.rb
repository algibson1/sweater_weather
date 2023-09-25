require "rails_helper"

RSpec.describe "Book Search Endpoint" do
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
    expect(results[:data][:attributes][:destination]).to have_key("denver,co")

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
    expect(books.count).to eq(results[:data][:attributes][:total_books_found])
    books.each do |book|
      expect(book).to have_key(:isbn)
      expect(book[:isbn]).to be_an(Array)
      expect(book[:isbn]).to all be_a(String)

      expect(book).to have_key(:title)
      expect(book[:title]).to be_a(String)
      expect(book[:title]).to include("Denver")
    end
  end

  xit "has an error if given city is invalid" do

  end
end