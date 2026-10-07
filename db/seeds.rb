puts "------------------- LOADING COUNTRIES -------------------"
if Country.count == 0
  File.foreach(Rails.root.join("db", "data", "countries.txt")) do |line|
    name, code = line.strip.split(",")
    Country.find_or_create_by!(code: code) do |country|
      country.name = name
    end
  end
end

puts "------------------- LOADING GENRES -------------------"
if Genre.count == 0
  genres = TicketmasterService.genres
  genres.each do |genre|
    Genre.find_or_create_by!(name: genre["name"])
  end
end

puts "------------------- CREATING ROLES -------------------"
admin_role = Role.find_or_create_by!(name: "admin")
user_role = Role.find_or_create_by!(name: "user")

puts "------------------- CREATING USERS -------------------"
admin = User.find_or_create_by!(username: "admin", email: "admin@gmail.com", role_id: admin_role.id)
admin.password = ENV.fetch("ADMIN_PASSWORD")
admin.save!
