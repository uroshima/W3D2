require_relative 'questions_database'
require 'sqlite3'
require 'singleton'
require 'byebug'
# require 'questions'

class Reply
  attr_accessor  :body, :user_id, :parent_id, :question_id
  attr_reader :id

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      id = ?
  SQL
  return nil unless id > 0

  Reply.new(reply.first)
  end

  def self.find_by_question_id(question_id)
    question = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL
    return nil unless question.length > 0

    Reply.new(question.first)
  end

  def self.find_by_user_id(user_id)
    user = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = ?
    SQL
    return nil unless user.length > 0

    Reply.new(user.first)
  end

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end

def initialize(options)
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
  end

  def create
   raise "#{self} already in database" if @id
   QuestionsDatabase.instance.execute(<<-SQL, @body, @question_id, @parent_id, @user_id)
     INSERT INTO
       replies (body, question_id, parent_id, user_id)
     VALUES
       (?, ?, ?, ?)
   SQL
   @id = QuestionsDatabase.instance.last_insert_row_id
 end
# Question.new('id' => 5, 'title' => 'hello', 'body' => 'world', 'user_id' => 2)
 def update
    raise "#{self} not in database" unless @id
    QuestionsDatabase.instance.execute(<<-SQL, @body, @question_id, @parent_id, @user_id, @id)
      UPDATE
        questions
      SET
        body = ?, question_id = ?, parent_id = ?, user_id = ?
      WHERE
        id = ?
    SQL
  end
end
