# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "csv"
require "open-uri"
require "json"
require "faker"


puts "Clearing tables..."
Categorization.delete_all
Category.delete_all
Inspection.delete_all
Review.delete_all
Restaurant.delete_all
Ward.delete_all

def find_or_create_ward(name)
  Ward.find_or_create_by(name: name)
end

# FOOD ESTABLISHMENTS DATA IMPORT

ESTABLISHMENTS_CSV = Rails.root.join("db", "data", "establishments.csv")

unless File.exist?(ESTABLISHMENTS_CSV)
  puts ">> Please place establishments.csv at db/data/establishments.csv (with columns: name,address,ward,lat,lon,ext_id,phone,postal)"
  puts ">> Seeding with a tiny fallback set so the app boots."
  sample = [
    { "name"=>"Pita Place", "address"=>"123 Main St", "ward"=>"Fort Rouge - East Fort Garry",
      "lat"=>"49.884", "lon"=>"-97.147", "ext_id"=>"SAMPLE-1", "phone"=>"204-555-1111", "postal"=>"R3C 1A1" },
    { "name"=>"Prairie Diner", "address"=>"456 Portage Ave", "ward"=>"Daniel McIntyre",
      "lat"=>"49.890", "lon"=>"-97.152", "ext_id"=>"SAMPLE-2", "phone"=>"204-555-2222", "postal"=>"R3B 2E9" }
  ]
  sample.each do |row|
    ward = find_or_create_ward(row["ward"])
    Restaurant.create!(
      name: row["name"],
      address: row["address"],
      ward: ward,
      latitude: row["lat"],
      longitude: row["lon"],
      external_id: row["ext_id"],
      phone: row["phone"],
      postal_code: row["postal"]
    )
  end
else
  puts "Importing establishments from CSV..."
  count = 0
  CSV.foreach(ESTABLISHMENTS_CSV, headers: true) do |row|
    ward = find_or_create_ward(row["ward"])
    Restaurant.create!(
      name: row["name"],
      address: row["address"],
      ward: ward,
      latitude: row["lat"],
      longitude: row["lon"],
      external_id: row["ext_id"],
      phone: row["phone"],
      postal_code: row["postal"]
    )
    count += 1
  end
  puts "Imported #{count} restaurants."
end


# inspections
INSPECTIONS_CSV = Rails.root.join("db", "data", "inspections.csv")
if File.exist?(INSPECTIONS_CSV)
  puts "Importing inspections..."
  count = 0
  CSV.foreach(INSPECTIONS_CSV, headers: true) do |row|
    restaurant = Restaurant.find_by(external_id: row["ext_id"])
    next unless restaurant
    Inspection.create!(
      restaurant: restaurant,
      inspected_on: Date.parse(row["inspected_on"]),
      outcome: row["outcome"],
      violations: row["violations"]
    )
    count += 1
  end
  puts "Imported #{count} inspections."
else
  puts "No inspections.csv found; generating a few fake inspections per restaurant."
  Restaurant.find_each do |r|
    rand(0..3).times do
      Inspection.create!(
        restaurant: r,
        inspected_on: Faker::Date.between(from: 2.years.ago, to: Date.today),
        outcome: ["Pass", "Conditional Pass", "Fail"].sample,
        violations: [nil, "Improper food storage; sanitizer not at correct concentration"].sample
      )
    end
  end
end

#categories and categorizations
CANDIDATE_CATEGORIES = %w[Pizza Chinese Filipino Vietnamese Cafe Bakery Diner Pub Sushi Indian Fast\ Food]
CANDIDATE_CATEGORIES.each { |n| Category.find_or_create_by!(name: n) }

Restaurant.find_each do |r|
  Category.order("RANDOM()").limit(rand(1..2)).each do |c|
    Categorization.find_or_create_by!(restaurant: r, category: c)
  end
end

#faker
puts "Generating reviews..."
Restaurant.find_each do |r|
  rand(1..5).times do
    Review.create!(
      restaurant: r,
      rating: rand(3..5),
      comment: Faker::Restaurant.review,
      author: Faker::Name.first_name
    )
  end
end

#temp troubleshooter
puts "Counts -> Wards: #{Ward.count}, Restaurants: #{Restaurant.count}, Inspections: #{Inspection.count}, Categories: #{Category.count}, Reviews: #{Review.count}"