-- PostgreSQL compatible SQL Dump
-- Original file: quiz_app_db.sql (MySQL)

-- Define ENUM type for quiz answers
CREATE TYPE quiz_answer_enum AS ENUM ('A', 'B', 'C', 'D');

-- --------------------------------------------------------

--
-- Table structure for table `classes`
--

CREATE TABLE classes (
  class_id SERIAL PRIMARY KEY,
  class_name varchar(100) NOT NULL UNIQUE
);

--
-- Dumping data for table `classes`
--

INSERT INTO classes (class_id, class_name) VALUES
(8, 'Lớp 10'),
(9, 'Lớp 11'),
(10, 'Lớp 12'),
(1, 'Lớp 3'),
(2, 'Lớp 4'),
(3, 'Lớp 5'),
(4, 'Lớp 6'),
(5, 'Lớp 7'),
(6, 'Lớp 8'),
(7, 'Lớp 9');

-- --------------------------------------------------------

--
-- Table structure for table `class_subjects`
--

CREATE TABLE class_subjects (
  class_subject_id SERIAL PRIMARY KEY,
  class_id int NOT NULL,
  subject_id int NOT NULL
);

--
-- Dumping data for table `class_subjects`
--

INSERT INTO class_subjects (class_subject_id, class_id, subject_id) VALUES
(45, 4, 1),
(48, 4, 2),
(49, 4, 4),
(51, 4, 3),
(54, 5, 1),
(55, 5, 3),
(56, 5, 2),
(57, 5, 4),
(58, 6, 1),
(59, 6, 3),
(60, 6, 2),
(61, 6, 4),
(62, 7, 1),
(63, 7, 3),
(64, 7, 2),
(65, 7, 4),
(66, 8, 1),
(67, 8, 3),
(68, 8, 2),
(69, 8, 4),
(70, 9, 1),
(71, 9, 3),
(72, 9, 2),
(73, 9, 4),
(74, 10, 1),
(75, 10, 3),
(76, 10, 2),
(77, 10, 4),
(78, 1, 1),
(79, 1, 4),
(80, 1, 1),
(81, 1, 4),
(82, 2, 1),
(83, 2, 4),
(84, 2, 1),
(85, 2, 4),
(86, 3, 1),
(87, 3, 4);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE notifications (
  notification_id SERIAL PRIMARY KEY,
  student_id int NOT NULL,
  message text NOT NULL,
  type varchar(50) DEFAULT 'general',
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE questions (
  question_id SERIAL PRIMARY KEY,
  subject_id int NOT NULL,
  question_text text NOT NULL,
  option_a text NOT NULL,
  option_b text NOT NULL,
  option_c text NOT NULL,
  option_d text NOT NULL,
  correct_answer quiz_answer_enum NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW() -- ON UPDATE CURRENT_TIMESTAMP requires a trigger in PostgreSQL
);

-- --------------------------------------------------------

--
-- Table structure for table `quiz_attempts`
--

CREATE TABLE quiz_attempts (
  attempt_id SERIAL PRIMARY KEY,
  student_id int NOT NULL,
  unit_id int NOT NULL,
  quiz_date TIMESTAMP DEFAULT NOW(),
  correct_answers int NOT NULL,
  wrong_answers int NOT NULL,
  total_questions_quizzed int NOT NULL
);

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE students (
  student_id SERIAL PRIMARY KEY,
  student_name varchar(255) NOT NULL,
  username varchar(50) NOT NULL UNIQUE,
  password_hash varchar(255) NOT NULL,
  class_id int DEFAULT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

--
-- Dumping data for table `students`
--

INSERT INTO students (student_id, student_name, username, password_hash, class_id, created_at) VALUES
(8, 'admin', 'admin', '$2y$10$YF.c1ad0iGPQR0azP4OBWOJCdTRGTTHD0AWp33H62B9Nnf7QHQjuK', NULL, '2025-06-28 21:38:10');

-- --------------------------------------------------------

--
-- Table structure for table `student_answers`
--

CREATE TABLE student_answers (
  student_answer_id SERIAL PRIMARY KEY,
  student_id int NOT NULL,
  question_id int NOT NULL,
  chosen_option quiz_answer_enum NOT NULL,
  is_correct_attempt BOOLEAN NOT NULL,
  attempt_time TIMESTAMP DEFAULT NOW()
);

-- --------------------------------------------------------

--
-- Table structure for table `student_vocabulary_answers`
--

CREATE TABLE student_vocabulary_answers (
  answer_id SERIAL PRIMARY KEY,
  student_id int NOT NULL,
  vocabulary_id int NOT NULL,
  chosen_meaning varchar(255) NOT NULL,
  is_correct BOOLEAN NOT NULL,
  answer_time TIMESTAMP NOT NULL DEFAULT NOW()
);

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE subjects (
  subject_id SERIAL PRIMARY KEY,
  subject_name varchar(100) NOT NULL UNIQUE
);

--
-- Dumping data for table `subjects`
--

INSERT INTO subjects (subject_id, subject_name) VALUES
(3, 'Hóa học'),
(4, 'Tiếng Anh'),
(1, 'Toán học'),
(2, 'Vật lý');

-- --------------------------------------------------------

--
-- Table structure for table `units`
--

CREATE TABLE units (
  unit_id SERIAL PRIMARY KEY,
  subject_id int NOT NULL,
  class_id int NOT NULL DEFAULT 1,
  unit_name varchar(255) NOT NULL
);

--
-- Dumping data for table `units`
--

INSERT INTO units (unit_id, subject_id, class_id, unit_name) VALUES
(22, 4, 4, 'Unit 1');

-- --------------------------------------------------------

--
-- Table structure for table `user_vocabularies`
--

CREATE TABLE user_vocabularies (
  user_vocabulary_id SERIAL PRIMARY KEY,
  student_id int NOT NULL,
  class_id int DEFAULT NULL,
  subject_id int DEFAULT NULL,
  unit_id int DEFAULT NULL,
  english_word varchar(255) NOT NULL,
  vietnamese_meaning varchar(255) NOT NULL,
  wrong_marks text DEFAULT '[]',
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_student_english_vietnamese UNIQUE (student_id, english_word, vietnamese_meaning)
);

--
-- Dumping data for table `user_vocabularies`
--

INSERT INTO user_vocabularies (user_vocabulary_id, student_id, class_id, subject_id, unit_id, english_word, vietnamese_meaning, wrong_marks, created_at) VALUES
(2, 8, 4, 4, 22, 'stupid', 'ngu', '[]', '2025-06-29 00:49:02');

-- --------------------------------------------------------

--
-- Table structure for table `vocabulary`
--

CREATE TABLE vocabulary (
  vocabulary_id SERIAL PRIMARY KEY,
  unit_id int NOT NULL,
  english_word varchar(255) NOT NULL,
  vietnamese_meaning varchar(255) NOT NULL
);

-- --------------------------------------------------------

--
-- Table structure for table `wrong_answers`
--

CREATE TABLE wrong_answers (
  wrong_answer_id SERIAL PRIMARY KEY,
  attempt_id int NOT NULL,
  vocabulary_id int DEFAULT NULL,
  user_vocabulary_id int DEFAULT NULL,
  student_answer varchar(255) NOT NULL
);

--
-- Constraints for dumped tables
--

ALTER TABLE class_subjects
  ADD CONSTRAINT class_subjects_class_id_fkey FOREIGN KEY (class_id) REFERENCES classes (class_id) ON DELETE CASCADE,
  ADD CONSTRAINT class_subjects_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES subjects (subject_id) ON DELETE CASCADE;

ALTER TABLE notifications
  ADD CONSTRAINT notifications_student_id_fkey FOREIGN KEY (student_id) REFERENCES students (student_id) ON DELETE CASCADE;

ALTER TABLE questions
  ADD CONSTRAINT questions_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES subjects (subject_id) ON UPDATE CASCADE;

ALTER TABLE quiz_attempts
  ADD CONSTRAINT quiz_attempts_student_id_fkey FOREIGN KEY (student_id) REFERENCES students (student_id),
  ADD CONSTRAINT quiz_attempts_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES units (unit_id);

ALTER TABLE students
  ADD CONSTRAINT fk_student_class FOREIGN KEY (class_id) REFERENCES classes (class_id);

ALTER TABLE student_answers
  ADD CONSTRAINT student_answers_student_id_fkey FOREIGN KEY (student_id) REFERENCES students (student_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT student_answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES questions (question_id) ON UPDATE CASCADE;

ALTER TABLE student_vocabulary_answers
  ADD CONSTRAINT student_vocabulary_answers_student_id_fkey FOREIGN KEY (student_id) REFERENCES students (student_id),
  ADD CONSTRAINT student_vocabulary_answers_vocabulary_id_fkey FOREIGN KEY (vocabulary_id) REFERENCES vocabulary (vocabulary_id);

ALTER TABLE units
  ADD CONSTRAINT fk_unit_class FOREIGN KEY (class_id) REFERENCES classes (class_id) ON DELETE CASCADE,
  ADD CONSTRAINT units_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES subjects (subject_id);

ALTER TABLE user_vocabularies
  ADD CONSTRAINT fk_user_vocab_class FOREIGN KEY (class_id) REFERENCES classes (class_id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_user_vocab_subject FOREIGN KEY (subject_id) REFERENCES subjects (subject_id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_user_vocab_unit FOREIGN KEY (unit_id) REFERENCES units (unit_id) ON DELETE SET NULL,
  ADD CONSTRAINT user_vocabularies_student_id_fkey FOREIGN KEY (`student_id`) REFERENCES students (`student_id`) ON DELETE CASCADE;

ALTER TABLE vocabulary
  ADD CONSTRAINT vocabulary_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES units (unit_id);

ALTER TABLE wrong_answers
  ADD CONSTRAINT wrong_answers_attempt_id_fkey FOREIGN KEY (attempt_id) REFERENCES quiz_attempts (attempt_id),
  ADD CONSTRAINT wrong_answers_vocabulary_id_fkey FOREIGN KEY (vocabulary_id) REFERENCES vocabulary (vocabulary_id);

-- Reset auto-increment sequences after inserting data
-- This is important to ensure new inserts use the correct starting ID
SELECT setval('classes_class_id_seq', COALESCE(MAX(class_id), 1), false) FROM classes;
SELECT setval('class_subjects_class_subject_id_seq', COALESCE(MAX(class_subject_id), 1), false) FROM class_subjects;
SELECT setval('notifications_notification_id_seq', COALESCE(MAX(notification_id), 1), false) FROM notifications;
SELECT setval('questions_question_id_seq', COALESCE(MAX(question_id), 1), false) FROM questions;
SELECT setval('quiz_attempts_attempt_id_seq', COALESCE(MAX(attempt_id), 1), false) FROM quiz_attempts;
SELECT setval('students_student_id_seq', COALESCE(MAX(student_id), 1), false) FROM students;
SELECT setval('student_answers_student_answer_id_seq', COALESCE(MAX(student_answer_id), 1), false) FROM student_answers;
SELECT setval('student_vocabulary_answers_answer_id_seq', COALESCE(MAX(answer_id), 1), false) FROM student_vocabulary_answers;
SELECT setval('subjects_subject_id_seq', COALESCE(MAX(subject_id), 1), false) FROM subjects;
SELECT setval('units_unit_id_seq', COALESCE(MAX(unit_id), 1), false) FROM units;
SELECT setval('user_vocabularies_user_vocabulary_id_seq', COALESCE(MAX(user_vocabulary_id), 1), false) FROM user_vocabularies;
SELECT setval('vocabulary_vocabulary_id_seq', COALESCE(MAX(vocabulary_id), 1), false) FROM vocabulary;
SELECT setval('wrong_answers_wrong_answer_id_seq', COALESCE(MAX(wrong_answer_id), 1), false) FROM wrong_answers;