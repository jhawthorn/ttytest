# !/usr/bin/env ruby
# frozen_string_literal: true

# this is from my personal project, ncsh.
# it is an example of integration/acceptance tests using ttytest2.
# ncsh is a noncanonical shell which I use ttytest2 to integration test.

require 'ttytest'

START_COL = 20
WC_C_LENGTH = '225'
SLEEP_TIME = 0.2
LS_LINES = 3
LS_ITEMS = 19
LS_FIRST_ITEM = 'CMakeLists.txt'
TAB_AUTOCOMPLETE_ROWS = 10

def assert_check_new_row(row)
  @tty.assert_row_starts_with(row, "#{ENV['USER']} ")
  @tty.assert_row_like(row, 'ncsh')
  @tty.assert_row_ends_with(row, ' ❱ ')
  @tty.assert_cursor_position(START_COL, row)
end

def starting_tests(test)
  puts "===== Starting #{test} tests ====="
end

def z_database_new_test(row)
  @tty.assert_row(row, 'Error opening z database file: No such file or directory')
  row += 1
  @tty.assert_row(row, 'Trying to create z database file.')
  row += 1
  @tty.assert_row(row, 'Created z database file.')
  row += 1
  puts 'New z database test passed'
  row
end

def startup_test(row)
  @tty.assert_row_starts_with(row, 'ncsh: startup time: ')
  row += 1
  puts 'Startup time test passed'
  row
end

def newline_sanity_test(row)
  assert_check_new_row(row)
  @tty.send_newline
  row += 1
  assert_check_new_row(row)
  @tty.send_newline
  row += 1
  puts 'Newline sanity test passed'
  row
end

def empty_line_arrow_check(row)
  @tty.send_left_arrow
  assert_check_new_row(row)
  @tty.send_right_arrow
  assert_check_new_row(row)
end

def empty_line_sanity_test(row)
  assert_check_new_row(row)
  empty_line_arrow_check(row)
  @tty.send_backspace
  assert_check_new_row(row)
  @tty.send_delete
  assert_check_new_row(row)
  puts 'Empty line sanity test passed'
  row
end

def startup_tests(row, run_z_database_new_tests)
  starting_tests 'startup tests'

  row = z_database_new_test row if run_z_database_new_tests
  row = startup_test row
  row = newline_sanity_test row

  empty_line_sanity_test row
end

def basic_ls_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls))
  @tty.assert_cursor_position(START_COL + 2, row)
  @tty.send_newline
  @tty.assert_row_ends_with(row, 'ls')
  row += 1
  @tty.assert_row_starts_with(row, LS_FIRST_ITEM)
  row += LS_LINES
  puts 'Basic input (ls) test passed'
  row
end

def basic_bad_command_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(lss)) # send a bad command
  @tty.assert_cursor_position(START_COL + 3, row)
  @tty.send_newline
  @tty.assert_row_ends_with(row, 'lss')
  row += 1
  @tty.assert_row(row, 'ncsh: Could not find command or directory: No such file or directory')
  row += 1
  puts 'Bad command test passed'
  row
end

def basic_tests(row)
  starting_tests 'basic'

  row = basic_ls_test row
  basic_bad_command_test row
end

def home_and_end_tests(row)
  starting_tests 'home and end'

  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ss))
  @tty.send_home
  @tty.assert_cursor_position(START_COL, row)
  @tty.send_end
  @tty.assert_cursor_position(START_COL + 2, row)
  @tty.send_backspaces(2)

  puts 'Home and End tests passed'
  row
end

def end_of_line_backspace_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(l))
  @tty.send_backspace
  assert_check_new_row(row)
  puts 'End of line backspace test passed'
  row
end

def multiple_end_of_line_backspace_test(row)
  @tty.send_keys_one_at_a_time(%(lsssss))
  @tty.assert_row_ends_with(row, %(lsssss))
  @tty.send_backspaces(4)
  @tty.assert_row_ends_with(row, 'ls')
  @tty.send_backspaces(2)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(echo hello)) # make sure buffer is properly formed after backspaces
  @tty.send_backspace
  @tty.send_keys_one_at_a_time(%(o))
  @tty.send_newline
  row += 1
  @tty.assert_row(row, 'hello')
  row += 1
  puts 'Multiple end of line backspace test passed'
  row
end

def midline_backspace_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(lsssss))
  @tty.assert_cursor_position(START_COL + 6, row)
  @tty.send_left_arrows(2)
  @tty.assert_cursor_position(START_COL + 4, row)
  @tty.send_backspaces(4)
  @tty.assert_cursor_position(START_COL, row)
  @tty.assert_row_ends_with(row, 'ss')
  @tty.send_right_arrows(2)
  @tty.assert_cursor_position(START_COL + 2, row)
  @tty.send_backspaces(2)
  @tty.assert_cursor_position(START_COL, row)
  @tty.send_keys_one_at_a_time(%(echo hello)) # make sure buffer is properly formed after backspaces
  @tty.send_newline
  row += 1
  @tty.assert_row(row, 'hello')
  row += 1
  puts 'Midline backspace test passed'
  row
end

def backspace_tests(row)
  starting_tests 'backspace'

  row = end_of_line_backspace_test row
  row = multiple_end_of_line_backspace_test row

  midline_backspace_test row
end

def end_of_line_delete_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time('s')
  @tty.assert_cursor_position(START_COL + 1, row)
  @tty.send_left_arrow
  @tty.assert_cursor_position(START_COL, row)
  @tty.send_delete
  assert_check_new_row(row)
  puts 'End of line delete test passed'
  row
end

def midline_delete_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(lssss))
  @tty.assert_cursor_position(START_COL + 5, row)
  @tty.send_left_arrows(4)
  @tty.assert_cursor_position(START_COL + 1, row)
  @tty.send_delete
  @tty.assert_cursor_position(START_COL + 1, row)
  @tty.send_deletes(3)
  @tty.send_left_arrow
  @tty.send_delete
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(echo hello))
  @tty.send_newline
  row += 1
  @tty.assert_row(row, 'hello')
  row += 1
  puts 'Midline delete test passed'
  row
end

def delete_tests(row)
  starting_tests 'delete'

  row = end_of_line_delete_test row
  midline_delete_test row
end

def pipe_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls | wc -c))
  @tty.send_newline
  row += 1
  @tty.assert_row_ends_with(row, WC_C_LENGTH)
  row += 1
  puts 'Simple pipe test passed'
  row
end

def multiple_pipes_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls | sort | wc -c))
  @tty.send_newline
  row += 1
  @tty.assert_row_ends_with(row, WC_C_LENGTH)
  row += 1
  puts 'Multiple pipes test passed'
  row
end

def pipe_tests(row)
  starting_tests 'pipe'

  row = pipe_test row
  multiple_pipes_test row
end

def basic_history_test(row)
  assert_check_new_row(row)
  @tty.send_up_arrow
  @tty.assert_row_ends_with(row, 'ls | sort | wc -c')
  @tty.send_up_arrow
  @tty.assert_row_ends_with(row, 'ls | wc -c')
  @tty.send_down_arrow
  @tty.assert_row_ends_with(row, 'ls | sort | wc -c')
  @tty.send_newline
  row += 1
  @tty.assert_row_ends_with(row, WC_C_LENGTH)
  row += 1
  puts 'Basic history test passed'
  row
end

def history_delete_test(row)
  assert_check_new_row(row)
  @tty.send_up_arrow
  @tty.assert_row_ends_with(row, 'ls | sort | wc -c')
  @tty.send_left_arrows(12)
  @tty.send_deletes(7)
  @tty.send_newline
  row += 1
  @tty.assert_row_ends_with(row, WC_C_LENGTH)
  row += 1
  puts 'History delete test passed'
  row
end

def history_backspace_test(row)
  # TODO: implementation
  puts 'History backspace test passed'
  row
end

def history_clear_test(row)
  # TODO: implementation
  puts 'History clear test passed'
  row
end

def history_tests(row)
  starting_tests 'history'

  row = basic_history_test row
  # row =
  history_delete_test row
  # row = history_backspace_test
  # history_clear_test
end

def basic_stdout_redirection_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls > t.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(head -1 t.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  @tty.assert_row_starts_with(row, LS_FIRST_ITEM)
  row += 1
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(rm t.txt))
  @tty.send_newline
  row += 1
  puts 'Basic output redirection test passed'
  row
end

def piped_stdout_redirection_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls | sort -r > t2.txt))
  @tty.assert_row_ends_with(row, %(ls | sort -r > t2.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(head -1 t2.txt))
  @tty.assert_row_ends_with(row, %(head -1 t2.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  @tty.assert_row_starts_with(row, 'tests_z.sh')
  row += 1
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(rm t2.txt))
  @tty.send_newline
  row += 1
  puts 'Piped output redirection test passed'
  row
end

def multiple_piped_stdout_redirection_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls | sort | wc -c > t3.txt))
  @tty.assert_row_ends_with(row, %(ls | sort | wc -c > t3.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(head -1 t3.txt))
  @tty.assert_row_ends_with(row, %(head -1 t3.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  @tty.assert_row_starts_with(row, (WC_C_LENGTH.to_i + 't3.txt'.length + 1).to_s)
  row += 1
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(rm t3.txt))
  @tty.send_newline
  row += 1
  puts 'Multiple piped output redirection test passed'
  row
end

def stdout_redirection_tests(row)
  starting_tests 'stdout redirection'

  row = basic_stdout_redirection_test row
  row = piped_stdout_redirection_test row
  multiple_piped_stdout_redirection_test row
end

def z_add_tests(row)
  starting_tests 'z_add'
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(z add ~/.config\n))
  row += 1
  @tty.assert_row_ends_with(row, %(Added new entry to z database.))
  row += 1
  @tty.send_keys_one_at_a_time(%(z add ~/.config\n))
  row += 1
  @tty.assert_row_ends_with(row, 'Entry already exists in z database.')
  row += 1
  puts 'z add tests passed'
  row
end

def basic_stdin_redirection_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls > t.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(sort < t.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  @tty.assert_row_starts_with(row, LS_FIRST_ITEM)
  row += LS_ITEMS
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(rm t.txt))
  @tty.send_newline
  row += 1
  puts 'Basic input redirection test passed'
  row
end

def piped_stdin_redirection_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls > t2.txt))
  @tty.assert_row_ends_with(row, %(ls > t2.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(sort | wc -c < t2.txt))
  @tty.assert_row_ends_with(row, %(sort | wc -c < t2.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  @tty.assert_row_starts_with(row, (WC_C_LENGTH.to_i + 't2.txt'.length + 1).to_s)
  row += 1
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(rm t2.txt))
  @tty.send_newline
  row += 1
  puts 'Piped input redirection test passed'
  row
end

def multiple_piped_stdin_redirection_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls > t3.txt))
  @tty.assert_row_ends_with(row, %(ls > t3.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  @tty.send_keys_one_at_a_time(%(sort | head -1 | wc -l < t3.txt))
  @tty.assert_row_ends_with(row, %(sort | head -1 | wc -l < t3.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  @tty.assert_row(row, '1')
  row += 1
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(rm t3.txt))
  @tty.send_newline
  row += 1
  puts 'Multiple piped input redirection test passed'
  row
end

def stdin_redirection_tests(row)
  starting_tests 'stdin redirection'

  row = basic_stdin_redirection_test row
  row = piped_stdin_redirection_test row
  multiple_piped_stdin_redirection_test row
end

def basic_autocompletion_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(l))
  @tty.send_right_arrow
  @tty.assert_row_ends_with(row, %(ls))
  @tty.send_backspaces(2)

  puts 'Basic autocompletion test passed'
  row
end

def backspace_and_delete_autocompletion_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls |))
  @tty.send_right_arrow
  @tty.assert_row_ends_with(row, %(ls | sort))

  @tty.send_left_arrows(6)
  @tty.send_deletes(6)
  @tty.send_keys_one_at_a_time(%(|))
  @tty.send_right_arrow
  @tty.assert_row_ends_with(row, %(ls | sort))

  @tty.send_keys_one_at_a_time(%( |))
  @tty.send_right_arrow
  @tty.assert_row_ends_with(row, %(ls | sort | wc -c))
  @tty.send_newline
  row += 1
  @tty.assert_row(row, WC_C_LENGTH)
  row += 1

  puts 'Backspace and delete autocompletion test passed'
  row
end

def autocompletion_tests(row)
  starting_tests 'autocompletion'

  row = basic_autocompletion_test row
  backspace_and_delete_autocompletion_test row
end

def help_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(help\n))
  row += 1
  @tty.assert_contents_at row, row + 6, <<~TERM
    ncsh by Alex Eski: help

    Builtin Commands {command} {args}
    q:              To exit, type q, exit, or quit and press enter. You can also use Ctrl+D to exit.
    cd/z:           You can change directory with cd or z.
    echo:           You can write things to the screen using echo.
    history:        You can see your command history using the history command.
    alex /shells/ncsh ❱
  TERM
  row += 7
  puts 'Help test passed'
  row
end

def basic_echo_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(echo hello))
  @tty.assert_cursor_position(START_COL + 10, row)
  @tty.send_newline
  @tty.assert_row_ends_with(row, 'echo hello')
  row += 1
  @tty.assert_row(row, 'hello')
  row += 1
  puts 'echo hello test passed'
  row
end

def builtin_tests(row)
  starting_tests 'builtin'

  row = help_test row
  basic_echo_test row
end

def delete_line_tests(row)
  starting_tests 'delete line'
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls | sort ))
  @tty.send_keys_exact(TTYtest::CTRLU)
  assert_check_new_row(row)
  @tty.send_keys_exact(TTYtest::CTRLU)
  puts 'Delete line test passed'
  row
end

def delete_word_tests(row)
  starting_tests 'delete word'
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls | sort ))
  @tty.send_keys(TTYtest::CTRLW)
  @tty.assert_row_ends_with(row, %(ls | sort))
  @tty.send_keys(TTYtest::CTRLW)
  @tty.assert_row_ends_with(row, %(ls |))
  @tty.send_keys(TTYtest::CTRLW)
  @tty.assert_row_ends_with(row, %(ls))
  @tty.send_keys(TTYtest::CTRLW)
  puts 'Delete word test passed'
  row
end

def tab_out_autocompletion_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls))
  @tty.send_keys(TTYtest::TAB)
  row += 1
  @tty.assert_row_ends_with(row, %(ls > t.txt))
  @tty.send_keys(TTYtest::TAB)
  row += TAB_AUTOCOMPLETE_ROWS
  assert_check_new_row(row)

  puts 'Tab out of autocompletion test passed'
  row
end

def arrows_move_tab_autocompletion_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls))
  @tty.send_keys(TTYtest::TAB)
  row += 1
  cursor_x_before = @tty.cursor_x
  cursor_y_before = @tty.cursor_y
  @tty.send_up_arrow
  @tty.assert_cursor_position(cursor_x_before, cursor_y_before)
  @tty.send_down_arrow
  @tty.assert_cursor_position(cursor_x_before, cursor_y_before + 1)
  @tty.send_down_arrows(TAB_AUTOCOMPLETE_ROWS + 1)
  @tty.assert_cursor_position(cursor_x_before, cursor_y_before + 8)
  @tty.send_keys(TTYtest::TAB)
  row += TAB_AUTOCOMPLETE_ROWS

  puts 'Arrows autocompletion test passed'
  row
end

def select_tab_autocompletion_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls))
  @tty.send_keys(TTYtest::TAB)
  row += 1
  @tty.send_down_arrows(5)
  @tty.send_newline
  row += TAB_AUTOCOMPLETE_ROWS + 1
  @tty.assert_row_ends_with(row, WC_C_LENGTH)
  row += 1

  puts 'Select tab autocompletion test passed'
  row
end

def tab_autocompletion_tests(row)
  starting_tests 'tab autocompletion'

  row = tab_out_autocompletion_test row
  row = arrows_move_tab_autocompletion_test row
  select_tab_autocompletion_test row
end

def assert_check_syntax_error(row, input)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(input)
  @tty.send_newline
  row += 1
  @tty.assert_row_starts_with(row, 'ncsh: Invalid syntax:')
  row += 1
  row
end

def operators_invalid_syntax_first_position_test(row)
  # tries sending operator as only character to ensure invalid syntax is shown to user
  row = assert_check_syntax_error(row, '|') # pipe
  row = assert_check_syntax_error(row, '>') # output redirection
  row = assert_check_syntax_error(row, '>>') # output redirection append
  row = assert_check_syntax_error(row, '<') # input redirection
  row = assert_check_syntax_error(row, '2>') # error redirection
  row = assert_check_syntax_error(row, '2>>') # error redirection append
  row = assert_check_syntax_error(row, '&>') # output and error redirection
  row = assert_check_syntax_error(row, '&>>') # output and error redirection append
  row = assert_check_syntax_error(row, '&') # background job
  puts 'Invalid syntax in first position test passed'
  row
end

def operators_invalid_syntax_last_position_test(row)
  row = assert_check_syntax_error(row, 'ls |') # pipe
  row = assert_check_syntax_error(row, 'ls >') # output redirection
  row = assert_check_syntax_error(row, 'ls >>') # output redirection append
  row = assert_check_syntax_error(row, 'sort <') # input redirection
  row = assert_check_syntax_error(row, 'ls 2>') # error redirection
  row = assert_check_syntax_error(row, 'ls 2>>') # error redirection append
  row = assert_check_syntax_error(row, 'ls &>') # output and error redirection
  row = assert_check_syntax_error(row, 'ls &>>') # output and error redirection append
  puts 'Invalid syntax in last position test passed'
  row
end

# invalid operator usage to ensure invalid syntax is shown to user
def syntax_error_tests(row)
  starting_tests 'syntax errors'

  row = operators_invalid_syntax_first_position_test row
  operators_invalid_syntax_last_position_test row
end

def basic_stderr_redirection_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(lss 2> t4.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  @tty.send_keys_one_at_a_time(%(cat t4.txt))
  @tty.send_newline
  row += 1
  @tty.assert_row_ends_with(row, 'No such file or directory')
  row += 1
  @tty.send_keys_one_at_a_time(%(rm t4.txt))
  @tty.send_newline
  row += 1

  puts 'Basic stderr redirection test passed'
  row
end

def stderr_redirection_tests(row)
  starting_tests 'sterr redirection'

  basic_stderr_redirection_test row
end

def basic_stdout_and_stderr_redirection_stderr_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(lss &> t4.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  @tty.send_keys_one_at_a_time(%(cat t4.txt))
  @tty.send_newline
  row += 1
  @tty.assert_row_ends_with(row, 'No such file or directory')
  row += 1
  @tty.send_keys_one_at_a_time(%(rm t4.txt))
  @tty.send_newline
  row += 1

  puts 'Basic stdout and stderr redirection stderr test passed'
  row
end

def basic_stdout_and_stderr_redirection_stdout_test(row)
  assert_check_new_row(row)
  @tty.send_keys_one_at_a_time(%(ls &> t4.txt))
  @tty.send_newline
  sleep SLEEP_TIME
  row += 1
  @tty.send_keys_one_at_a_time(%(cat t4.txt | head -1))
  @tty.send_newline
  row += 1
  @tty.assert_row_ends_with(row, LS_FIRST_ITEM)
  row += 1
  @tty.send_keys_one_at_a_time(%(rm t4.txt))
  @tty.send_newline
  row += 1

  puts 'Basic stdout and stderr redirection stdout test passed'
  row
end

def stdout_and_stderr_redirection_tests(row)
  starting_tests 'stdout and sterr redirection'

  row = basic_stdout_and_stderr_redirection_stderr_test row
  basic_stdout_and_stderr_redirection_stdout_test row
end

row = 0
@tty = TTYtest.new_terminal(%(PS1='$ ' ./bin/ncsh), width: 120, height: 120)

row = startup_tests(row, true)
row = basic_tests row
row = home_and_end_tests row
row = backspace_tests row
row = delete_tests row
row = pipe_tests row
row = history_tests row
row = stdout_redirection_tests row
row = z_add_tests row
row = stdin_redirection_tests row
row = autocompletion_tests row
row = builtin_tests row
row = delete_line_tests row
row = delete_word_tests row
tab_autocompletion_tests row
@tty.send_keys_exact(%(quit))
@tty.send_newline

row = 0
@tty = TTYtest.new_terminal(%(PS1='$ ' ./bin/ncsh), width: 180, height: 150)
row = startup_tests(row, false)
row = syntax_error_tests row
row = stderr_redirection_tests row
stdout_and_stderr_redirection_tests row

# troubleshooting
# @tty.print
# @tty.print_rows
# p @tty.to_s

puts 'All tests passed!'
