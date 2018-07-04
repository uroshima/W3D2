#question folloqws

require_relative 'student_questions'
require 'sqlite3'
require 'singleton'
require 'byebug'


class QuestionFollows
  attr_reader :id, :question_id, :user_id

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_follows
    WHERE
      id = ?
  SQL
  return nil unless id > 0

  QuestionFollows.new(reply.first)
  end

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| QuestionFollows.new(datum) }
  end

def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def create
   raise "#{self} already in database" if @id
   QuestionsDatabase.instance.execute(<<-SQL, @question_id, @user_id)
     INSERT INTO
       question_follows (question_id, user_id)
     VALUES
       (?, ?)
   SQL
   @id = QuestionsDatabase.instance.last_insert_row_id
 end

 def update
    raise "#{self} not in database" unless @id
    QuestionsDatabase.instance.execute(<<-SQL, @question_id, @user_id, @id)
      UPDATE
        question_follows
      SET
         question_id = ?, user_id = ?
      WHERE
        id = ?
    SQL
  end
end
