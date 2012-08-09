class User < ActiveRecord::Base
  include LogicallyDeletable

  # Include default devise modules. Others available are:
  # :token_authenticatable, :registerable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :password, :password_confirmation, :remember_me, :time_zone, :tz, :admin

  has_many :deployments, :dependent => :nullify, :order => 'created_at DESC'
  has_many :activities, :as => :target, :dependent => :destroy

  validates_presence_of   :login
  validates_length_of     :login, :within => 3..40
  validates_uniqueness_of :login, :case_sensitive => false

  scope :enabled,  where(:disabled_at => nil)
  scope :disabled, where("disabled_at IS NOT NULL")
  scope :admins,   where(:admin => true, :disabled_at => nil)

  validate :guard_last_admin, :on => :update

  def name
    login
  end

  def revoke_admin!
    self.admin = false
    self.save!
  end

  def make_admin!
    self.admin = true
    self.save!
  end

  def disabled?
    self.disabled_at.present?
  end

  def disable!
    self.update_column(:disabled_at, Time.now)
    self.forget_me!
  end

  def enable!
    self.update_column(:disabled_at, nil)
  end

protected

  def guard_last_admin
    if User.find(self.id).admin? && !self.admin?
      errors.add('admin', 'status can no be revoked as there needs to be one admin left.') if User.admins.count == 1
    end
  end

end
