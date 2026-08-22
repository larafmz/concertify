# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Load countries from file
if Country.count == 0
  File.foreach(Rails.root.join("db", "data", "countries.txt")) do |line|
    name, code = line.strip.split(",")
    Country.find_or_create_by!(code: code) do |country|
      country.name = name
    end
  end
end

#Load genres from Ticketmaster API
if Genre.count == 0
  genres = TicketmasterService.genres
  genres.each do |genre|
    Genre.find_or_create_by!(name: genre["name"])
  end
end

Role.find_or_create_by!(name: "admin")
Role.find_or_create_by!(name: "user")
