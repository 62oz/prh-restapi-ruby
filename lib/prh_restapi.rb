require_relative "prh_restapi/client"
require_relative "prh_restapi/database"
require_relative "prh_restapi/server"
require "webrick"
require "sqlite3"

def main
    # Choose the postal codes and the number of companies to get for each call
    postal_codes = ["00210"]
    n_companies = 2

    puts "Fetching data from the API..."
    # Fetch the data from the API
    data = fetch_data(postal_codes, n_companies)

    # Create a database
    db = getDB("companies")

    puts "Inserting data into the database..."
    # Insert the data into the database
    insertCompanies(db, data)

    # Create the server and mount the handler
    server = WEBrick::HTTPServer.new(:Port => 8080)
    server.mount("/postal_codes/", PostalCodeHandler)

    # Start the server
    trap("INT") { server.shutdown }
    puts "Starting server port 8080 (http://localhost:8080/postal_codes/)"
    server.start
    puts "Server stopped"
end

main
