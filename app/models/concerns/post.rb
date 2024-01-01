class Post < ApplicationRecord
    validates :title, presence: true, uniqueness: true
    validates :content, presence: true
    validates :owner, presence: true
    validates :category, presence: true
end