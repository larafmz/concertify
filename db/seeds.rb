puts "------------------- LOADING COUNTRIES -------------------"
if Country.count == 0
  File.foreach(Rails.root.join("db", "data", "countries.txt")) do |line|
    name, code = line.strip.split(",")
    Country.find_or_create_by!(code: code) do |country|
      country.name = name
    end
  end
end

puts "------------------- CREATING GENRES -------------------"
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
admin = User.find_or_create_by!(username: "admin", email: "admin@gmail.com") do |user|
  user.password = "Admin123!"
  user.role = admin_role
end
user = User.find_or_create_by!(username: "larafmz", email: "larafmdz@gmail.com") do |user|
  user.password = "Prueba1!"
  user.role = user_role
end
names = ["music_lover", "fan", "maria", "ana", "lucia", "sofia", "carla", "paula", "elena", "carlos", "laura", "eva", "julia", "marta", "alba", "clara", "david", "pablo", "andrea", "sara", "nuria", "gabriel", "ivan", "javier", "raul", "sergio", "miguel", "alvaro", "roberto", "jorge"]
50.times do |i|
  name = names.sample
  number = rand(1000..9999)
  User.create_or_find_by!(
    email: "#{name}#{number}@gmail.com",
    username: "#{name}#{number}",
    password: "Prueba1!",
    role: user_role
  )
end
users = User.all.where.not(role: admin_role).where.not(username: "larafmz")

puts "------------------- CREATING ARTISTS -------------------"
artists_id = ["K8vZ917GfM0", "K8vZ9171hSf", "K8vZ917pf50", "K8vZ917G60V", "K8vZ9174-C0", "K8vZ917r9aV", "K8vZ9174ek0", "K8vZ9174Za7", "K8vZ9174l1f", "K8vZ91721VV", "K8vZ917pJy7", "K8vZ9179HEV", "K8vZ917_3a7", "K8vZ917QeqV", "K8vZ9174dlV", "K8vZ9178oX0", "K8vZ917oP4f", "K8vZ917bDxf", "K8vZ9178u5f", "K8vZ917bQoV", "K8vZ917ukw7", "K8vZ917Q6Q7", "K8vZ917G9zV", "K8vZ917Gk4V", "K8vZ9173-lV"] 
artists_id.each do |ticketmaster_id|
  Artist.create_or_update_by_ticketmaster_id(ticketmaster_id)
end

puts "------------------- CREATING EVENTS -------------------"
events_api = TicketmasterService.events_by({}, size: 10)    
ticketmaster_ids = events_api.map { |event| event["id"] }
ticketmaster_ids.each do |ticketmaster_id|
  puts "Creating with Ticketmaster ID: #{ticketmaster_id}"
  Event.create_or_update_by_ticketmaster_id(ticketmaster_id)
end

puts "------------------- CREATING REQUESTS -------------------"
request1 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "Semana Grande de Gijón", date: "2019-08-12", ubication: Ubication.find_or_create_by(venue: "Playa de Poniente", city: "Gijón, Asturias", country: Country.find_by(code: "ES")),
    artists: [Artist.find_by!(ticketmaster_id: "K8vZ9179HEV")] ))
request2 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "Metropoli Gijón", date: "2022-07-06", ubication: Ubication.find_or_create_by(venue: "Metropoli Gijón", city: "Gijón, Asturias", country: Country.find_by(code: "ES")),
    artists: [Artist.create(name: "Beli Basarte", status: 0, requester_id: user.id)] ))
request3 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "Metropoli Gijón", date: "2022-07-06", ubication: Ubication.find_or_create_by(venue: "Metropoli Gijón", city: "Gijón, Asturias", country: Country.find_by(code: "ES")),
    artists: [Artist.find_by(ticketmaster_id: "K8vZ917_3a7")] ))
request4 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "Metropoli Gijón", date: "2022-07-07", ubication: Ubication.find_or_create_by(venue: "Metropoli Gijón", city: "Gijón, Asturias", country: Country.find_by(code: "ES")),
    artists: [Artist.find_by(ticketmaster_id: "K8vZ917QeqV")] ))
request5 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "Cuando te muerdes el labio Tour", date: "2022-09-11", ubication: Ubication.find_or_create_by(venue: "La Ería", city: "Oviedo, Asturias", country: Country.find_by(code: "ES")),
    artists: [Artist.find_by(ticketmaster_id: "K8vZ9174dlV")] ))
request6 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "The 5 Seconds of Summer Show Tour", date: "2023-09-24", ubication: Ubication.find_or_create_by(venue: "Palacio Vistalegre", city: "Madrid", country: Country.find_by(code: "ES")),
    artists: [Artist.find_by(ticketmaster_id: "K8vZ9178oX0")] ))
request7 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "PORTALS Tour", date: "2023-11-28", ubication: Ubication.find_or_create_by(venue: "WiZink Center", city: "Madrid", country: Country.find_by(code: "ES")),
    artists: [Artist.find_by(ticketmaster_id: "K8vZ917oP4f")] ))
request8 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "Metropoli Gijón", date: "2024-07-05", ubication: Ubication.find_or_create_by(venue: "Metropoli Gijón", city: "Gijón, Asturias", country: Country.find_by(code: "ES")),
    artists: [Artist.find_by(ticketmaster_id: "K8vZ917bDxf")] ))
request9 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "Semana Grande de Gijón", date: "2024-08-13", ubication: Ubication.find_or_create_by(venue: "Playa de Poniente", city: "Gijón, Asturias", country: Country.find_by(code: "ES")),
    artists: [Artist.find_by(ticketmaster_id: "K8vZ9178u5f")] ))
request10 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "Semana Grande de Gijón", date: "2026-08-08", ubication: Ubication.find_or_create_by(venue: "Playa de Poniente", city: "Gijón, Asturias", country: Country.find_by(code: "ES")),
    artists: [Artist.find_by(ticketmaster_id: "K8vZ917bQoV")] ))
request11 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "The Clancy World Tour", date: "2025-04-22", ubication: Ubication.find_or_create_by(venue: "Palau Sant Jordi", city: "Barcelona", country: Country.find_by(code: "ES")),
    artists: [Artist.find_by(ticketmaster_id: "K8vZ917ukw7")] ))
request12 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "The Trilogy Tour", date: "2024-10-05", ubication: Ubication.find_or_create_by(venue: "Palau Sant Jordi", city: "Barcelona", country: Country.find_by(code: "ES")),
    artists: [Artist.find_by(ticketmaster_id: "K8vZ917oP4f")] ))
request13 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "Tour Gigante", date: "2025-07-26", ubication: Ubication.find_or_create_by(venue: "Parque Hermanos Castro", city: "Gijón, Asturias", country: Country.find_by(code: "ES")),
    artists: [Artist.find_by(ticketmaster_id: "K8vZ9174dlV")] ))
request14 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "ONU TOUR", date: "2026-11-06", ubication: Ubication.find_or_create_by(venue: "Teatro Albéniz", city: "Gijón, Asturias", country: Country.find_by(code: "ES")),
    artists: [Artist.find_or_create_by(name: "Niña Polaca", status: 0, requester_id: user.id)] ))
request15 = Request.create!(status: 0, requester_id: user.id, 
  event: Event.create(tour_name: "Tour Gigante (Fin de Gira)", date: "2026-09-19", ubication: Ubication.find_or_create_by(venue: "La Ería", city: "Oviedo, Asturias", country: Country.find_by(code: "ES")),
    artists: [Artist.find_by(ticketmaster_id: "K8vZ9174dlV")] ))


puts "------------------- CREATING REGISTERS -------------------"
Register.create(user_id: user.id, review: "Chulisima y encima GRATIS", event_id: request1.event.id, rating: 4) 
Register.create(user_id: user.id, event_id: request2.event.id) 
Register.create(user_id: user.id, event_id: request3.event.id) 
Register.create(user_id: user.id, review: "Estaba PETADISIMO de gente que no podiamos ni movernos y yo tenia COVID pero TOP CONCIERTOS", event_id: request4.event.id, rating: 5) 
Register.create(user_id: user.id, review: "Primera vez que vi a Leiva y la vez que mas me presto", event_id: request5.event.id, rating: 5) 
Register.create(user_id: user.id, review: "Concierto con Lau!! Aunque no me sabia casi las canciones, me encantoooo", event_id: request6.event.id, rating: 3) 
Register.create(user_id: user.id, review: "Primer conci de Melanie despues de ser fan desde que tenia 14 años. Y en primera fila (de la pista B :c)", event_id: request7.event.id, rating: 5) 
Register.create(user_id: user.id, event_id: request8.event.id) 
Register.create(user_id: user.id, event_id: request9.event.id) 
Register.create(user_id: user.id, review: "Conciertazo, Amaia reina... LLoré.", event_id: request10.event.id, rating: 5) 
Register.create(user_id: user.id, review: "PRIMER CONCI CHULO CON ALI Y ENCIMA DE LOS MAS GRANDES, VAYA DIA, 10/10", event_id: request11.event.id, rating: 5) 
Register.create(user_id: user.id, review: "Desvirtualize a una amiga en este conci!! Estuvo chulo pero tuvimos beef con la señora de atras, no repetiria :,)", event_id: request12.event.id, rating: 2) 
Register.create(user_id: user.id, review: "Segundaaaaa, casi primera fila. No me toco la gente mas guay alrededor en el conci y me jodieron un poco la experiencia.", event_id: request13.event.id, rating: 3) 
Register.create(user_id: user.id, review: "Fui con MI MADRE, alli desde las 17 como buenas fans. Me encanto. Toco la cancion de Robe y pude ver a Juanchito.", event_id: request15.event.id, rating: 4) 
FutureAssistance.create(user_id: user.id, event_id: request14.event.id, from: "", event_seat: nil, event_seat_details: "", company: 1)
reviews = [
  "Fui con mi madre y me encantó. El ambiente fue increíble y disfruté muchísimo.",
  "Muy buen evento, lo pasé genial y repetiría sin duda.",
  "La experiencia fue increíble, sobre todo el ambiente y la música.",
  "Fui con unos amigos y nos lo pasamos genial. Muy recomendable.",
  "Me encantó el evento, todo estuvo muy bien organizado.",
  "Una noche increíble. La actuación fue espectacular.",
  "Disfruté muchísimo, volvería a ir sin pensármelo.",
  "El ambiente fue brutal y la experiencia superó mis expectativas.",
  "Muy buena experiencia, especialmente por el ambiente y la gente.",
  "Fue una pasada. Sin duda uno de los mejores eventos a los que he ido."
]
Event.accepted.each do |event|
  random_user = users.order("RANDOM()").first
  Register.create(
    user_id: random_user.id,
    review: reviews.sample,
    event_id: event.id,
    rating: rand(3..5)
  )
end

puts "------------------- CREATING PUBLICATIONS -------------------"
contents = [
  "Que mono de conciertos...",
  "Necesito música en directo ya.",
  "¿Quién se apunta al próximo concierto?",
  "Qué ganas de volver a vivir algo así.",
  "Los conciertos son otro nivel.",
  "Necesito un buen festival urgentemente.",
  "Planazo para este finde.",
  "¿Cuál ha sido vuestro concierto favorito?",
  "Ya tengo ganas del próximo evento.",
  "La música en directo >>>"
]
users_ids = users.pluck(:id)
artists = Artist.accepted.pluck(:id)
events = Event.accepted.pluck(:id)
50.times do
  publication = {
    user_id: users_ids.sample,
    review: contents.sample
  }
  if rand < 0.5 && artists.any?
    publication[:artist_id] = artists.sample
  elsif events.any?
    publication[:event_id] = events.sample
  end

  Publication.create(publication)
end

50.times do
  Relation.create(follower_id: users_ids.sample, followed_id: Artist.accepted.order("RANDOM()").first.id, relation_type: 0, followed_type: "Artist")
end