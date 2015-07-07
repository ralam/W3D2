require 'byebug'
require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end

class Users

  def self.find_by_id(given_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, given_id)
      SELECT * FROM users WHERE id = ?
    SQL
    self.new(result.first)
  end

  attr_reader :id, :fname, :lname
  def initialize(options = {})
    @id = options[id]
    @fname = options['fname']
    @lname = options['lname']
  end
end

p Users.find_by_id(2)
