# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Load countries from file
File.foreach(Rails.root.join("db", "data", "countries.txt")) do |line|
  name, code = line.strip.split(",")
  Country.find_or_create_by!(code: code) do |country|
    country.name = name
  end
end
