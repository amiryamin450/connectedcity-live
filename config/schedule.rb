every 1.day, :at => '2:00 am' do
  rake "-s sitemap:refresh"
  command "gunzip ./public/sitemap.xml.gz"
end