class User < ActiveRecord::Base
  acts_as_authentic
  has_many :recipes, :foreign_key => 'owner_id'

  def has_role?(role, object = nil)
    admin?
  end
end
