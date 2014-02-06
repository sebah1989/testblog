class Vote
  include Mongoid::Document
  include Mongoid::Timestamps

  after_create :check_comment

  field :value, type: Integer

  belongs_to :user
  belongs_to :comment

  protected
  def check_comment
    comment.check_abusive
  end
end
