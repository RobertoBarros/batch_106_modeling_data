class Room
  attr_accessor :capacity, :patients, :id
  def initialize(attributes = {})
    @id = attributes[:id]
    @capacity = attributes[:capacity] || 0
    @patients = attributes[:patients] || []
  end

  def full?
    @patients.size == @capacity
  end

  def add(patient)
    fail Exception, "Room is full" if full?

    @patients << patient
    patient.room = self


  end
end