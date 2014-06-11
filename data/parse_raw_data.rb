# ruby script used to parse and consolidate the raw txt files into a usable csv

require 'csv'
require 'pry'

class ParseCSV
  attr_accessor :data_array

  def initialize
    @data_array = [] # container array for each row
  end

  def find_a_file(year)
    (1..12).each do |m|
      filename = './weather/noaahourly_' + m.to_s + year + '.txt'
      fetch_data(filename)
    end
  end

  def fetch_data(filename)
    f = File.open(filename)
    # drop in to file past misc header matter
    f.drop(8).each do |row|
      unless row == "\n"
        add_row = make_row_array(row)
        check_for_duplicates(add_row)
        data_array << add_row
      end
    end
    f.close
    write_to_csv('2013.csv', data_array)
  end

  def make_row_array(row)
    row_array = row.split(',')
    new_row = []
    unless row_array.length <= 1
      # get date
      # make a date
      new_date = row_array[1][4..5] + "/" + row_array[1][6..7] + "/" + row_array[1][0..3]
      new_row << new_date
      # get time
      new_row << row_array[2][0..1]
      # get sky condition
      new_row << convert_sky_condition(row_array[4])
    end
  end

  def convert_sky_condition(conditions)
    conversion = {
      'CLR' => 0, # clear below 12,000 ft
      'SCT' => 1, # 0/8 - 2/8 sky cover
      'FEW' => 2, # 3/8 - 4/8 sky cover
      'BKN' => 3, # 5/8 - 7/8 sky cover
      'OVC' => 4, # 8/8 sky cover
      'VV0' => 4 # VV indicates indefinite ceiling - let's just call this 8/8 as well
    }
    c = conditions.split
    conversion[c.pop[0..2]]
  end

  def check_for_duplicates(row)
    # skip for the first time added
    unless data_array.length == 0
      last_hour_added = data_array[-1][1]
      new_hour_to_add = row[1]
      if new_hour_to_add == last_hour_added
        data_array.pop
      end
    end
  end

  def write_to_csv(filename, data_array)
    CSV.open(filename, "w") do |csv|
      csv << ["csv_date", "hour", "sky_condition"]
      data_array.each do |row|
        csv << row
      end
    end  
  end
end

get_data = ParseCSV.new
get_data.find_a_file('2013')

# iterate through data files one by one

# at each file, grab each row and make an array of the necessary data
# get date field as is for now
# create an hour field
# get temp for future
# sky coverage - this will have to be function that returns correct number
# will also need something to check for duplicate hours
# take each row array and put that into a container array
# when done, write the container array to a csv