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
admin = User.find_or_create_by!(username: "admin", email: "admin@gmail.com") do |user|
  user.password = "Admin123!"
  user.role = admin_role
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

puts "------------------- CREATING REGISTERS -------------------"
reviews = [
  "Fui con mis padres y me encantó. El ambiente fue increíble y disfruté muchísimo.",
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