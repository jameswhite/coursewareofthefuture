Fabricator(:quiz_submission) do
  submitted_at { 2.days.ago }
end

Fabricator(:submitted_quiz_submission, from: :quiz_submission) do
  after_create {|quiz| quiz.question_answers.each{|a| a.answer = "true" }; quiz.submit!; quiz.save! }
end

Fabricator(:unfinished_quiz_submission, from: :quiz_submission) do
  submitted_at nil
end
