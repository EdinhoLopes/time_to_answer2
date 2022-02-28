class Subject < ApplicationRecord
  has_many :questions
	#kaminari
	paginates_per 15
end
