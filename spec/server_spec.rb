require "rspec"
require "prh_restapi/server.rb"

RSpec.describe PostalCodeHandler do
  describe '#do_get' do
    let(:request) { double('request') }
    let(:response) { double('response', :status= => nil, :[]= => nil, :body= => nil) }
    let(:db) { double('database connection') }

    it 'returns a JSON response of companies for a valid postal code' do
      # Set up the request
      allow(request).to receive(:path).and_return('/postal_codes/00210/companies')

      # Set up the database connection
      allow(db).to receive(:execute).and_return([
        {

    "businessId": "3353862-4",
    "name": "Stay Sharp Oy",
    "registrationDate": "2023-03-23",
    "companyForm": "OY",
    "detailsUri": "http://avoindata.prh.fi/opendata/bis/v1/3353862-4",
    "postal_code": "00210"

},
{

    "businessId": "3349694-6",
    "name": "HSN Consulting Oy",
    "registrationDate": "2023-03-06",
    "companyForm": "OY",
    "detailsUri": "http://avoindata.prh.fi/opendata/bis/v1/3349694-6",
    "postal_code": "00210"

}
      ])

      # Create a new PostalCodeHandler instance and call the do_get method
      handler = PostalCodeHandler.new(:Port => 8080)
      handler.instance_variable_set(:@db, db)
      handler.do_GET(request, response)

      # Check the response
      expect(response).to receive(:status).with(200)
      expect(JSON.parse(response.body)).to eq([
        {

    "businessId": "3353862-4",
    "name": "Stay Sharp Oy",
    "registrationDate": "2023-03-23",
    "companyForm": "OY",
    "detailsUri": "http://avoindata.prh.fi/opendata/bis/v1/3353862-4",
    "postal_code": "00210"

},
{

    "businessId": "3349694-6",
    "name": "HSN Consulting Oy",
    "registrationDate": "2023-03-06",
    "companyForm": "OY",
    "detailsUri": "http://avoindata.prh.fi/opendata/bis/v1/3349694-6",
    "postal_code": "00210"

}
      ])
    end
  end
end
