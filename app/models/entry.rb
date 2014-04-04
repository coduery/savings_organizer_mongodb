class Entry

  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :entry_date,   type: Date
  field :entry_amount, type: Float
  field :category_id,  type: Integer

  belongs_to :category

  validates :entry_amount, numericality: true

end
