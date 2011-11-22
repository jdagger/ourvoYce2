class UsZipValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless Zip.where(:zip => value.to_s).count == 1
      record.errors[attribute] << (options[:message] || "is not a United States zip")
    end
  end
end
