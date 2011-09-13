xml.instruct!
xml.ages :scaletop => @results[:max], :scalebottom => 0, :ylabel => "Number of Users", :xlabel => "Age of Users" do
  @results[:ages].each do |age|
    xml.age :label => age[:label], :scale => (number_with_precision(age[:scale], :precision => 2) rescue 0), :color => age[:color]
  end
end
