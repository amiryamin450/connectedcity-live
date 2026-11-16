# Public address of the files in the image storage bucket (S3_BUCKET_NAME).
# S3_ENDPOINT is set when the bucket is on S3-compatible storage outside AWS (FullHost), which
# only serves path-style addresses: <endpoint>/<bucket>/<file>. Without it, the bucket is on AWS.
module FileStorage
  def self.base_url
    if ENV['S3_ENDPOINT'].present?
      "#{ENV['S3_ENDPOINT']}/#{ENV['S3_BUCKET_NAME']}"
    else
      "https://#{ENV['S3_BUCKET_NAME']}.s3.#{ENV['AWS_REGION']}.amazonaws.com"
    end
  end

  def self.url(path)
    "#{base_url}/#{path}"
  end
end
