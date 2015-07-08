require 'byebug'
require 'sqlite3'
require 'singleton'

require_relative 'user.rb'
require_relative 'question.rb'
require_relative 'question_like.rb'
require_relative 'question_follow.rb'
require_relative 'reply.rb'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end

doug = User.new({"fname" => "Doug", "lname" => "Smith"})
p doug
doug.save!
