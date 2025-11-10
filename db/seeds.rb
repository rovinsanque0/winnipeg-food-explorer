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

puts "Fetching Winnipeg Wards from Open Data..."

WARD_URL = "https://data.winnipeg.ca/resource/t4cg-yaxs.json"

begin
  raw = URI.open(WARD_URL).read
  data = JSON.parse(raw)

  data.each do |w|
    Ward.find_or_create_by!(
      external_id: w["jno"],
      name: w["name"]
    )
  end

  puts "Seeded #{Ward.count} wards from API"
rescue => e
  puts "Failed to load Winnipeg wards: #{e.message}"
  puts "Using fallback ward instead..."
  Ward.find_or_create_by!(name: "Unknown")
end


def find_or_create_ward(name)
  Ward.find_or_create_by(name: name)
end

#restaurant

ESTABLISHMENTS_CSV = Rails.root.join("db", "data", "establishments.csv")

if File.exist?(ESTABLISHMENTS_CSV)
  puts "Importing establishments from CSV with Faker restaurant names..."
  count = 0

  CSV.foreach(ESTABLISHMENTS_CSV, headers: true) do |row|
    ward = Ward.find_by(name: row["ward"]) || Ward.find_by(name: "Unknown")

  Restaurant.create!(
    name:        row["name"],
    address:     row["address"],
    ward:        ward,
    latitude:    row["lat"],
    longitude:   row["lon"],
    external_id: row["ext_id"],
    phone:       row["phone"] || Faker::PhoneNumber.cell_phone,
    postal_code: row["postal"] || "R3X 1X1"
  )

    count += 1
  end

  puts "Imported #{count} restaurants."
else
  puts "establishments.csv missing!"

end


#inspections
Restaurant.find_each do |r|
  rand(1..3).times do
    Inspection.create!(
      restaurant: r,
      inspected_on: Faker::Date.between(from: 2.years.ago, to: Date.today),
      outcome: ["Pass", "Conditional Pass", "Fail"].sample,
      violations: [nil, "Improper food storage; sanitizer not at correct concentration"].sample
    )
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