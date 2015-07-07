class QuestionLike
  def self.find_by_id(given_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, given_id)
      SELECT * FROM questions_likes WHERE id = ?
    SQL
    self.new(result.first)
  end

  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT u.*
      FROM users u
      JOIN questions_likes ql ON u.id = ql.user_id
      WHERE ql.question_id = ?
    SQL
    results.map { |result| User.new(result) }
  end

  def self.num_likes_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT COUNT(u.id)
      FROM users u
      JOIN questions_likes ql ON u.id = ql.user_id
      WHERE ql.question_id = ?
    SQL
    result.first["COUNT(u.id)"]
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT q.*
      FROM questions q
      JOIN questions_likes ql ON q.id = ql.question_id
      WHERE ql.user_id = ?
    SQL
    results.map { |result| Question.new(result) }
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT q.*
      FROM questions q
      JOIN questions_likes l on q.id = l.question_id
      GROUP BY q.id
      ORDER BY COUNT(l.id) DESC
      LIMIT ?
    SQL

    results.map { |result| Question.new(result)}
  end

  attr_accessor :id, :user_id, :question_id
  def initialize(options = {})
    # byebug
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
