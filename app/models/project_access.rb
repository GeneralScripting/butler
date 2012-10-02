class ProjectAccess < ActiveRecord::Base
  include LogicallyDeletable

  attr_accessible :mode, :project_id, :user_id, :poject, :user

  # relations
  belongs_to :user
  belongs_to :project
  has_many :activities, :as => :target, :dependent => :destroy

  # validations
  validates :user_id, :project_id, :presence => true


  def name
    "User #{user.name} in project #{project.name}"
  end

end
