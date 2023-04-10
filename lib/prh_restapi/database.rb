def getDB(name)
    # Open a database
    begin
        db = SQLite3::Database.new("#{name}.db")
    rescue SQLite3::Exception => e
        puts "Error opening database: #{e.message}"
        return nil
    end

    # Create a table for the companies
    begin
        db.execute("CREATE TABLE IF NOT EXISTS companies (
            business_id TEXT PRIMARY KEY,
            name TEXT,
            registration_date TEXT,
            postal_code TEXT,
            company_form TEXT,
            details_uri TEXT
        )")
    rescue SQLite3::Exception => e
        puts "Error creating table: #{e.message}"
        return nil
    end

    return db

end


def insertCompanies(db, data)
    begin
      db.transaction do |tx|
        data.each do |company|
          begin
            db.prepare("INSERT OR REPLACE INTO companies (business_id, name, registration_date, postal_code, company_form, details_uri) VALUES (?, ?, ?, ?, ?, ?)") do |stmt|
              stmt.bind_params(company["businessId"], company["name"], company["registrationDate"], company["postal_code"], company["companyForm"], company["detailsUri"])
              stmt.execute
            end
          rescue SQLite3::Exception => e
            raise "Error preparing or executing statement: #{e.message}"
            tx.rollback
            return e
          end
        end
      end
    rescue SQLite3::Exception => e
      puts "Error inserting data: #{e.message}"
      return e
    end
    return nil
  end

def getCompaniesByPostalCode(db, postal_code)
    begin
        companies = []
        db.execute("SELECT * FROM companies WHERE postal_code = ?", postal_code) do |row|
            companies << row
        end
    rescue SQLite3::Exception => e
        puts "Error getting companies: #{e.message}"
        return nil
    end
    return companies
end
