class User

  def self.find_by_id(given_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, given_id)
      SELECT * FROM users WHERE id = ?
    SQL
    self.new(result.first)
  end

  def self.find_by_name(fname, lname)
    results = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT * FROM users WHERE fname = ? AND lname = ?
    SQL
    results.map { |result| self.new(result)}
  end

  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions_for_user_id
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    result = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT SUM(l2.likes_for_one_question)/CAST(COUNT(q.id) AS FLOAT (5,2))
      FROM questions q
      LEFT JOIN (
        SELECT l.question_id, COUNT(l.id) AS likes_for_one_question
        FROM questions_likes l
        GROUP BY l.question_id) AS l2 ON l2.question_id = q.id
      WHERE q.author_id = ?
    SQL

    result.first.values.first
  end

  def save
    if @id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, fname: @fname, lname: @lname)
      INSERT INTO
        users(fname, lname)
      VALUES
        (:fname, :lname)
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, fname: @fname, lname: @lname, id: @id)
      UPDATE
        users
      SET
        fname = :fname, lname = :lname
      WHERE id = :id
      SQL
    end
  end

end
