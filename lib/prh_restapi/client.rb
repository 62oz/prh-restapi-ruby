require 'net/http'

def fetch_data (postal_codes, n_companies)
    # Create variable for the data
    data = []
    # Get data from the API for each postal code
    postal_codes.each do |postal_code|
        url = URI("https://avoindata.prh.fi/bis/v1")
        url.query = URI.encode_www_form(
            totalResults: false,
            maxResults: n_companies,
            resultsFrom: 0,
            streetAddressPostCode: postal_code
        )

        begin
            response = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == "https") do |http|
                http.get(url)
            end

            result = JSON.parse(response.body)
            # Keep only the results field
            result = result["results"]
            # Add postal_code field to result
            result.each do |company|
                begin
                company["postal_code"] = postal_code
                rescue StandardError => e
                    puts "Error adding postal code to company: #{e.message}"
                end
            end
            data += result
        rescue StandardError => e
            puts "Error fetching data for postal code #{postal_code}: #{e.message}"
            return []
        end
    end
    return data
end
