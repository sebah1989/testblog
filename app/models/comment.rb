class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String
  field :abusive, type: Boolean, default: false

  belongs_to :post
  belongs_to :user
  has_many :votes, dependent: :destroy

  def check_abusive
    if votes.where({ value: -1 }).count >= 3
      update_attributes({ abusive: true })
    end
  end
end
