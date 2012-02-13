module Helpers
  def truncate_table(table)
    ActiveRecord::Base.connection.execute("TRUNCATE #{table};") 
  end
end

class String
  def comment_line
    start_with?('//') #comment line, so ignore
  end

  def section_line
    starts_with?('##') #Section
  end

  def tag_section_line
    starts_with?('##TAGS##')
  end

  def item_section_line
    starts_with?('##ITEMS##')
  end

  def to_seed_array
    # 1 Remove whitespace/newline
    # 2 Remove leading and trailing ::
    # 3 Convert delimited line to array
    # 4 Strip whitespace from each column. Replace ' with '' for sql sanitization
    strip.slice(2...-2).split('::').map{|x|x.strip.gsub("'", "''")}
  end
end
