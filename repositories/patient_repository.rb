require 'csv'
require_relative '../models/patient'

class PatientRepository
  def initialize(csv_file, room_repository)
    @csv_file = csv_file
    @room_repository = room_repository
    @patients = []
    load_csv
  end

  def all
    @patients
  end

  def add(patient)
    patient.id = @next_id
    @patients << patient
    write_csv
    @next_id += 1
  end

  def find(id)
    @patients.select { |patient| patient.id == id }.first
  end

  def write_csv
    CSV.open(@csv_file, 'w') do |csv|
      csv << [:id, :name, :cured, :room_id]
      @patients.each do |patient|
        csv << [patient.id, patient.name, patient.cured, patient.room.id]
      end
    end
  end

  def load_csv
    csv_options = { headers: :first_row, header_converters: :symbol }
    CSV.foreach(@csv_file, csv_options) do |row|
      row[:id] = row[:id].to_i
      row[:cured] = row[:cured] == 'true'

      room_id = row[:room_id].to_i
      room = @room_repository.find(room_id)

      patient = Patient.new(row)
      room.add(patient)

      @patients << patient
    end
    @next_id = @patients.empty? ? 1 : @patients.last.id + 1
  end









end