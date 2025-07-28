# frozen_string_literal: true

module TTYtest
  # Assertions for ttytest2.
  module Matchers
    # Asserts the contents of a single row match the value expected
    # @param [Integer] row_number the row (starting from 0) to test against
    # @param [String] expected the expected value of the row. Any trailing whitespace is ignored
    # @raise [MatchError] if the row doesn't match exactly
    def assert_row(row_number, expected)
      validate(row_number)
      expected = expected.rstrip
      actual = row(row_number)

      return if !actual.nil? && actual == expected

      raise MatchError,
            "expected row #{row_number} to be #{expected.inspect} but got #{get_inspection(actual)}\n
            Entire screen:\n#{self}"
    end
    alias assert_line assert_row

    # Asserts the specified row is empty
    # @param [Integer] row_number the row (starting from 0) to test against
    # @raise [MatchError] if the row isn't empty
    def assert_row_is_empty(row_number)
      validate(row_number)
      actual = row(row_number)

      return if actual == ''

      raise MatchError,
            "expected row #{row_number} to be empty but got #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end
    alias assert_line_is_empty assert_row_is_empty

    # Asserts the contents of a single row contains the expected string at a specific position
    # @param [Integer] row_number the row (starting from 0) to test against
    # @param [Integer] column_start the column position to start comparing expected against
    # @param [Integer] columns_end the column position to end comparing expected against
    # @param [String] expected the expected value that the row starts with. Any trailing whitespace is ignored
    # @raise [MatchError] if the row doesn't match
    def assert_row_at(row_number, column_start, column_end, expected)
      validate(row_number)
      expected = expected.rstrip
      actual = row(row_number)
      column_end += 1

      return if !actual.nil? && actual[column_start, column_end].eql?(expected)

      inspection = get_inspection_bounded(actual, column_start, column_end)

      raise MatchError,
            "expected row #{row_number} to contain #{expected[column_start,
                                                              column_end]} at #{column_start}-#{column_end} and got #{inspection}\nEntire screen:\n#{self}"
    end
    alias assert_line_at assert_row_at

    # Asserts the contents of a single row contains the value expected
    # @param [Integer] row_number the row (starting from 0) to test against
    # @param [String] expected the expected value contained in the row. Any trailing whitespace is ignored
    # @raise [MatchError] if the row doesn't match
    def assert_row_like(row_number, expected)
      validate(row_number)
      expected = expected.rstrip
      actual = row(row_number)

      return if !actual.nil? && actual.include?(expected)

      raise MatchError,
            "expected row #{row_number} to be like #{expected.inspect} but got #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end
    alias assert_row_contains assert_row_like
    alias assert_line_contains assert_row_like
    alias assert_line_like assert_row_like

    # Asserts the contents of a single row starts with expected string
    # @param [Integer] row_number the row (starting from 0) to test against
    # @param [String] expected the expected value that the row starts with. Any trailing whitespace is ignored
    # @raise [MatchError] if the row doesn't match
    def assert_row_starts_with(row_number, expected)
      validate(row_number)
      expected = expected.rstrip
      actual = row(row_number)

      return if !actual.nil? && actual.start_with?(expected)

      raise MatchError,
            "expected row #{row_number} to start with #{expected.inspect} and got #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end

    # Asserts the contents of a single row end with expected
    # @param [Integer] row_number the row (starting from 0) to test against
    # @param [String] expected the expected value that the row starts with. Any trailing whitespace is ignored
    # @raise [MatchError] if the row doesn't match
    def assert_row_ends_with(row_number, expected)
      validate(row_number)
      expected = expected.rstrip
      actual = row(row_number)

      return if !actual.nil? && actual.end_with?(expected)

      raise MatchError,
            "expected row #{row_number} to end with #{expected.inspect} and got #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end

    # Asserts the contents of a single row match against the passed in regular expression
    # @param [Integer] row_number the row (starting from 0) to test against
    # @param [String] regexp_str the regular expression as a string that will be used to match with.
    # @raise [MatchError] if the row doesn't match against the regular expression
    def assert_row_regexp(row_number, regexp_str)
      validate(row_number)
      regexp = Regexp.new(regexp_str)
      actual = row(row_number)

      return if !actual.nil? && actual.match?(regexp)

      raise MatchError,
            "expected row #{row_number} to match regexp #{regexp_str} but it did not. Row value #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end

    # Asserts the contents of a multiple rows each match against the passed in regular expression
    # @param [Integer] row_start the row (starting from 0) to test against
    # @param [Integer] row_end the last row to test against
    # @param [String] regexp_str the regular expression as a string that will be used to match with.
    # @raise [MatchError] if the row doesn't match against the regular expression
    def assert_rows_each_match_regexp(row_start, row_end, regexp_str)
      validate(row_end)
      regexp = Regexp.new(regexp_str)
      row_end += 1 if row_end.zero?

      rows.slice(row_start, row_end).each_with_index do |actual_row, index|
        next if !actual_row.nil? && actual_row.match?(regexp)

        raise MatchError,
              "expected row #{index} to match regexp #{regexp_str} but it did not. Row value #{get_inspection(actual_row)}\nEntire screen:\n#{self}"
      end
    end

    # Asserts that the cursor is in the expected position
    # @param [Integer] x cursor x (row) position, starting from 0
    # @param [Integer] y cursor y (column) position, starting from 0
    # @raise [MatchError] if the cursor position doesn't match
    def assert_cursor_position(x, y)
      expected = [x, y]
      actual = [cursor_x, cursor_y]

      return if actual == expected

      raise MatchError,
            "expected cursor to be at #{expected.inspect} but was at #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end

    # @raise [MatchError] if the cursor is hidden
    def assert_cursor_visible
      return if cursor_visible?

      raise MatchError, "expected cursor to be visible was hidden\nEntire screen:\n#{self}"
    end

    # @raise [MatchError] if the cursor is visible
    def assert_cursor_hidden
      return if cursor_hidden?

      raise MatchError, "expected cursor to be hidden was visible\nEntire screen:\n#{self}"
    end

    def matched(expected, actual)
      expected_rows = expected.split("\n")
      diff = []
      matched = true
      actual.each_with_index do |actual_row, index|
        expected_row = (expected_rows[index] || '').rstrip
        if actual_row != expected_row
          diff << "-#{expected_row}"
          diff << "+#{actual_row}"
          matched = false
        else
          diff << " #{actual_row}".rstrip
        end
      end

      [matched, diff]
    end

    # Asserts the full contents of the terminal
    # @param [String] expected the full expected contents of the terminal. Trailing whitespace on each line is ignored
    # @raise [MatchError] if the terminal doesn't match the expected content
    def assert_contents(expected)
      matched, diff = matched(expected, rows)

      return if matched

      raise MatchError,
            "screen did not match expected content:\n--- expected\n+++ actual\n#{diff.join("\n")}"
    end
    alias assert_matches assert_contents
    alias assert_screen assert_contents

    # Asserts the contents of the terminal at specified rows
    # @param [String] expected the expected contents of the terminal at specified rows. Trailing whitespace on each line is ignored
    # @raise [MatchError] if the terminal doesn't match the expected content
    def assert_contents_at(row_start, row_end, expected)
      validate(row_end)
      row_end += 1 if row_end.zero?

      matched, diff = matched(expected, rows.slice(row_start, row_end))

      return if matched

      raise MatchError,
            "screen did not match expected content:\n--- expected\n+++ actual\n#{diff.join("\n")}"
    end
    alias assert_matches_at assert_contents_at
    alias assert_rows assert_contents_at

    def assert_file_exists(file_path)
      raise file_not_found_error(file_path) unless File.exist?(file_path)
      raise file_is_dir_error(file_path) unless File.file?(file_path)
    end

    def assert_file_doesnt_exist(file_path)
      return unless File.exist?(file_path) || File.file?(file_path)

      raise MatchError,
            "File with path #{file_path} was found or is a directory when it was asserted it did not exist.\nEntire screen:\n#{self}"
    end

    def assert_file_contains(file_path, needle)
      raise file_not_found_error(file_path) unless File.exist?(file_path)
      raise file_is_dir_error(file_path) unless File.file?(file_path)

      file_contains = false
      File.foreach(file_path) do |line|
        if line.include?(needle)
          file_contains = true
          break
        end
      end
      return if file_contains

      raise MatchError,
            "File with path #{file_path} did not contain #{needle}.\nEntire screen:\n#{self}"
    end

    def assert_file_has_permissions(file_path, permissions)
      raise file_not_found_error(file_path) unless File.exist?(file_path)
      raise file_is_dir_error(file_path) unless File.file?(file_path)

      file_mode = File.stat(file_path).mode
      perms_octal = format('%o', file_mode)[-3...]
      return if perms_octal == permissions

      raise MatchError,
            "File had permissions #{perms_octal}, not #{permissions} as expected.\n Entire screen:\n#{self}"
    end

    METHODS = public_instance_methods

    private

    def get_inspection(actual)
      if actual.nil?
        'nil'
      else
        actual.inspect
      end
    end

    def get_inspection_bounded(actual, column_start, column_end)
      if actual.nil?
        'nil'
      else
        actual[column_start, column_end]
      end
    end

    def validate(row)
      return if @height.nil?
      return unless row >= @height

      raise MatchError,
            "row is at #{row}, which is greater than set height #{height}, so assertions will fail. If intentional, set height larger or break apart tests.\n
            Entire screen:\n#{self}"
    end

    def file_not_found_error(file_path)
      raise MatchError,
            "File with path #{file_path} was not found when asserted it did exist.\nEntire screen:\n#{self}"
    end

    def file_is_dir_error(file_path)
      raise MatchError,
            "File with path #{file_path} is a directory.\nEntire screen:\n#{self}"
    end
  end
end
