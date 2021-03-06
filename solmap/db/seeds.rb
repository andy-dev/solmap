# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'
require 'httparty'

states_hash =  {AL: "Alabama",
                AR: "Arkansas",
                AS: "American Samoa",
                AZ: "Arizona",
                CA: "California",
                CO: "Colorado",
                CT: "Connecticut",
                DC: "District of Columbia",
                DE: "Delaware",
                FL: "Florida",
                GA: "Georgia",
                GU: "Guam",
                HI: "Hawaii",
                IA: "Iowa",
                ID: "Idaho",
                IL: "Illinois",
                IN: "Indiana",
                KS: "Kansas",
                KY: "Kentucky",
                LA: "Louisiana",
                MA: "Massachusetts",
                MD: "Maryland",
                ME: "Maine",
                MI: "Michigan",
                MN: "Minnesota",
                MO: "Missouri",
                MS: "Mississippi",
                MT: "Montana",
                NC: "North Carolina",
                ND: "North Dakota",
                NE: "Nebraska",
                NH: "New Hampshire",
                NJ: "New Jersey",
                NM: "New Mexico",
                NV: "Nevada",
                NY: "New York",
                OH: "Ohio",
                OK: "Oklahoma",
                OR: "Oregon",
                PA: "Pennsylvania",
                PR: "Puerto Rico",
                RI: "Rhode Island",
                SC: "South Carolina",
                SD: "South Dakota",
                TN: "Tennessee",
                TX: "Texas",
                UT: "Utah",
                VA: "Virginia",
                VI: "Virgin Islands",
                VT: "Vermont",
                WA: "Washington",
                WI: "Wisconsin",
                WV: "West Virginia",
                WY: "Wyoming"}

states_hash.each do |abbreviation, name|
	State.create(abbrev: abbreviation, name: name)
end

zipcodes = CSV.open("#{Rails.root}/db/zip_code_database.csv", :headers => true, :header_converters => :symbol)
hashed_zipcodes = zipcodes.to_a.map { |row| row.to_hash }

hashed_zipcodes.each do |zipcode|
	state = State.find_by_abbrev(zipcode[:state])
  county = County.create(name: zipcode[:county], state_id: state.id) if state
	Zipcode.create(code: zipcode[:zip], city_name: zipcode[:primary_city], county_id: county.id) if county
end

# Seeding the solar radiance and average cost of CA counties

ca_state_id = 5
ca_counties = County.where(state_id: ca_state_id)

ca_counties.each do |county|
  county.irradiance_data
  county.genability_data
end

