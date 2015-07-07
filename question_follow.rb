class QuestionFollow
  def self.find_by_id(given_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, given_id)
      SELECT * FROM question_follows WHERE id = ?
    SQL
    self.new(result.first)
  end

  attr_accessor :id, :user_id, :question_id
  def initialize(options = {})
    # byebug
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
