class Proposal < ActiveRecord::Base
  has_many :authorships
  has_many :people, :through => :authorships
  has_many :documents
  belongs_to :prop_type
  belongs_to :prop_status
  belongs_to :timeslot
  belongs_to :conference

  validates_presence_of :title
  validates_presence_of :prop_type_id
  validates_presence_of :prop_status_id
  validates_presence_of :conference_id
  validates_associated :prop_type, :prop_status, :timeslot, :conference

  def scheduled?
    ! self.timeslot.empty?
  end
end
