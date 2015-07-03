# require 'csv'
#
# Video.delete_all
# file_to_load = File.dirname(__FILE__) + "/kpoplist.csv"
#
# csv_text = File.read(file_to_load)
# csv = CSV.parse(csv_text, :headers => true)
# csv.each do |row|
#     Video.create!(row.to_hash)
# end

