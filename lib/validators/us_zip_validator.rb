class UsZipValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, zip)
    unless Zip.where(:zip => zip.to_s.strip).count == 1
      record.errors[attribute] << (options[:message] || "is not a United States zip")
    end
  end
end
