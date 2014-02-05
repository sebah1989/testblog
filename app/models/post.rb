class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable

  field :body, type: String
  field :title, type: String
  field :archived, type: Boolean, default: false

  validates_presence_of :body, :title
  
  has_many :comments, dependent: :destroy
  belongs_to :user

  default_scope ->{ ne(archived: true) }

  def archive!
    update_attribute :archived, true
  end

  def hotness
    if check_is_date_in_range?(24.hour.ago, Time.now)
      has_at_least_3_comments? ? 4 : 3
    elsif check_is_date_in_range?(72.hour.ago, 24.hour.ago)
      has_at_least_3_comments? ? 3 : 2
    elsif check_is_date_in_range?(7.day.ago, 3.day.ago)
      has_at_least_3_comments? ? 2 : 1
    else
      has_at_least_3_comments? ? 1 : 0
    end  
  end

  private
  def check_is_date_in_range?(start_date, end_date)
    (start_date..end_date).cover?(created_at)
  end

  def has_at_least_3_comments?
    comments.count >= 3
  end
end
