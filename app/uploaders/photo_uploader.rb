class PhotoUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  if Rails.env === "test"
    storage :file
  else
    storage :fog
  end

  process resize_to_fit: [800, 800]

  version :small do
    process resize_to_fit: [415, 800]
  end

  version :thumb do
    process resize_to_limit: [80, 80]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  def filename
    "hitchhiking-from-#{model.trip.from.parameterize}-to-#{model.trip.to.parameterize}#{File.extname(super)}" if original_filename
  end
end
