# questions class ayy
require_relative 'questions_database'
require 'sqlite3'
require 'singleton'
require 'byebug'

class Question
  attr_accessor :title, :body, :user_id
  attr_reader :id

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      questions
    WHERE
      id = ?
  SQL
  return nil unless question.length > 0

  Question.new(question.first)
  end

  def self.find_by_author_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      questions
    WHERE
      user_id = ?
    SQL
    return nil unless questions.length > 0
    #
    questions.map {|datum| Question.new(datum)}
  end

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum) }
  end

def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def create
   raise "#{self} already in database" if @id
   QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @user_id)
     INSERT INTO
       questions (title, body, user_id)
     VALUES
       (?, ?, ?)
   SQL
   @id = QuestionsDatabase.instance.last_insert_row_id
 end
# Question.new('id' => 5, 'title' => 'hello', 'body' => 'world', 'user_id' => 2)
 def update
    raise "#{self} not in database" unless @id
    QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @user_id, @id)
      UPDATE
        questions
      SET
        title = ?, body = ?, user_id = ?
      WHERE
        id = ?
    SQL
  end
end
