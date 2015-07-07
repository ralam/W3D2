class Reply

  def self.table_name
    "replies"
  end

  def self.find_by_id(given_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, given_id)
      SELECT * FROM #{table_name} WHERE id = ?
    SQL
    self.new(result.first)
  end

  def self.find_by_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT * FROM #{table_name} WHERE user_id = ?
    SQL
    results.map { |result| self.new(result)}
  end

  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT * FROM #{table_name} WHERE question_id = ?
    SQL
    results.map { |result| self.new(result) }
  end

  attr_accessor :id, :user_id, :question_id, :body, :parent_id
  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @body = options['body']
    @parent_id = options['parent_id']
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    raise "No Parents" if @parent_id.nil?
    Reply.find_by_id(@parent_id)
  end

  def save
    if @id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, user_id: @user_id, question_id: @question_id, body: @body, parent_id: @parent_id)
      INSERT INTO
        replies(user_id, question_id, body, parent_id)
      VALUES
        (:user_id, :question_id, :body, :parent_id)
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, user_id: @user_id, question_id: @question_id, body: @body, parent_id: @parent_id, id: @id)
      UPDATE
        replies
      SET
        user_id = :user_id, question_id = :question_id, body = :body, parent_id = :parent_id
      WHERE id = :id
      SQL
    end
  end
end
