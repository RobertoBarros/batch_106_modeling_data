require 'csv'
require_relative '../models/room'

class RoomRepository
  def initialize(csv_file)
    @csv_file = csv_file
    @rooms = []
    load_csv
  end

  def all
    @rooms
  end

  def add(room)
    room.id = @next_id
    @rooms << room
    write_csv
    @next_id += 1
  end

  def find(id)
    @rooms.select { |room| room.id == id }.first
  end

  def write_csv
    CSV.open(@csv_file, 'w') do |csv|
      csv << [:id, :capacity]
      @rooms.each do |room|
        csv << [room.id, room.capacity]
      end
    end
  end

  def load_csv
    csv_options = { headers: :first_row, header_converters: :symbol }
    CSV.foreach(@csv_file, csv_options) do |row|
      row[:id] = row[:id].to_i
      row[:capacity] = row[:capacity].to_i
      @rooms << Room.new(row)
    end
    @next_id = @rooms.empty? ? 1 : @rooms.last.id + 1
  end
end