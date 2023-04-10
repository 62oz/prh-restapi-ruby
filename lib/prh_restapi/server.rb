require 'webrick'
require 'json'
require_relative 'database'


class PostalCodeHandler < WEBrick::HTTPServlet::AbstractServlet
    def do_GET(request, response)
        db = getDB("companies")
        # Check for the correct path
        prefix = "/postal_codes/"
        if !request.path.start_with?(prefix) || !request.path.end_with?("/companies")
            response.status = 404
            response.body = "Not found"
            return
        end
        code = request.path.sub(prefix, "").chomp("/companies")

        # Get the companies from the database
        companies = getCompaniesByPostalCode(db, code)
        if companies.nil?
            response.status = 500
            response.body = "Internal server error: companies is nil 1"
            return
        end

        # If data is not in the database, fetch it from API
        if companies.empty?
            # Get the data from the API
            puts "Fetching data from the API for new postal code..."
            companies = fetch_data([code], 20)
            if companies.nil?
                response.status = 500
                response.body = "Internal server error: companies is nil 2"
                return
            end
            if companies.empty?
                response.status = 404
                response.body = "No companies found for this postal code."
                puts "companies empty 3"
                return
            end
            # Insert the data into the database
            puts "Inserting data into the database..."
            e = insertCompanies(db, companies)
            if !e.nil?
                response.status = 500
                response.body = "Internal server error"
                return
            end
        end

        # Return the companies as JSON response
        response.status = 200
        response['Content-Type'] = 'application/json'
        response.body = JSON.generate(companies)
    end
end

