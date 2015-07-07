class QuestionFollow
  def self.find_by_id(given_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, given_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    self.new(result.first)
  end

  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        u.*
      FROM
        question_follows q
      JOIN
        users u ON u.id = q.user_id
      WHERE
        q.question_id = ?
    SQL
    results.map { |result| User.new(result)}
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        q.*
      FROM
        question_follows qf
      JOIN
        questions q ON q.id = qf.question_id
      WHERE
        qf.user_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        q.*
      FROM
        questions q
      JOIN
        question_follows f on q.id = f.question_id
      GROUP BY
        q.id
      ORDER BY
        COUNT(f.id) DESC
      LIMIT ?
    SQL

    results.map { |result| Question.new(result)}
  end

  attr_accessor :id, :user_id, :question_id
  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end


end
