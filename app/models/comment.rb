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

  def vote_up(user_id)
    vote(user_id, 1)
  end

  def vote_down(user_id)
    vote(user_id, -1)
  end

  def mark_as_not_abusive
    votes.where({ value: -1 }).delete
    update_attributes({ abusive: false })
  end

  def sum_down_votes
    votes.where({ value: -1 }).count
  end

  private
  def vote(user_id, value)
    unless votes.where({ user_id: user_id }).any?
      votes.create({ value: value, user_id: user_id })
    end
  end
end
