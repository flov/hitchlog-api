json.id ride.id
json.title ride.title
json.story ride.story
json.waiting_time ride.waiting_time
json.duration ride.duration
json.number ride.number
json.experience ride.experience
json.vehicle ride.vehicle
json.youtube ride.youtube
json.gender ride.gender
json.tags ride.tag_list
unless ride.photo_url.nil?
  json.photo_caption ride.photo_caption
  json.photo do
    json.url ride.photo.url
    json.small do
      json.url ride.photo.small.url
      # json.width ride.photo.small.width
      # json.height ride.photo.small.height
    end
    json.thumb do
      json.url ride.photo.thumb.url
      # json.width ride.photo.thumb.width
      # json.height ride.photo.thumb.height
    end
  end
end
