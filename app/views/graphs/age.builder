xml.instruct!
xml.ages :scaletop => @scale_top, :scalebottom => 0, :ylabel => "Number of Users", :xlabel => "Age of Users" do
  @ages.each do |age|
    xml.age :label => age[:label], :scale => (number_with_precision(age[:scale], :precision => 2) rescue 0), :color => age[:color]
  end
end
