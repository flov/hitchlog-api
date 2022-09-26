require "factory_bot"
require "faker"

FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2022-09-17 18:11:35" }
  end

  factory :ride do
    title { "MyString" }
    story { "MyText" }
    waiting_time { 1 }
    duration { 1.5 }
    number { 1 }
    experience { "MyString" }
    vehicle { "MyString" }
    youtube { "MyString" }
    gender { "MyString" }
    trip
  end

  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.username }
    password { "password" }
    cs_user { Faker::Internet.username }
    date_of_birth { 23.years.ago }
    gender { Faker::Gender.binary_type }
    about_you { Faker::Fantasy::Tolkien.poem }
  end

  factory :comment do
    body { "Great Example Comment" }
    user
    trip
  end

  factory :munich_user, parent: :user do
    current_sign_in_ip { "195.71.11.67" }
  end

  factory :berlin_user, parent: :user do
    current_sign_in_ip { "88.73.54.0" }
  end

  factory :country_distance do
    distance { 600000 }
    country { "Germany" }
  end

  factory :location do
    city { "Berlin" }
    country { "Germany" }
    country_code { "DE" }
    place_id { "ChIJAVkDPzdOqEcRcDteW2Kq6zA" }
    lat { 52.520008 }
    lng { 13.404954 }
  end

  factory :trip do
    user
    from { "Tehran" }
    to { "Shiraz" }
    from_city { "Berlin" }
    from_country { "Germany" }
    from_country_code { "DE" }
    from_place_id { "ChIJAVkDPzdOqEcRcDteW2Kq6zA" }
    from_lat { 52.520008 }
    from_lng { 13.404954 }
    to_city { "Berlin" }
    to_country { "Germany" }
    to_country_code { "DE" }
    to_place_id { "ChIJAVkDPzdOqEcRcDteW2Kq6zA" }
    to_lat { 52.520008 }
    to_lng { 13.404954 }
    departure { "07/12/2011 10:00" }
    arrival { "07/12/2011 20:00" }
    travelling_with { 0 }
    google_duration { 9.hours.to_i }
    distance { 1_646_989 }
    number_of_rides { 1 }
  end

  factory :future_trip do
    from { "Barcelona" }
    to { "Madrid" }
    departure { 10.days.from_now }
  end
end
