class Person < ActiveRecord::Base
  acts_as_magic_model
  has_many :authorships
  has_many :proposals, :through => :authorships
  has_and_belongs_to_many :admin_tasks
  has_many :participations
  has_many :conferences, :through => :participations, :order => :id
  has_many :participation_types, :through => :participations

  validates_presence_of :firstname
  validates_presence_of :famname
  validates_presence_of :login
  validates_presence_of :passwd
  validates_uniqueness_of :login

  def self.ck_login(given_login, given_passwd)
    person = Person.find_by_login(given_login)
    return false if person.blank? or
      person.passwd != Digest::MD5.hexdigest(person.pw_salt + given_passwd)

    person.last_login_at = Time.now
    person.save

    person
  end

  def self.core_attributes
    %w(created_at email famname firstname id last_login_at login passwd 
       pw_salt)
  end
  def core_attributes; self.class.core_attributes; end

  # Returns a list of any user-listable attributes that are not part of the
  # base Person data
  def self.extra_listable_attributes 
    self.column_names - self.core_attributes
  end
  def extra_listable_attributes; self.class.extra_listable_attributes; end

  def passwd= plain
    # Don't accept empty passwords!
    return nil if plain.blank? or /^\s*$/.match(plain)
    self.pw_salt = String.random(8)
    self['passwd'] = Digest::MD5.hexdigest(pw_salt + plain)
  end

  def name
    "#{firstname} #{famname}"
  end

  private
  def pw_salt
    self[:pw_salt]
  end
end
