xml.instruct!
xml.dots do
  @zips.each do |dot|
    xml.dot "name" => dot[:name], "scale" => (number_with_precision(dot[:scale], :precision => 2) rescue 0), "lat" => dot[:lat], "lon" => dot[:long], "color" => dot[:color]
  end
end
